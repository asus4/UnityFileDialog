//
//  UNAppViewConrollerViewController.m
//  UnityNativeDialogPlugin
//
//  Created by ibu on 2013/07/27.
//  Copyright (c) 2013年 Asus4. All rights reserved.
//

#import "UNAppViewConrollerViewController.h"
#import "UNNativeDialogPlugin.h"

@interface UNAppViewConrollerViewController ()

@end

@implementation UNAppViewConrollerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (IBAction)onOpenClicked:(id)sender {
    [[UNNativeDialogPlugin sharedManager]openPanel];
}

- (IBAction)onSaveClicked:(id)sender {
    [[UNNativeDialogPlugin sharedManager]savePanel];
}

- (IBAction)onUpdate:(id)sender {
    NSLog(@"onUpdate");
    UNNativeDialogPlugin *dialogPlugin = [UNNativeDialogPlugin sharedManager];
    
    if([dialogPlugin hasOpenResult]) {
        NSLog(@"hasOpenResult : %@", [dialogPlugin getOpenPath]);
    }
    
    if([dialogPlugin hasSaveResult]) {
        NSLog(@"hasSaveResult : %@", [dialogPlugin getSavePath]);
    }
    
}
@end
