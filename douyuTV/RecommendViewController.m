//
//  RecommendViewController.m
//  douyuTV
//
//  Created by 吴凡 on 17/3/15.
//  Copyright © 2017年 吴凡. All rights reserved.
//

#import "RecommendViewController.h"
#import "RecommendCycleView.h"
#import "RecommendBaseModel.h"
#import "CollectionBaseCell.h"
#import "CollectionNormalCell.h"
#import "CollectionPrettyCell.h"
#import "CollectionHeaderView.h"



#define kCycleViewH kScreenW * 3 / 8

@interface RecommendViewController ()
@property (nonatomic,strong)RecommendCycleView *cycleView;
@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    _cycleView = [[RecommendCycleView alloc]initWithFrame:CGRectMake(0, -kCycleViewH, kScreenW, kCycleViewH)];
    self.collectionView.frame = self.view.bounds;
    [self.view addSubview:self.collectionView];
    [self.collectionView addSubview:_cycleView];
    self.collectionView.contentInset = UIEdgeInsetsMake(kCycleViewH, 0, 0, 0);
    
    _dataSource = [NSMutableArray new];
    _sectionArr = [NSMutableArray new];
    [self getHttpRequestWithHot];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _dataSource.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSMutableArray *sectionArr = _dataSource[section];
    return sectionArr.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return CGSizeMake(kItemW, kPrettyItemH);
    }
    else{
        return CGSizeMake(kItemW, kNormalItemH);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
         CollectionNormalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kNormalCell forIndexPath:indexPath];
        if (_dataSource.count != 0) {
            NSMutableArray *modelArr = _dataSource[0];
            RecommendBaseModel *hotModel = modelArr[indexPath.item];
            [cell.roomImage sd_setImageWithURL:[NSURL URLWithString:hotModel.roomImageUrl]];
            cell.roomName.text = [NSString stringWithFormat:@"%@",hotModel.roomName];
            cell.nickName.text = [NSString stringWithFormat:@"%@",hotModel.nickName];
            [cell.onlineLabel setTitle:[NSString stringWithFormat:@"%@在线",hotModel.onlineNumber]forState:UIControlStateNormal];
        }
        return cell;
    }
    
    else if (indexPath.section == 1) {
        CollectionPrettyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPrettyCell forIndexPath:indexPath];
        if (_dataSource.count != 0) {
            NSMutableArray *modelArr = _dataSource[1];
            RecommendBaseModel *prettyModel = modelArr[indexPath.item];
            [cell.roomIamge sd_setImageWithURL:[NSURL URLWithString:prettyModel.roomImageUrl]];
            //主播名 非房间名
            cell.roomName.text = [NSString stringWithFormat:@"%@",prettyModel.nickName];
            [cell.onlineLabel setTitle:[NSString stringWithFormat:@"%@在线",prettyModel.onlineNumber]forState:UIControlStateNormal];
            if ([prettyModel.onlineNumber integerValue] > 10000) {
                [cell.onlineLabel setTitle:[NSString stringWithFormat:@"%d万在线",[prettyModel.onlineNumber intValue]/10000]forState:UIControlStateNormal];
            }
        }
        return cell;
    }
    else {
        CollectionNormalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kNormalCell forIndexPath:indexPath];
        if (_dataSource.count != 0) {
            NSMutableArray *modelArr = _dataSource[indexPath.section];
            RecommendBaseModel *hotModel = modelArr[indexPath.item];
            [cell.roomImage sd_setImageWithURL:[NSURL URLWithString:hotModel.roomImageUrl]];
            cell.roomName.text = [NSString stringWithFormat:@"%@",hotModel.roomName];
            cell.nickName.text = [NSString stringWithFormat:@"%@",hotModel.nickName];
            [cell.onlineLabel setTitle:[NSString stringWithFormat:@"%@在线",hotModel.onlineNumber]forState:UIControlStateNormal];
        }
        return cell;
    }
    
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderViewID forIndexPath:indexPath];
    headerView.imageIcon.image = [UIImage imageNamed:@"home_header_normal"];
    headerView.titleLabel.text = [NSString stringWithFormat:@"%@",_sectionArr[indexPath.section]];
    
    if (indexPath.section == 0) {
        headerView.imageIcon.image = [UIImage imageNamed:@"home_header_hot"];
    }
    else if (indexPath.section == 1) {
        headerView.imageIcon.image = [UIImage imageNamed:@"home_header_phone"];
    }

    return headerView;
}
#pragma mark - HttpRequest
-(void)getHttpRequestWithHot
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"POST", @"GET", @"HEAD"]];
    manager.securityPolicy.allowInvalidCertificates =YES;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html;charset=UTF-8", nil];
    
    NSString *timeStr = [NSData getCurrentTime];
    NSDictionary *parameterDict = @{@"time":timeStr};
    NSLog(@"%@",parameterDict);
    
    [manager POST:@"http://capi.douyucdn.cn/api/v1/getbigDataRoom" parameters:parameterDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSMutableArray *dataArr = dict[@"data"];
        
        [_dataSource removeAllObjects];
        NSMutableArray *sectionArr = [NSMutableArray new];
        for (NSDictionary *subDic in dataArr) {
            RecommendBaseModel *hotModel = [RecommendBaseModel new];
            hotModel.nickName = [NSString stringWithFormat:@"%@",subDic[@"nickname"]];
            hotModel.roomImageUrl = [NSString stringWithFormat:@"%@",subDic[@"room_src"]];
            hotModel.roomId = [NSString stringWithFormat:@"%@",subDic[@"room_id"]];
            hotModel.roomName = [NSString stringWithFormat:@"%@",subDic[@"room_name"]];
            hotModel.onlineNumber = [NSString stringWithFormat:@"%@",subDic[@"online"]];

            [sectionArr addObject:hotModel];
        }
        [_dataSource addObject:sectionArr];
        
        [_sectionArr addObject:@"最热"];
        
        [self.collectionView reloadData];
        
        [self getHttpRequestWithPretty];
        
        
        NSLog(@"%@ - hot",dict);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (void)getHttpRequestWithPretty
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"POST", @"GET", @"HEAD"]];
    manager.securityPolicy.allowInvalidCertificates =YES;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html;charset=UTF-8", nil];
    
    NSString *timeStr = [NSData getCurrentTime];
    NSDictionary *parameterDict = @{@"time":timeStr};
    NSLog(@"%@",parameterDict);
    
    [manager POST:@"http://capi.douyucdn.cn/api/v1/getVerticalRoom?limit=4&offset=0" parameters:parameterDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSMutableArray *dataArr = dict[@"data"];
        
        NSMutableArray *sectionArr = [NSMutableArray new];
        for (NSDictionary *subDic in dataArr) {
            RecommendBaseModel *prettyModel = [RecommendBaseModel new];
            prettyModel.nickName = [NSString stringWithFormat:@"%@",subDic[@"nickname"]];
            prettyModel.roomImageUrl = [NSString stringWithFormat:@"%@",subDic[@"vertical_src"]];
            prettyModel.roomId = [NSString stringWithFormat:@"%@",subDic[@"room_id"]];
            prettyModel.roomName = [NSString stringWithFormat:@"%@",subDic[@"room_name"]];
            prettyModel.onlineNumber = [NSString stringWithFormat:@"%@",subDic[@"online"]];
            prettyModel.city = [NSString stringWithFormat:@"%@",subDic[@"anchor_city"]];
            
            [sectionArr addObject:prettyModel];
        }
        [_dataSource addObject:sectionArr];
        
        [self.collectionView reloadData];
        
        [_sectionArr addObject:@"颜值"];
        
        [self getHttpRequestWithBigData];
        
        
        NSLog(@"%@ - pretty",dict);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
-(void)getHttpRequestWithBigData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"POST", @"GET", @"HEAD"]];
    manager.securityPolicy.allowInvalidCertificates =YES;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html;charset=UTF-8", nil];
    
    NSString *timeStr = [NSData getCurrentTime];
    NSDictionary *parameterDict = @{@"time":timeStr,@"limit":@4,@"offset":@0};
    NSLog(@"%@",parameterDict);
    
    [manager POST:@"http://capi.douyucdn.cn/api/v1/getHotCate" parameters:parameterDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSMutableArray *dataArr = dict[@"data"];
        
        for (NSDictionary *subDic in dataArr) {
            NSMutableArray *sectionArr = [NSMutableArray new];
            for (NSDictionary *roomDic in subDic[@"room_list"]) {
                RecommendBaseModel *hotModel = [RecommendBaseModel new];
                hotModel.nickName = [NSString stringWithFormat:@"%@",roomDic[@"nickname"]];
                hotModel.roomImageUrl = [NSString stringWithFormat:@"%@",roomDic[@"room_src"]];
                hotModel.roomId = [NSString stringWithFormat:@"%@",roomDic[@"room_id"]];
                hotModel.roomName = [NSString stringWithFormat:@"%@",roomDic[@"room_name"]];
                hotModel.onlineNumber = [NSString stringWithFormat:@"%@",roomDic[@"room_list"][@"online"]];
                
                [sectionArr addObject:hotModel];
                }
             [_dataSource addObject:sectionArr];
             [_sectionArr addObject:[NSString stringWithFormat:@"%@",subDic[@"tag_name"]]];
        }
       
        [self.collectionView reloadData];
        
        
        NSLog(@"%@ - bigData",dict);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
