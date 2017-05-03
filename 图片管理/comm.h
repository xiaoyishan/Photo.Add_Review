//
//  comm.h
//  YunBu
//
//  Created by 锋 on 16/3/29.
//  Copyright © 2016年 邵兰霞. All rights reserved.
//
#import "SVProgressHUD.h"
#import "AppDelegate.h"

#import <Foundation/Foundation.h>
static NSString *hostUrl = @"http://123.59.145.198:3006/";
@interface comm : NSObject
+(comm *)share;
- (void)PostURL:(NSString *)URL parameter:(NSDictionary*)parameter finish:(void (^)(NSDictionary *obj))cb;
- (void)PostNoneCodeURL:(NSString *)URL parameter:(NSDictionary*)parameter finish:(void (^)(NSDictionary *obj))cb;
- (void)PostIMGURL:(NSString *)URL parameter:(NSDictionary*)parameter IMG:(NSArray*)images finish:(void (^)(NSDictionary *obj))cb;



-(id)ViaDicNull:(NSString*)JSONDic;
-(id)ViaNull:(id)JSONstring;
-(id)ViaArrayNull:(NSString*)JSONArray;

//fix camera
- (UIImage *)fixOrientation:(UIImage *)aImage;
//手动实现图片压缩，可以写到分类里，封装成常用方法。按照大小进行比例压缩，改变了图片的size。
- (UIImage *)makeThumbnailFromImage:(UIImage *)srcImage scale:(double)imageScale;

//遍历取出 数组中 字典里的数据
-(NSArray*)ys_name:(NSArray*)data com:(NSString*)dicstring;
//取数组中的某一个index后的数组
-(NSArray*)ys_name:(NSArray*)data Index:(int)dex;











@end
