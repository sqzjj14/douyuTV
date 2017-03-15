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

- (instancetype)initWithFrame:(CGRect)frame childVCs:(NSMutableArray*)childVcs perentViewController:(UIViewController*)perentViewController
{
    if (self != [super initWithFrame:frame]) {
        return nil;
    }
    self.frame = frame;
    _childVCs = childVcs;
    _perentVC = perentViewController;
    
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

#pragma mark - ScrollDelegate

@end
