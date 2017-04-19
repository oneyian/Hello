//
//  GetNameView.h
//  IMDemo
//
//  Created by 王毅安 on 17/4/19.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyBoardBar.h"

@interface GetNameView : UIView <UITextFieldDelegate,KeyBoardBarDelegate>

@property (nonatomic,strong) KeyBoardBar * ToolBar;
/** 头像 */
@property (nonatomic,strong) UIButton * NameView;
/** 用户ID */
@property (nonatomic,strong) UITextField * NameText;
/** 用户登陆 */
@property (nonatomic,strong) UIButton * GetName;

@end
