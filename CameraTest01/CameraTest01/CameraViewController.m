//
//  CameraViewController.m
//  CameraTest01
//
//  Created by 天野 裕介 on 2013/02/21.
//  Copyright (c) 2013年 天野 裕介. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //カメラを起動
    [self kickCamera];
}

//カメラを起動
- (void)kickCamera
{
    UIImagePickerController *imagePickerController =[[UIImagePickerController alloc] init];
    
    //カメラ機能を選択
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    imagePickerController.delegate = self;

    //YESにしないと、UIImage(カメラで撮ったデータ) が取得できない
    imagePickerController.allowsEditing = YES;
    
    //モーダルビューでカメラ起動
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

//カメラ撮影後のデリゲートメソッド
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    //撮ったデータをUIImageにセットする
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //カメラロールに画像を保存
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(didFinishSavingImage:didFinishSavingWithError:contextInfo:), nil);
    
    //モーダルビューを消す
    [self dismissViewControllerAnimated:YES completion:nil];
}

//画像保存完了後。非同期で呼ばれる
- (void) didFinishSavingImage:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    //画像保存完了したよ、とアラートを出す
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"保存完了"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
