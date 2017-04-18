//
//  HeaderBar.m
//  IMDemo
//
//  Created by 王毅安 on 17/4/18.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import "HeaderBar.h"

@implementation HeaderBar
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        _title=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2-50, 30, 100, 20)];
        _title.font=[UIFont systemFontOfSize:19];
        _title.text=@"Hello World";
        [self addSubview:_title];
        
        _menu=[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-50, 20, 40, 40)];
        [_menu setImage:[UIImage imageNamed:@"ic_menu_normal"] forState:UIControlStateNormal];
        [_menu setImage:[UIImage imageNamed:@"ic_menu_highlighted"] forState:UIControlStateHighlighted];
        [self addSubview:_menu];
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
