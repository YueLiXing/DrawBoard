//
//  UIView+AddSubView.m
//  TestDrawBoard
//
//  Created by yuelixing on 2017/2/22.
//  Copyright © 2017年 YueLiXing. All rights reserved.
//

#import "UIView+AddSubView.h"

@implementation UIView (AddSubView)

- (void)addSubviewFromArray:(NSArray<UIView *> *)views {
    for (UIView * temp in views) {
        if (temp.superview == nil) {
            [self addSubview:temp];
        }
    }
}


@end
