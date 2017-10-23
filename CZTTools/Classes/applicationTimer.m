//
//  applicationTimer.m
//  noteBook
//
//  Created by CastielChen on 2017/8/9.
//  Copyright © 2017年 Diana. All rights reserved.
//

#import "applicationTimer.h"

@interface applicationTimer (){
    NSTimeInterval   startTimer;
    NSTimeInterval   endTimer;
    BOOL start_flag;
    
    BOOL click_flag;
    
    
    BOOL returndelegate;
    
    
    NSTimer * readBanner_timer;
    
}

@end


@implementation applicationTimer



- (instancetype)init
{
    self = [super init];
    if (self) {
        returndelegate=NO;
        //监听是否重新进入程序程序.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification object:nil];
        
        //监听是否触发home键挂起程序.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationWillResignActiveNotification object:nil];
    }
    return self;
}




-(void)startClickTimer{
    if (readBanner_timer) {
        [readBanner_timer invalidate];
        readBanner_timer =nil;
    }
    
    readBanner_timer = [NSTimer scheduledTimerWithTimeInterval:(self.timer) target:self selector:@selector(onClickOverlay) userInfo:nil repeats:NO];
}

-(void)onClickOverlay{
    click_flag =YES;
    if (!returndelegate&&click_flag) {
        if (self.delegate &&[self.delegate respondsToSelector:@selector(timerFinsh:)]) {
            [self.delegate timerFinsh:YES];
        }
    }
    
    
}

-(void)stopClickTimer{
    
    
    if (readBanner_timer) {
        [readBanner_timer invalidate];
        readBanner_timer =nil;
    }
    
    if (!start_flag) {
        return;
    }
    start_flag=NO;
   [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(timerFinsh:)]) {
        [self.delegate timerFinsh:click_flag];
        click_flag =NO;
    }
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    if (self.isval) {
        return;
    }
    
    startTimer =[[NSDate date] timeIntervalSince1970];
    NSLog(@"进入后台....");
     [self stopClickTimer];
    
 
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    if (self.isval) {
        return;
    }
    NSLog(@"进入前台");
    endTimer =[[NSDate date] timeIntervalSince1970];
    
    int  cha_timer =endTimer -startTimer;
    BOOL flag=NO;
    if (cha_timer>=self.timer) {
        flag =YES;
    }
    if (self.delegate &&[self.delegate respondsToSelector:@selector(timerFinsh:)]) {
        returndelegate=YES;
        [self.delegate timerFinsh:flag];
    }

       
}

-(void)clearTimer{
    if (readBanner_timer) {
         [readBanner_timer invalidate];	
        readBanner_timer =nil;
    }
}


- (void)dealloc
{
    if (readBanner_timer) {
        [readBanner_timer invalidate];
         readBanner_timer=nil;
    }
}

@end
