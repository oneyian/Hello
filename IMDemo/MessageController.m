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

@interface MessageController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property (nonatomic, strong) AppDelegate *appDelegate;

@property (nonatomic,strong) UITableView * MessageTable;
@property (nonatomic,strong) NSMutableArray * MessageArray;
@property (nonatomic,strong) UIView * ToolView;
@property (nonatomic,strong) UIView * TextView;
@property (nonatomic,strong) UITextView * MessageText;
@property BOOL isN;
@property (nonatomic,assign) CGFloat OldY;
@property (nonatomic,assign) CGFloat NewHeight;
@property (nonatomic,assign) CGRect KeyBoardFrame;
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
    
    _MessageTable=[[UITableView alloc]initWithFrame:CGRectMake(0,64, Width, Height-64-85.5) style:UITableViewStylePlain];
    [_MessageTable setBackgroundColor:self.view.backgroundColor];
    _MessageTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    _MessageTable.showsVerticalScrollIndicator = NO;
    [_MessageTable setDelegate:self];
    [_MessageTable setDataSource:self];
    [self.view addSubview:_MessageTable];
    
    _TextView=[[UIView alloc]initWithFrame:CGRectMake(0, Height-85.5, Width, 5+30.5)];
    [_TextView setBackgroundColor:self.view.backgroundColor];
    [self.view addSubview:_TextView];
    
    _MessageText=[[UITextView alloc]initWithFrame:CGRectMake(10, 5, Width-20, 30.5)];
    _MessageText.textContainerInset = UIEdgeInsetsMake(5,5, 5, 5);
    [_MessageText setShowsVerticalScrollIndicator:NO];
    [_MessageText setScrollEnabled:NO];
    [_MessageText setFont:[UIFont systemFontOfSize:17]];
    [_MessageText.layer setCornerRadius:5];
    [_MessageText setReturnKeyType:UIReturnKeySend];
    [_MessageText setTextAlignment:NSTextAlignmentLeft];
    _MessageText.delegate=self;
    [_TextView addSubview:_MessageText];
    
    _ToolView=[[UIView alloc]initWithFrame:CGRectMake(0, Height-50, Width, 50)];
    [_ToolView setBackgroundColor:self.view.backgroundColor];
    [self.view addSubview:_ToolView];
    
    UIButton *addFile=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
    [addFile addTarget:self action:@selector(addfile:) forControlEvents:UIControlEventTouchUpInside];
    [addFile setImage:[UIImage imageNamed:@"ic_addfile"] forState:UIControlStateNormal];
    [_ToolView addSubview:addFile];
    
    //键盘工具条
    UIToolbar *Tool=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, Width, 35)];
    Tool.barStyle=UIBarStyleDefault;
    UIBarButtonItem *bt1=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *bt2=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *done=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
    done.tintColor=[UIColor brownColor];
    NSArray *Darray=@[bt1,bt2,done];
    [Tool setItems:Darray];
    [_MessageText setInputAccessoryView:Tool];
    
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
-(void)done:(UIBarButtonItem*)sender{
    [_MessageText resignFirstResponder];
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
            [Cell setBackgroundColor:self.view.backgroundColor];
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
- (void)textViewDidChange:(UITextView *)textView{
    CGSize newSize = [textView sizeThatFits:CGSizeMake(textView.frame.size.width,MAXFLOAT)];
    
    if((int)newSize.height>=132) {
        _TextView.frame=CGRectMake(0, _OldY-(132-30.5), Width, 5+132);
        _MessageText.frame=CGRectMake(10, 5, Width-20, 132);
        _NewHeight=132;
        if ((int)newSize.height>=172) {
                [_MessageText setScrollEnabled:YES];
                [_MessageText setShowsVerticalScrollIndicator:YES];
        }
    }else{
        _TextView.frame=CGRectMake(0, _OldY-(newSize.height-30.5), Width, 5+newSize.height);
        _MessageText.frame=CGRectMake(10, 5, Width-20, newSize.height);
        _NewHeight=newSize.height;
        [_MessageText setScrollEnabled:NO];
        [_MessageText setShowsVerticalScrollIndicator:NO];
    }
}
#pragma mark ##### 发送数据 #####
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        if (![_MessageText.text isEqualToString:@""]) {
            NSDictionary *messageData=[[NSDictionary alloc]initWithObjectsAndKeys:_MessageText.text,@"message",@"0",@"type", nil];
            [_MessageArray addObject:messageData];
            [_MessageTable reloadData];
            [self ShowFootCell];
            
            NSData *dataToSend = [_MessageText.text dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *allPeers = _appDelegate.mcManager.session.connectedPeers;
            NSError *error;
            
            [_appDelegate.mcManager.session sendData:dataToSend
                                             toPeers:allPeers
                                            withMode:MCSessionSendDataReliable
                                               error:&error];
            [_MessageText setText:@""];
            _TextView.frame=CGRectMake(0, _KeyBoardFrame.origin.y-50-35.5, Width, 35.5);
            
            _MessageTable.frame=CGRectMake(0,64, Width, _KeyBoardFrame.origin.y-64-50-35.5);
        }
        return NO;
    }
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_MessageText resignFirstResponder];
    
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
