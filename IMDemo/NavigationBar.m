//
//  NavigationBar.m
//  IMDemo
//
//  Created by 王毅安 on 17/4/20.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import "NavigationBar.h"

@implementation NavigationBar
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self setTranslucent:YES];
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self setShadowImage:[UIImage new]];
        
        _back=[[UIButton alloc]initWithFrame:CGRectMake(5, 20, 40, 40)];
        [_back setImage:[UIImage imageNamed:@"game_out"] forState:UIControlStateNormal];
        [_back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_back];
        
        _title=[[UILabel alloc]initWithFrame:CGRectMake(50, 30, self.frame.size.width-100, 20)];
        _title.font=[UIFont boldSystemFontOfSize:19];
        [_title setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_title];
        
        _menu=[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-50, 20, 40, 40)];
        [_menu setImage:[UIImage imageNamed:@"ic_menu_normal"] forState:UIControlStateNormal];
        [_back addTarget:self action:@selector(menu:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_menu];
    }
    return self;
}
-(void)back:(UIButton*)back{
    [_navigationBarDalegate back:back];
}
-(void)menu:(UIButton*)menu{
    [_navigationBarDalegate back:menu];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
