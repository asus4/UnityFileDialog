//
//  UNAppViewConrollerViewController.h
//  UnityNativeDialogPlugin
//
//  Created by ibu on 2013/07/27.
//  Copyright (c) 2013年 Asus4. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface UNAppViewConrollerViewController : NSViewController
//@property (assign) IBOutlet NSTextField *logLabel;
- (IBAction)onOpenClicked:(id)sender;
- (IBAction)onSaveClicked:(id)sender;
- (IBAction)onUpdate:(id)sender;

@end
