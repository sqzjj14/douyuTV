//
//  CollectionNormalCell.h
//  douyuTV
//
//  Created by 吴凡 on 17/3/16.
//  Copyright © 2017年 吴凡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionBaseCell.h"

@interface CollectionNormalCell : CollectionBaseCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *roomName;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UIButton *onlineNumber;

@end
