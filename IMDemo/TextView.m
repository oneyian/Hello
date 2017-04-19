//
//  TextView.m
//  IMDemo
//
//  Created by 王毅安 on 17/4/18.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import "TextView.h"

@implementation TextView
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        _textView=[[UITextView alloc]initWithFrame:CGRectMake(10, 5, self.frame.size.width-20, 30.5)];
        _textView.textContainerInset = UIEdgeInsetsMake(5,5, 5, 5);
        [_textView setShowsVerticalScrollIndicator:NO];
        [_textView setScrollEnabled:NO];
        [_textView setFont:[UIFont systemFontOfSize:17]];
        [_textView.layer setCornerRadius:5];
        [_textView setReturnKeyType:UIReturnKeySend];
        [_textView setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:_textView];
        
        //键盘工具条
        _ToolBar=[[KeyBoardBar alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 35)];
        [_ToolBar setKeyboardDelegate:self];
        [_textView setInputAccessoryView:_ToolBar];
    }
    return self;
}
-(void)done:(UIBarButtonItem*)done{
    [_textView resignFirstResponder];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
