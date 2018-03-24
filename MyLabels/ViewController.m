//
//  ViewController.m
//  MyLabels
//
//  Created by apple on 2018/3/18.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import "ViewController.h"
#import "MyLabelsView.h"
#import "NSArray+Log.h"
@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *infoArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"选择标签" forState:0];
    button.frame = CGRectMake(0, 0, 100, 30);
    button.center = self.view.center;
    [button setBackgroundColor:[UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0]];
    [button addTarget:self action:@selector(showLabels) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

- (void)showLabels
{
    MyLabelsView * view = [[MyLabelsView alloc]initWithInfoArr:self.infoArr];
    view.BackBlock = ^(NSMutableArray *infoArr) {
        NSLog(@"%@",infoArr);
    };
    [view show];
}


- (NSMutableArray *)infoArr
{
    if (_infoArr == nil) {
        _infoArr = [NSMutableArray array];
        NSMutableArray * arr1 = [[NSMutableArray alloc]initWithArray:@[
                                                                       @"推荐",@"热点",@"北京",@"视频",
                                                                       @"社会",@"图片",@"娱乐",@"问答",
                                                                       @"科技",@"汽车",@"财经",@"军事",
                                                                       @"体育",@"段子",@"国际",@"趣图",
                                                                       @"健康",@"特卖",@"房产",@"小说",
                                                                       @"时尚",@"直播",@"育儿",@"搞笑",
                                                                       ]];
        NSMutableArray * arr2 = [[NSMutableArray alloc]initWithArray:@[
                                                                       @"历史",@"数码",@"美食",@"养生",
                                                                       @"电影",@"手机",@"旅游",@"宠物",
                                                                       @"情感",@"家具",@"教育",@"三农",
                                                                       @"孕产",@"文化",@"游戏",@"股票",
                                                                       @"科学",@"动漫",@"故事",@"收藏",
                                                                       @"精选",@"语录",@"星座",@"美图",
                                                                       @"辟谣",@"中国新唱将",@"微头条",@"正能量",
                                                                       @"互联网法院",@"彩票",@"快乐男声",@"中国好表演",
                                                                       @"传媒"
                                                                       ]];
        [_infoArr addObject:arr1];
        [_infoArr addObject:arr2];
    }
    return _infoArr;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
