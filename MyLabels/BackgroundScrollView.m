//
//  BackgroundScrollView.m
//  MyLabels
//
//  Created by apple on 2018/3/21.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import "BackgroundScrollView.h"

@implementation BackgroundScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

@end
