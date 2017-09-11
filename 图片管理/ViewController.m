//
//  ViewController.m
//  图片管理
//
//  Created by sundeariOS on 16/6/27.
//  Copyright © 2016年 sundeariOS. All rights reserved.
//
#import "UIButton+WebCache.h"
#import "YPimageCell.h"

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *YPtable;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _YPtable.tableFooterView=[[UIView alloc]init];
    [[UIApplication sharedApplication] setStatusBarStyle:1];
    
    _Locallist=[[NSMutableArray alloc]init];
    _URLlist=[[NSMutableArray alloc]initWithArray:@[@"http://bbsimg.qianlong.com/data/attachment/forum/201410/03/170043am147yzc4xc1z97y.jpg",
                                                    @"http://4k.znds.com/20140314/4kznds3.jpg",
                                                    @"http://i.epetbar.com/2014-06/07/a08a0303f1e8e41b880588891c453b16.jpg",
                                                    @"http://img6.faloo.com/picture/0x0/0/183/183379.jpg",
                                                    @"http://image6.huangye88.com/2013/03/28/2a569ac6dbab1216.jpg",
                                                    @"http://img3.3lian.com/2013/v8/72/d/61.jpg"]];
}


#pragma mark -- UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(_Locallist.count+_URLlist.count==9) return 9;
    return _Locallist.count+_URLlist.count+1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YPimageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ypimgcell" forIndexPath:indexPath];
    NSInteger allcout=_Locallist.count+_URLlist.count;
    NSInteger row=[indexPath item];
    //action
    [cell.IMG addTarget:self action:@selector(SeeIMG:) forControlEvents:UIControlEventTouchUpInside];
    [cell.Del addTarget:self action:@selector(DelIMG:) forControlEvents:UIControlEventTouchUpInside];
     //upload images
    if(row==allcout && allcout!=9){
        cell.IMG.tag=5011;//上传标志符
        [cell.IMG setImage:[UIImage imageNamed:@"uploadIMG"] forState:UIControlStateNormal];
        cell.Del.hidden=YES;
        cell.IMG.imageView.contentMode=1;
        return cell;
    }else{
        cell.Del.hidden=NO;
        //长按 位置交换
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(EditIMG:)];
        [collectionView addGestureRecognizer:longGesture];
        
        if (_URLlist.count>row) {//URL images
            cell.IMG.tag=row+100;
            cell.Del.tag=row+200;
            [cell.IMG sd_setImageWithURL:[NSURL URLWithString:_URLlist[row]] forState:UIControlStateNormal];
        }else{//local images
            cell.IMG.tag=row+1000;
            cell.Del.tag=row+2000;
            NSData *diskdata=[NSData dataWithContentsOfFile:_Locallist[row-_URLlist.count]];
            [cell.IMG setImage:[UIImage imageWithData:diskdata] forState:UIControlStateNormal];}}
    //修复异常model
    cell.IMG.imageView.contentMode=2;
    
    
    
    return cell;
}
-(void)SeeIMG:(UIButton*)button{
    //upload
    if (button.tag==5011){[self SelectIMG];return;}
    NSMutableArray *Reviews=[_URLlist mutableCopy];
    [Reviews addObjectsFromArray:_Locallist];
    if (button.tag<500) {

        YS_Photo *obj=[[YS_Photo alloc]init];
        obj.ClickImageBlock(Reviews,button.tag-100);

//        Ys_Browser *obj=[[Ys_Browser alloc]init];
//        obj.ClickImageBlock(Reviews,button.tag-100);

    }else{//本地File图片

//        Ys_Browser *obj=[[Ys_Browser alloc]init];
//        obj.ClickImageBlock(Reviews,button.tag-1000);

        YS_Photo *obj=[[YS_Photo alloc]init];
        obj.ClickImageBlock(Reviews,button.tag-1000);
    }
}
-(void)DelIMG:(UIButton*)button{
    UICollectionView *sCol=[_YPtable viewWithTag:3333];
//    YPimageCell *cell = (YPimageCell*)[[button superview]superview];//获取cell
//    NSIndexPath *dex =[sCol indexPathForCell:cell];//获取cell对应的indexpath;
//    NSLog(@"index:  %@",dex);
//    //test
//
//    [sCol performBatchUpdates:^{
////        [sCol deleteItemsAtIndexPaths:@[dex]];
//    } completion:nil];
    
    if (button.tag<500) {[_URLlist removeObjectAtIndex:button.tag-200];}
    else{[_Locallist removeObjectAtIndex:button.tag-2000-_URLlist.count];}
    
    [sCol reloadData];
    
    
}
- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath{
    UICollectionView *sCol=[_YPtable viewWithTag:3333];
    UICollectionViewLayoutAttributes *attr = [sCol layoutAttributesForItemAtIndexPath:itemIndexPath];
    
    attr.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.2, 0.2), M_PI);
    attr.center = CGPointMake(CGRectGetMidX(sCol.bounds), CGRectGetMaxY(sCol.bounds));
    
    return attr;
}













//Edit
-(void)EditIMG:(UILongPressGestureRecognizer*)longGesture{
    UICollectionView *sCol=[_YPtable viewWithTag:3333];
    //判断手势状态
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{
            //判断手势落点位置是否在路径上
            NSIndexPath *indexPath = [sCol indexPathForItemAtPoint:[longGesture locationInView:sCol]];
            if (indexPath == nil)break;
            //在路径上则开始移动该路径上的cell
            [sCol beginInteractiveMovementForItemAtIndexPath:indexPath];}break;
            
        case UIGestureRecognizerStateChanged:
            //移动过程当中随时更新cell位置
            [sCol updateInteractiveMovementTargetPosition:[longGesture locationInView:sCol]];
            break;
        case UIGestureRecognizerStateEnded:
            //移动结束后关闭cell移动
            [sCol endInteractiveMovement];
            break;
        default:
            [sCol cancelInteractiveMovement];
            break;
    }
}
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger allcout=_Locallist.count+_URLlist.count;
    if(indexPath.row==allcout && allcout!=9)return NO;
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
//    //取出源item数据
//    id objc = [_dataSource objectAtIndex:sourceIndexPath.item];
//    //从资源数组中移除该数据
//    [_dataSource removeObject:objc];
//    //将数据插入到资源数组中的目标位置上
//    [_dataSource insertObject:objc atIndex:destinationIndexPath.item];
}







#pragma mark UITableView        DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ypimglistcell"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 305;
}

















-(void)SelectIMG{
    [self.view endEditing:YES];
    UIActionSheet *chooseImageSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil];
    [chooseImageSheet showInView:self.view];
}
#pragma mark -照片功能
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0)[self takePhoto];
    if(buttonIndex==1)[self LocalPhoto];
}
//拍照
-(void)takePhoto{
    if([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusDenied){
        [SVProgressHUD showString:@"没有相机权限!请在设置-隐私-相机中开启!"];return;}
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        [SVProgressHUD showString:@"相机不可用!"];return;}
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:nil];
}
//相册
-(void)LocalPhoto{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 9-_URLlist.count-_Locallist.count;//最多一次性上传10张
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
    if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
        NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
        return duration >= 9-_URLlist.count-_Locallist.count;//最多一次性上传9张
        }else{return YES;}}];
    [self presentViewController:picker animated:NO completion:NULL];
}
#pragma mark - 取图片
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    for (int i=0; i<assets.count; i++) {
        UIImage *image = [UIImage imageWithCGImage:[assets[i] defaultRepresentation].fullResolutionImage];//方便漫画展示使用原图
        [self saveImage:image WithName:[self IMGname:i]];}
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSData *imageData = UIImageJPEGRepresentation(info[UIImagePickerControllerOriginalImage],0.5);
    UIImage *image = [UIImage imageWithData:imageData];
    image=[[comm share]fixOrientation:image];
    image=[[comm share]makeThumbnailFromImage:image scale:0.329];
    [self saveImage:image WithName:[self IMGname:0]];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//图片名字
-(NSString*)IMGname:(int)num{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"yyyy-MM-dd-hh:mm:ss"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSString *imageName = [NSString stringWithFormat:@"%@%d.png",dateString,num];
    return imageName;
}
#pragma mark -写入图片到磁盘
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString* PathFile = [paths[0] stringByAppendingPathComponent:imageName];
    [UIImageJPEGRepresentation(tempImage, .6) writeToFile:PathFile atomically:NO];
    
    NSURL *url = [NSURL fileURLWithPath:PathFile];
    [_Locallist addObject:url];

    UICollectionView *sCol=[_YPtable viewWithTag:3333];
    [sCol reloadData];
}


////图片删除
//-(void)delSampleImgById:(NSString *)strId{
//    NSLog(@"即将删除的图片:  %@",strId);
//    [[comm share]PostURL:@"Sample/DelSamplePicById" parameter:@{@"FileID":strId} finish:^(NSDictionary *Dic){
//        [SVProgressHUD showString:Dic[@"msg"]];
//        [addYPTableview reloadData];
//    }];
//    
//}






@end
