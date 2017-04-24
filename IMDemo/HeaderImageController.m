//
//  HeaderImageController.m
//  IMDemo
//
//  Created by 王毅安 on 17/4/19.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import "HeaderImageController.h"
#import "NavigationBar.h"
#import "ImageItem.h"

#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height
@interface HeaderImageController ()<NavigationBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) NavigationBar * Bar;

@property (nonatomic,strong) UIButton * Header;
@property (nonatomic,strong) UIImageView * BackImage;

@property (nonatomic,copy) NSString * imageName;
@property (nonatomic,copy) NSString * Path;

@property (nonatomic,strong) UICollectionView * ImageCollection;
@property (nonatomic,strong) NSMutableArray * imageArray;

@end

@implementation HeaderImageController
-(NSMutableArray*)imageArray{
    if (!_imageArray) {
        NSString *BundlePath = [[NSBundle mainBundle] pathForResource:@"imageName" ofType:@"plist"];
        _imageArray=[[NSMutableArray alloc]initWithContentsOfFile:BundlePath];
    }
    return _imageArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    NSString *PreferencePath = NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES).firstObject;
    _Path = [PreferencePath stringByAppendingPathComponent:@"header.png"];
    
    [self loadCollectionView];
    [self loadHeaderImage];
    
    _Bar=[[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, Width , 64)];
    _Bar.title.text=@"设置头像";
    [_Bar.title setTextColor:[UIColor whiteColor]];
    _Bar.menu.hidden=YES;
    [_Bar setNavigationBarDalegate:self];
    [self.view addSubview:_Bar];
    // Do any additional setup after loading the view.
}
-(void)loadHeaderImage{
    _BackImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Width, 300)];
    _BackImage.image=[self imageWithimage:[UIImage imageNamed:@"login_btn_blue"]];
    [_BackImage setUserInteractionEnabled:YES];
    [self.view addSubview:_BackImage];
    
    /** 获取头像 */
    _Header=[[UIButton alloc]initWithFrame:CGRectMake((Width-130)/2, 110, 130, 130)];
    [_Header setClipsToBounds:YES];
    [_Header.layer setCornerRadius:65];
    [_Header addTarget:self action:@selector(saveImage:) forControlEvents:UIControlEventTouchUpInside];
    [_Header setBackgroundImage:[self setHeaderImage] forState:UIControlStateNormal];
    [_BackImage addSubview:_Header];
}
-(void)loadCollectionView{
    self.automaticallyAdjustsScrollViewInsets = NO;//关闭布局
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    layout.sectionInset=UIEdgeInsetsMake(25, 25, 25, 25);
    layout.itemSize=CGSizeMake((Width-120)/3, (Width-120)/3);
    
    _ImageCollection=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 300, Width, Height-300) collectionViewLayout:layout];
    
    _ImageCollection.delegate=self;
    _ImageCollection.dataSource=self;
    [_ImageCollection registerNib:[UINib nibWithNibName:@"ImageItem" bundle:nil]forCellWithReuseIdentifier:@"imageItem"];
    _ImageCollection.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_ImageCollection];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat ScrollY = scrollView.contentOffset.y;
    CGFloat MaxY=64;
    // 临界值x，向上拖动时变透明
    if (ScrollY >= 0 && ScrollY <= MaxY) {
        _BackImage.frame=CGRectMake(0, 0, Width, 300-ScrollY);
        CGFloat headerSize=130-ScrollY/2;
        _Header.frame=CGRectMake((Width-headerSize)/2, 110-ScrollY/2,headerSize, headerSize);
        [_Header.layer setCornerRadius:headerSize/2];
        _ImageCollection.frame=CGRectMake(0, 300-ScrollY, Width, Height-300+ScrollY);
    }else if(ScrollY > MaxY){
        _BackImage.frame=CGRectMake(0, 0, Width, 300-MaxY);
        CGFloat headerSize=130-MaxY/2;
        _Header.frame=CGRectMake((Width-headerSize)/2, 110-MaxY/2,headerSize, headerSize);
        [_Header.layer setCornerRadius:headerSize/2];
        _ImageCollection.frame=CGRectMake(0, 300-MaxY, Width, Height-300+MaxY);
    }
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageItem *Item=[collectionView dequeueReusableCellWithReuseIdentifier:@"imageItem" forIndexPath:indexPath];
    [Item setClipsToBounds:YES];
    [Item.layer setCornerRadius:Item.frame.size.width/2];

    Item.image.image=[UIImage imageNamed:_imageArray[indexPath.item]];
    return Item;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _imageName=_imageArray[indexPath.item];
    [_Header setBackgroundImage:[UIImage imageNamed:_imageName] forState:UIControlStateNormal];
}
-(void)saveImage:(UIButton*)saveImage{
    UIAlertController *Save=[UIAlertController alertControllerWithTitle:@"设置头像" message:@"请确定是否设置新头像." preferredStyle:UIAlertControllerStyleAlert];
    [Save addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [Save addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dataWithImage:[UIImage imageNamed:_imageName] filePath:_Path];
    }]];
    [self presentViewController:Save animated:YES completion:nil];
}
-(UIImage*)setHeaderImage{
    NSString *PreferencePath = NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES).firstObject;
    if (![[NSFileManager defaultManager] fileExistsAtPath:PreferencePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:PreferencePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    UIImage *Headerimage=[[UIImage alloc]initWithContentsOfFile:_Path];
    
    if (!Headerimage) {
        Headerimage=[UIImage imageNamed:@"default"];
        [self dataWithImage:Headerimage filePath:_Path];
    }
    return Headerimage;
}
-(void)dataWithImage:(UIImage*)image filePath:(NSString*)path{
        /** image转data存储 */
        NSData *data=[NSData new];
        if (!UIImagePNGRepresentation(image)) {
            data = UIImageJPEGRepresentation(image, 1);
        }
        else {
            data = UIImagePNGRepresentation(image);
        }
        if (data) {
            [data writeToFile:path atomically:YES];
            [[NSUserDefaults standardUserDefaults] setObject:_imageName forKey:@"image"];
        }
}
-(void)back:(UIButton*)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark ##### 拉伸图片 #####
-(UIImage*)imageWithimage:(UIImage*)image{
    image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    return image;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
