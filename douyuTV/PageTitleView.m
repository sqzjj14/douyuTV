//
//  PageTitleView.m
//  douyuTV
//
//  Created by 吴凡 on 17/3/15.
//  Copyright © 2017年 吴凡. All rights reserved.
//

#import "PageTitleView.h"
#define kWidth self.frame.size.width
#define kHeight self.frame.size.height
#define kNormalTitleColor  [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1]
#define kSelectTitleColor  [UIColor colorWithRed:255/255.0 green:128/255.0 blue:0/255.0 alpha:1]

@implementation PageTitleView

-(instancetype)initWithFrame:(CGRect)frame isScrollEnable:(BOOL)isScrollEnable titles:(NSArray *)titles
{
    if (self != [super initWithFrame:frame]) {
        return nil;
    }
    
    _isScrollEnable = isScrollEnable;
    _titles = titles;
    self.frame = frame;
    _labelArray = [NSMutableArray new];
    
    [self creatScrollView];
    
    return self;
}

- (void)creatScrollView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    _scrollView.contentSize = CGSizeMake(kWidth/4 * _titles.count, self.bounds.size.height);
    _scrollView.showsHorizontalScrollIndicator = false;
    _scrollView.scrollsToTop = false;
    _scrollView.bounces = NO;;
    _scrollView.scrollEnabled = _isScrollEnable;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_scrollView];
    
    [self creatLabel];
}
-(void)creatLabel
{
    for (int i = 0; i < _titles.count; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/4 * i, -64, kWidth/4, kHeight - 2)];
        label.tag = i+100;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16.f];
        label.text = _titles[i];
        label.textColor = kNormalTitleColor;
        if (i == 0) {
            label.textColor = kSelectTitleColor;
            _oldIndex = label.tag;
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelClick:)];
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:tap];
        [_scrollView addSubview:label];
        [_labelArray addObject:label];
    }
    
   [self creatBottomLineAndScrollline];
    
}
- (void)creatBottomLineAndScrollline
{
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight-0.5, kWidth, 0.5)];
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:bottomLine];
    
    _scrollLine = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight - 2.5, kWidth/4, 2)];
    _scrollLine.backgroundColor = kSelectTitleColor;
    [self addSubview:_scrollLine];
}

#pragma mark - Action
- (void)labelClick:(UITapGestureRecognizer*)tap
{
    UILabel *label = (UILabel*)tap.view;
    NSInteger index = label.tag;
    
    [self scrollToIndex:index];
    
    if ([_delegate respondsToSelector:@selector(GetPageTitleViewIndexWithClass:andIndex:)]) {
        [_delegate GetPageTitleViewIndexWithClass:self andIndex:index];
    }
}

#pragma mark - Scroll
- (void)scrollToIndex:(NSInteger)index
{
    UILabel *oldLabel = _labelArray[_oldIndex -100];
    UILabel *newLabel = _labelArray[index - 100];
    
    newLabel.textColor = kSelectTitleColor;
    oldLabel.textColor = kNormalTitleColor;
    
    CGFloat scrollLineEndX = _scrollLine.frame.size.width * (index - 100);
    [UIView animateWithDuration:0.2 animations:^{
        _scrollLine.frame = CGRectMake(scrollLineEndX, kHeight - 2.5 ,kWidth/4, 2);
    }];

    _oldIndex = index;
}
@end
