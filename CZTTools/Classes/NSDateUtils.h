//
//  NSDate+bookUtils.h
//  noteBook
//
//  Created by CastielChen on 2017/8/4.
//  Copyright © 2017年 Diana. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSDateUtils;
@protocol NSDateUtilsDelegate <NSObject>

-(void)NSDateUtilsEveryMinute:(NSString *)dayStr  hoursStr:(NSString *)hoursStr minutesStr:(NSString *)minutesStr secondsStr:(NSString *)secondsStr;

-(void)NSDateUtilsFinsh:(NSDateUtils*)utils;

@end

@interface NSDateUtils:NSDate

@property(weak,nonatomic)id delegate;

-(id)startTimer:(NSInteger)endtime;
-(NSString*)getStrByDate:(NSTimeInterval)timer;

-(void)beginTimer;
- (void)stopTimer;
-(void)clearTimer;
@end
