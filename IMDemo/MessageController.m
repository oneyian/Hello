//
//  MessageController.m
//  IMDemo
//
//  Created by 王毅安 on 17/4/15.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import "MessageController.h"
#import "AppDelegate.h"
#import "MessageCell.h"

#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height

@interface MessageController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) AppDelegate *appDelegate;

@property (nonatomic,strong) UITableView * MessageTable;
@property (nonatomic,strong) NSMutableArray * MessageArray;
@property (nonatomic,strong) UIView * MessageView;
@property (nonatomic,strong) UITextField * MessageField;
@end

@implementation MessageController
-(NSMutableArray*)MessageArray{
    if (!_MessageArray) {
        _MessageArray=[NSMutableArray new];
    }
    return _MessageArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveDataWithNotification:) name:@"MCDidReceiveDataNotification" object:nil];
    
    [self CreatUIView];
}
#pragma mark ##### UI界面 #####
-(void)CreatUIView{
    self.automaticallyAdjustsScrollViewInsets = NO;//关闭布局
    
    UINavigationBar *HeaderBar=[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, Width, 64)];
    [self.view addSubview:HeaderBar];
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(Width/2-50, 30, 100, 20)];
    title.font=[UIFont systemFontOfSize:19];
    title.text=@"Hello World";
    [HeaderBar addSubview:title];
    
    UIButton *Menu=[[UIButton alloc]initWithFrame:CGRectMake(Width-50, 20, 40, 40)];
    [Menu setImage:[UIImage imageNamed:@"ic_menu_normal"] forState:UIControlStateNormal];
    [Menu setImage:[UIImage imageNamed:@"ic_menu_highlighted"] forState:UIControlStateHighlighted];
    [Menu addTarget:self action:@selector(menu:) forControlEvents:UIControlEventTouchUpInside];
    [HeaderBar addSubview:Menu];
    
    _MessageTable=[[UITableView alloc]initWithFrame:CGRectMake(0,64, Width, Height-64-50) style:UITableViewStylePlain];
    _MessageTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    _MessageTable.showsVerticalScrollIndicator = NO;
    [_MessageTable setDelegate:self];
    [_MessageTable setDataSource:self];
    [self.view addSubview:_MessageTable];
    
    _MessageView=[[UIView alloc]initWithFrame:CGRectMake(0, Height-50, Width, 50)];
    [_MessageView setBackgroundColor:_MessageTable.backgroundColor];
    [self.view addSubview:_MessageView];
    
    UIButton *addFile=[[UIButton alloc]initWithFrame:CGRectMake(6, 6, 38, 38)];
    [addFile addTarget:self action:@selector(addfile:) forControlEvents:UIControlEventTouchUpInside];
    [addFile setImage:[UIImage imageNamed:@"ic_addfile"] forState:UIControlStateNormal];
    [_MessageView addSubview:addFile];
    
    _MessageField=[[UITextField alloc]initWithFrame:CGRectMake(50, 7.5, Width-60, 35)];
    _MessageField.borderStyle=UITextBorderStyleRoundedRect;
    [_MessageField setReturnKeyType:UIReturnKeySend];
    [_MessageField setTextAlignment:NSTextAlignmentLeft];
    _MessageField.delegate=self;
    [_MessageView addSubview:_MessageField];
    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Showkeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Hidekeyboard:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark ##### 控件方法实现 #####
-(void)ShowFootCell{
    //滚动显示最后一条数据
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_MessageArray.count - 1 inSection:0];
    [_MessageTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
-(void)menu:(UIButton*)sender{
    [[_appDelegate mcManager] advertiseSelf:NO];
    [_appDelegate.mcManager.session disconnect];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)addfile:(UIButton*)sender{
    
}
- (void)Showkeyboard:(NSNotification *)notification{
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        _MessageTable.frame=CGRectMake(0,64, Width, keyboardFrame.origin.y-64-50);
        _MessageView.frame=CGRectMake(0, keyboardFrame.origin.y-50, Width, 50);
    }];
    if (_MessageArray.count>0) {
        //滚动显示最后一条数据
        [self ShowFootCell];
    }
}
- (void)Hidekeyboard:(NSNotification *)notification{
    float duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        _MessageTable.frame=CGRectMake(0,64, Width, Height-64-50);
        _MessageView.frame=CGRectMake(0, Height-50, Width, 50);
    }];
    if (_MessageArray.count>0) {
        //滚动显示最后一条数据
        [self ShowFootCell];
    }
}
#pragma mark ##### 代理方法实现 #####
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.MessageArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
#pragma mark ##### 发送数据 #####
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![_MessageField.text isEqualToString:@""]) {
        NSDictionary *messageData=[[NSDictionary alloc]initWithObjectsAndKeys:_MessageField.text,@"message",@"0",@"type", nil];
        [_MessageArray addObject:messageData];
        [_MessageTable reloadData];
        [self ShowFootCell];
        
        NSData *dataToSend = [_MessageField.text dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *allPeers = _appDelegate.mcManager.session.connectedPeers;
        NSError *error;
        
        [_appDelegate.mcManager.session sendData:dataToSend
                                         toPeers:allPeers
                                        withMode:MCSessionSendDataReliable
                                           error:&error];
        [_MessageField setText:@""];
    }
    return YES;
}
#pragma mark ##### 数据接收 #####
-(void)didReceiveDataWithNotification:(NSNotification *)notification{
    NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
    NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    NSDictionary *messageData=[[NSDictionary alloc]initWithObjectsAndKeys:receivedText,@"message",@"1",@"type", nil];
    [_MessageArray addObject:messageData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_MessageTable reloadData];
        [self ShowFootCell];
    });
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
