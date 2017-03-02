//
//  LxCanvas.h
//  TestDrawBoard
//
//  Created by yuelixing on 2017/2/21.
//  Copyright © 2017年 YueLiXing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LxBrush.h"

/**
 画布
 */
@interface LxCanvas : UIView

- (void)setBrush:(LxBrush *)brush;

@end
