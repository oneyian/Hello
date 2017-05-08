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

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 88, Width, Height-176)];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    NSData *data=[[NSData alloc]initWithBase64EncodedString:_image options:NSDataBase64DecodingIgnoreUnknownCharacters];
    [imageView setImage:[UIImage imageWithData:data]];
    [self.view addSubview:imageView];
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self     action:@selector(tap:)];
    tap.numberOfTapsRequired =1;
    tap.numberOfTouchesRequired =1;
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}
-(void)tap:(UITapGestureRecognizer *)tapSender{
    [self dismissViewControllerAnimated:YES completion:nil];
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
