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

    BC=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, Height)];
    BC.backgroundColor=[UIColor blackColor];
    [[UIApplication sharedApplication].keyWindow addSubview:BC];

    
    rootSc=[[UIScrollView alloc]initWithFrame:BC.frame];
    rootSc.frame=CGRectMake(0, 0, Width+20, Height);
    rootSc.pagingEnabled=YES;
    rootSc.delegate=self;
    rootSc.showsVerticalScrollIndicator = NO;
    rootSc.showsHorizontalScrollIndicator = NO;
    [BC addSubview:rootSc];
    
    //页码
    pag=[[UIPageControl alloc]initWithFrame:CGRectMake(0, Height-30, Width, 10)];
    pag.currentPageIndicatorTintColor = [UIColor whiteColor];
    pag.pageIndicatorTintColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1];
    pag.userInteractionEnabled=NO;
    [BC addSubview:pag];

    
    
    rootSc.alpha=0;
    pag.alpha=0;


     __block YS_Photo * bObject = self;
     bObject.ClickImageBlock=^(NSArray *img,NSInteger index){

        //开场动画
         [UIView animateWithDuration:.25 animations:^{
             rootSc.alpha=1;
             pag.alpha=1;
         }];

        //主视图长度
        rootSc.contentSize=CGSizeMake((Width+20)*img.count, Height);
        rootSc.contentOffset=CGPointMake((Width+20)*index, 0);
         
        //页码数
        pag.numberOfPages=img.count;
        pag.currentPage=index;

        //子视图
        for (int k=0; k<img.count; k++) {
           
            UIScrollView *subSc=[[UIScrollView alloc]initWithFrame:CGRectMake((Width+20)*k,0 ,(Width+20),Height)];
//            subSc.backgroundColor=[UIColor blackColor];
            subSc.delegate=self;
            subSc.maximumZoomScale=2;
            subSc.zoomScale=0.8;
            subSc.tag=1100+k;
            subSc.showsVerticalScrollIndicator = NO;
            subSc.showsHorizontalScrollIndicator = NO;
            subSc.decelerationRate = UIScrollViewDecelerationRateFast;
            //交互
            UITapGestureRecognizer *ScrollTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTouch:)];
            UITapGestureRecognizer *NilScrollTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTouch:)];
            [NilScrollTap setNumberOfTapsRequired:2];
            [subSc addGestureRecognizer:ScrollTap];
            [subSc addGestureRecognizer:NilScrollTap];
            [ScrollTap requireGestureRecognizerToFail:NilScrollTap];

            [rootSc addSubview:subSc];
 
            
            //被放大的图片
            UIImageView *ScaleIMG=[[UIImageView alloc]initWithFrame:CGRectMake(0, 100, Width, Height-200)];
            ScaleIMG.contentMode=UIViewContentModeScaleAspectFit;
            ScaleIMG.clipsToBounds = YES;
            ScaleIMG.userInteractionEnabled = YES;
            [subSc addSubview:ScaleIMG];

//            //交互
//            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTouch:)];
//            UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTouch:)];
//            [doubleTap setNumberOfTapsRequired:2];
//            [ScaleIMG addGestureRecognizer:singleTap];
//            [ScaleIMG addGestureRecognizer:doubleTap];
//            [singleTap requireGestureRecognizerToFail:doubleTap];

            
            
            //路径图片处理
            if ([[img[k] class] isEqual:[NSURL class]]) {//local url
                subSc.zoomScale=YES;
                NSData *diskdata=[NSData dataWithContentsOfFile:img[k]];
                ScaleIMG.image=[UIImage imageWithData:diskdata];
                float xx=[ScaleIMG.image size].height*Width/[ScaleIMG.image size].width;
                ScaleIMG.frame=CGRectMake(0, Height/2-xx/2, Width, xx);

                //小图处理
                if (ScaleIMG.image.size.height < Height && ScaleIMG.image.size.width < Width) {
                    ScaleIMG.frame=CGRectMake(subSc.frame.size.width/2-ScaleIMG.image.size.width/2,
                                              subSc.frame.size.height/2-ScaleIMG.image.size.height/2,
                                              ScaleIMG.image.size.width,
                                              ScaleIMG.image.size.height);
                }

                //长图 （漫画模式禁用双击放大）
                if (ScaleIMG.image.size.height/ScaleIMG.image.size.width>2) {
                    ScaleIMG.contentMode=0;
                    subSc.contentSize=CGSizeMake(Width, Width*ScaleIMG.image.size.height/ScaleIMG.image.size.width);
                    ScaleIMG.frame=CGRectMake(0, 0, Width, subSc.contentSize.height);
                }
            }else{
                //网络图片处理
                subSc.userInteractionEnabled=NO;
                [ScaleIMG sd_setImageWithURL:[NSURL URLWithString:img[k]] placeholderImage:[UIImage imageNamed:@"yp_load"] completed:^(UIImage *sdimg, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                    subSc.userInteractionEnabled=YES;
                    float xx=[ScaleIMG.image size].height*Width/[ScaleIMG.image size].width;
                    ScaleIMG.frame=CGRectMake(0, Height/2-xx/2, Width, xx);}];}
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
        float ScrolH=[IMG.image size].height*Width/[IMG.image size].width;


        //小图处理
        if (IMG.image.size.height < Height && IMG.image.size.width < Width) {
            IMG.frame=CGRectMake((Width - scrollView.zoomScale*[IMG.image size].width)/2,
                                 (Height- scrollView.zoomScale*[IMG.image size].height)/2,
                                 IMG.mj_w,
                                 IMG.mj_h);
            return;
        }



        
        //放大时
        IMG.frame=CGRectMake(0, Height/2-ScrolH/2-(scrollView.zoomScale-1)*(ScrolH/2), IMG.mj_w, IMG.mj_h);
        NSLog(@"观察图片y轴变化:%f",IMG.frame.origin.y);
        
        //修复偏移
        if (IMG.mj_y<0) {
            float eff=IMG.mj_y;
            IMG.frame=CGRectMake(0, Height/2-ScrolH/2-(scrollView.zoomScale-1)*(ScrolH/2)-eff, IMG.mj_w, IMG.mj_h);}
        
        //修复缩小靠左
        if (scrollView.zoomScale<1) {
            float efx=(1-scrollView.zoomScale)*Width/2;
            IMG.frame=CGRectMake(efx, IMG.mj_y, IMG.mj_w, IMG.mj_h);}
        
    }
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:rootSc]) {
        int Numpage=scrollView.contentOffset.x/Width;
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
//    NSLog(@"单击");
}

//双击 放大缩小
-(void)doubleTouch:(UITapGestureRecognizer *)tap{
    UIScrollView *subScr1=[rootSc viewWithTag:1100+pag.currentPage];
    for (UIImageView *view in [subScr1 subviews]) {
        if ([view isKindOfClass:[UIImageView class]]) {

            //长图 （漫画模式禁用放大）
            if (view.image.size.height/view.image.size.width>2) return;


            [NSObject cancelPreviousPerformRequestsWithTarget:subScr1];
            CGPoint point=[tap locationInView:view];
//            NSLog(@"X:%f    Y:%f",point.x,point.y);
            if (subScr1.zoomScale==1) {
                CGFloat zoomW = view.frame.size.height / 4;
                CGFloat zoomH = view.frame.size.width / 4;
                [UIView animateWithDuration:.25 animations:^{
                    [subScr1 zoomToRect:CGRectMake(point.x - zoomW, point.y - zoomH, zoomW, zoomH) animated:YES];
                    subScr1.zoomScale=2;
                }];
            }else{
                [UIView animateWithDuration:0.5 animations:^(void){
                subScr1.zoomScale=1;
            }];}}}

}

//消失 长图消失残影bug待修改
-(void)miss{

    UIScrollView *subScr1=[rootSc viewWithTag:1100+pag.currentPage];

    [UIView animateWithDuration:.35 animations:^(void){
        rootSc.alpha=0;
        subScr1.alpha=0;
        BC.alpha=0;
        subScr1.subviews.firstObject.frame=CGRectMake(Width/2-10, Height/2-10, 20, 20);

//        subScr1.layer.mj_w=50;
//        subScr1.layer.mj_h=50;
//        subScr1.layer.anchorPoint=CGPointMake(.5, .5);

    }completion:^(BOOL finish){
        [BC removeFromSuperview];
        [[UIApplication sharedApplication].keyWindow setWindowLevel:0];
    }];

}












@end
