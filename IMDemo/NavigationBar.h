//
//  NavigationBar.h
//  IMDemo
//
//  Created by 王毅安 on 17/4/20.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NavigationBarDelegate <NSObject>

@optional
-(void)back:(UIButton*)back;
-(void)menu:(UIButton*)menu;

@end

@interface NavigationBar : UINavigationBar
@property (nonatomic,strong) id<NavigationBarDelegate> navigationBarDalegate;
/** 返回 */
@property (nonatomic,strong) UIButton * back;
/** 标题 */
@property (nonatomic,strong) UILabel * title;
/** 菜单 */
@property (nonatomic,strong) UIButton * menu;
/** 背景图片 */
@property (nonatomic,strong) UIImageView * image;

@end
