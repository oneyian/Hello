//
//  GetNameView.m
//  IMDemo
//
//  Created by 王毅安 on 17/4/19.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import "GetNameView.h"

@implementation GetNameView 

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        _NameView=[[UIButton alloc]initWithFrame:CGRectMake((self.frame.size.width-80)/2, 0, 80, 80)];
        [_NameView.layer setCornerRadius:40];
        [_NameView setClipsToBounds:YES];
        [_NameView setBackgroundImage:[self setHeaderImage] forState:UIControlStateNormal];
        [self addSubview:_NameView];
        
        _NameText=[[UITextField alloc]initWithFrame:CGRectMake(15, 95, self.frame.size.width-30, 45)];
        _NameText.font = [UIFont systemFontOfSize:17];
        _NameText.clearButtonMode = UITextFieldViewModeWhileEditing;
        _NameText.placeholder=@"请输入用户名";
        _NameText.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        _NameText.textAlignment=NSTextAlignmentCenter;
        _NameText.returnKeyType =UIReturnKeyDone;
        _NameText.delegate=self;
        [self addSubview:_NameText];
        
        _GetName=[[UIButton alloc]initWithFrame:CGRectMake(15, 150, self.frame.size.width-30, 40)];
        [_GetName.layer setCornerRadius:5];
        [_GetName setClipsToBounds:YES];
        [_GetName setBackgroundImage:[self imageWithimage:[UIImage imageNamed:@"login_btn_blue"]] forState:UIControlStateNormal];
        [_GetName setTitle:@"登陆" forState:UIControlStateNormal];
        [self addSubview:_GetName];
        
        //键盘工具条
        _ToolBar=[[KeyBoardBar alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 35)];
        [_ToolBar setKeyboardDelegate:self];
        [_NameText setInputAccessoryView:_ToolBar];
    }
    return self;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_NameText resignFirstResponder];
    return YES;
}
-(void)done:(UIBarButtonItem *)done{
    [_NameText resignFirstResponder];
}
-(UIImage*)setHeaderImage{
    NSString *PreferencePath = NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES).firstObject;

    if (![[NSFileManager defaultManager] fileExistsAtPath:PreferencePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:PreferencePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *FilePath = [PreferencePath stringByAppendingPathComponent:@"header.png"];
    
    UIImage *Headerimage=[[UIImage alloc]initWithContentsOfFile:FilePath];
    
    if (!Headerimage) {
        Headerimage=[UIImage imageNamed:@"default"];
        [[NSUserDefaults standardUserDefaults] setObject:@"default" forKey:@"image"];
        /** image转data */
        NSData *data=[NSData new];
        if (!UIImagePNGRepresentation(Headerimage)) {
            data = UIImageJPEGRepresentation(Headerimage, 1);
        }
        else {
            data = UIImagePNGRepresentation(Headerimage);
        }
        if (data) {
            [data writeToFile:FilePath atomically:YES];
        }
    }
    return Headerimage;
}
#pragma mark ##### 拉伸图片 #####
-(UIImage*)imageWithimage:(UIImage*)image{
    image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    return image;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@end
