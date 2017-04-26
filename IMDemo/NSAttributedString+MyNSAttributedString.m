//
//  NSAttributedString+MyNSAttributedString.m
//  IMDemo
//
//  Created by 王毅安 on 17/4/25.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import "NSAttributedString+MyNSAttributedString.h"
#import "MyNSText.h"

@implementation NSAttributedString (MyNSAttributedString)
- (NSString *)getPlainString {
    
    //最终纯文本
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    
    //替换下标的偏移量
    __block NSUInteger base = 0;
    
    //遍历
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if (value && [value isKindOfClass:[MyNSText class]]) {
            //替换
            [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                       withString:((MyNSText *) value).ExpString];
            
            //增加偏移量
            base += ((MyNSText *) value).ExpString.length - 1;
        }
    }];
    return plainString;
}

@end
