//
//  Expression.m
//  IMDemo
//
//  Created by 王毅安 on 17/4/24.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import "Expression.h"
#import "ExpItem.h"

#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height

@implementation Expression

-(NSMutableArray*)ExpArray{
    if (!_ExpArray) {
        _ExpArray=[NSMutableArray new];
        for (int i=1; i<=184; i++) {
            if (i<10) {
                [_ExpArray addObject:[NSString stringWithFormat:@"00%d",i]];
            }else if (i<100){
                [_ExpArray addObject:[NSString stringWithFormat:@"0%d",i]];
            }
            else if (i>120 && i<143){ }
            else{
                [_ExpArray addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
    }
    return _ExpArray;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection=UICollectionViewScrollDirectionVertical;
        layout.sectionInset=UIEdgeInsetsMake(20, 20, 20, 20);
        layout.itemSize=CGSizeMake((Width-140)/7, (Width-140)/7);
        
        _ExpCollection=[[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        
        _ExpCollection.delegate=self;
        _ExpCollection.dataSource=self;
        [_ExpCollection registerNib:[UINib nibWithNibName:@"ExpItem" bundle:nil]forCellWithReuseIdentifier:@"expItem"];
        _ExpCollection.backgroundColor=[UIColor whiteColor];
        [self addSubview:_ExpCollection];
    }
    return self;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.ExpArray.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ExpItem *Item=[collectionView dequeueReusableCellWithReuseIdentifier:@"expItem" forIndexPath:indexPath];
    
    Item.image.image=[UIImage imageNamed:_ExpArray[indexPath.item]];
    return Item;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [_expDelegate didSelectExp:_ExpArray[indexPath.item]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
