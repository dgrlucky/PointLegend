//
//  UIActionSheet+Block.m
//  IOS-Categories
//
//  Created by chun on 15/7/3.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "UIActionSheet+Block.h"
#import <objc/runtime.h>

static const void *actionSheetKey = @"actionSheetKey";

@implementation UIActionSheet (Block)

+ (void)actionSheetWithCallBackBlock:(UIActionSheetCallBackBlock)alertViewCallBackBlock title:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:nil cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles, nil];
    NSString *other = nil;
    va_list args;
    if (otherButtonTitles) {
        va_start(args, otherButtonTitles);
        while ((other = va_arg(args, NSString*))) {
            [actionSheet addButtonWithTitle:other];
        }
        va_end(args);
    }
    actionSheet.delegate = actionSheet;
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    actionSheet.actionSheetCallBackBlock = alertViewCallBackBlock;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.actionSheetCallBackBlock) {
        self.actionSheetCallBackBlock(buttonIndex);
    }
}

- (void)setActionSheetCallBackBlock:(UIActionSheetCallBackBlock)actionSheetCallBackBlock
{
    objc_setAssociatedObject(self, actionSheetKey, actionSheetCallBackBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIActionSheetCallBackBlock)actionSheetCallBackBlock
{
    return objc_getAssociatedObject(self, actionSheetKey);
}

@end
