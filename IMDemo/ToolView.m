//
//  ToolView.m
//  IMDemo
//
//  Created by 王毅安 on 17/4/18.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import "ToolView.h"

@implementation ToolView
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        _image=[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width/2-17.5, 7.5, 35, 35)];
        [_image setImage:[UIImage imageNamed:@"chat_bottom_photo_nor"] forState:UIControlStateNormal];
        [_image setImage:[UIImage imageNamed:@"chat_bottom_photo_press"] forState:UIControlStateHighlighted];
        [self addSubview:_image];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
