//
//  MyNSText.m
//  IMDemo
//
//  Created by 王毅安 on 17/4/25.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import "MyNSText.h"

@implementation MyNSText

- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex
{
    return CGRectMake(0, 0, lineFrag.size.height, lineFrag.size.height);
}
@end
