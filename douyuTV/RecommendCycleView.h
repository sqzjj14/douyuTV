//
//  RecommendCycleView.h
//  douyuTV
//
//  Created by 吴凡 on 17/3/17.
//  Copyright © 2017年 吴凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendCycleView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong)UICollectionView *collectView;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)NSMutableArray *dataSource;

-(instancetype)initWithFrame:(CGRect)frame;
@end
