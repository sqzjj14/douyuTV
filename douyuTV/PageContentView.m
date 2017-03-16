//
//  PageContentView.m
//  douyuTV
//
//  Created by 吴凡 on 17/3/15.
//  Copyright © 2017年 吴凡. All rights reserved.
//

#import "PageContentView.h"
#define kCell @"cell"

@implementation PageContentView

- (instancetype)initWithFrame:(CGRect)frame childVCs:(NSMutableArray*)childVcs perentViewController:(UIViewController*)perentViewController scrollView:(UIScrollView *)scrollview
{
    if (self != [super initWithFrame:frame]) {
        return nil;
    }
    self.frame = frame;
    _childVCs = childVcs;
    _perentVC = perentViewController;
    _scrollView = scrollview;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = self.bounds.size;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    //水平
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    _collectionView.showsHorizontalScrollIndicator = false;
    _collectionView.pagingEnabled = true;
    _collectionView.bounces = false;
    _collectionView.scrollsToTop = false;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCell];
    [self addSubview:_collectionView];
    
    for (UIViewController *childVC in childVcs) {
        
        [perentViewController addChildViewController:childVC];
        
    }
    
    return self;
}
#pragma mark - CollectViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _childVCs.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCell forIndexPath:indexPath];
    
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    UIViewController *childVc = _childVCs[indexPath.item];
    childVc.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:childVc.view];
    
    return cell;
}

#pragma mark - Scroll
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _startOffsetX = scrollView.contentOffset.x;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _sourceIndex = 0;
    _targetIndex = 0;
    _progress = 0;
    CGFloat currentOffsetX = scrollView.contentOffset.x; //scrollview即collectview
    NSLog(@"%f _startOffsetX=%f",currentOffsetX,_startOffsetX)
    ;
    CGFloat scrollViewW = scrollView.bounds.size.width;
    
    if (currentOffsetX > _startOffsetX) {
        _progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW);
        _sourceIndex = (int)(currentOffsetX / scrollViewW);
        _targetIndex = _sourceIndex + 1;
        
        if (_targetIndex >= _childVCs.count)
        {
            _targetIndex = _childVCs.count - 1;
        }
        
        if (currentOffsetX - _startOffsetX == scrollViewW) {
            _progress = 1;
            _targetIndex = _sourceIndex;
        }
    }
    else {
         _progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW));
        _targetIndex = (int)(currentOffsetX / scrollViewW);
        _sourceIndex = _targetIndex + 1;
        
        if (_sourceIndex >= _childVCs.count)
        {
            _sourceIndex = _childVCs.count - 1;
        }
    }
    
    NSLog(@"sourceIndex = %ld , targetIndex = %ld",(long)_sourceIndex,(long)_targetIndex);
    
    if ([_delegate respondsToSelector:@selector(GetPageContentViewScrollInroWithClass:andSourceIndex:andTargetIndex:andProgress:)]) {
        [_delegate GetPageContentViewScrollInroWithClass:self andSourceIndex:_sourceIndex andTargetIndex:_targetIndex andProgress:_progress];
    }
    
}

@end
