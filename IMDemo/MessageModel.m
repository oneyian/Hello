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
    model.dataType=[data objectForKey:@"datatype"];
    model.name=[data objectForKey:@"name"];
    model.type=[[data objectForKey:@"type"] integerValue];
    model.image=[data objectForKey:@"image"];
    if ([model.dataType isEqualToString:@"text"]) {
        model.message=[data objectForKey:@"message"];
        model.imageData=nil;
    }else{
        model.imageData=[data objectForKey:@"message"];
        model.message=@"";
    }

    
    return model;
}
@end
