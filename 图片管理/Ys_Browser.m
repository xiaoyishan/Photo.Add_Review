//
//  Ys_Browser.m
//  图片管理
//
//  Created by Sundear on 2017/5/3.
//  Copyright © 2017年 sundeariOS. All rights reserved.
//

#import "Ys_Browser.h"

@implementation Ys_Browser


-(instancetype)init{
    [[UIApplication sharedApplication] keyWindow].windowLevel=UIWindowLevelStatusBar;
    [self BuildUI];
    return self;
}

-(void)BuildUI{
    BC=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, Height)];
    BC.backgroundColor=[UIColor blackColor];
    [[UIApplication sharedApplication].keyWindow addSubview:BC];


    RootSc=[[UIScrollView alloc]initWithFrame:BC.frame];
    RootSc.frame=CGRectMake(0, 0, Width+20, Height);
    RootSc.pagingEnabled=YES;
    RootSc.delegate=self;
    RootSc.showsVerticalScrollIndicator = NO;
    RootSc.showsHorizontalScrollIndicator = NO;
    [BC addSubview:RootSc];

    //页码
    pag=[[UIPageControl alloc]initWithFrame:CGRectMake(0, Height-40, Width, 10)];
    pag.currentPageIndicatorTintColor = [UIColor whiteColor];
    pag.pageIndicatorTintColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    pag.userInteractionEnabled=NO;
    [BC addSubview:pag];

    [self SubViews];

    
}


-(void)SubViews{
    Ys_Browser * bObject = self;
    bObject.ClickImageBlock=^(NSArray *img,NSInteger index){
        //主视图长度
        RootSc.contentSize=CGSizeMake((Width+20)*img.count, Height);
        RootSc.contentOffset=CGPointMake((Width+20)*index, 0);
        //页码数
        pag.numberOfPages=img.count;
        pag.currentPage=index;

        //子视图
        for (int k=0; k<img.count; k++) {

            UIScrollView *subSc=[[UIScrollView alloc]initWithFrame:CGRectMake((Width+20)*k, 0, (Width+20), Height)];
            subSc.delegate=self;
            subSc.maximumZoomScale=2;
            subSc.zoomScale=0.8;
            subSc.tag=1100+k;
            subSc.showsVerticalScrollIndicator = NO;
            subSc.showsHorizontalScrollIndicator = NO;
            subSc.decelerationRate = UIScrollViewDecelerationRateFast;
            [RootSc addSubview:subSc];


            //被放大的图片
            UIImageView *ScaleIMG=[[UIImageView alloc]initWithFrame:CGRectMake((Width+20)*k, 0, Width, Height)];
            ScaleIMG.contentMode=UIViewContentModeCenter;
            ScaleIMG.clipsToBounds = YES;
            ScaleIMG.userInteractionEnabled = YES;
            [subSc addSubview:ScaleIMG];
            ScaleIMG.layer.anchorPoint=CGPointMake(.5, .5);
//            ScaleIMG.layer.mj_x=subSc.mj_w/2;
//            ScaleIMG.layer.mj_y=subSc.mj_h/2;

            //交互
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTouch:)];
            UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTouch:)];
            [doubleTap setNumberOfTapsRequired:2];
            [ScaleIMG addGestureRecognizer:singleTap];
            [ScaleIMG addGestureRecognizer:doubleTap];
            [singleTap requireGestureRecognizerToFail:doubleTap];

//            [ScaleIMG setUserInteractionEnabled:YES];
//            [ScaleIMG setMultipleTouchEnabled:YES];
//            [self addGestureRecognizerToView:ScaleIMG];


            //路径图片处理
            if ([[img[k] class] isEqual:[NSURL class]]) {//local url
                subSc.zoomScale=YES;
                NSData *diskdata=[NSData dataWithContentsOfFile:img[k]];
                ScaleIMG.image=[UIImage imageWithData:diskdata];

            }else{//网络图片处理
                subSc.zoomScale=NO;
                [ScaleIMG sd_setImageWithURL:[NSURL URLWithString:img[k]]
                            placeholderImage:[UIImage imageNamed:@"yp_load"]
                                   completed:^(UIImage *sdimg, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                    subSc.zoomScale=YES;
                }];}



            //大图
            if (ScaleIMG.image.size.width>Width || ScaleIMG.image.size.height>Height) {
                ScaleIMG.contentMode=UIViewContentModeScaleAspectFit;
                subSc.maximumZoomScale=ScaleIMG.image.size.height/Height*4;
                NSLog(@"最大值:%f", subSc.maximumZoomScale);
//                ScaleIMG.layer.mj_size=ScaleIMG.image.size;
            }

            //长图
            if (ScaleIMG.image.size.height/ScaleIMG.image.size.width>2) {
                ScaleIMG.contentMode=0;
                subSc.contentSize=CGSizeMake(Width, Width*ScaleIMG.image.size.height/ScaleIMG.image.size.width);
                ScaleIMG.frame=CGRectMake(0, 0, Width, subSc.contentSize.height);
            }

        }

        
    };
}






-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    for (UIImageView *view in [scrollView subviews]) {
        if ([view isKindOfClass:[UIImageView class]]) {
            return view;} }
    return  nil;
}

//- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
//    for (UIImageView *IMG in [scrollView subviews]) {
//        IMG.center=IMG.superview.center;
//    }
//}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:RootSc]) {
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
    UIScrollView *subScr1=[RootSc viewWithTag:1100+pag.currentPage];
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
    UIScrollView *subScr1=[RootSc viewWithTag:1100+pag.currentPage];
    for (SDBrowserImageView *view in [subScr1 subviews]) {
        if ([view isKindOfClass:[SDBrowserImageView class]]) {

            [NSObject cancelPreviousPerformRequestsWithTarget:subScr1];
            CGPoint point=[tap locationInView:view];
            NSLog(@"X:%f    Y:%f",point.x,point.y);
            if (subScr1.zoomScale==1) {
                [view doubleTapToZommWithScale:2];
//                    [subScr1 zoomToRect:CGRectMake(point.x - view.mj_h/3/2, point.y - view.mj_w/3/2, view.mj_h/3, view.mj_w/3) animated:YES];
            }else{
                [UIView animateWithDuration:0.5 animations:^(void){
//                    subScr1.zoomScale=1;
                    [view doubleTapToZommWithScale:1];
                }];
            }
        }}
    
}






//消失
-(void)miss{
    RootSc.alpha=0;
    [BC removeFromSuperview];
    [[UIApplication sharedApplication].keyWindow setWindowLevel:0];
}





// 添加所有的手势
- (void) addGestureRecognizerToView:(UIView *)view
{
    // 旋转手势
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
    [view addGestureRecognizer:rotationGestureRecognizer];

    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [view addGestureRecognizer:pinchGestureRecognizer];

    // 移动手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [view addGestureRecognizer:panGestureRecognizer];
}

// 处理旋转手势
- (void) rotateView:(UIRotationGestureRecognizer *)rotationGestureRecognizer
{
    UIView *view = rotationGestureRecognizer.view;
    if (rotationGestureRecognizer.state == UIGestureRecognizerStateBegan || rotationGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformRotate(view.transform, rotationGestureRecognizer.rotation);
        [rotationGestureRecognizer setRotation:0];
    }
}

// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}

// 处理拖拉手势
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = panGestureRecognizer.view;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}



-(void)test{
    
}
-(void)test1{
    
}


@end
