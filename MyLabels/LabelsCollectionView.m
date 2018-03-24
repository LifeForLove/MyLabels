//
//  LabelsCollectionView.m
//  MyLabels
//
//  Created by apple on 2018/3/18.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import "LabelsCollectionView.h"

#define SectionH 40

@protocol LabelsHeadReusableViewDelegate <NSObject>

- (void)editBtnAction:(UIButton *)sender;

@end

@interface LabelsHeadReusableView :UICollectionReusableView

@property (nonatomic, strong) UILabel *sectionLabel;

@property (nonatomic, strong) UIButton *sectionBtn;

@property (nonatomic, weak) id<LabelsHeadReusableViewDelegate> delegate;

@end

@implementation LabelsHeadReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.sectionLabel];
        [self addSubview:self.sectionBtn];
        self.sectionBtn.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
    }
    return self;
}

- (void)editBtnAction:(UIButton *)sender
{
    [self.delegate editBtnAction:sender];
}

- (UILabel *)sectionLabel
{
    if (_sectionLabel == nil) {
        _sectionLabel = [[UILabel alloc]init];
        _sectionLabel.font = [UIFont systemFontOfSize:15];
    }
    return _sectionLabel;
}

- (UIButton *)sectionBtn
{
    if (_sectionBtn == nil) {
        _sectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sectionBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_sectionBtn addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sectionBtn;
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.sectionLabel.frame = CGRectMake(10, 0, self.bounds.size.width - 20, self.bounds.size.height);
    CGFloat btnW = 60;
    CGFloat btnH = self.bounds.size.height;
    self.sectionBtn.frame = CGRectMake(self.bounds.size.width - 10 - btnW, 0, btnW, btnH);
}
@end


@class LabelsCollectionViewCell;
@protocol LabelsCollectionViewCellDelegate <NSObject>

- (void)deleteAction:(LabelsCollectionViewCell *)cell;

@end


@interface LabelsCollectionViewCell :UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, weak) id<LabelsCollectionViewCellDelegate> delegate;

@end

@implementation LabelsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.deleteBtn];
        self.deleteBtn.hidden = YES;
        self.titleLabel.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
    }
    return self;
}

- (void)deleteBtnAction:(UIButton *)sender
{
    [self.delegate deleteAction:self];
}

- (UIButton *)deleteBtn
{
    if (_deleteBtn == nil) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = self.contentView.bounds;
    self.deleteBtn.frame = CGRectMake(self.contentView.bounds.size.width - 20, -10, 30, 30);
}


@end




@interface LabelsCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource,LabelsCollectionViewCellDelegate,LabelsHeadReusableViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end


@implementation LabelsCollectionView
{
    CGPoint _selectItemCenter;      //当前选择的item的中心点
    CGPoint _currentPassPoint;      //当前经过的点
    BOOL _deleteState;              //是否是删除状态
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.collectionView];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray * arr = self.infoArr[section];
    return arr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, SectionH);
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.infoArr.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView * reusableView;
    if (kind == UICollectionElementKindSectionHeader) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headCell" forIndexPath:indexPath];
     LabelsHeadReusableView * reusableHeadView = (LabelsHeadReusableView *)reusableView;
        reusableHeadView.sectionLabel.text = indexPath.section == 0 ? @"我的频道":@"推荐频道";
        [reusableHeadView.sectionBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [reusableHeadView.sectionBtn setTitle:@"完成" forState:UIControlStateSelected];
        reusableHeadView.sectionBtn.hidden = indexPath.section == 0 ? NO :YES;
        reusableHeadView.delegate = self;
    }
    return reusableView;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LabelsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.titleLabel.text = self.infoArr[indexPath.section][indexPath.item];
        cell.deleteBtn.hidden = _deleteState ? NO : YES;
    }else
    {
        cell.titleLabel.text = [NSString stringWithFormat:@"+%@",self.infoArr[indexPath.section][indexPath.item]];
        cell.deleteBtn.hidden = YES;
    }
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        [self insertLabels:indexPath];
    }
}

- (void)insertLabels:(NSIndexPath *)indexPath
{
    NSMutableArray * myArr = self.infoArr[0];
    NSMutableArray * refArr = self.infoArr[1];
    [myArr addObject:refArr[indexPath.item]];
    NSIndexPath * myIndex = [NSIndexPath indexPathForItem:myArr.count - 1 inSection:0];
    [self.infoArr replaceObjectAtIndex:0 withObject:myArr];
    [self.collectionView insertItemsAtIndexPaths:@[myIndex]];
    
    [refArr removeObjectAtIndex:indexPath.item];
    [self.infoArr replaceObjectAtIndex:1 withObject:refArr];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    
}

- (void)deleteAction:(LabelsCollectionViewCell *)cell
{
    NSIndexPath * indexPath = [self.collectionView indexPathForCell:cell];
    
    NSMutableArray * myArr = self.infoArr[0];
    NSMutableArray * refArr = self.infoArr[1];
    
    [refArr insertObject:myArr[indexPath.item] atIndex:0];
    [self.infoArr replaceObjectAtIndex:1 withObject:refArr];
    NSIndexPath * refIndex = [NSIndexPath indexPathForItem:0 inSection:1];
    [self.collectionView insertItemsAtIndexPaths:@[refIndex]];
    
    [myArr removeObjectAtIndex:indexPath.item];
    [self.infoArr replaceObjectAtIndex:0 withObject:myArr];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

- (void)editBtnAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self showDeleteImg];
    }else
    {
        [self hideDelete];
    }
    
}


#pragma mark   长按：进行拖动item
- (void)longPressGestureOperation:(UILongPressGestureRecognizer *)longPressGesture
{
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint point = [longPressGesture locationInView:self.collectionView];
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
            //如果长按的不是图片位置，则无效
            if (indexPath.section != 0 || indexPath == nil) {
                break;
            }
            //如果是显示图片的Cell则可以拖动
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            //找到点击的视图，让其抖一抖
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
            
            [self showDeleteImg];
            //记录当前选择的item中心点在collecitonView上的位置。
            _selectItemCenter = cell.center;
            //记录当前经过的点
            _currentPassPoint = point;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            //当前经过的点
            CGPoint point = [longPressGesture locationInView:self.collectionView];
            //上次经过的点，与本次经过的点在 x y 方向上的位移
            CGFloat cha_x = point.x - _currentPassPoint.x;
            CGFloat cha_y = point.y - _currentPassPoint.y;
            //那么点击的item的中心点也跟随移动相同的位移
            _selectItemCenter = CGPointMake(_selectItemCenter.x+cha_x, _selectItemCenter.y+cha_y);
            [self.collectionView updateInteractiveMovementTargetPosition:_selectItemCenter];
            _currentPassPoint = point;
        }
            break;
        case  UIGestureRecognizerStateEnded:
        {
            [self.collectionView endInteractiveMovement];
        }
            break;
        default:
            
            break;
    }
}
//是否允许跟随移动
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//即将交换位置的时候调用
- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath
{
    //如果要交换的indexPath不是第一区，则返回原来的位置
    if (proposedIndexPath.section != 0) {
        return originalIndexPath;
    }
    return proposedIndexPath;
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSString * title = self.infoArr[0][sourceIndexPath.item];
    NSMutableArray * myArr = self.infoArr[0];
    [myArr removeObjectAtIndex:sourceIndexPath.item];
    [myArr insertObject:title atIndex:destinationIndexPath.item];
    [self.infoArr replaceObjectAtIndex:0 withObject:myArr];
}

- (void)showDeleteImg
{
    UIScrollView * scrollView = (UIScrollView *)self.nextResponder;
    scrollView.scrollEnabled = NO;
    _deleteState = YES;
    LabelsHeadReusableView * reus = (LabelsHeadReusableView *)[self.collectionView supplementaryViewForElementKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    reus.sectionBtn.selected = YES;
    NSArray * myArr = self.infoArr[0];
    for (int i = 0; i < myArr.count ; i++)
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        LabelsCollectionViewCell * cell = (LabelsCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        cell.deleteBtn.hidden = NO;
    }
}

- (void)hideDelete
{
    UIScrollView * scrollView = (UIScrollView *)self.nextResponder;
    scrollView.scrollEnabled = YES;
    _deleteState = NO;
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
    [self.collectionView reloadSections:indexSet];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MylabelsViewToTop" object:nil];
    }else{
        if (!_deleteState) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"MylabelsViewToBottom" object:nil];
        }
    }
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    self.collectionView.frame = CGRectMake(0, SectionH, self.bounds.size.width, self.bounds.size.height - SectionH);
}


- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = self.backgroundColor;
        [_collectionView registerClass:[LabelsCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerClass:[LabelsHeadReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headCell"];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureOperation:)];
        [_collectionView addGestureRecognizer:longPress];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout
{
    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc]init];
        _layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 50)/ 4 , 30);
        _layout.minimumInteritemSpacing = 10;
        _layout.minimumLineSpacing = 10;
        _layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return _layout;
}

- (void)setInfoArr:(NSMutableArray *)infoArr
{
    _infoArr = infoArr;
    [self.collectionView reloadData];
}
@end
