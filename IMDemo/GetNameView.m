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
        [_NameView setBackgroundImage:[UIImage imageNamed:@"anon_group_loading_fail"] forState:UIControlStateNormal];
        [self addSubview:_NameView];
        
        _NameText=[[UITextField alloc]initWithFrame:CGRectMake(10, 100, self.frame.size.width-20, 40)];
        _NameText.borderStyle = UITextBorderStyleRoundedRect;
        _NameText.font = [UIFont systemFontOfSize:18];
        _NameText.clearButtonMode = UITextFieldViewModeWhileEditing;
        _NameText.placeholder=@"请输入用户名";
        _NameText.text=@"未设置用户名";
        _NameText.textAlignment=NSTextAlignmentCenter;
        _NameText.returnKeyType =UIReturnKeyDone;
        _NameText.delegate=self;
        [self addSubview:_NameText];
        
        _GetName=[[UIButton alloc]initWithFrame:CGRectMake(10, 150, self.frame.size.width-20, 40)];
        [_GetName.layer setCornerRadius:8];
        UIImage *image=[UIImage imageNamed:@"common_big_button_focus_nor_no_change"];
        image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
        [_GetName setBackgroundImage:image forState:UIControlStateNormal];
        [_GetName setTitle:@"确定" forState:UIControlStateNormal];
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
