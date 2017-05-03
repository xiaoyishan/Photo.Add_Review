//
//  YS_Photo.h
//  图片浏览器
//
//  Created by sundeariOS on 16/6/1.
//  Copyright © 2016年 sundeariOS. All rights reserved.
//
#define  kScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define  kScreenHeight  [[UIScreen mainScreen] bounds].size.height
#define  kScreenPoint   (1 / [UIScreen mainScreen].scale)
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "UIView+MJExtension.h"

@interface YS_Photo : NSObject<UIScrollViewDelegate>{
    UIView *BC;
    UIScrollView *rootSc;
    UIPageControl *pag;
}

-(instancetype)init;

@property (nonatomic,copy) void (^ClickImageBlock)(NSArray *images,NSInteger index);






@end
