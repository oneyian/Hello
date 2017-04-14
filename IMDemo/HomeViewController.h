//
//  ViewController.h
//  IMDemo
//
//  Created by 王毅安 on 17/4/14.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface HomeViewController : UIViewController <MCBrowserViewControllerDelegate>

-(void)peerDidChangeStateWithNotification:(NSNotification *)notification;
-(void)didReceiveDataWithNotification:(NSNotification *)notification;
@end

