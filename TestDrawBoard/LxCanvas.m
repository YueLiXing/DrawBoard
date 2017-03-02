//
//  LxCanvas.m
//  TestDrawBoard
//
//  Created by yuelixing on 2017/2/21.
//  Copyright © 2017年 YueLiXing. All rights reserved.
//

#import "LxCanvas.h"


@interface LxCanvas ()

@property (nonatomic, retain) CAShapeLayer * shapeLayer;

@end

@implementation LxCanvas

- (instancetype)init {
    if (self = [super init]) {
        [self.layer addSublayer:self.shapeLayer];
        self.layer.backgroundColor = [UIColor clearColor].CGColor;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.shapeLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
    }
    return _shapeLayer;
}

- (void)setBrush:(LxBrush *)brush {
    CAShapeLayer *shapeLayer = self.shapeLayer;
    if (brush == nil) {
        shapeLayer.path = nil;
        [self.shapeLayer removeFromSuperlayer];
        self.shapeLayer = nil;
        return;
    }
    if (self.shapeLayer.superlayer == nil) {
        [self.layer addSublayer:self.shapeLayer];
        self.shapeLayer.frame = self.bounds;
    }
    
    shapeLayer.strokeColor = brush.color.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineWidth = brush.width;
    
    shapeLayer.path = brush.bezierPath.CGPath;

}


@end
