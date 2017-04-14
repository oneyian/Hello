//
//  ViewController.m
//  IMDemo
//
//  Created by 王毅安 on 17/4/14.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "MessageCell.h"

#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) AppDelegate * appDelegate;
@property (nonatomic,strong) NSMutableArray * MessageArray;
@property (nonatomic,strong) NSMutableArray * DevicesArray;
@property (nonatomic,strong) UIActivityIndicatorView *Activity;
@property (nonatomic,strong) UITableView * DevicesTable;
@property (nonatomic,strong) UITableView * MessageTable;
@property (nonatomic,strong) UIButton * stop;
@property (nonatomic,strong) UITextField * messageField;
@property (nonatomic,strong) UIView * ToolView;

@end

@implementation HomeViewController
-(NSMutableArray*)DevicesArray{
    if (!_DevicesArray) {
        _DevicesArray=[NSMutableArray new];
    }
    return _DevicesArray;
}
-(NSMutableArray*)MessageArray{
    if (!_MessageArray) {
        _MessageArray=[NSMutableArray new];
    }
    return _MessageArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Hello"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(peerDidChangeStateWithNotification:) name:@"MCDidChangeStateNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveDataWithNotification:) name:@"MCDidReceiveDataNotification" object:nil];

    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self CreatTable];
    
    [self CreatUI];
    
    [self CreatButton];
    
}
#pragma mark ##### UI界面 #####
-(void)CreatUI{
    _ToolView=[[UIView alloc]initWithFrame:CGRectMake(0, Height/2+45, Width, 30)];
    _ToolView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_ToolView];
    
    _Activity=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(Width/2-63, 11, 22, 22)];
    [_Activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.navigationController.navigationBar addSubview:_Activity];

    UIButton *add=[[UIButton alloc]initWithFrame:CGRectMake(10, 0, 30, 30)];
    [add.titleLabel setFont:[UIFont systemFontOfSize:24]];
    [add addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    [add setTitle:@"＋" forState:UIControlStateNormal];
    [add setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [add setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_ToolView addSubview:add];
    
    _messageField=[[UITextField alloc]initWithFrame:CGRectMake(50, 0, Width-120, 30)];
    _messageField.borderStyle=UITextBorderStyleRoundedRect;
    [_messageField setTextAlignment:NSTextAlignmentLeft];
    _messageField.delegate=self;
    [_ToolView addSubview:_messageField];
    
    UIButton *send=[[UIButton alloc]initWithFrame:CGRectMake(Width-60, 0, 50, 30)];
    [send.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [send addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
    [send setTitle:@"Send" forState:UIControlStateNormal];
    [send setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [send setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_ToolView addSubview:send];
    
    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrames:) name:UIKeyboardWillHideNotification object:nil];
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
-(void)CreatTable{
    _DevicesTable=[[UITableView alloc]initWithFrame:CGRectMake(0, Height/2+190, Width, Height-Height/2+190) style:UITableViewStylePlain];
    _DevicesTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_DevicesTable setDelegate:self];
    [_DevicesTable setDataSource:self];
    [self.view addSubview:_DevicesTable];
    
    _MessageTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, Width, Height/2+45-64) style:UITableViewStylePlain];
    _MessageTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    _MessageTable.showsVerticalScrollIndicator = NO;
    [_MessageTable setDelegate:self];
    [_MessageTable setDataSource:self];
    [self.view addSubview:_MessageTable];
}
#pragma mark ##### 监控连接状态 #####
-(void)peerDidChangeStateWithNotification:(NSNotification *)notification{
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
    
    if (state == MCSessionStateConnecting) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_Activity startAnimating];
            [self.navigationItem setTitle:@"正在连接.."];
        });
    }else if (state == MCSessionStateConnected) {
        [_DevicesArray addObject:peerDisplayName];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_DevicesTable reloadData];
            [_Activity stopAnimating];
            [self.navigationItem setTitle:@"连接成功!"];
        });
    }else if (state == MCSessionStateNotConnected){
        if ([_DevicesArray count] > 0) {
            int indexOfPeer = (int)[_DevicesArray indexOfObject:peerDisplayName];
            [_DevicesArray removeObjectAtIndex:indexOfPeer];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_DevicesTable reloadData];
                [_Activity stopAnimating];
                [self.navigationItem setTitle:@"Hello"];
            });
        }
    }
}
#pragma mark ##### 数据接收 #####
-(void)didReceiveDataWithNotification:(NSNotification *)notification{
    NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
    NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    NSDictionary *messageData=[[NSDictionary alloc]initWithObjectsAndKeys:receivedText,@"message",@"1",@"type", nil];
    [_MessageArray addObject:messageData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_MessageTable reloadData];
    });
}
#pragma mark ##### 控件实现区 #####
-(void)server:(UIButton*)sender{
    [[_appDelegate mcManager] setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
    [_appDelegate.mcManager advertiseSelf:YES];
    [_Activity startAnimating];
    [self.navigationItem setTitle:@"等待加入.."];

    [_stop removeFromSuperview];
    _stop=[[UIButton alloc]initWithFrame:CGRectMake(Width/2+55, Height/2+100, 90, 30)];
    [_stop.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [_stop addTarget:self action:@selector(stop:) forControlEvents:UIControlEventTouchUpInside];
    [_stop setTitle:@"销毁房间" forState:UIControlStateNormal];
    [_stop setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_stop setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:_stop];
}
-(void)stop:(UIButton*)sender{
    [_Activity stopAnimating];
    [self.navigationItem setTitle:@"Hello"];
    [[_appDelegate mcManager] advertiseSelf:NO];
    [_appDelegate.mcManager.session disconnect];
    [_DevicesArray removeAllObjects];
    [_DevicesTable reloadData];
    [sender removeFromSuperview];
}
-(void)client:(UIButton*)sender{
    [[_appDelegate mcManager] setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
    [_appDelegate.mcManager advertiseSelf:YES];
    
    [[_appDelegate mcManager] setupMCBrowser];
    [[[_appDelegate mcManager] browser] setDelegate:self];
    [self presentViewController:[[_appDelegate mcManager] browser] animated:YES completion:nil];
}
-(void)add:(UIButton*)sender{
    
}
-(void)send:(UIButton*)sender{
    /** 发送数据 */
    if (![_messageField.text isEqualToString:@""]) {
        NSDictionary *messageData=[[NSDictionary alloc]initWithObjectsAndKeys:_messageField.text,@"message",@"0",@"type", nil];
        [_MessageArray addObject:messageData];
        [_MessageTable reloadData];
        
        NSData *dataToSend = [_messageField.text dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *allPeers = _appDelegate.mcManager.session.connectedPeers;
        NSError *error;
        
        [_appDelegate.mcManager.session sendData:dataToSend
                                         toPeers:allPeers
                                        withMode:MCSessionSendDataReliable
                                           error:&error];
        
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
        [_messageField setText:@""];
        [_messageField resignFirstResponder];
    }
}
#pragma mark ##### 代理方法区 #####
-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [_Activity stopAnimating];
    [self.navigationItem setTitle:@"连接成功!"];
    [_appDelegate.mcManager.browser dismissViewControllerAnimated:YES completion:nil];
}
-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [_Activity stopAnimating];
    [self.navigationItem setTitle:@"Hello"];
    [_appDelegate.mcManager advertiseSelf:NO];
    [_DevicesArray removeAllObjects];
    [_DevicesTable reloadData];
    [_appDelegate.mcManager.browser dismissViewControllerAnimated:YES completion:nil];
}
- (void)keyboardChangeFrame:(NSNotification *)notifi{
    CGRect keyboardFrame = [notifi.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float duration = [notifi.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        _ToolView.frame=CGRectMake(0, keyboardFrame.origin.y-30, Width, 30);
    }];
}
- (void)keyboardChangeFrames:(NSNotification *)notifi{
    float duration = [notifi.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        _ToolView.frame=CGRectMake(0, Height/2+45, Width, 30);
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_DevicesTable) {
        return self.DevicesArray.count;
    }else{
        return self.MessageArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_DevicesTable) {
    return 30;
    }else{
        return 50;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_DevicesTable) {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"id"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
        }
        cell.textLabel.text=_DevicesArray[indexPath.row];
        cell.backgroundColor=[UIColor groupTableViewBackgroundColor];
        return cell;
    }else{
        CGFloat padding=40;
        if ([[_MessageArray[indexPath.row] objectForKey:@"type"] integerValue]==0) {
            MessageCell *Cell=[MessageCell cellWithTableView:tableView cellWithType:MessageTypeMe];
            Cell.selectionStyle = UITableViewCellSelectionStyleNone;
            Cell.myself.text=[_MessageArray[indexPath.row] objectForKey:@"message"];
            if (Cell.myself.text.length>=15) {
                [Cell.myself setFrame:CGRectMake(10, 10, Width-90, 30)];
            }else{
                [Cell.myself setFrame:CGRectMake(Width-Cell.myself.text.length*15-80-padding, 10, Cell.myself.text.length*15+padding, 30)];
            }
            Cell.myself.layer.cornerRadius=10;
            Cell.myself.clipsToBounds=YES;
            return Cell;
        }else{
            MessageCell *Cell=[MessageCell cellWithTableView:tableView cellWithType:MessageTypeOther];
            Cell.selectionStyle = UITableViewCellSelectionStyleNone;
            Cell.other.text=[_MessageArray[indexPath.row] objectForKey:@"message"];
            if (Cell.other.text.length>=15) {
                [Cell.other setFrame:CGRectMake(80, 10, Width-90, 30)];
            }else{
                [Cell.other setFrame:CGRectMake(80, 10, Cell.other.text.length*15+padding, 30)];
            }
            Cell.other.layer.cornerRadius=10;
            Cell.other.clipsToBounds=YES;
            return Cell;
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_messageField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
