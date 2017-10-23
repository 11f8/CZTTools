//
//  NSDate+bookUtils.m
//  noteBook
//
//  Created by CastielChen on 2017/8/4.
//  Copyright © 2017年 Diana. All rights reserved.
//

#import "NSDateUtils.h"


@interface NSDateUtils (){
        NSTimeInterval  start_timer;
        NSTimeInterval  end_timer;
        NSTimer *timer;
    
    
    
        /**
         *  广告轮换器是否暂停
         */
        BOOL isTimerPaused;
        /**
         *  定时器暂停时保存的触发时间
         */
        NSDate *old_date;
        /**
         *  广告暂停时间
         */
        NSTimeInterval timerintervalSinceNow;
        /**
         *
         */
        NSTimeInterval stop_timerinterval;
    int beginStart;
}
@end


@implementation NSDateUtils

 

- (instancetype)init
{
    self = [super init];
    if (self) {
        //监听是否重新进入程序程序.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification object:nil];
        
        //监听是否触发home键挂起程序.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:)
                                                     name:UIApplicationWillResignActiveNotification object:nil];
        
    }
    return self;
}


-(NSTimeInterval)getStartData{
    start_timer=[[NSDate date] timeIntervalSince1970];
    return  start_timer;
}



-(NSTimeInterval)getEndData:(float)adstime{
    start_timer = [self getStartData];
    end_timer = start_timer+adstime;
    return end_timer;
}
-(id)startTimer:(int)adstime{
    
    beginStart=1;
    [self getEndData:adstime];
    timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    return  self;
}


-(void)handleTimer{
    [self getStartData];
    NSTimeInterval timeInterval = end_timer - start_timer;
    int days = (int)(timeInterval/(3600*24));
    int hours = (int)((timeInterval-days*24*3600)/3600);
    int minutes = (int)(timeInterval-days*24*3600-hours*3600)/60;
    int seconds = timeInterval-days*24*3600-hours*3600-minutes*60;
    
    NSString *dayStr;NSString *hoursStr;NSString *minutesStr;NSString *secondsStr;
    //天
    dayStr = [NSString stringWithFormat:@"%d",days];
    //小时
    hoursStr = [NSString stringWithFormat:@"%d",hours];
    //分钟
    if(minutes<10)
        minutesStr = [NSString stringWithFormat:@"0%d",minutes];
    else
        minutesStr = [NSString stringWithFormat:@"%d",minutes];
    //秒
    if(seconds < 10)
        secondsStr = [NSString stringWithFormat:@"0%d", seconds];
    else
        secondsStr = [NSString stringWithFormat:@"%d",seconds];
    
  
    if (days <= 0&&hours<=0&&minutes<=0&&seconds<=0) {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(NSDateUtilsFinsh:)]) {
            [self.delegate NSDateUtilsFinsh:self];
        }
        [self clearTimer];
    }else{
        if (self.delegate&&[self.delegate respondsToSelector:@selector(NSDateUtilsEveryMinute:hoursStr:minutesStr:secondsStr:)]) {
            [self.delegate NSDateUtilsEveryMinute:dayStr hoursStr:hoursStr minutesStr:minutesStr secondsStr:secondsStr];
        }
    }
}





- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    NSLog(@"进入后台....");
    
    [self stopTimer];
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"进入前台");
    
    [self beginTimer];
    
}


-(void)beginTimer{
    
    if (stop_timerinterval ==0) {
        return;
    }
    
    if (![timer isValid]) {
        return ;
    }
    NSDate *fire_date = [NSDate dateWithTimeIntervalSinceNow:timerintervalSinceNow];
    [timer setFireDate:fire_date];
    [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    
    end_timer =[self getStartData]+stop_timerinterval;
    old_date = nil;
    isTimerPaused = NO;
    timerintervalSinceNow =0;
}


-(void)clearTimer{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}
- (void) stopTimer{
    if (!timer||![timer isValid]) {
        return;
    }
    
    if (isTimerPaused) {
        return;
    }
    if (timer && !isTimerPaused) {
        old_date = [timer fireDate];
        timerintervalSinceNow = [old_date timeIntervalSinceNow];
        [timer setFireDate:[NSDate distantFuture]];
        isTimerPaused = YES;
        stop_timerinterval = end_timer - start_timer;
        NSLog(@"保存----%f",stop_timerinterval);
    }
    
}




-(NSString*)getStrByDate:(NSTimeInterval)timeInterval{
    int days = (int)(timeInterval/(3600*24));
    int hours = (int)((timeInterval-days*24*3600)/3600);
    int minutes = (int)(timeInterval-days*24*3600-hours*3600)/60;
    int seconds = timeInterval-days*24*3600-hours*3600-minutes*60;
    
    NSString *dayStr;NSString *hoursStr;NSString *minutesStr;NSString *secondsStr;
    //天
    dayStr = [NSString stringWithFormat:@"%d",days];
    //小时
    hoursStr = [NSString stringWithFormat:@"%d",hours];
    //分钟
    if(minutes<10)
        minutesStr = [NSString stringWithFormat:@"0%d",minutes];
    else
        minutesStr = [NSString stringWithFormat:@"%d",minutes];
    //秒
    if(seconds < 10)
        secondsStr = [NSString stringWithFormat:@"0%d", seconds];
    else
        secondsStr = [NSString stringWithFormat:@"%d",seconds];
    
    return  [NSString stringWithFormat:@"%@:%@",minutesStr,secondsStr];
}

 



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (timer) {
        [timer invalidate];
        timer =nil;
    }
}
@end
