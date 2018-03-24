//
//  MyLabelsView.m
//  MyLabels
//
//  Created by apple on 2018/3/18.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import "MyLabelsView.h"
#import "LabelsCollectionView.h"
#import "BackgroundScrollView.h"
#define ContentTopMargin 40

@interface MyLabelsView ()<UIScrollViewDelegate>

@property (nonatomic, strong) BackgroundScrollView *bgScrollView;

@property (nonatomic, strong) LabelsCollectionView *labelsCollectionView;

@property (nonatomic, strong) NSMutableArray *infoArr;

@end


@implementation MyLabelsView

- (instancetype)initWithInfoArr:(NSMutableArray *)infoArr
{
    self = [super init];
    if (self) {
        self.infoArr = infoArr;
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = [UIColor colorWithRed:20/255.0 green:20/255.0 blue:20/255.0 alpha:0.3];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mylabelsViewToTop) name:@"MylabelsViewToTop" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mylabelsViewToBottom) name:@"MylabelsViewToBottom" object:nil];
        
    }
    return self;
}


- (void)mylabelsViewToTop
{
    _bgScrollView.contentOffset = CGPointMake(0, [UIScreen mainScreen].bounds.size.height);
    _bgScrollView.scrollEnabled = NO;
}

- (void)mylabelsViewToBottom
{
    _bgScrollView.scrollEnabled = YES;
}


- (void)show
{
    [self addSubview:self.bgScrollView];
    [self.bgScrollView setContentOffset:CGPointMake(0, [UIScreen mainScreen].bounds.size.height) animated:YES];
    
    [self.bgScrollView addSubview:self.labelsCollectionView];
    self.labelsCollectionView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height + ContentTopMargin, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - ContentTopMargin);
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y == 0) {
        [self hide];
    }
}


- (void)hide
{
    if (self.BackBlock) {
        self.BackBlock(self.infoArr);
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        [self.bgScrollView removeFromSuperview];
        [self.labelsCollectionView removeFromSuperview];
        [self removeFromSuperview];
    }];
}


- (LabelsCollectionView *)labelsCollectionView
{
    if (_labelsCollectionView == nil) {
        _labelsCollectionView = [[LabelsCollectionView alloc]init];
        _labelsCollectionView.infoArr = self.infoArr;
    }
    return _labelsCollectionView;
}


-(UIScrollView *)bgScrollView
{
    if (_bgScrollView == nil) {
        _bgScrollView = [[BackgroundScrollView alloc]initWithFrame:self.bounds];
        _bgScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 2);
        _bgScrollView.pagingEnabled = YES;
        _bgScrollView.delegate = self;
    }
    return _bgScrollView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
