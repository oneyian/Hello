//
//  PromptView.h
//  IMDemo
//
//  Created by 王毅安 on 17/4/19.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromptView : UIView

/** 提示气泡 */
@property (nonatomic,strong) UIImageView * messageView;
/** 提示 */
@property (nonatomic,strong) UILabel * message;
/** 提示按钮 */
@property (nonatomic,strong) UIButton * messagePrompt;

+(CGSize)sizeWithString:(NSString*)string;
-(UIImage*)imageWithimage:(UIImage*)image;
@end
