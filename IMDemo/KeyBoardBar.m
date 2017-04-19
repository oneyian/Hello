//
//  KeyBoardBar.m
//  IMDemo
//
//  Created by 王毅安 on 17/4/19.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import "KeyBoardBar.h"

@implementation KeyBoardBar

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        _left=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        _centers=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        _right=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"chat_bottom_keyboard_nor"] style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
        
        [self setItems:@[_left,_centers,_right]];
    }
    return self;
}
-(void)done:(UIBarButtonItem*)done{
    if ([_keyboardDelegate respondsToSelector:@selector(done:)]) {
        [_keyboardDelegate done:done];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
