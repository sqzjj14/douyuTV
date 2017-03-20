//
//  NSData+Time.m
//  douyuTV
//
//  Created by 吴凡 on 17/3/17.
//  Copyright © 2017年 吴凡. All rights reserved.
//

#import "NSData+Time.h"

@implementation NSData (Time)
+ (NSString*)getCurrentTime
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    int a= (int)[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%d", a];
    
    return timeString;
}
@end

