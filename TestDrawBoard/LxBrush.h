//
//  LxBrush.h
//  TestDrawBoard
//
//  Created by yuelixing on 2017/2/21.
//  Copyright © 2017年 YueLiXing. All rights reserved.
//

#import <UIKit/UIKit.h>

//画笔形状
typedef NS_ENUM(NSInteger, LxShapeType) {
    LxShapeDefault = 0,//曲线(默认)
    LxShapeLine,//直线
    LxShapeEllipse,//椭圆
    LxShapeRect,//矩形
    LxShapeEraser // 橡皮擦
};

/**
 画笔
 */
@interface LxBrush : NSObject

@property (nonatomic, retain) UIColor * color;

@property (nonatomic, assign) CGFloat width;

//形状
@property (nonatomic, assign) LxShapeType shapeType;

//路径
@property (nonatomic, retain) UIBezierPath * bezierPath;

//起点
@property (nonatomic, assign) CGPoint beginPoint;
//终点
@property (nonatomic, assign) CGPoint endPoint;



@property (nonatomic, class, readonly) LxBrush * brushDefault;
@property (nonatomic, class, readonly) LxBrush * brushLine;
@property (nonatomic, class, readonly) LxBrush * brushEllipse;
@property (nonatomic, class, readonly) LxBrush * brushRect;
@property (nonatomic, class, readonly) LxBrush * brushEraser;


@end
