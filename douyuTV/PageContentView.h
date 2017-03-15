//
//  PageContentView.h
//  douyuTV
//
//  Created by 吴凡 on 17/3/15.
//  Copyright © 2017年 吴凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PageContentView;
@protocol PageContentViewDelegate <NSObject>

- (void)GetPageContentViewScrollInroWithClass:(PageContentView*)pageContentView andSourceIndex:(NSInteger)sourceIndex andTargetIndex:(NSInteger)targetIndex andProgress:(CGFloat)progress;

@end

@interface PageContentView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *childVCs;
@property (nonatomic,strong)UIViewController *perentVC;
@property (nonatomic,weak)id<PageContentViewDelegate>delegate;
@property (nonatomic,assign)NSInteger sourceIndex;
@property (nonatomic,assign)NSInteger targetIndex;
@property (nonatomic,assign)CGFloat progress;
@property (nonatomic,assign)CGFloat startOffsetX;


- (instancetype)initWithFrame:(CGRect)frame childVCs:(NSMutableArray*)childVcs perentViewController:(UIViewController*)perentViewController;
@end
