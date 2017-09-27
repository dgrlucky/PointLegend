//
//  PLChooseWindow.h
//  Legend
//
//  Created by ydcq on 15/12/2.
//  Copyright © 2015年 frocky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLChooseWindow : UIWindow
/**
 *  筛选条件数组
 */
@property (nonatomic, strong) NSArray *itemArray;

@property (nonatomic, weak) id delegate;

- (void)show;

- (void)dismiss;

void setSelectedIndexToZero();

@end
