//
//  LxBrush.m
//  TestDrawBoard
//
//  Created by yuelixing on 2017/2/21.
//  Copyright © 2017年 YueLiXing. All rights reserved.
//

#import "LxBrush.h"

@implementation LxBrush

- (instancetype)init {
    if (self = [super init]) {
        
        self.color = [UIColor blackColor];
        self.shapeType = LxShapeDefault;
        self.bezierPath = [UIBezierPath bezierPath];
        self.bezierPath.lineJoinStyle = kCGLineJoinRound;
        self.bezierPath.lineCapStyle = kCGLineCapRound;
        
        self.width = 5;
    }
    return self;
}

- (void)setWidth:(CGFloat)width {
    _width = width;
    self.bezierPath.lineWidth = width;
}

+ (instancetype)brushDefault {
    LxBrush * brush = [[LxBrush alloc] init];
    return brush;
}

+ (instancetype)brushLine {
    LxBrush * brush = [[LxBrush alloc] init];
    brush.shapeType = LxShapeLine;
    return brush;
}

+ (instancetype)brushEllipse {
    LxBrush * brush = [[LxBrush alloc] init];
    brush.shapeType = LxShapeEllipse;
    return brush;
}


+ (instancetype)brushRect {
    LxBrush * brush = [[LxBrush alloc] init];
    brush.shapeType = LxShapeRect;
    return brush;
}


+ (instancetype)brushEraser {
    LxBrush * brush = [[LxBrush alloc] init];
    brush.shapeType = LxShapeEraser;
    brush.color = [UIColor whiteColor];
//    brush.color = [UIColor clearColor];
    brush.width = 10;
    return brush;
}

@end
