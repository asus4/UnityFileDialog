//
//  UNNativeDialogPlugin.m
//  UnityNativeDialogPlugin
//
//  Created by ibu on 2013/07/27.
//  Copyright (c) 2013年 Asus4. All rights reserved.
//

#import "UNNativeDialogPlugin.h"
#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import <WebKit/WebKit.h>
#import <Carbon/Carbon.h>
#import <OpenGL/gl.h>
#import <unistd.h>

//#define _UNITY_SEND_MESSAGE

#define MakeStringCopy( _x_ ) ( _x_ != NULL && [_x_ isKindOfClass:[NSString class]] ) ? strdup( [_x_ UTF8String] ) : NULL

static BOOL inEditor;



//extern void UnitySendMessage(const char *, const char *, const char *);
typedef void *MonoDomain;
typedef void *MonoAssembly;
typedef void *MonoImage;
typedef void *MonoObject;
typedef void *MonoMethodDesc;
typedef void *MonoMethod;
typedef void *MonoString;

extern "C" {
	MonoDomain *mono_domain_get();
	MonoAssembly *mono_domain_assembly_open(
                                            MonoDomain *domain, const char *assemblyName);
	MonoImage *mono_assembly_get_image(MonoAssembly *assembly);
	MonoMethodDesc *mono_method_desc_new(
                                         const char *methodString, int useNamespace);
	MonoMethodDesc *mono_method_desc_free(MonoMethodDesc *desc);
	MonoMethod *mono_method_desc_search_in_image(
                                                 MonoMethodDesc *methodDesc, MonoImage *image);
	MonoObject *mono_runtime_invoke(
                                    MonoMethod *method, void *obj, void **params, MonoObject **exc);
	MonoString *mono_string_new(MonoDomain *domain, const char *text);
}

static MonoDomain *monoDomain;
static MonoAssembly *monoAssembly;
static MonoImage *monoImage;
static MonoMethodDesc *monoDesc;
static MonoMethod *monoMethod;

static void UnitySendMessage(
                             const char *gameObject, const char *method, const char *message)
{
	if (monoMethod == 0) {
		NSString *assemblyPath;
		if (inEditor) {
			assemblyPath =
            @"Library/ScriptAssemblies/Assembly-CSharp-firstpass.dll";
		} else {
			NSString *dllPath =
            @"Contents/Data/Managed/Assembly-CSharp-firstpass.dll";
			assemblyPath = [[[NSBundle mainBundle] bundlePath]
                            stringByAppendingPathComponent:dllPath];
		}
		monoDomain = mono_domain_get();
		monoAssembly =
        mono_domain_assembly_open(monoDomain, [assemblyPath UTF8String]);
		monoImage = mono_assembly_get_image(monoAssembly);
		monoDesc = mono_method_desc_new(
                                        "UnitySendMessageDispatcher:Dispatch(string,string,string)", FALSE);
		monoMethod = mono_method_desc_search_in_image(monoDesc, monoImage);
	}
    
	void *args[] = {
		mono_string_new(monoDomain, gameObject),
		mono_string_new(monoDomain, method),
		mono_string_new(monoDomain, message),
	};
    
	mono_runtime_invoke(monoMethod, 0, args, 0);
}


// impelementation

@implementation UNNativeDialogPlugin

static UNNativeDialogPlugin * sharedDialogPlugin;

+ (UNNativeDialogPlugin*) sharedManager {
//    @synchronized(self) {
        if(sharedDialogPlugin == nil) {
            sharedDialogPlugin = [[self alloc] init];
        }
//    }
    return sharedDialogPlugin;
}

- (NSWindow *) getMainWindow {
    NSApplication * application = [NSApplication sharedApplication];
    return application.mainWindow;
}

- (void) initializeUnity:(BOOL) isEditor {
    inEditor = isEditor;
}

- (void) savePanel {
    NSSavePanel *panel = [NSSavePanel savePanel];
    
    [panel beginSheetModalForWindow:[self getMainWindow]
                  completionHandler:^(NSInteger result) {
                    if(result == NSOKButton) {
                        NSLog(@"save panel %@", panel.URL.path);
                        savePath = [NSString stringWithString:panel.URL.path];
//                        UnitySendMessage("NativeDialogPlugin", "OnOpenPath", [panel.URL.path UTF8String]);
                    }
                    else {
                        NSLog(@"save canceled");
                        savePath = @"";
                    }
                     [savePath retain];
                  }];
}

- (void) openPanel {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    
    [panel beginSheetModalForWindow:[self getMainWindow]
                  completionHandler:^(NSInteger result) {
                      if(result == NSOKButton) {
                          NSLog(@"open panel %@", panel.URL.path);
                          openPath = [NSString stringWithString:panel.URL.path];
                      }
                      else {
                          NSLog(@"open canceld");
                          openPath = @"";
                      }
                      [openPath retain];
                  }];
}

- (BOOL) hasOpenResult {
    return openPath != nil;
}

-(BOOL) hasSaveResult {
    return savePath != nil;
}

- (NSString*) getOpenPath {
//    NSLog(openPath);
    NSString * msg = [NSString stringWithString:openPath];
//    [openPath release];
    openPath = nil;
    return msg;
}

- (NSString*) getSavePath {
//    NSLog(savePath);
    NSString * msg = [NSString stringWithString:savePath];
//    [savePath release];
    savePath = nil;
    return msg;
}

@end






// unity plugin interface
extern "C" {
    void initializeUnity(BOOL isEditor) {
        
    }
    
    void nativeSavePanel() {
        [[UNNativeDialogPlugin sharedManager] savePanel];
    }
    
    void nativeOpenPanel() {
        [[UNNativeDialogPlugin sharedManager] openPanel];
    }
    
    uint hasOpenResult() {
        return [[UNNativeDialogPlugin sharedManager] hasOpenResult] ? 1 : 0;
    }
    
    uint hasSaveResult() {
        return [[UNNativeDialogPlugin sharedManager] hasSaveResult] ? 1 : 0;
    }
    
    const char* getOpenPath() {
        return MakeStringCopy([[UNNativeDialogPlugin sharedManager] getOpenPath]);
    }
    
    const char* getSavePath() {
        return MakeStringCopy([[UNNativeDialogPlugin sharedManager] getSavePath]);
    }
    

}

