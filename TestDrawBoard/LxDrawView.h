//
//  DrawView.h
//  TestDrawBoard
//
//  Created by yuelixing on 2017/2/20.
//  Copyright © 2017年 YueLiXing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LxBrush.h"

@interface LxDrawView : UIView

/**
 默认-画笔
 */
@property (nonatomic, retain) LxBrush * brushDefault;

/**
 线段-画笔
 */
@property (nonatomic, retain) LxBrush * brushLine;
/**
 椭圆-画笔
 */
@property (nonatomic, retain) LxBrush * brushEllipse;
/**
 矩形-画笔
 */
@property (nonatomic, retain) LxBrush * brushRect;
/**
 橡皮擦-画笔
 */
@property (nonatomic, retain) LxBrush * brushEraser;

@property (nonatomic, weak) LxBrush * currentBrush;


@property (nonatomic, assign) CGFloat lindWidth;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)drawimage:(UIImage *)image InRect:(CGRect)rect;

- (void)cleanAll;

- (BOOL)canUndo;
- (BOOL)canRedo;

- (void)undo;
- (void)redo;

@end
