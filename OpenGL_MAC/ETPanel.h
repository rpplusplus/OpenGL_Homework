//
//  ETPanel.h
//  OpenGL_MAC
//
//  Created by Xiaoxuan Tang on 13-5-6.
//  Copyright (c) 2013年 txx. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ETPanel : NSPanel

@property (nonatomic, retain) IBOutlet NSTextField* a;

- (IBAction) hideWiredBtnClick:(id) sender;
- (IBAction) hideLightBtnClick:(id)sender;

@end
