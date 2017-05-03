//
//  singleview.m
//  封装uiview
//
//  Created by 夏 on 16/1/13.
//  Copyright © 2016年 夏. All rights reserved.
//


#import "singleview.h"

#define  kScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define  kScreenHeight  [[UIScreen mainScreen] bounds].size.height
#define  kScreenPoint   (1 / [UIScreen mainScreen].scale)
static NSInteger CycleSzie=15;    //小圆圈大小

@implementation singleview{
    UILabel *yellowL;
    UILabel *blueL;
    NSInteger CycleX;
    
}


+(singleview *)share{
    static singleview *WaitView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        WaitView = [[singleview alloc] init]; });
    return WaitView;
}

- (id)init{
    CGRect frameRect = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    CycleX=kScreenWidth/2-CycleSzie/2;
    
    
    self = [self initWithFrame:frameRect];
    if (self)  NSLog(@"Init called");
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        self.tag=11011077;
        UILabel *redL=[[UILabel alloc]initWithFrame:CGRectMake(CycleX, kScreenHeight/2, CycleSzie, CycleSzie)];
//        redL.backgroundColor=[UIColor colorWithHex:0x18c8ed];
        redL.layer.cornerRadius=CycleSzie/2;
        redL.alpha=0.5;
        redL.layer.masksToBounds=YES;
        [self addSubview:redL];
        
        
        yellowL=[[UILabel alloc]initWithFrame:CGRectMake(CycleX-30, kScreenHeight/2, CycleSzie, CycleSzie)];
//        yellowL.backgroundColor=[UIColor colorWithHex:0x8ee00e];
        yellowL.layer.cornerRadius=CycleSzie/2;
        yellowL.alpha=0.5;
        yellowL.layer.masksToBounds=YES;
        [self addSubview:yellowL];
        
        blueL=[[UILabel alloc]initWithFrame:CGRectMake(CycleX+30, kScreenHeight/2, CycleSzie, CycleSzie)];
//        blueL.backgroundColor=[UIColor colorWithHex:0x0b91f0];
        blueL.layer.cornerRadius=CycleSzie/2;
        blueL.alpha=0.5;
        blueL.layer.masksToBounds=YES;
        [self addSubview:blueL];
        

       
        [self BeginAnimation];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
            _endAnimation=YES;
         });

        
    }
    
    
    
    return self;
}
- (void)HUDShow:(UIView*)view{
    singleview *sing=[[singleview alloc]init];
    [view addSubview:sing];
}
+ (void)HUDShow{
    singleview *sing=[[singleview alloc]init];
    sing.tag=111111;
    [[[UIApplication sharedApplication] keyWindow] addSubview:sing];

}
+ (void)HUDdismiss{
    singleview *sing=[[[UIApplication sharedApplication] keyWindow] viewWithTag:111111];
    [sing removeFromSuperview];
    sing.endAnimation=YES;
}


-(void)BeginAnimation{
    [UIView animateWithDuration:.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void){
                         yellowL.frame=CGRectMake(CycleX+30, kScreenHeight/2, CycleSzie, CycleSzie);
                         blueL.frame=CGRectMake(CycleX-30, kScreenHeight/2, CycleSzie, CycleSzie);
                     }completion:^(BOOL finished){

                         [self BackAnimation];
                     }];
}

-(void)BackAnimation{
    [UIView animateWithDuration:.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void){
                         yellowL.frame=CGRectMake(CycleX-30, kScreenHeight/2, CycleSzie, CycleSzie);
                         blueL.frame=CGRectMake(CycleX+30, kScreenHeight/2, CycleSzie, CycleSzie);
                     }completion:^(BOOL finished){
                         if(_endAnimation) return;
                         [self BeginAnimation];
                     }];
}



@end
