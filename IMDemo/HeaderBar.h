//
//  HeaderBar.h
//  IMDemo
//
//  Created by 王毅安 on 17/4/18.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderBar : UINavigationBar
/** 标题 */
@property (nonatomic,strong) UILabel * title;
/** 菜单 */
@property (nonatomic,strong) UIButton * menu;
@end
