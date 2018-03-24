//
//  MyLabelsView.h
//  MyLabels
//
//  Created by apple on 2018/3/18.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyLabelsView : UIView

- (instancetype)initWithInfoArr:(NSMutableArray *)infoArr;

- (void)show;

@property (nonatomic, copy) void (^BackBlock)(NSMutableArray * infoArr);


@end
