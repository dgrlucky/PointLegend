//
//  UIActionSheet+Block.h
//  IOS-Categories
//
//  Created by chun on 15/7/3.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIActionSheetCallBackBlock)(NSInteger buttonIndex);

@interface UIActionSheet (Block)<UIActionSheetDelegate>

@property (nonatomic, copy) UIActionSheetCallBackBlock actionSheetCallBackBlock;

+ (void)actionSheetWithCallBackBlock:(UIActionSheetCallBackBlock)alertViewCallBackBlock title:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION;

@end
