//
//  HeaderImageController.m
//  IMDemo
//
//  Created by 王毅安 on 17/4/19.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import "HeaderImageController.h"
#import "NavigationBar.h"
#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height
@interface HeaderImageController ()<NavigationBarDelegate>

@property (nonatomic,strong) NavigationBar * Bar;
@property (nonatomic,strong) UIImage * Image;
@property (nonatomic,strong) UIButton * Header;
@property (nonatomic,strong) UIImageView * BackImage;

@end

@implementation HeaderImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
[self loadHeaderImage];
    
    _Bar=[[NavigationBar alloc]initWithFrame:CGRectMake(0, 0,Width , 64)];
    _Bar.title.text=@"设置头像";
    [_Bar.title setTextColor:[UIColor whiteColor]];
    _Bar.menu.hidden=YES;
    [_Bar setNavigationBarDalegate:self];
    [self.view addSubview:_Bar];
    // Do any additional setup after loading the view.
}
-(void)loadHeaderImage{
    _BackImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Width, 250)];
    _BackImage.image=[self imageWithimage:[UIImage imageNamed:@"login_btn_blue"]];
    [self.view addSubview:_BackImage];
    
    _Image=[self setHeaderImage];
    _Header=[[UIButton alloc]initWithFrame:CGRectMake((Width-100)/2, 95, 100, 100)];
    [_Header.layer setCornerRadius:50];
    [_Header addTarget:self action:@selector(saveImage:) forControlEvents:UIControlEventTouchUpInside];
    [_Header setBackgroundImage:_Image forState:UIControlStateNormal];
    [_BackImage addSubview:_Header];
}
-(void)saveImage:(UIButton*)saveImage{
    UIAlertController *Save=[UIAlertController alertControllerWithTitle:@"设置头像" message:@"请确定是否设置新头像." preferredStyle:UIAlertControllerStyleAlert];
    [Save addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [Save addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *PreferencePath = NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES).firstObject;
        NSString *FilePath = [PreferencePath stringByAppendingPathComponent:@"header.png"];
        [self dataWithImage:_Image filePath:FilePath];
    }]];
    [self presentViewController:Save animated:YES completion:nil];
}
-(UIImage*)setHeaderImage{
    NSString *PreferencePath = NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES).firstObject;
    if (![[NSFileManager defaultManager] fileExistsAtPath:PreferencePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:PreferencePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *FilePath = [PreferencePath stringByAppendingPathComponent:@"header.png"];
    UIImage *Headerimage=[[UIImage alloc]initWithContentsOfFile:FilePath];
    
    if (!Headerimage) {
        Headerimage=[UIImage imageNamed:@"default"];
        [self dataWithImage:Headerimage filePath:FilePath];
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
