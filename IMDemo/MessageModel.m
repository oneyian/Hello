//
//  MessageModel.m
//  IMDemo
//
//  Created by 王毅安 on 17/4/18.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

+(instancetype)messageWithModel:(NSDictionary*)data{
    MessageModel *model=[self new];
    model.name=[data objectForKey:@"name"];
    model.type=[[data objectForKey:@"type"] integerValue];
    model.message=[data objectForKey:@"message"];
    model.image=[data objectForKey:@"image"];
    return model;
}
@end
