//
//  LoadViewController.m
//  IMDemo
//
//  Created by 王毅安 on 17/4/19.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import "LoadViewController.h"
#import "PromptView.h"
#import "GetNameView.h"
#import "HeaderImageController.h"
#import "HomeViewController.h"

#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height

@interface LoadViewController ()

@property (nonatomic,strong) PromptView * Prompt;
@property (nonatomic,strong) GetNameView * GetName;
@property (nonatomic,strong) UIButton * GetQQName;

@end

@implementation LoadViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [_GetName.NameView setBackgroundImage:[_GetName setHeaderImage] forState:UIControlStateNormal];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIImageView *BackgroundView=[[UIImageView alloc]initWithFrame:self.view.bounds];
    BackgroundView.image=[UIImage imageNamed:@"loadview"];
    [self.view addSubview:BackgroundView];
    
    [self loadPromptView];
    [self loadGetNameView];
    
    UIImageView *phone=[[UIImageView alloc]initWithFrame:CGRectMake(Width/4, Height-50, Width/2, 30)];
    [phone setContentMode:UIViewContentModeScaleAspectFit];
    phone.image=[UIImage imageNamed:@"mulAccount_foreground"];
    [self.view addSubview:phone];
    
    // Do any additional setup after loading the view.
}
-(void)loadPromptView{
    _Prompt=[[PromptView alloc]initWithFrame:CGRectMake(0, 0, Width, Height/3.6)];
    [_Prompt.messagePrompt addTarget:self action:@selector(messagePrompt:) forControlEvents:UIControlEventTouchUpInside];
    _Prompt.message.text=@"您和其他用户在同一局域网环境下（WIFI/蓝牙），即可享受免流量聊天，传输文件等功能哦~";
    [self.view addSubview:_Prompt];
}
-(void)loadGetNameView{
    _GetName=[[GetNameView alloc]initWithFrame:CGRectMake(0, Height/3.6, Width, Height/3)];
    [_GetName.NameView addTarget:self action:@selector(nameview:) forControlEvents:UIControlEventTouchUpInside];
    [_GetName.GetName addTarget:self action:@selector(getname:) forControlEvents:UIControlEventTouchUpInside];
    _GetName.NameText.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_GetName];
    
    _GetQQName=[[UIButton alloc]initWithFrame:CGRectMake((Width-50)/2, Height-110,50, 50)];
    [_GetQQName addTarget:self action:@selector(getqqname:) forControlEvents:UIControlEventTouchUpInside];
    [_GetQQName setBackgroundImage:[UIImage imageNamed:@"QQ"] forState:UIControlStateNormal];
    [self.view addSubview:_GetQQName];
}
#pragma mark ##### 提示 #####
-(void)messagePrompt:(UIButton*)messagePrompt{
    if (!messagePrompt.selected) {
        CGSize size = [PromptView sizeWithString:_Prompt.message.text];
        
        _Prompt.messageView.frame=CGRectMake((Width-(size.width+40))/2, 55, size.width+40, size.height+40);
        _Prompt.message.frame=CGRectMake((Width-size.width)/2, 75, size.width, size.height);
        
        messagePrompt.selected=!messagePrompt.selected;
        
    }else{
        _Prompt.messageView.frame=CGRectMake( 0, 0, 0, 0);
        _Prompt.message.frame=CGRectMake( 0, 0, 0, 0);
        
        messagePrompt.selected=!messagePrompt.selected;
    }
}
-(void)nameview:(UIButton*)nameview{
    HeaderImageController *Header=[HeaderImageController new];
    Header.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    [self presentViewController:Header animated:YES completion:nil];
}
-(void)getname:(UIButton*)getname{
    if ([_GetName.NameText.text isEqualToString:@""]) {
        _GetName.NameText.text=@"新晋游客";
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:_GetName.NameText.text forKey:@"username"];
        HomeViewController *Home=[HomeViewController new];
        
        if (self.presentingViewController==Home) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            Home.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
            [self presentViewController:Home animated:YES completion:nil];
        }
    }
}
-(void)getqqname:(UIButton*)getqqname{
    
    
    
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/** 图片拉伸两边 */
//- (UIImage *)LeftAndRightWithContainerSize:(CGSize)size
//{
//    UIImage *image=[UIImage imageNamed:@"qqwallet_input_bubble_bg"];
//
//    //1.第一次拉伸右边 保护左边
//    image = [image stretchableImageWithLeftCapWidth:image.size.width *0.8 topCapHeight:image.size.height * 0.5];
//
//    //第一次拉伸的距离之后图片总宽度
//    CGFloat tempWidth = (size.width+ image.size.width)/2;
//
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(tempWidth, image.size.height), NO, [UIScreen mainScreen].scale);
//
//    [image drawInRect:CGRectMake(0, 0, tempWidth, image.size.height)];
//
//    //拿到拉伸过的图片
//    image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    //2.第二次拉伸左边 保护右边
//    image = [image stretchableImageWithLeftCapWidth:image.size.width *0.1 topCapHeight:image.size.height*0.5];
//
//    return image;
//}

@end
