//
//  comm.m
//  YunBu
//
//  Created by 锋 on 16/3/29.
//  Copyright © 2016年 邵兰霞. All rights reserved.
//

#import "comm.h"
#import "singleview.h"
#import "AFNetworking.h"


@implementation comm

+(comm *)share{
    static comm *SingleShenAFN;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SingleShenAFN = [[comm alloc] init]; });
    return SingleShenAFN;
}






- (void)PostURL:(NSString *)URL parameter:(NSDictionary*)parameter finish:(void (^)(NSDictionary *obj))cb{
    //检查网络
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//    if ( delegate.onNet) {
//        [SVProgressHUD showString:@"无网络"];//cb(nil,nil);
//        return;}
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *par=[parameter mutableCopy];
    if(par==nil) par=[NSMutableDictionary new];
    [par setObject:[userdefault objectForKey:@"accountid"] forKey:@"AccountId"];
    NSLog(@"参数:%@",par);
    [singleview HUDShow];
    URL=[NSString stringWithFormat:@"%@%@",hostUrl,URL];
    URL=[URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeOUT"];
    manager.requestSerializer.timeoutInterval=25.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeOUT"];
    [manager POST:URL parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject){
       [singleview HUDdismiss];
        NSMutableDictionary *myDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSInteger status=[myDic[@"code"] integerValue];
        if (status==0)  {
            cb(myDic);return;
        }
        if (status==-2)  {
            NSLog(@"授权失败！");return;
        }
        else{
            [SVProgressHUD showString:myDic[@"msg"]];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showString:@"网络异常"];//cb(@{}  ,nil);
        [singleview HUDdismiss];
    }];

    
    
}
//
- (void)PostIMGURL:(NSString *)URL parameter:(NSDictionary*)parameter IMG:(NSArray*)images finish:(void (^)(NSDictionary *obj))cb{
    
    //检查网络
//    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//    if ( delegate.onNet) {
//        [SVProgressHUD showString:@"无网络"];//cb(nil,nil);
//        return;}
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *par=[parameter mutableCopy];
    if(par==nil) par=[NSMutableDictionary new];
    [par setObject:[userdefault objectForKey:@"accountid"] forKey:@"AccountId"];
    NSLog(@"参数:%@",par);
    [singleview HUDShow];
    
    URL=[NSString stringWithFormat:@"%@%@",hostUrl,URL];
    URL=[URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeOUT"];
    manager.requestSerializer.timeoutInterval=25.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeOUT"];
    [manager POST:URL parameters:par constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSError *error;
        for (int i=0; i<images.count; i++) {
            BOOL success = [formData appendPartWithFileURL:[images objectAtIndex:i] name:@"File" error:&error];
            if (!success) NSLog(@"上传失败!");
        }
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [singleview HUDdismiss];
        NSMutableDictionary *myDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];

        
        NSInteger status=[myDic[@"code"] integerValue];
        if (status==0)  {
            cb(myDic);return;
        }
        if (status==-2)  {
            NSLog(@"授权失败！超时");return;
        }
        else{
            [SVProgressHUD showString:myDic[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [SVProgressHUD showString:@"网络异常"];
        [singleview HUDdismiss];
    }];


    
    
    
}








- (void)PostNoneCodeURL:(NSString *)URL parameter:(NSDictionary*)parameter finish:(void (^)(NSDictionary *obj))cb{
    //检查网络
//    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//    if ( delegate.onNet) {
//        [SVProgressHUD showString:@"无网络"];//cb(nil,nil);
//        return;}
    
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *par=[parameter mutableCopy];
    if(par==nil) par=[NSMutableDictionary new];
    [par setObject:[userdefault objectForKey:@"accountid"] forKey:@"AccountId"];
    
    
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:par options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *jsondata= [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"参数:%@",par);
    
    
    
    URL=[NSString stringWithFormat:@"%@%@",hostUrl,URL];
    URL=[URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"my url:%@",URL);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeOUT"];
    manager.requestSerializer.timeoutInterval=15.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeOUT"];
    [manager POST:URL parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSMutableDictionary *myDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                cb(myDic);
        NSInteger status=[myDic[@"code"] integerValue];
        if (status==-2)  {
            NSLog(@"授权失败！超时");return;
        }
           }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               [SVProgressHUD showString:@"网络异常"];//cb(@{} ,error);
           }];
}

-(id)ViaNull:(NSString*)JSONstring{

    if ([JSONstring isEqual:nil] ||
        JSONstring==nil          ||
        JSONstring==Nil          ||
        JSONstring==NULL         ||
        [JSONstring isEqual:Nil]                ||
        [JSONstring isEqual:NULL]               ||
        [JSONstring isEqual:[NSNull null]]      ||
        [JSONstring isEqual:@"null"]            ||
        [JSONstring isEqual:@"nil"]             ||
        [JSONstring isEqual:@"NULL"]            ||
        [JSONstring isEqual:@"(null)"]          ||
        [JSONstring isEqual:@"<null>"])return @"";
    return JSONstring;
}
-(id)ViaDicNull:(NSString*)JSONDic{
    
    if ([JSONDic isEqual:nil] ||
        JSONDic==nil          ||
        JSONDic==Nil          ||
        JSONDic==NULL         ||
        [JSONDic isEqual:Nil]                ||
        [JSONDic isEqual:NULL]               ||
        [JSONDic isEqual:[NSNull null]]      ||
        [JSONDic isEqual:@"null"]            ||
        [JSONDic isEqual:@"nil"]             ||
        [JSONDic isEqual:@"NULL"]            ||
        [JSONDic isEqual:@"<null>"])return @{};
    return JSONDic;
}
-(id)ViaArrayNull:(NSString*)JSONArray{
    
    if ([JSONArray isEqual:nil] ||
        JSONArray==nil          ||
        JSONArray==Nil          ||
        JSONArray==NULL         ||
        [JSONArray isEqual:Nil]                ||
        [JSONArray isEqual:NULL]               ||
        [JSONArray isEqual:[NSNull null]]      ||
        [JSONArray isEqual:@"null"]            ||
        [JSONArray isEqual:@"nil"]             ||
        [JSONArray isEqual:@"NULL"]            ||
        [JSONArray isEqual:@"<null>"])return @[];
    return JSONArray;
}


//Fix image direction
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}





//手动实现图片压缩，可以写到分类里，封装成常用方法。按照大小进行比例压缩，改变了图片的size。
- (UIImage *)makeThumbnailFromImage:(UIImage *)srcImage scale:(double)imageScale {
    UIImage *thumbnail = nil;
    CGSize imageSize = CGSizeMake(srcImage.size.width * imageScale, srcImage.size.height * imageScale);
    if (srcImage.size.width != imageSize.width || srcImage.size.height != imageSize.height)
    {
        UIGraphicsBeginImageContext(imageSize);
        CGRect imageRect = CGRectMake(0.0, 0.0, imageSize.width, imageSize.height);
        [srcImage drawInRect:imageRect];
        thumbnail = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else
    {
        thumbnail = srcImage;
    }
    return thumbnail;
}


//取单位名
-(NSArray*)ys_name:(NSArray*)data com:(NSString*)dicstring{
    NSMutableArray *newArray=[[NSMutableArray alloc]init];
    for (int k=0; k<data.count; k++) {
        [newArray addObject:[NSString stringWithFormat:@"%@",data[k][dicstring]]];
    }
    return newArray;
}

//取数组中的某一个index后的数组
-(NSArray*)ys_name:(NSArray*)data Index:(int)dex{
    NSMutableArray *newArray=[[NSMutableArray alloc]init];
    for (int k=0; k<data.count; k++) {
        [newArray addObject:data[k][dex]];
    }
    return newArray;
}




@end
