//
//  applicationTimer.h
//  noteBook
//  监听进入后台长
//  Created by CastielChen on 2017/8/9.
//  Copyright © 2017年 Diana. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol applicationTimerDelegate <NSObject>

-(void)timerFinsh:(BOOL)flag;

@end

@interface applicationTimer : NSObject


@property(assign,nonatomic)  NSInteger timer;
@property(weak,nonatomic) id delegate;
@property(assign,nonatomic) BOOL isval;



-(void)startClickTimer;
-(void)stopClickTimer;
-(void)clearTimer;
@end
