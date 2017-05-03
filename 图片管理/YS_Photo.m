//
//  YS_Photo.m
//  图片浏览器
//
//  Created by sundeariOS on 16/6/1.
//  Copyright © 2016年 sundeariOS. All rights reserved.
//
#import "UIImageView+WebCache.h"
#import "YS_Photo.h"


@implementation YS_Photo


-(instancetype)init{

    [[UIApplication sharedApplication] keyWindow].windowLevel=UIWindowLevelStatusBar;

    BC=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    BC.backgroundColor=[UIColor blackColor];
    [[UIApplication sharedApplication].keyWindow addSubview:BC];

    
    rootSc=[[UIScrollView alloc]initWithFrame:BC.frame];
    rootSc.frame=CGRectMake(0, 0, kScreenWidth+20, kScreenHeight);
    rootSc.pagingEnabled=YES;
    rootSc.delegate=self;
    rootSc.showsVerticalScrollIndicator = NO;
    rootSc.showsHorizontalScrollIndicator = NO;
    [BC addSubview:rootSc];
    
    //页码
    pag=[[UIPageControl alloc]initWithFrame:CGRectMake(0, kScreenHeight-40, kScreenWidth, 10)];
    pag.currentPageIndicatorTintColor = [UIColor whiteColor];
    pag.pageIndicatorTintColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1];
    pag.userInteractionEnabled=NO;
    [BC addSubview:pag];

    
    

     __block YS_Photo * bObject = self;
     bObject.ClickImageBlock=^(NSArray *img,NSInteger index){

        //主视图长度
        rootSc.contentSize=CGSizeMake((kScreenWidth+20)*img.count, kScreenHeight);
        rootSc.contentOffset=CGPointMake((kScreenWidth+20)*index, 0);
         
        //页码数
        pag.numberOfPages=img.count;
        pag.currentPage=index;

        //子视图
        for (int k=0; k<img.count; k++) {
           
            UIScrollView *subSc=[[UIScrollView alloc]initWithFrame:CGRectMake((kScreenWidth+20)*k,0 ,(kScreenWidth+20),kScreenHeight)];
//            subSc.backgroundColor=[UIColor blackColor];
            subSc.delegate=self;
            subSc.maximumZoomScale=2;
            subSc.zoomScale=0.8;
            subSc.tag=1100+k;
            subSc.showsVerticalScrollIndicator = NO;
            subSc.showsHorizontalScrollIndicator = NO;
            subSc.decelerationRate = UIScrollViewDecelerationRateFast;
            [rootSc addSubview:subSc];
 
            
            //被放大的图片
            UIImageView *ScaleIMG=[[UIImageView alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, kScreenHeight-200)];
            ScaleIMG.contentMode=UIViewContentModeScaleAspectFit;
            ScaleIMG.clipsToBounds = YES;
            ScaleIMG.userInteractionEnabled = YES;
            [subSc addSubview:ScaleIMG];

            //交互
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTouch:)];
            UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTouch:)];
            [doubleTap setNumberOfTapsRequired:2];
            [ScaleIMG addGestureRecognizer:singleTap];
            [ScaleIMG addGestureRecognizer:doubleTap];
            [singleTap requireGestureRecognizerToFail:doubleTap];
            
            
            
            //路径图片处理
            if ([[img[k] class] isEqual:[NSURL class]]) {//local url
                subSc.zoomScale=YES;
                NSData *diskdata=[NSData dataWithContentsOfFile:img[k]];
                ScaleIMG.image=[UIImage imageWithData:diskdata];
                float xx=[ScaleIMG.image size].height*kScreenWidth/[ScaleIMG.image size].width;
                ScaleIMG.frame=CGRectMake(0, kScreenHeight/2-xx/2, kScreenWidth, xx);

                //小图处理
                if (ScaleIMG.image.size.height < kScreenHeight && ScaleIMG.image.size.width < kScreenWidth) {
                    ScaleIMG.frame=CGRectMake(subSc.frame.size.width/2-ScaleIMG.image.size.width/2,
                                              subSc.frame.size.height/2-ScaleIMG.image.size.height/2,
                                              ScaleIMG.image.size.width,
                                              ScaleIMG.image.size.height);
                }

            }else{
                //网络图片处理
                subSc.zoomScale=NO;
                [ScaleIMG sd_setImageWithURL:[NSURL URLWithString:img[k]] placeholderImage:[UIImage imageNamed:@"yp_load"] completed:^(UIImage *sdimg, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                    subSc.zoomScale=YES;
                    float xx=[ScaleIMG.image size].height*kScreenWidth/[ScaleIMG.image size].width;
                    ScaleIMG.frame=CGRectMake(0, kScreenHeight/2-xx/2, kScreenWidth, xx);}];}
             }
         
         
        };
    

    return self;
    
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    for (UIImageView *view in [scrollView subviews]) {
        if ([view isKindOfClass:[UIImageView class]]) {
            return view;} }
    return  nil;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    for (UIImageView *IMG in [scrollView subviews]) {
        float ScrolH=[IMG.image size].height*kScreenWidth/[IMG.image size].width;
        
        //放大时
        IMG.frame=CGRectMake(0, kScreenHeight/2-ScrolH/2-(scrollView.zoomScale-1)*(ScrolH/2), IMG.frame.size.width, IMG.frame.size.height);
        NSLog(@"观察图片y轴变化:%f",IMG.frame.origin.y);
        
        //修复偏移
        if (IMG.frame.origin.y<0) {
            float eff=IMG.frame.origin.y;
            IMG.frame=CGRectMake(0, kScreenHeight/2-ScrolH/2-(scrollView.zoomScale-1)*(ScrolH/2)-eff, IMG.frame.size.width, IMG.frame.size.height);}
        
        //修复缩小靠左
        if (scrollView.zoomScale<1) {
            float efx=(1-scrollView.zoomScale)*kScreenWidth/2;
            IMG.frame=CGRectMake(efx, IMG.frame.origin.y, IMG.frame.size.width, IMG.frame.size.height);}
        
    }
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:rootSc]) {
        int Numpage=scrollView.contentOffset.x/kScreenWidth;
        pag.currentPage=Numpage;
        //恢复缩放
        UIScrollView *subScr=(UIScrollView*)[scrollView viewWithTag:1100+Numpage];
        UIScrollView *subScr1=(UIScrollView*)[scrollView viewWithTag:1100+pag.currentPage];
        [UIView animateWithDuration:0.5 animations:^(void){
            subScr.zoomScale=1;
            subScr1.zoomScale=1;
        }];
    }
    
}

//单击 取消或miss
-(void)SingleTouch:(UITapGestureRecognizer *)tap{
    UIScrollView *subScr1=[rootSc viewWithTag:1100+pag.currentPage];
    if (subScr1.zoomScale==1) {
        [self miss];
    }else{
        [UIView animateWithDuration:0.5 animations:^(void){
            subScr1.zoomScale=1;
        }];
    }
    NSLog(@"单击");
}

//双击 放大缩小
-(void)doubleTouch:(UITapGestureRecognizer *)tap{
    UIScrollView *subScr1=[rootSc viewWithTag:1100+pag.currentPage];
    for (UIImageView *view in [subScr1 subviews]) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [NSObject cancelPreviousPerformRequestsWithTarget:subScr1];
            CGPoint point=[tap locationInView:view];
            NSLog(@"X:%f    Y:%f",point.x,point.y);
            if (subScr1.zoomScale==1) {

                    
                    CGFloat xsize = view.frame.size.height / 2;
                    CGFloat ysize = view.frame.size.width / 2;
                    [subScr1 zoomToRect:CGRectMake(point.x - xsize/2, point.y - ysize/2, xsize, ysize) animated:YES];

//                [UIView animateWithDuration:0.5 animations:^(void){
//                    subScr1.zoomScale=2;
//                }];
            }else{
                [UIView animateWithDuration:0.5 animations:^(void){
                    subScr1.zoomScale=1;
                }];}}}

}

//消失
-(void)miss{
//    [UIView animateWithDuration:.25 animations:^(void){
//        rootSc.alpha=0;
//        
//    }completion:^(BOOL finish){
        rootSc.alpha=0;
        [BC removeFromSuperview];
        [[UIApplication sharedApplication].keyWindow setWindowLevel:0];
//    }];

}












@end
