//
//  PopDevicesController.m
//  IMDemo
//
//  Created by 王毅安 on 17/4/27.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import "PopDevicesController.h"
#import "DevicesCell.h"
#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height

@interface PopDevicesController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * DeviceTable;
@end

@implementation PopDevicesController

- (void)viewDidLoad {
    [super viewDidLoad];
    _DeviceTable=[[UITableView alloc]initWithFrame:self.view.bounds];
    _DeviceTable.delegate=self;
    _DeviceTable.dataSource=self;
    [self.view addSubview:_DeviceTable];
    // Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _DevicesArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_DevicesArray.count>0) {
        return [DevicesCell SizeWithString:_DevicesArray[indexPath.row]].height+20;
    }else{
        return 0.01f;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DevicesCell *Cell=[DevicesCell cellWithTableView:tableView dataWithString:_DevicesArray[indexPath.row]];
    return Cell;
}
-(CGSize)preferredContentSize{
    if (self.popoverPresentationController != nil) {
        CGSize size =CGSizeMake(150, 300);
        size = [_DeviceTable sizeThatFits:size];  //返回一个完美适应tableView的大小的 size
        return size;
    }else{
        return [super preferredContentSize];
    }
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
