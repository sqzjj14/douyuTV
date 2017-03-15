//
//  PageTitleView.h
//  douyuTV
//
//  Created by 吴凡 on 17/3/15.
//  Copyright © 2017年 吴凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PageTitleView;
@protocol PageTitleViewDelegate <NSObject>

- (void)GetPageTitleViewIndexWithClass:(PageTitleView*)pageTitleView andIndex:(NSInteger)index;

@end

@interface PageTitleView : UIView
@property(nonatomic,assign)BOOL isScrollEnable;
@property(nonatomic,strong)NSArray *titles;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIView *scrollLine;
@property(nonatomic,strong)NSMutableArray *labelArray;
@property(nonatomic,assign)NSInteger oldIndex;
@property(nonatomic,weak)id<PageTitleViewDelegate>delegate;

-(instancetype)initWithFrame:(CGRect)frame isScrollEnable:(BOOL)isScrollEnable titles:(NSArray*)titles;

@end
