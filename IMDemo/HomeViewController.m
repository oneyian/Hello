//
//  ViewController.m
//  IMDemo
//
//  Created by 王毅安 on 17/4/14.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import "HomeViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "AppDelegate.h"
#import "MessageController.h"
#import "PromptView.h"
#import "GetNameView.h"
#import "HeaderImageController.h"
#import "LoadViewController.h"

#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height

@interface HomeViewController ()<MCBrowserViewControllerDelegate>

@property (nonatomic,strong) AppDelegate * appDelegate;

@property (nonatomic,strong) NSMutableArray * DevicesArray;

@property (nonatomic,strong) UIAlertController *Alert;
@property (nonatomic,strong) PromptView * Prompt;
@property (nonatomic,strong) GetNameView * GetName;

@end

@implementation HomeViewController
-(NSMutableArray*)DevicesArray{
    if (!_DevicesArray) {
        _DevicesArray=[NSMutableArray new];
    }
    return _DevicesArray;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.DevicesArray removeAllObjects];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIImageView *BackgroundView=[[UIImageView alloc]initWithFrame:self.view.bounds];
    BackgroundView.image=[UIImage imageNamed:@"nowlive_room_default_bkg"];
    [self.view addSubview:BackgroundView];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(peerDidChangeStateWithNotification:) name:@"MCDidChangeStateNotification" object:nil];
    
    [self CreatButton];
    [self loadPromptView];
    [self loadGetNameView];
    
    UIButton *logout=[[UIButton alloc]initWithFrame:CGRectMake(5, 20, 40, 40)];
    [logout setImage:[UIImage imageNamed:@"game_out"] forState:UIControlStateNormal];
    [logout addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logout];
}
#pragma mark ##### UI界面 #####
-(void)loadPromptView{
    _Prompt=[[PromptView alloc]initWithFrame:CGRectMake(0, 0, Width, Height/3.6)];
    [_Prompt.messagePrompt addTarget:self action:@selector(messagePrompt:) forControlEvents:UIControlEventTouchUpInside];
    _Prompt.message.text=@"您和其他用户在同一局域网环境下（WIFI/蓝牙），即可享受免流量聊天，传输文件等功能哦~";
    [self.view addSubview:_Prompt];
}
-(void)loadGetNameView{
    _GetName=[[GetNameView alloc]initWithFrame:CGRectMake(0, Height/3.6, Width, Height/3)];
    [_GetName.NameView addTarget:self action:@selector(nameview:) forControlEvents:UIControlEventTouchUpInside];
    [_GetName.GetName setHidden:YES];
    
    UIImageView *textimage=[[UIImageView alloc]initWithFrame:CGRectMake(12.5, 95,Width-25, 45)];
    textimage.image=[self imageWithimage:[UIImage imageNamed:@"qcall_chat_with_friend_normal"]];
    [_GetName addSubview:textimage];
    [self.view addSubview:_GetName];
    
    UIImageView *phone=[[UIImageView alloc]initWithFrame:CGRectMake(Width/4, Height-50, Width/2, 30)];
    [phone setContentMode:UIViewContentModeScaleAspectFit];
    phone.image=[UIImage imageNamed:@"qqusb_intro_iPad"];
    [self.view addSubview:phone];
}
-(void)PresentMessageController{
    MessageController *Message=[MessageController new];
    [Message setDevicesArray:self.DevicesArray];
    Message.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:Message animated:YES completion:nil];
}
-(void)CreatButton{
    CGFloat padding=100;
    UIButton *Server=[[UIButton alloc]initWithFrame:CGRectMake(Width/2-50, Height/2+padding, 100, 30)];
    [Server.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [Server.layer setCornerRadius:10];
    [Server addTarget:self action:@selector(server:) forControlEvents:UIControlEventTouchUpInside];
    [Server setTitle:@"创建房间" forState:UIControlStateNormal];
    [Server setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    UIImage *serverImage=[self imageWithimage:[UIImage imageNamed:@"occupation_science_bg"]];
    [Server setBackgroundImage:serverImage forState:UIControlStateNormal];
    [self.view addSubview:Server];
    
    UIButton *Client=[[UIButton alloc]initWithFrame:CGRectMake(Width/2-50, Height/2+padding+50, 100, 30)];
    [Client.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [Client.layer setCornerRadius:10];
    [Client addTarget:self action:@selector(client:) forControlEvents:UIControlEventTouchUpInside];
    [Client setTitle:@"搜索房间" forState:UIControlStateNormal];
    [Client setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    UIImage *clientImage=[self imageWithimage:[UIImage imageNamed:@"occupation_business_bg"]];
    [Client setBackgroundImage:clientImage forState:UIControlStateNormal];
    [self.view addSubview:Client];
}
#pragma mark ##### 控件实现区 #####
-(void)logout:(UIButton*)logout{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"username"];
    LoadViewController *Load=[LoadViewController new];
    if (self.presentingViewController==Load) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        Load.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
        [self presentViewController:Load animated:YES completion:nil];
    }
}
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
-(void)server:(UIButton*)sender{
    if ([_GetName.NameText.text isEqualToString:@""]) {
        _GetName.NameText.text=@"新晋游客";
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:_GetName.NameText.text forKey:@"username"];
        [[_appDelegate mcManager] setupPeerAndSessionWithDisplayName:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]];
        [_appDelegate.mcManager advertiseSelf:YES];
        
        _Alert =[UIAlertController alertControllerWithTitle:@"创建成功" message:@"正在等待其他用户进入..." preferredStyle:UIAlertControllerStyleAlert];
        [_Alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [[_appDelegate mcManager] advertiseSelf:NO];
            [_appDelegate.mcManager.session disconnect];
        }]];
        [self presentViewController:_Alert animated:YES completion:nil];
    }
}
-(void)client:(UIButton*)sender{
    if ([_GetName.NameText.text isEqualToString:@""]) {
        _GetName.NameText.text=@"新晋游客";
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:_GetName.NameText.text forKey:@"username"];
        [[_appDelegate mcManager] setupPeerAndSessionWithDisplayName:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]];
        [_appDelegate.mcManager advertiseSelf:YES];
        [self PresentMessageController];
        
        //
        //    [[_appDelegate mcManager] setupMCBrowser];
        //    [[[_appDelegate mcManager] browser] setDelegate:self];
        //    [self presentViewController:[[_appDelegate mcManager] browser] animated:YES completion:nil];
    }
}
#pragma mark ##### 连接状态 #####
-(void)peerDidChangeStateWithNotification:(NSNotification *)notification{
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
    
    if (state == MCSessionStateConnecting) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_Alert setMessage:@"正在连接中..."];
            [_DevicesArray addObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]];
        });
    }else if (state == MCSessionStateConnected) {
        if(![_DevicesArray containsObject:peerID.displayName]){
            [_DevicesArray addObject:peerID.displayName];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_Alert setTitle:@"连接成功"];
            [_Alert setMessage:@"是否进入房间？"];
            [_Alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self PresentMessageController];
            }]];
        });
    }else if (state == MCSessionStateNotConnected){
        if ([_DevicesArray count] > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_Alert dismissViewControllerAnimated:YES completion:nil];
                UIAlertController *NotConnect=[UIAlertController alertControllerWithTitle:@"连接断开" message:@"您的连接已断开." preferredStyle:UIAlertControllerStyleAlert];
                [NotConnect addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [[_appDelegate mcManager] advertiseSelf:NO];
                    [_appDelegate.mcManager.session disconnect];
                    [_DevicesArray removeAllObjects];
                }]];
                [self presentViewController:NotConnect animated:YES completion:nil];
            });
        }
    }
}
#pragma mark ##### 代理方法区 #####
-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [_appDelegate.mcManager.browser dismissViewControllerAnimated:NO completion:^{
        [self PresentMessageController];
    }];
}
-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    UIAlertController *Cancelled=[UIAlertController alertControllerWithTitle:@"断开连接？" message:@"您将断开与其他人的连接." preferredStyle:UIAlertControllerStyleAlert];
    [Cancelled addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[_appDelegate mcManager] advertiseSelf:NO];
        [_appDelegate.mcManager.session disconnect];
        [_DevicesArray removeAllObjects];
        [_appDelegate.mcManager.browser dismissViewControllerAnimated:YES completion:nil];
    }]];
    [_appDelegate.mcManager.browser presentViewController:Cancelled animated:YES completion:nil];
}
#pragma mark ##### 拉伸图片 #####
-(UIImage*)imageWithimage:(UIImage*)image{
    image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    return image;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
