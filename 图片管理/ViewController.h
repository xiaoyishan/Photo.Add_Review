//
//  ViewController.h
//  图片管理
//
//  Created by sundeariOS on 16/6/27.
//  Copyright © 2016年 sundeariOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYQAssetPickerController.h"
#import <AVFoundation/AVFoundation.h>
#import "SVProgressHUD.h"
#import "YS_Photo.h"
#import "Ys_Browser.h"

#import "comm.h"

@interface ViewController : UIViewController<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,ZYQAssetPickerControllerDelegate>

@property (strong) NSMutableArray *URLlist;
@property (strong) NSMutableArray *Locallist;

@end

