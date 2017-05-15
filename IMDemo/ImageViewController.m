//
//  ImageViewController.m
//  IMDemo
//
//  Created by 王毅安 on 17/5/8.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import "ImageViewController.h"
#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height

@interface ImageViewController ()
@property (nonatomic,strong) UIImageView * imageView;
@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 88, Width, Height-176)];
    [_imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_imageView setImage:[UIImage imageWithData:_imageData]];
    [self.view addSubview:_imageView];
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self     action:@selector(tap:)];
    tap.numberOfTapsRequired =1;
    tap.numberOfTouchesRequired =1;
    [self.view addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longPress =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration =0.5;
    longPress.allowableMovement =1;
    [self.view addGestureRecognizer:longPress];
    // Do any additional setup after loading the view.
}
-(void)tap:(UITapGestureRecognizer *)tapSender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)longPress:(UILongPressGestureRecognizer *)longPressSender{
    if (longPressSender.state == UIGestureRecognizerStateBegan) {
        //将图片保存到相册
        UIAlertController *alertVc =[UIAlertController alertControllerWithTitle:@"图片" message:@"是否保存图片到相册." preferredStyle:UIAlertControllerStyleAlert];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImageWriteToSavedPhotosAlbum(_imageView.image, nil, nil, nil);
            [self SaveWithSuggest];
        }]];
        [self presentViewController:alertVc animated:YES completion:nil];
    }else if (longPressSender.state == UIGestureRecognizerStateEnded)
    {}
}
-(void)SaveWithSuggest{
    UIAlertController *alertVc =[UIAlertController alertControllerWithTitle:@"图片" message:@"操作成功." preferredStyle:UIAlertControllerStyleAlert];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alertVc animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
