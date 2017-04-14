//
//  ViewController.m
//  IMDemo
//
//  Created by 王毅安 on 17/4/14.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"

#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height

@interface HomeViewController ()
@property (nonatomic,strong) AppDelegate * appDelegate;
@property (nonatomic,strong) UIButton * stop;
@property (nonatomic,copy) NSString * UID;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _UID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[_appDelegate mcManager] setupPeerAndSessionWithDisplayName:_UID];
    [[_appDelegate mcManager] advertiseSelf:YES];
    [self CreatButton];

}
#pragma mark ##### UI界面 #####
-(void)BeginAction{
    NSLog(@"开始广播");
    [self.stop removeFromSuperview];
    self.stop=[[UIButton alloc]initWithFrame:CGRectMake(Width/2-62, Height/2+30, 124, 30)];
    [_stop.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [_stop addTarget:self action:@selector(stop:) forControlEvents:UIControlEventTouchUpInside];
    [_stop setTitle:@"取消全部服务" forState:UIControlStateNormal];
    [_stop setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_stop setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:_stop];
}
-(void)CreatServerView{
    [self BeginAction];
    NSLog(@"创建");
}
-(void)CreatClientView{
    [self BeginAction];
    NSLog(@"搜索");
}
-(void)CreatButton{
    CGFloat padding=100;
    UIButton *Server=[[UIButton alloc]initWithFrame:CGRectMake(Width/2-50, Height/2+padding, 100, 30)];
    [Server.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [Server addTarget:self action:@selector(server:) forControlEvents:UIControlEventTouchUpInside];
    [Server setTitle:@"创建房间" forState:UIControlStateNormal];
    [Server setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [Server setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.view addSubview:Server];
    
    UIButton *Client=[[UIButton alloc]initWithFrame:CGRectMake(Width/2-50, Height/2+padding+50, 100, 30)];
    [Client.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [Client addTarget:self action:@selector(client:) forControlEvents:UIControlEventTouchUpInside];
    [Client setTitle:@"搜索房间" forState:UIControlStateNormal];
    [Client setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [Client setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.view addSubview:Client];
}
#pragma mark ##### 控件实现区 #####
-(void)server:(UIButton*)sender{

    [self CreatServerView];
}
-(void)client:(UIButton*)sender{

    
    [self CreatClientView];
}
-(void)stop:(UIButton*)sender{
    [sender removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
