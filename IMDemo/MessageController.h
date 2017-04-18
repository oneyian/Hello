//
//  MessageController.h
//  IMDemo
//
//  Created by 王毅安 on 17/4/15.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageController : UIViewController

-(void)didReceiveDataWithNotification:(NSNotification *)notification;
@property (nonatomic,strong) NSMutableArray * DevicesArray;
@end
