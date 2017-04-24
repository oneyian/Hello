//
//  MessageModel.h
//  IMDemo
//
//  Created by 王毅安 on 17/4/18.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject
/** 头像 */
@property (nonatomic,strong) NSString * image;
/** ID */
@property (nonatomic,strong) NSString * name;
/** 用户类型 */
@property (nonatomic,assign) NSInteger type;
/** 信息 */
@property (nonatomic,strong) NSString * message;

+(instancetype)messageWithModel:(NSDictionary*)data;
@end
