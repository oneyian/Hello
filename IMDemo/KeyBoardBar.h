//
//  KeyBoardBar.h
//  IMDemo
//
//  Created by 王毅安 on 17/4/19.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeyBoardBarDelegate <NSObject>

-(void)done:(UIBarButtonItem*)done;

@end

@interface KeyBoardBar : UIToolbar

@property (nonatomic,strong)id<KeyBoardBarDelegate> keyboardDelegate;
/** 左边 */
@property (nonatomic,strong) UIBarButtonItem * left;
/** 中间 */
@property (nonatomic,strong) UIBarButtonItem * centers;
/** 右边 */
@property (nonatomic,strong) UIBarButtonItem * right;

@end
