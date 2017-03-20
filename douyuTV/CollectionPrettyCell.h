//
//  CollectionPrettyCell.h
//  douyuTV
//
//  Created by 吴凡 on 17/3/16.
//  Copyright © 2017年 吴凡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionBaseCell.h"

@interface CollectionPrettyCell : CollectionBaseCell
@property (weak, nonatomic) IBOutlet UIButton *onlineLabel;
@property (weak, nonatomic) IBOutlet UIImageView *roomIamge;
@property (weak, nonatomic) IBOutlet UILabel *roomName;
@property (weak, nonatomic) IBOutlet UIButton *cityLabel;

@end
