//
//  Ys_Browser.h
//  图片管理
//
//  Created by Sundear on 2017/5/3.
//  Copyright © 2017年 sundeariOS. All rights reserved.
//

#import <Foundation/Foundation.h>

#define  Width      [[UIScreen mainScreen] bounds].size.width
#define  Height     [[UIScreen mainScreen] bounds].size.height
#define  kPoint     (1 / [UIScreen mainScreen].scale)

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "UIView+MJExtension.h"


#import "SDBrowserImageView.h"


@interface Ys_Browser : NSObject<UIScrollViewDelegate>{
    UIView *BC;
    UIScrollView *RootSc;
    UIPageControl *pag;
}


-(instancetype)init;
@property (nonatomic,copy) void (^ClickImageBlock)(NSArray *images,NSInteger index);

@end
