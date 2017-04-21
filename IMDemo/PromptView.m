//
//  PromptView.m
//  IMDemo
//
//  Created by 王毅安 on 17/4/19.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import "PromptView.h"
#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height

@implementation PromptView
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];

    _messagePrompt=[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-40, 32, 26, 21)];
    [_messagePrompt setImage:[UIImage imageNamed:@"device_msg_aio"] forState:UIControlStateNormal];
    [self addSubview:_messagePrompt];
    
    _messageView=[UIImageView new];
    _messageView.image=[self imageWithimage:[UIImage imageNamed:@"chat_send_dim"]];
    [self addSubview:_messageView];
    
    _message=[UILabel new];
    _message.font=[UIFont systemFontOfSize:17];
    _message.numberOfLines=0;
    [_message setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:_message];
    
    return self;
}
#pragma mark ##### 计算Size #####
+(CGSize)sizeWithString:(NSString*)string{
    CGSize size = [string boundingRectWithSize:CGSizeMake(Width-100, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil].size;
    return size;
}
#pragma mark ##### 图片拉伸 #####
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
