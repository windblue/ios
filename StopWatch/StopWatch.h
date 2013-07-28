//
//  StopWatch.h
//  StopWatch
//
//  Created by 天野 裕介 on 2013/07/28.
//  Copyright (c) 2013年 Yusuke Amano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StopWatch : NSObject

+ (StopWatch *)sharedInstance;

- (void)start:(NSString *)lapId;
- (void)stop:(NSString *)lapId;
- (void)showResult;

@end
