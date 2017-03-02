//
//  UIView+Extension.m
//  MJRefreshExample
//
//  Created by MJ Lee on 14-5-28.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "UIView+MJExtension.h"

@implementation UIView (MJExtension)
- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (void)setMj_x:(CGFloat)mj_x
{
    CGRect frame = self.frame;
    frame.origin.x = mj_x;
    self.frame = frame;
}

- (CGFloat)mj_x
{
    return self.frame.origin.x;
}
- (void)setMax_x:(CGFloat)max_x {
    CGRect frame = self.frame;
    frame.origin.x = max_x-frame.size.width;
    self.frame = frame;
}
- (void)setMax_y:(CGFloat)max_y{
    CGRect frame = self.frame;
    frame.origin.y = max_y-frame.size.height;
    self.frame = frame;
}
- (CGFloat)max_x{
    return self.frame.origin.x + self.frame.size.width;
}
- (CGFloat)max_y{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setMj_y:(CGFloat)mj_y
{
    CGRect frame = self.frame;
    frame.origin.y = mj_y;
    self.frame = frame;
}

- (CGFloat)mj_y
{
    return self.frame.origin.y;
}

- (void)setMj_width:(CGFloat)mj_width {
    CGRect frame = self.frame;
    frame.size.width = mj_width;
    self.frame = frame;
}

- (CGFloat)mj_width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setMj_height:(CGFloat)mj_height {
    CGRect frame = self.frame;
    frame.size.height = mj_height;
    self.frame = frame;
}

- (CGFloat)mj_height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setMj_size:(CGSize)mj_size {
    CGRect frame = self.frame;
    frame.size = mj_size;
    self.frame = frame;
}
- (CGSize)mj_size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setMj_origin:(CGPoint)mj_origin {
    CGRect frame = self.frame;
    frame.origin = mj_origin;
    self.frame = frame;
}

- (CGPoint)mj_origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setMj_centerX:(CGFloat)mj_centerX {
    CGPoint center = self.center;
    center.x = mj_centerX;
    self.center = center;
}

- (CGFloat)mj_centerX {
    return self.center.x;
}

- (void)setMj_centerY:(CGFloat)mj_centerY {
    CGPoint center = self.center;
    center.y = mj_centerY;
    self.center = center;
}

- (CGFloat)mj_centerY {
    return self.center.y;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}

@end


@implementation UIView (CornerRadius)

- (void)makeCorRadius {
    [self makeCorRadiusWithRadius:self.mj_height/2.0];
}

- (void)makeCorRadiusWithRadius:(CGFloat)radius {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
}

- (void)addBorderWidth:(CGFloat)width Color:(UIColor *)color {
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
}

@end
