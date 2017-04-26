//
//  Expression.h
//  IMDemo
//
//  Created by 王毅安 on 17/4/24.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ExpDelegate <NSObject>

-(void)didSelectExp:(NSString*)exp;

@end


@interface Expression : UIView <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)id<ExpDelegate> expDelegate;
@property (nonatomic,strong) UICollectionView * ExpCollection;
@property (nonatomic,strong) NSMutableArray * ExpArray;

@end
