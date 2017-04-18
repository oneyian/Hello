//
//  ViewController.m
//  IMDemo
//
//  Created by 王毅安 on 17/4/14.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "MessageController.h"

#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) AppDelegate * appDelegate;
@property (nonatomic,strong) UITableView * DevicesTable;
@property (nonatomic,strong) NSMutableArray * DevicesArray;
@property (nonatomic,strong) UIAlertController *Alert;

@end

@implementation HomeViewController
-(NSMutableArray*)DevicesArray{
    if (!_DevicesArray) {
        _DevicesArray=[NSMutableArray new];
    }
    return _DevicesArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Hello"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(peerDidChangeStateWithNotification:) name:@"MCDidChangeStateNotification" object:nil];
    
    [self CreatTable];
    
    [self CreatButton];
    
}
#pragma mark ##### UI界面 #####
-(void)PresentMessageController{
    MessageController *Message=[MessageController new];
    Message.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:Message animated:YES completion:nil];
}
-(void)CreatButton{
    CGFloat padding=100;
    UIButton *Server=[[UIButton alloc]initWithFrame:CGRectMake(Width/2-50, Height/2+padding, 100, 30)];
    [Server.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [Server.layer setCornerRadius:10];
    [Server setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [Server addTarget:self action:@selector(server:) forControlEvents:UIControlEventTouchUpInside];
    [Server setTitle:@"创建房间" forState:UIControlStateNormal];
    [Server setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [Server setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.view addSubview:Server];
    
    UIButton *Client=[[UIButton alloc]initWithFrame:CGRectMake(Width/2-50, Height/2+padding+50, 100, 30)];
    [Client.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [Client.layer setCornerRadius:10];
    [Client setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [Client addTarget:self action:@selector(client:) forControlEvents:UIControlEventTouchUpInside];
    [Client setTitle:@"搜索房间" forState:UIControlStateNormal];
    [Client setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [Client setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.view addSubview:Client];
}
-(void)CreatTable{
    self.automaticallyAdjustsScrollViewInsets = NO;//关闭布局
    _DevicesTable=[[UITableView alloc]initWithFrame:CGRectMake(0, Height/2+190, Width, Height-Height/2+190) style:UITableViewStylePlain];
    _DevicesTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    _DevicesTable.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [_DevicesTable setDelegate:self];
    [_DevicesTable setDataSource:self];
    [self.view addSubview:_DevicesTable];
}
#pragma mark ##### 控件实现区 #####
-(void)server:(UIButton*)sender{
    [[_appDelegate mcManager] setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
    [_appDelegate.mcManager advertiseSelf:YES];

    _Alert =[UIAlertController alertControllerWithTitle:@"房间创建成功" message:@"正在等待其他用户进入..." preferredStyle:UIAlertControllerStyleAlert];
    [_Alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[_appDelegate mcManager] advertiseSelf:NO];
        [_appDelegate.mcManager.session disconnect];
        [_DevicesArray removeAllObjects];
        [_DevicesTable reloadData];
    }]];
    [self presentViewController:_Alert animated:YES completion:nil];
}
-(void)client:(UIButton*)sender{
    [self PresentMessageController];
//    [[_appDelegate mcManager] setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
//    [_appDelegate.mcManager advertiseSelf:YES];
//    
//    [[_appDelegate mcManager] setupMCBrowser];
//    [[[_appDelegate mcManager] browser] setDelegate:self];
//    [self presentViewController:[[_appDelegate mcManager] browser] animated:YES completion:nil];
}
#pragma mark ##### 连接状态 #####
-(void)peerDidChangeStateWithNotification:(NSNotification *)notification{
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
    
    if (state == MCSessionStateConnecting) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_Alert setMessage:@"正在连接中..."];
        });
    }else if (state == MCSessionStateConnected) {
        if(![_DevicesArray containsObject:peerDisplayName]){
            [_DevicesArray addObject:peerDisplayName];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_DevicesTable reloadData];
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
                UIAlertController *NotConnect=[UIAlertController alertControllerWithTitle:@"连接失败" message:@"您与其他人的连接已断开." preferredStyle:UIAlertControllerStyleAlert];
                [NotConnect addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [[_appDelegate mcManager] advertiseSelf:NO];
                    [_appDelegate.mcManager.session disconnect];
                    [_DevicesArray removeAllObjects];
                    [_DevicesTable reloadData];
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
        [_DevicesTable reloadData];
        [_appDelegate.mcManager.browser dismissViewControllerAnimated:YES completion:nil];
    }]];
    [_appDelegate.mcManager.browser presentViewController:Cancelled animated:YES completion:nil];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.DevicesArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"id"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.textLabel.layer.borderWidth = 1;
    cell.textLabel.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    cell.textLabel.layer.cornerRadius=10;
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
    cell.textLabel.text=_DevicesArray[indexPath.row];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
