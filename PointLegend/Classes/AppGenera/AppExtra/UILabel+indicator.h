//
//  UILabel+indicator.h
//  Legend
//
//  Created by ydcq on 15/12/4.
//  Copyright © 2015年 frocky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (indicator)

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

- (void)showIndicator;

- (void)hideIndicator;

@end
