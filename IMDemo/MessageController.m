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
#import "MessageModel.h"
#import "TextView.h"
#import "ToolView.h"
#import "NavigationBar.h"

#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height

@interface MessageController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,NavigationBarDelegate>
@property (nonatomic, strong) AppDelegate *appDelegate;

@property (nonatomic,strong) UITableView * MessageTable;
@property (nonatomic,strong) NSMutableArray * MessageArray;

@property (nonatomic,assign) CGFloat OldY;
@property (nonatomic,assign) CGFloat NewHeight;
@property (nonatomic,assign) CGRect KeyBoardFrame;

@property (nonatomic,strong) NavigationBar * HeaderBar;
@property (nonatomic,strong) TextView * TextView;
@property (nonatomic,strong) ToolView * ToolView;
@end

@implementation MessageController
-(NSMutableArray*)MessageArray{
    if (!_MessageArray) {
        _MessageArray=[NSMutableArray new];
        NSDictionary *myself=[[NSDictionary alloc]initWithObjectsAndKeys:@"Me",@"name",@"通过我亲自测试，使用自动算高cell不可取，自动算高的cell在高度不发生变化的情况下（所谓高度不发生变化指的是cell在重用的时候高度不发生变化）滑动并不卡顿现象（即使高度发生变化，滑动过一次后卡顿就消失了，可见apple对约束的计算结果做了缓存，未来可期）",@"message",@"0",@"type", nil];
        NSDictionary *other=[[NSDictionary alloc]initWithObjectsAndKeys:@"Other",@"name",@"通过我亲自测试，使用自动算高cell不可取，自动算高的cell在高度不发生变化的情况下（所谓高度不发生变化指的是cell在重用的时候高度不发生变化）滑动并不卡顿现象（即使高度发生变化，滑动过一次后卡顿就消失了，可见apple对约束的计算结果做了缓存，未来可期）",@"message",@"1",@"type", nil];
        [_MessageArray addObject:myself];
        [_MessageArray addObject:other];
    }
    return _MessageArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveDataWithNotification:) name:@"MCDidReceiveDataNotification" object:nil];
    
    [self CreatUIView];
    
    
//    NSTextAttachment *emojiTextAttachment = [NSTextAttachment new];
//    
//    //设置表情图片
//    emojiTextAttachment.image = [UIImage imageNamed:@""];
//    
//    //插入表情
//     [_MessageText.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:emojiTextAttachment]
//                                          atIndex:_MessageText.selectedRange.location];
}
#pragma mark ##### UI界面 #####
-(void)CreatUIView{
    self.automaticallyAdjustsScrollViewInsets = NO;//关闭布局
    
    _HeaderBar=[[NavigationBar alloc]initWithFrame:CGRectMake(0, 0,Width , 64)];
    [_HeaderBar.menu setImage:[UIImage imageNamed:@"mulchat_header_icon_group"] forState:UIControlStateNormal];
    [_HeaderBar.menu setFrame:CGRectMake(Width-40, 25, 30, 30)];
    [_HeaderBar setBackgroundImage:[UIImage imageNamed:@"nowlive_room_default_bkg"] forBarMetrics:UIBarMetricsDefault];
    _HeaderBar.title.text=@"Hello";
    [_HeaderBar.title setTextColor:[UIColor whiteColor]];
    [_HeaderBar setNavigationBarDalegate:self];
    [self.view addSubview:_HeaderBar];
    
    _MessageTable=[[UITableView alloc]initWithFrame:CGRectMake(0,64, Width, Height-64-85.5) style:UITableViewStylePlain];
    [_MessageTable setBackgroundColor:self.view.backgroundColor];
    _MessageTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    _MessageTable.showsVerticalScrollIndicator = NO;
    [_MessageTable setDelegate:self];
    [_MessageTable setDataSource:self];
    [self.view addSubview:_MessageTable];
    
    _TextView=[[TextView alloc]initWithFrame:CGRectMake(0, Height-85.5, Width, 5+30.5)];
    [_TextView setBackgroundColor:self.view.backgroundColor];
    [_TextView.textView setDelegate:self];
    [self.view addSubview:_TextView];
    
    _ToolView=[[ToolView alloc]initWithFrame:CGRectMake(0, Height-50, Width, 50)];
    [_ToolView setBackgroundColor:self.view.backgroundColor];
    [_ToolView.image addTarget:self action:@selector(image:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_ToolView];
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
-(void)back:(UIButton *)back{
    [[_appDelegate mcManager] advertiseSelf:NO];
    [_appDelegate.mcManager.session disconnect];
    [_DevicesArray removeAllObjects];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)menu:(UIButton *)menu{
    
}
-(void)image:(UIButton*)image{
    
}
- (void)Showkeyboard:(NSNotification *)notification{
    _KeyBoardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if (_TextView.frame.size.height>35.5) {
        [UIView animateWithDuration:duration animations:^{
            _ToolView.frame=CGRectMake(0, _KeyBoardFrame.origin.y-50, Width, 50);
            
            _TextView.frame=CGRectMake(0, _KeyBoardFrame.origin.y-50-(5+_NewHeight), Width, 5+_NewHeight);
            
            _MessageTable.frame=CGRectMake(0,64, Width, _KeyBoardFrame.origin.y-64-50-(5+_NewHeight));
        } completion:^(BOOL finished) {
            if (finished) {
                if (_MessageArray.count>0) {
                    //滚动显示最后一条数据
                    [self ShowFootCell];
                }
            }
        }];
    }else{
        [UIView animateWithDuration:duration animations:^{
            _ToolView.frame=CGRectMake(0, _KeyBoardFrame.origin.y-50, Width, 50);
            
            _TextView.frame=CGRectMake(0, _KeyBoardFrame.origin.y-50-35.5, Width, 35.5);
            
            _MessageTable.frame=CGRectMake(0,64, Width, _KeyBoardFrame.origin.y-64-50-35.5);
        } completion:^(BOOL finished) {
            if (finished) {
                _OldY=_TextView.frame.origin.y;
                if (_MessageArray.count>0) {
                    //滚动显示最后一条数据
                    [self ShowFootCell];
                }
            }
        }];
    }
}
- (void)Hidekeyboard:(NSNotification *)notification{
        float duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if (_TextView.frame.size.height>35.5) {
        [UIView animateWithDuration:duration animations:^{
            _ToolView.frame=CGRectMake(0, Height-50, Width, 50);
            
            _TextView.frame=CGRectMake(0, Height-50-(5+_NewHeight), Width, 5+_NewHeight);
            
            _MessageTable.frame=CGRectMake(0,64, Width, Height-64-50-(5+_NewHeight));
        } completion:^(BOOL finished) {
            if (finished) {
                if (_MessageArray.count>0) {
                    //滚动显示最后一条数据
                    [self ShowFootCell];
                }
            }
        }];
    }else{
        [UIView animateWithDuration:duration animations:^{
            _ToolView.frame=CGRectMake(0, Height-50, Width, 50);
            
            _TextView.frame=CGRectMake(0, Height-50-35.5, Width, 35.5);
            
            _MessageTable.frame=CGRectMake(0,64, Width, Height-64-50-35.5);
        } completion:^(BOOL finished) {
            if (finished) {
                if (_MessageArray.count>0) {
                    //滚动显示最后一条数据
                    [self ShowFootCell];
                }
            }
        }];
    }
}
#pragma mark ##### 代理方法实现 #####
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.MessageArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_MessageArray.count>0) {
        MessageModel *model=[MessageModel messageWithModel:_MessageArray[indexPath.row]];
        return [MessageCell sizeWithString:model.message].height+70;
    }else{
        return 0.01f;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageModel *model=[MessageModel messageWithModel:_MessageArray[indexPath.row]];
    MessageCell *Cell=[MessageCell cellWithTableView:tableView dataWithModel:model];
    return Cell;
}
- (void)textViewDidChange:(UITextView *)textView{
    CGSize newSize = [textView sizeThatFits:CGSizeMake(textView.frame.size.width,MAXFLOAT)];
    
    if((int)newSize.height>=132) {
        _TextView.frame=CGRectMake(0, _OldY-(132-30.5), Width, 5+132);
        _TextView.textView.frame=CGRectMake(10, 5, Width-20, 132);
        _NewHeight=132;
        if ((int)newSize.height>=172) {
                [_TextView.textView setScrollEnabled:YES];
                [_TextView.textView setShowsVerticalScrollIndicator:YES];
        }
    }else{
        _TextView.frame=CGRectMake(0, _OldY-(newSize.height-30.5), Width, 5+newSize.height);
        _TextView.textView.frame=CGRectMake(10, 5, Width-20, newSize.height);
        _NewHeight=newSize.height;
        [_TextView.textView setScrollEnabled:NO];
        [_TextView.textView setShowsVerticalScrollIndicator:NO];
    }
}
#pragma mark ##### 发送数据 #####
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        if (![_TextView.textView.text isEqualToString:@""]) {
            
            NSDictionary *messageData=[[NSDictionary alloc]initWithObjectsAndKeys:_appDelegate.mcManager.peerID.displayName,@"name",_TextView.textView.text,@"message",@"0",@"type", nil];
            [_MessageArray addObject:messageData];
            [_MessageTable reloadData];
            [self ShowFootCell];
            
            NSData *dataToSend = [_TextView.textView.text dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *allPeers = _appDelegate.mcManager.session.connectedPeers;
            NSError *error;
            
            [_appDelegate.mcManager.session sendData:dataToSend
                                             toPeers:allPeers
                                            withMode:MCSessionSendDataReliable
                                               error:&error];
            [_TextView.textView setText:@""];
            _TextView.frame=CGRectMake(0, _KeyBoardFrame.origin.y-50-35.5, Width, 35.5);
            
            _MessageTable.frame=CGRectMake(0,64, Width, _KeyBoardFrame.origin.y-64-50-35.5);
        }
        return NO;
    }
    return YES;
}
#pragma mark ##### 数据接收 #####
-(void)didReceiveDataWithNotification:(NSNotification *)notification{
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
    NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    NSDictionary *messageData=[[NSDictionary alloc]initWithObjectsAndKeys:peerID.displayName,@"name",receivedText,@"message",@"1",@"type", nil];
    [_MessageArray addObject:messageData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_MessageTable reloadData];
        [self ShowFootCell];
    });
}
#pragma mark ##### 拉伸图片 #####
-(UIImage*)imageWithimage:(UIImage*)image{
    image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    return image;
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
