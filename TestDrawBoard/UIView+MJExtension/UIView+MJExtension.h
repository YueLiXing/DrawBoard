//
//  UIView+Extension.h
//  MJRefreshExample
//
//  Created by MJ Lee on 14-5-28.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MJExtension)

/**
 *  左侧
 */
@property (nonatomic) CGFloat left;
/**
 *  最上
 */
@property (nonatomic) CGFloat top;
/**
 *  最右边
 */
@property (nonatomic) CGFloat right;
/**
 *  最下边
 */
@property (nonatomic) CGFloat bottom;

@property (assign, nonatomic) CGFloat mj_x;
@property (assign, nonatomic) CGFloat mj_y;
@property (assign, nonatomic) CGFloat mj_width;
@property (nonatomic, assign) CGFloat width;
@property (assign, nonatomic) CGFloat mj_height;
@property (nonatomic, assign) CGFloat height;
@property (assign, nonatomic) CGSize mj_size;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGPoint mj_origin;
@property (assign, nonatomic) CGPoint origin;
@property (assign,nonatomic)CGFloat max_x;
@property (assign,nonatomic)CGFloat max_y;
@property (nonatomic, assign) CGFloat mj_centerX;
@property (nonatomic, assign) CGFloat mj_centerY;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat centerX;

@end


@interface UIView (CornerRadius)

- (void)makeCorRadius;

- (void)makeCorRadiusWithRadius:(CGFloat)radius;

- (void)addBorderWidth:(CGFloat)width Color:(UIColor *)color;

@end
