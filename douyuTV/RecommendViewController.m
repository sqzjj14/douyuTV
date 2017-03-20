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
    
    [self getHttpRequest];
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
#pragma mark - HttpRequest
-(void)getHttpRequest
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"POST", @"GET", @"HEAD"]];
    manager.securityPolicy.allowInvalidCertificates =YES;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html;charset=UTF-8", nil];
    
    NSString *timeStr = [NSData getCurrentTime];
    NSLog(@"timeStr = %@",timeStr);
    //NSDictionary *parameterDict = @{@"version":@"2.300"};
    //NSLog(@"%@",parameterDict);
    
    [manager POST:@"http://www.douyutv.com/api/v1/slide/6" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSMutableArray *dataArr = dict[@"data"];
        
       // [_dataSource removeAllObjects];
        for (NSDictionary *subDic in dataArr) {
//            CycleModel *cycleModel = [CycleModel new];
//            cycleModel.title = [NSString stringWithFormat:@"%@",subDic[@"title"]];
//            cycleModel.imageUrl = [NSString stringWithFormat:@"%@",subDic[@"pic_url"]];
//            [_dataSource addObject:cycleModel];
        }
        
        //[_collectView reloadData];
        
        
        NSLog(@"%@ - cycleData",dict);
        
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
