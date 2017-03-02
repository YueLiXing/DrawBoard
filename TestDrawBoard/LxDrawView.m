//
//  DrawView.m
//  TestDrawBoard
//
//  Created by yuelixing on 2017/2/20.
//  Copyright © 2017年 YueLiXing. All rights reserved.
//

#import "LxDrawView.h"
#import "LxCanvas.h"

static void dispatch_async_back(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(0, 0), block);
}
//static void dispatch_async_main(dispatch_block_t block) {
//    dispatch_async(dispatch_get_main_queue(), block);
//}

//@interface LxImageHistory : NSObject
//
//@end
//@implementation LxImageHistory
//@end

@interface LxDrawView ()
{
    // 方案二
    CGPoint pts[5];
    uint ctr;
}
@property (nonatomic, retain) UIImageView * backImageView;

@property (nonatomic, retain) LxCanvas * canvas;

//@property (nonatomic, retain) CADisplayLink * displayLink;

@property (nonatomic, retain) NSMutableArray<NSString *> * historyImageArray;
@property (nonatomic, assign) NSInteger currentIndex;

// 方案一
@property (nonatomic, assign) CGPoint lastPoint;

@end

@implementation LxDrawView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self loadDefaultConfig];
        self.clipsToBounds = YES;
        [self addSubview:self.backImageView];
        [self addSubview:self.canvas];
        
        self.frame = frame;
    }
    return self;
}

- (void)loadDefaultConfig {
    self.currentIndex = -1;
    self.lindWidth = 2;
    self.brushDefault = [LxBrush brushDefault];
    self.brushLine = [LxBrush brushLine];
    self.brushEllipse = [LxBrush brushEllipse];
    self.brushRect = [LxBrush brushRect];
    self.brushEraser = [LxBrush brushEraser];
    
    self.currentBrush = self.brushDefault;
    
    [self performSelectorInBackground:@selector(cleanLocalCache) withObject:nil];
}

- (void)cleanLocalCache {
    NSString * tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"cacheofdraw"];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:tempPath] == NO) {
        BOOL ret = [fileManager createDirectoryAtPath:tempPath withIntermediateDirectories:nil attributes:nil error:nil];
        NSLog(@"临时文件夹创建%@", ret?@"成功":@"失败");
    } else {
        NSLog(@"临时文件夹存在")
        for (NSString * tempName in [fileManager subpathsAtPath:tempPath]) {
            BOOL ret = [fileManager removeItemAtPath:[tempPath stringByAppendingPathComponent:tempName] error:nil];
            NSLog(@"%@ %@", ret?@"删除成功":@"删除失败", tempName);
        }
    }
    
}

- (void)setCurrentBrush:(LxBrush *)currentBrush {
    if (_currentBrush.shapeType == LxShapeEraser || currentBrush.shapeType == LxShapeEraser) {
        NSLog(@"橡皮擦不继承颜色 和 粗细");
    } else if (_currentBrush) {
        currentBrush.width = _currentBrush.width;
        currentBrush.color = _currentBrush.color;
    }
    _currentBrush = currentBrush;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.canvas.frame = self.bounds;
    self.backImageView.frame = self.bounds;
}

- (void)cleanAll {
//    [self.linesArray removeAllObjects];
    [self.historyImageArray removeAllObjects];
    self.currentIndex = -1;
    self.backImageView.image = nil;
    [self.canvas setBrush:nil];
    [self storeCurrentImage];
}

- (BOOL)canUndo {
    return self.historyImageArray.count > 0 && self.currentIndex >= 0;
}
- (BOOL)canRedo {
    return self.historyImageArray.count > self.currentIndex+1;
}

- (void)undo {
    self.currentIndex -= 1;
    if (self.currentIndex < 0) {
        [self.canvas setBrush:nil];
        self.backImageView.image = nil;
        self.currentIndex = -1;
    } else {
        NSString * filePath = [self.historyImageArray objectAtIndex:self.currentIndex];
        UIImage * image = [[UIImage alloc] initWithContentsOfFile:filePath];
        [self.canvas setBrush:nil];
        self.backImageView.image = image;
    }
}

- (void)redo {
    if (self.historyImageArray.count > self.currentIndex+1) {
        self.currentIndex += 1;
        NSString * filePath = [self.historyImageArray objectAtIndex:self.currentIndex];
        UIImage * image = [[UIImage alloc] initWithContentsOfFile:filePath];
        [self.canvas setBrush:nil];
        self.backImageView.image = image;
    } else {
        NSLog(@"数据异常");
    }
}

- (void)setLindWidth:(CGFloat)lindWidth {
    _lindWidth = lindWidth;
    if (self.currentBrush) {
        self.currentBrush.width = _lindWidth;
    }
}

#pragma mark - public

- (void)drawimage:(UIImage *)image InRect:(CGRect)rect {
    CGRect targetRect;
    targetRect.origin.x = 0;
    targetRect.origin.y = 0;
    targetRect.size = image.size;
    CGFloat temp = image.size.width/image.size.height;
    NSLog(@"1  %lf", targetRect.size.width/targetRect.size.height);
    if (targetRect.size.width > self.width) {
        targetRect.size.width = self.width;
        targetRect.size.height = self.width/temp;
    }
    NSLog(@"2  %lf", targetRect.size.width/targetRect.size.height);
    if (targetRect.size.height > self.height) {
        targetRect.size.height = self.height;
        targetRect.size.width = self.height*temp;
    }
    NSLog(@"3  %lf", targetRect.size.width/targetRect.size.height);
    UIImage * tempimage = [self composeBrushToImageWithImage:image Rect:targetRect];
    self.backImageView.image = tempimage;
    [self storeCurrentImage];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dealTouches:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dealTouches:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dealTouches:touches];
}

- (void)dealTouches:(NSSet<UITouch *> *)touches {
    UITouch * tempTouch = [touches anyObject];
    //    UITouchPhaseBegan
    CGPoint currentPoint = [tempTouch locationInView:tempTouch.view];

    LxBrush * brush = self.currentBrush;
    if (tempTouch.phase == UITouchPhaseBegan) { // 开始
        if (brush == nil) {
            brush = [[LxBrush alloc] init];
//            [self.linesArray addObject:brush];
        }
        brush.beginPoint = currentPoint;
        self.lastPoint = currentPoint;
        ctr = 0;
        pts[0] = currentPoint;
        [brush.bezierPath moveToPoint:currentPoint];
    } else if (tempTouch.phase == UITouchPhaseEnded) { // 结束
        ctr = 0;
        brush.endPoint = currentPoint;
        // 默认画线，点击同一个点时，添加黑点
        if (brush.shapeType == LxShapeDefault && CGPointEqualToPoint(brush.beginPoint, brush.endPoint)) {
            [brush.bezierPath addArcWithCenter:currentPoint radius:self.lindWidth/4.0 startAngle:0 endAngle:2*M_PI clockwise:NO];
        } else if (brush.shapeType == LxShapeEraser) {
            [brush.bezierPath addArcWithCenter:currentPoint radius:self.lindWidth/4.0 startAngle:0 endAngle:2*M_PI clockwise:NO];
        }
        if (brush.shapeType == LxShapeEraser) {
            [self drawEraser:brush];
        } else {
            [self.canvas setBrush:brush];
        }
        [self storeCurrentImage];
    } else { // 移动
        if (brush.shapeType == LxShapeDefault || brush.shapeType == LxShapeEraser) {
//            CGPoint centerPoint = CGPointMake((currentPoint.x+self.lastPoint.x)*0.5, (currentPoint.y+self.lastPoint.y)*0.5);
//            [brush.bezierPath addQuadCurveToPoint:currentPoint controlPoint:centerPoint];
            // 此处优化策略，参考
            // https://code.tutsplus.com/tutorials/smooth-freehand-drawing-on-ios--mobile-13164
            ctr++;
            pts[ctr] = currentPoint;
            if (ctr == 4) {
                pts[3] = CGPointMake((pts[2].x + pts[4].x)/2.0, (pts[2].y + pts[4].y)/2.0); // move the endpoint to the middle of the line joining the second control point of the first Bezier segment and the first control point of the second Bezier segment
                
                [brush.bezierPath moveToPoint:pts[0]];
                [brush.bezierPath addCurveToPoint:pts[3] controlPoint1:pts[1] controlPoint2:pts[2]]; // add a cubic Bezier from pt[0] to pt[3], with control points pt[1] and pt[2]
                // replace points and get ready to handle the next segment
                pts[0] = pts[3]; 
                pts[1] = pts[4]; 
                ctr = 1;
            }
        } else if (brush.shapeType == LxShapeLine) {
            [brush.bezierPath removeAllPoints];
            [brush.bezierPath moveToPoint:brush.beginPoint];
            [brush.bezierPath addLineToPoint:currentPoint];
        } else if (brush.shapeType == LxShapeEllipse) {
            brush.bezierPath = [UIBezierPath bezierPathWithOvalInRect:[self getRectWithStartPoint:brush.beginPoint endPoint:currentPoint]];
        } else if (brush.shapeType == LxShapeRect) {
            brush.bezierPath = [UIBezierPath bezierPathWithRect:[self getRectWithStartPoint:brush.beginPoint endPoint:currentPoint]];
//        } else if (brush.shapeType == LxShapeEraser) {
            
        } else {
            NSLog(@"%ld", brush.shapeType);
        }
        if (brush.shapeType == LxShapeEraser) {
            [self drawEraser:brush];
        } else {
            [self.canvas setBrush:brush];
        }
        self.lastPoint = currentPoint;
    }
}

- (void)drawEraser:(LxBrush *)brush {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    [brush.bezierPath strokeWithBlendMode:kCGBlendModeClear alpha:1.0];
    
    self.backImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}


- (CGRect)getRectWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    CGFloat x = startPoint.x <= endPoint.x ? startPoint.x: endPoint.x;
    CGFloat y = startPoint.y <= endPoint.y ? startPoint.y : endPoint.y;
    CGFloat width = fabs(startPoint.x - endPoint.x);
    CGFloat height = fabs(startPoint.y - endPoint.y);
    
    return CGRectMake(x , y , width, height);
}


// MARK: - 撤销，缓存相关
- (void)storeCurrentImage {
    UIImage * image = [self composeBrushToImage];
    self.backImageView.image = image;
    [self.canvas setBrush:nil];
    [self.currentBrush.bezierPath removeAllPoints];
    dispatch_async_back(^{
        NSString * filePath = [self getTempImageBufferName];
        
        NSData *imgData = UIImagePNGRepresentation(image);
        BOOL bSucc = NO;
        if (imgData) {
            bSucc = [imgData writeToFile:filePath atomically:YES];
        }
        if (bSucc) {
            NSLog(@"存储成功 total:%ld index:%ld", self.historyImageArray.count, self.currentIndex);
            if (self.currentIndex < 0) {
                [self.historyImageArray removeAllObjects];
            } else {
                if (self.currentIndex == self.historyImageArray.count-1) {
                    NSLog(@"没有多余数据");
                } else if (self.historyImageArray.count > self.currentIndex+1) {
                    NSRange deleteRange = NSMakeRange(self.currentIndex+1, self.historyImageArray.count-self.currentIndex-1);
                    NSArray * bufferArray = [self.historyImageArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:deleteRange]];
                    [self.historyImageArray removeObjectsInRange:deleteRange];
                    dispatch_async_back(^{
                        for (NSString * tempFilePath in bufferArray) {
                            [[NSFileManager defaultManager] removeItemAtPath:tempFilePath error:nil];
                        }
                    });
                } else {
                    NSLog(@"数据异常");
                }
            }
            [self.historyImageArray addObject:filePath];
            self.currentIndex = self.historyImageArray.count-1;
        } else {
            NSLog(@"存储失败");
        }
    });
}

- (UIImage *)composeBrushToImage {
    return [self composeBrushToImageWithImage:nil Rect:CGRectZero];
}


- (UIImage *)composeBrushToImageWithImage:(UIImage *)image Rect:(CGRect)rect {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    if (image) {
        [image drawInRect:rect];
    }
    
    UIImage *getImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return getImage;
}




#pragma mark - 渲染计时器

- (void)checkToDraw {
//    <#code#>
}


#pragma mark - get

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.clipsToBounds = YES;
    }
    return _backImageView;
}

- (LxCanvas *)canvas {
    if (!_canvas) {
        _canvas = [[LxCanvas alloc] init];
    }
    return _canvas;
}

- (NSMutableArray *)historyImageArray {
    if (!_historyImageArray) {
        _historyImageArray = [NSMutableArray new];
    }
    return _historyImageArray;
}


// MARK: - private mathod

- (NSString *)getTempImageBufferName {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HHmmssSSS"];
    NSString * now = [dateformatter stringFromDate:date];
    NSString * picPath = [NSString stringWithFormat:@"%@cacheofdraw/%@_%ld", NSTemporaryDirectory(), now, self.historyImageArray.count];
    return picPath;
}


@end
