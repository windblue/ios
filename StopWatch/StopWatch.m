//
//  StopWatch.m
//  StopWatch
//
//  Created by 天野 裕介 on 2013/07/28.
//  Copyright (c) 2013年 Yusuke Amano. All rights reserved.
//

#import "StopWatch.h"

@implementation StopWatch

static NSMutableDictionary *startDictionary;
static NSMutableDictionary *endDictionary;
static StopWatch* sharedInstance = nil;

+ (StopWatch *)sharedInstance {
	@synchronized(self) {
		if (sharedInstance == nil) {
			sharedInstance = [[self alloc] init];
            
            startDictionary = [[NSMutableDictionary alloc] init];
            endDictionary = [[NSMutableDictionary alloc] init];
		}
	}
	return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (sharedInstance == nil) {
			sharedInstance = [super allocWithZone:zone];
			return sharedInstance;
		}
	}
	return nil;
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

#pragma classmethod
- (void)start:(NSString *)lapId
{
    [startDictionary setObject:[NSDate date] forKey:lapId];
    
}

- (void)stop:(NSString *)lapId
{
    [endDictionary setObject:[NSDate date] forKey:lapId];
}

- (void)showResult
{
    for (id key in startDictionary) {
        if ([endDictionary objectForKey:key] == nil) {
            continue;
        }
        
        NSDate *startTime = [startDictionary objectForKey:key];
        NSDate *endTime = [endDictionary objectForKey:key];
        
        NSLog(@"LapTime : %@ = %f", key, [endTime timeIntervalSinceDate:startTime]);
        
    }
}

@end
