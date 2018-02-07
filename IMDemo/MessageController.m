//
//  MessageController.m
//  IMDemo
//
//  Created by 王毅安 on 17/4/15.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import "MessageController.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AppDelegate.h"
#import "MessageCell.h"
#import "MessageModel.h"
#import "TextView.h"
#import "ToolView.h"
#import "NavigationBar.h"
#import "Expression.h"
#import "MyNSText.h"
#import "NSAttributedString+MyNSAttributedString.h"
#import "Utility.h"
#import "PopDevicesController.h"
#import "ImageViewController.h"


#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height

@interface MessageController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,NavigationBarDelegate,ExpDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverPresentationControllerDelegate>

@property (nonatomic,strong) AppDelegate *appDelegate;

@property (nonatomic,strong) UITableView * MessageTable;
@property (nonatomic,strong) NSMutableArray * MessageArray;

@property (nonatomic,assign) CGFloat OldY;
@property (nonatomic,assign) CGFloat NewHeight;
@property (nonatomic,assign) CGRect KeyBoardFrame;

@property (nonatomic,strong) NavigationBar * HeaderBar;
@property (nonatomic,strong) TextView * TextView;
@property (nonatomic,strong) ToolView * ToolView;
@property (nonatomic,strong) Expression * ExpresView;
@property (nonatomic,strong) UIActivityIndicatorView * Activity;
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
    [self loadActivity];
}
#pragma mark ##### UI界面 #####
-(void)loadActivity{
    _Activity=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    _Activity.center=self.view.center;
    [_Activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_Activity setBackgroundColor:[UIColor lightGrayColor]];
    [_Activity.layer setCornerRadius:10];
    [self.view addSubview:_Activity];
}
-(void)CreatUIView{
    self.automaticallyAdjustsScrollViewInsets = NO;//关闭布局
    
    _HeaderBar=[[NavigationBar alloc]initWithFrame:CGRectMake(0, 0,Width , 64)];
    _HeaderBar.image.image = [UIImage imageNamed:@"headerBackImage"];
    [_HeaderBar.menu setImage:[UIImage imageNamed:@"mulchat_header_icon_group"] forState:UIControlStateNormal];
    [_HeaderBar.menu setFrame:CGRectMake(Width-40, 25, 30, 30)];
    [_HeaderBar.menu addTarget:self action:@selector(menu:) forControlEvents:UIControlEventTouchUpInside];
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
    [_ToolView.camera addTarget:self action:@selector(camera:) forControlEvents:UIControlEventTouchUpInside];
    [_ToolView.expression addTarget:self action:@selector(expression:) forControlEvents:UIControlEventTouchUpInside];
    [_ToolView.files addTarget:self action:@selector(files:) forControlEvents:UIControlEventTouchUpInside];
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
    PopDevicesController *PopDevices=[PopDevicesController new];
    [PopDevices setDevicesArray:_DevicesArray];
    PopDevices.modalPresentationStyle = UIModalPresentationPopover;
    PopDevices.popoverPresentationController.sourceView=menu;
    PopDevices.popoverPresentationController.sourceRect=menu.bounds;
    PopDevices.popoverPresentationController.backgroundColor=[UIColor whiteColor];
    PopDevices.preferredContentSize = CGSizeMake(150, 300);
    PopDevices.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    PopDevices.popoverPresentationController.delegate = self;
    [self presentViewController:PopDevices animated:YES completion:nil];
}
-(void)image:(UIButton*)image{
    UIImagePickerController *imagePc=[UIImagePickerController new];
    imagePc.delegate= self;
    [self presentViewController:imagePc animated:YES completion:nil];
}
-(void)camera:(UIButton*)camera{
    UIImagePickerController *imagePc=[UIImagePickerController new];
    imagePc.sourceType=UIImagePickerControllerSourceTypeCamera;
    imagePc.delegate= self;
    [self presentViewController:imagePc animated:YES completion:nil];
}
-(void)expression:(UIButton*)expression{
    [_TextView.textView resignFirstResponder];
    expression.selected=!expression.selected;
    if (expression.selected) {
        _ExpresView=[[Expression alloc]initWithFrame:CGRectMake(0, Height-240, Width, 240)];
        _ExpresView.expDelegate=self;
        [self.view addSubview:_ExpresView];
        if (_TextView.frame.size.height>35.5) {
            _ToolView.frame=CGRectMake(0, Height-290, Width, 50);
            _TextView.frame=CGRectMake(0, Height-290-(5+_NewHeight), Width, 5+_NewHeight);
            _MessageTable.frame=CGRectMake(0,64, Width, Height-64-290-(5+_NewHeight));
            if (_MessageArray.count>0) {[self ShowFootCell];}
        }else{
            _ToolView.frame=CGRectMake(0, Height-290, Width, 50);
            _TextView.frame=CGRectMake(0, Height-290-35.5, Width, 35.5);
            _MessageTable.frame=CGRectMake(0,64, Width, Height-64-290-35.5);
            if (_MessageArray.count>0) {[self ShowFootCell];}
        }
    }
    else{
        [_ExpresView removeFromSuperview];
        if (_TextView.frame.size.height>35.5) {
            _ToolView.frame=CGRectMake(0, Height-50, Width, 50);
            _TextView.frame=CGRectMake(0, Height-50-(5+_NewHeight), Width, 5+_NewHeight);
            _MessageTable.frame=CGRectMake(0,64, Width, Height-64-50-(5+_NewHeight));
            if (_MessageArray.count>0) {[self ShowFootCell];}
        }else{
            _ToolView.frame=CGRectMake(0, Height-50, Width, 50);
            _TextView.frame=CGRectMake(0, Height-50-35.5, Width, 35.5);
            _MessageTable.frame=CGRectMake(0,64, Width, Height-64-50-35.5);
            if (_MessageArray.count>0) {[self ShowFootCell];}
        }
    }
}
-(void)files:(UIButton*)files{
    UIAlertController *Alter=[UIAlertController alertControllerWithTitle:@"分享文件" message:@"您的手机需要越狱才可以进行分享文件." preferredStyle:UIAlertControllerStyleAlert];
    [Alter addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
    [self presentViewController:Alter animated:YES completion:nil];
}
-(void)Showkeyboard:(NSNotification *)notification{
    [_ExpresView removeFromSuperview];
    [_ToolView.expression setSelected:NO];
    _KeyBoardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if (_TextView.frame.size.height>35.5) {
        [UIView animateWithDuration:duration animations:^{
            _ToolView.frame=CGRectMake(0, _KeyBoardFrame.origin.y-50, Width, 50);
            _TextView.frame=CGRectMake(0, _KeyBoardFrame.origin.y-50-(5+_NewHeight), Width, 5+_NewHeight);
            _MessageTable.frame=CGRectMake(0,64, Width, _KeyBoardFrame.origin.y-64-50-(5+_NewHeight));
        } completion:^(BOOL finished) {
            if (finished) {
                if (_MessageArray.count>0) {[self ShowFootCell];}
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
                if (_MessageArray.count>0) {[self ShowFootCell];}
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
                if (_MessageArray.count>0) {[self ShowFootCell];}
            }
        }];
    }else{
        [UIView animateWithDuration:duration animations:^{
            _ToolView.frame=CGRectMake(0, Height-50, Width, 50);
            _TextView.frame=CGRectMake(0, Height-50-35.5, Width, 35.5);
            _MessageTable.frame=CGRectMake(0,64, Width, Height-64-50-35.5);
        } completion:^(BOOL finished) {
            if (finished) {
                if (_MessageArray.count>0) {[self ShowFootCell];}
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
        if ([model.dataType isEqualToString:@"text"]) {
                    return [MessageCell sizeLabelToFit:[Utility emotionStrWithString:model.message]].height+70;
        }else{
            return 120;
        }
    }else{
        return 0.01f;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageModel *model=[MessageModel messageWithModel:_MessageArray[indexPath.row]];
    MessageCell *Cell=[MessageCell cellWithTableView:tableView dataWithModel:model];
    return Cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageModel *model=[MessageModel messageWithModel:_MessageArray[indexPath.row]];
    if (![model.dataType isEqualToString:@"text"]) {
        ImageViewController *Image=[ImageViewController new];
        [Image setImageData:model.imageData];
        Image.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:Image animated:YES completion:nil];
    }
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
-(void)didSelectExp:(NSString *)exp{
    MyNSText *Exp=[MyNSText new];
    Exp.ExpString=[NSString stringWithFormat:@"[%@]",exp];
    Exp.image = [UIImage imageNamed:exp];

    [_TextView.textView.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:Exp] atIndex:_TextView.textView.selectedRange.location];
    [_TextView.textView setFont:[UIFont systemFontOfSize:17]];
    [_TextView.textView setSelectedRange:NSMakeRange(_TextView.textView.selectedRange.location+1,0)];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self dismissViewControllerAnimated:YES completion:^{
        
        UIImage *image=info[UIImagePickerControllerOriginalImage];
        NSData *imageData=[NSData new];
        if (!UIImagePNGRepresentation(image)) {
            imageData = UIImageJPEGRepresentation(image, 1);
        }
        else {
            imageData = UIImagePNGRepresentation(image);
        }
        if (imageData) {
            [_Activity startAnimating];
            __block NSString *imageStr=[NSString new];
            NSBlockOperation *oper=[NSBlockOperation blockOperationWithBlock:^{
                imageStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            }];
            NSBlockOperation *oper1=[NSBlockOperation blockOperationWithBlock:^{
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    NSDictionary *messageData=[[NSDictionary alloc]initWithObjectsAndKeys: _appDelegate.mcManager.peerID.displayName,@"name",
                                               imageData,@"message",
                                               @"0",@"type",
                                               @"image",@"datatype",
                                               [[NSUserDefaults standardUserDefaults] objectForKey:@"image"],@"image",
                                               nil];
                    
                    [_MessageArray addObject:messageData];
                    /** 插入新数据 */
                    [_MessageTable insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_MessageArray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    [self ShowFootCell];
                    [_Activity stopAnimating];
                    
                    NSMutableDictionary *dataDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:imageStr,@"message",[[NSUserDefaults standardUserDefaults] objectForKey:@"image"],@"image",@"image",@"datatype", nil];
                    
                    NSData *dataToSend = [NSKeyedArchiver archivedDataWithRootObject:dataDict];
                    
                    NSArray *allPeers = _appDelegate.mcManager.session.connectedPeers;
                    NSError *error;
                    
                    [_appDelegate.mcManager.session sendData:dataToSend
                                                     toPeers:allPeers
                                                    withMode:MCSessionSendDataReliable
                                                       error:&error];
                }];
            }];
            [oper1 addDependency:oper];
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            [queue addOperations:@[oper, oper1] waitUntilFinished:NO];
        }
    }];
}
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}
#pragma mark ##### 发送数据 #####
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        if (![_TextView.textView.text isEqualToString:@""]) {
            NSString *message=[_TextView.textView.textStorage getPlainString];
            NSDictionary *messageData=[[NSDictionary alloc]initWithObjectsAndKeys:
                                       _appDelegate.mcManager.peerID.displayName,@"name",
                                       message,@"message",
                                       @"0",@"type",
                                       @"text",@"datatype",
                                       [[NSUserDefaults standardUserDefaults] objectForKey:@"image"],@"image",
                                       nil];
            
            [_MessageArray addObject:messageData];
            /** 插入新数据 */
            [_MessageTable insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_MessageArray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self ShowFootCell];
            
            NSMutableDictionary *dataDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:message,@"message",[[NSUserDefaults standardUserDefaults] objectForKey:@"image"],@"image",@"text",@"datatype", nil];
            
            NSData *dataToSend = [NSKeyedArchiver archivedDataWithRootObject:dataDict];

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
-(void)sendEmoji{
        if (![_TextView.textView.text isEqualToString:@""]) {
            NSString *message=[_TextView.textView.textStorage getPlainString];
            NSDictionary *messageData=[[NSDictionary alloc]initWithObjectsAndKeys:
                                       _appDelegate.mcManager.peerID.displayName,@"name",
                                       message,@"message",
                                       @"0",@"type",
                                       @"text",@"datatype",
                                       [[NSUserDefaults standardUserDefaults] objectForKey:@"image"],@"image",
                                       nil];
            
            [_MessageArray addObject:messageData];
            /** 插入新数据 */
            [_MessageTable insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_MessageArray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self ShowFootCell];
            
            NSMutableDictionary *dataDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:message,@"message",[[NSUserDefaults standardUserDefaults] objectForKey:@"image"],@"image",@"text",@"datatype", nil];
            
            NSData *dataToSend = [NSKeyedArchiver archivedDataWithRootObject:dataDict];

            NSArray *allPeers = _appDelegate.mcManager.session.connectedPeers;
            NSError *error;
            
            [_appDelegate.mcManager.session sendData:dataToSend
                                             toPeers:allPeers
                                            withMode:MCSessionSendDataReliable
                                               error:&error];
            [_TextView.textView setText:@""];
            
            _ToolView.frame=CGRectMake(0, Height-290, Width, 50);
            _TextView.frame=CGRectMake(0, Height-290-35.5, Width, 35.5);
            _MessageTable.frame=CGRectMake(0,64, Width, Height-64-290-35.5);
            if (_MessageArray.count>0) {[self ShowFootCell];}
        }
}
#pragma mark ##### 数据接收 #####
-(void)didReceiveDataWithNotification:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_Activity startAnimating];
    });
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSData *Data = [[notification userInfo] objectForKey:@"data"];
    
    NSMutableDictionary *dataDict=[NSKeyedUnarchiver unarchiveObjectWithData:Data];
    
    if ([[dataDict objectForKey:@"datatype"]isEqualToString:@"text"]) {
        NSDictionary *messageData=[[NSDictionary alloc]initWithObjectsAndKeys:
                                   peerID.displayName,@"name",
                                   [dataDict objectForKey:@"message"],@"message",
                                   @"1",@"type",
                                   [dataDict objectForKey:@"image"],@"image",[dataDict objectForKey:@"datatype"],@"datatype",
                                   nil];
        
        [_MessageArray addObject:messageData];
    }else{
        NSData *data=[[NSData alloc]initWithBase64EncodedString:[dataDict objectForKey:@"message"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        NSDictionary *messageData=[[NSDictionary alloc]initWithObjectsAndKeys:
                                   peerID.displayName,@"name",
                                   data,@"message",
                                   @"1",@"type",
                                   [dataDict objectForKey:@"image"],@"image",[dataDict objectForKey:@"datatype"],@"datatype",
                                   nil];
        [_MessageArray addObject:messageData];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_Activity stopAnimating];
        /** 插入新数据 */
        [_MessageTable insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_MessageArray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
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
