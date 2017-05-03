//
//  singleview.h
//  封装uiview
//
//  Created by 夏 on 16/1/13.
//  Copyright © 2016年 夏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface singleview : UIView
@property BOOL endAnimation;          //停止动画键 防止死循环

- (id)initWithFrame:(CGRect)frame;

+ (void)HUDShow;
+ (void)HUDdismiss;
- (void)HUDShow:(UIView*)view;

@end
