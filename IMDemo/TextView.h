//
//  TextView.h
//  IMDemo
//
//  Created by 王毅安 on 17/4/18.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyBoardBar.h"

@interface TextView : UIView <KeyBoardBarDelegate>

/** 聊天信息框 */
@property (nonatomic,strong) UITextView * textView;

@property (nonatomic,strong) KeyBoardBar * ToolBar;

@end
