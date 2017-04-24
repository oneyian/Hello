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
        _image=[[UIButton alloc]initWithFrame:CGRectMake(10, 7.5, 35, 35)];
        [_image setImage:[UIImage imageNamed:@"chat_bottom_photo_nor"] forState:UIControlStateNormal];
        [_image setImage:[UIImage imageNamed:@"chat_bottom_photo_press"] forState:UIControlStateHighlighted];
        [self addSubview:_image];
        
        _camera=[[UIButton alloc]initWithFrame:CGRectMake((self.frame.size.width-160)/3+45, 7.5, 35, 35)];
        [_camera setImage:[UIImage imageNamed:@"chat_bottom_Camera_nor"] forState:UIControlStateNormal];
        [_camera setImage:[UIImage imageNamed:@"chat_bottom_Camera_press"] forState:UIControlStateHighlighted];
        [self addSubview:_camera];
        
        _files=[[UIButton alloc]initWithFrame:CGRectMake((self.frame.size.width-160)/3*2+80, 7.5, 35, 35)];
        [_files setImage:[UIImage imageNamed:@"chat_bottom_file_nor"] forState:UIControlStateNormal];
        [_files setImage:[UIImage imageNamed:@"chat_bottom_file_pressed"] forState:UIControlStateHighlighted];
        [self addSubview:_files];
        
        _expression=[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-45, 7.5, 35, 35)];
        [_expression setImage:[UIImage imageNamed:@"chat_bottom_emotion_nor"] forState:UIControlStateNormal];
        [_expression setImage:[UIImage imageNamed:@"chat_bottom_emotion_press"] forState:UIControlStateHighlighted];
        [self addSubview:_expression];
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
