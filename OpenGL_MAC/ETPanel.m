//
//  ETPanel.m
//  OpenGL_MAC
//
//  Created by Xiaoxuan Tang on 13-5-6.
//  Copyright (c) 2013年 txx. All rights reserved.
//

#import "ETPanel.h"

@implementation ETPanel

- (IBAction) hideWiredBtnClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideWired"
                                                        object:nil
                                                      userInfo:nil];
}

- (IBAction) hideLightBtnClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideLight"
                                                        object:nil
                                                      userInfo:nil];
}

- (void) awakeFromNib
{
    [self becomeFirstResponder];
    [_a becomeFirstResponder];
}
@end
