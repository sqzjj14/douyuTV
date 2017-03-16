//
//  HomeViewController.m
//  douyuTV
//
//  Created by 吴凡 on 17/3/15.
//  Copyright © 2017年 吴凡. All rights reserved.
//

#import "HomeViewController.h"
#import "RecommendViewController.h"
#import "GameViewController.h"
#import "AmuseViewController.h"
#import "FunnyViewController.h"
#import "PageTitleView.h"
#import "PageContentView.h"

@interface HomeViewController ()<PageTitleViewDelegate,PageContentViewDelegate>
@property(nonatomic,strong)PageTitleView *pageTitleView;
@property(nonatomic,strong)PageContentView *pageContentView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationLeftItem];
    [self setNavigationRightItem];
    
    _pageTitleView = [[PageTitleView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, 40) isScrollEnable:NO titles:@[@"推荐", @"游戏", @"娱乐", @"趣玩"]];
    _pageTitleView.delegate = self;
    [self.view addSubview:_pageTitleView];
    
    NSMutableArray *childVCs = [NSMutableArray new];
    RecommendViewController *vc1 = [RecommendViewController new];
    GameViewController *vc2 = [GameViewController new];
    AmuseViewController *vc3 = [AmuseViewController new];
    FunnyViewController *vc4 = [FunnyViewController new];
    [childVCs addObject:vc1];
    [childVCs addObject:vc2];
    [childVCs addObject:vc3];
    [childVCs addObject:vc4];
    
    _pageContentView = [[PageContentView alloc]initWithFrame:CGRectMake(0, 64 + 40, kScreenW, kScreenH - 64 -40) childVCs:childVCs perentViewController:self scrollView:_pageContentView.scrollView];
    _pageContentView.delegate = self;
    [self.view addSubview:_pageContentView];

}
- (void)setNavigationLeftItem
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"logo"] forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(leftItemClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
- (void)setNavigationRightItem
{
    UIButton *historyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [historyBtn setImage:[UIImage imageNamed:@"image_my_history"] forState:UIControlStateNormal];
    [historyBtn setImage:[UIImage imageNamed:@"Image_my_history_click"] forState:UIControlStateHighlighted];
    [historyBtn sizeToFit];
    [historyBtn addTarget:self action:@selector(historyItemClick:) forControlEvents:UIControlEventTouchUpInside];
    historyBtn.frame = CGRectMake(0, 0, 40, 44);
    UIBarButtonItem *itme1 = [[UIBarButtonItem alloc]initWithCustomView:historyBtn];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:[UIImage imageNamed:@"btn_search"] forState:UIControlStateNormal];
    [searchBtn setImage:[UIImage imageNamed:@"btn_search_clicked"] forState:UIControlStateHighlighted];
    [searchBtn sizeToFit];
    [searchBtn addTarget:self action:@selector(searchItemClick:) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.frame = CGRectMake(0, 0, 40, 44);
    UIBarButtonItem *itme2 = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    
    UIButton *qrcodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [qrcodeBtn setImage:[UIImage imageNamed:@"Image_scan"] forState:UIControlStateNormal];
    [qrcodeBtn setImage:[UIImage imageNamed:@"Image_scan_click"] forState:UIControlStateHighlighted];
    [qrcodeBtn sizeToFit];
    [qrcodeBtn addTarget:self action:@selector(qrcodeItemClick:) forControlEvents:UIControlEventTouchUpInside];
    qrcodeBtn.frame = CGRectMake(0, 0, 40, 44);
    UIBarButtonItem *itme3 = [[UIBarButtonItem alloc]initWithCustomView:qrcodeBtn];
    
    self.navigationItem.rightBarButtonItems = @[itme1,itme2,itme3];


}
#pragma mark - Custom Delegate
- (void)GetPageTitleViewIndexWithClass:(PageTitleView *)pageTitleView andIndex:(NSInteger)index
{
    CGPoint offset = CGPointMake((index-100) * _pageContentView.collectionView.bounds.size.width, 0);
    [_pageContentView.collectionView setContentOffset:offset];
}

- (void)GetPageContentViewScrollInroWithClass:(PageContentView *)pageContentView andSourceIndex:(NSInteger)sourceIndex andTargetIndex:(NSInteger)targetIndex andProgress:(CGFloat)progress
{
    NSLog(@"progress = %f",progress);
    
    float a[] = {85,85,85};
    float b[] = {255,128,0};
    float c[] = {b[0]-a[0],b[1]-a[1],b[2]-a[2]}; //颜色渐变范围
    
    UILabel *sourceLabel = _pageTitleView.labelArray[sourceIndex];
    UILabel *targetLabel = _pageTitleView.labelArray[targetIndex];
    
    CGFloat moveMargin = targetLabel.frame.origin.x - sourceLabel.frame.origin.x;
    _pageTitleView.scrollLine.frame = CGRectMake(sourceLabel.frame.origin.x + moveMargin * progress, _pageTitleView.frame.size.height - 2.5 ,_pageTitleView.frame.size.width/4, 2);
    
    sourceLabel.textColor = [UIColor colorWithRed:(b[0] - c[0]*progress)/255.f green:(b[1] - c[1]*progress)/255.f blue:(b[2] - c[2]*progress)/255.f alpha:1];
    targetLabel.textColor = [UIColor colorWithRed:(a[0] + c[0]*progress)/255.f green:(a[1] + c[1]*progress)/255.f blue:(a[2] + c[2]*progress)/255.f alpha:1];

    
}

#pragma mark - Click Action
- (void)leftItemClick:(id)sender
{
    NSLog(@"点击了logo");
}
-(void)historyItemClick:(id)sender
{
    NSLog(@"点击了历史记录");
}
-(void)searchItemClick:(id)sender
{
    NSLog(@"点击了搜索");
}
-(void)qrcodeItemClick:(id)sender
{
    NSLog(@"点击了扫描二维码");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
