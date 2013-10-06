//
//  UNNativeDialogPlugin.h
//  UnityNativeDialogPlugin
//
//  Created by ibu on 2013/07/27.
//  Copyright (c) 2013年 Asus4. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UNNativeDialogPlugin : NSObject {
    NSString *openPath;
    NSString *savePath;
}

// static
+ (UNNativeDialogPlugin*) sharedManager;

// methods
- (void) initializeUnity:(BOOL) isEditor;
- (void) savePanel;
- (void) openPanel;
- (BOOL) hasOpenResult;
-(BOOL) hasSaveResult;
- (NSString*) getOpenPath;
- (NSString*) getSavePath;

@end
