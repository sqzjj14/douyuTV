//
//  RecommendCycleView.m
//  douyuTV
//
//  Created by 吴凡 on 17/3/17.
//  Copyright © 2017年 吴凡. All rights reserved.
//

#import "RecommendCycleView.h"
#import "CollectionCycleCell.h"
#import "CycleModel.h"

#define kCycleCellID @"cycleCell"

@implementation RecommendCycleView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self != [super initWithFrame:frame]) {
        return nil;
    }
    
    self.frame = frame;
    _dataSource = [NSMutableArray new];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(kScreenW, frame.size.height);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    
    _collectView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    [_collectView registerNib:[UINib nibWithNibName:@"CollectionCycleCell" bundle:nil] forCellWithReuseIdentifier:kCycleCellID];
    _collectView.pagingEnabled = true;
    _collectView.bounces = false;
    _collectView.showsHorizontalScrollIndicator = false;
    _collectView.scrollsToTop = false;
    _collectView.dataSource = self;
    _collectView.delegate = self;
    [self addSubview:_collectView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    _pageControl.numberOfPages = 3;
    _pageControl.currentPage = 0;
    _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    _pageControl.pageIndicatorTintColor = RGBACOLOR(232, 234, 236, 1);
    //[_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_pageControl];
    
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        //make.width.mas_equalTo(40);
        make.bottom.equalTo(self.mas_bottom).offset(-8);
        make.height.mas_equalTo(20);
    }];
    
    [self removeTimer];
    [self addTimer];
    [self getHttpRequest];
    
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_dataSource.count == 0) {
        return 10000;
    }
    return _dataSource.count * 10000;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionCycleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCycleCellID forIndexPath:indexPath];
    
    if (_dataSource.count != 0) {
        NSInteger index =  indexPath.item % _dataSource.count;
        CycleModel *model = _dataSource[index];
        cell.title.text = model.title; //(null)
        if (![model.imageUrl isEqualToString:@"(null)"]) {
            [cell.image sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"Img_default"]];
        }
    }
    
    return cell;
}
- (void)scrollToNext
{
    CGFloat currentOffSet = _collectView.contentOffset.x + _collectView.bounds.size.width;
    [_collectView setContentOffset:CGPointMake(currentOffSet, 0) animated:YES];
}
- (void)addTimer
{
    _timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(scrollToNext) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}
- (void)removeTimer
{
    [_timer invalidate];
    _timer = nil;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.x + scrollView.bounds.size.width * 0.5;
    if (_dataSource.count != 0) {
        _pageControl.currentPage = (int)(offset / scrollView.bounds.size.width) % (_dataSource.count);
    }
    else {
        _pageControl.currentPage = (int)(offset / scrollView.bounds.size.width) % 3;
    }
    
}

#pragma mark - HttpRequest
-(void)getHttpRequest
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"POST", @"GET", @"HEAD"]];
    manager.securityPolicy.allowInvalidCertificates =YES;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html;charset=UTF-8", nil];

    NSDictionary *parameterDict = @{@"version":@"2.300"};
    NSLog(@"%@",parameterDict);
    
    [manager POST:@"http://www.douyutv.com/api/v1/slide/6" parameters:parameterDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSMutableArray *dataArr = dict[@"data"];
        
        [_dataSource removeAllObjects];
        for (NSDictionary *subDic in dataArr) {
            CycleModel *cycleModel = [CycleModel new];
            cycleModel.title = [NSString stringWithFormat:@"%@",subDic[@"title"]];
            cycleModel.imageUrl = [NSString stringWithFormat:@"%@",subDic[@"pic_url"]];
            [_dataSource addObject:cycleModel];
        }
        
        [_collectView reloadData];
        _pageControl.numberOfPages = _dataSource.count;
            
           
        NSLog(@"%@ - cycleData",dict);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

@end
