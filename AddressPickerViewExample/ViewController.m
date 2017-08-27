//
//  ViewController.m
//  AddressPickerViewExample
//
//  Created by Bruce Chin on 2017/8/27.
//  Copyright © 2017年 Bruce Chin. All rights reserved.
//

#import "ViewController.h"

#import "SXD_AddressPickerView.h"

@interface ViewController ()<SXD_AddressPickerViewDelegate>
    
@property (weak, nonatomic) IBOutlet UILabel *detailAddressLable;

@end

@implementation ViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
    
    
#pragma mark ---SXD_AddressPickerView Delegate---
- (void)addressPickerView:(SXD_AddressPickerView *)addressPickerView didSelectAddressInfo:(NSString *)selectedAddress{
    
    self.detailAddressLable.text = selectedAddress;
}
    
    
    /**点击选取地址*/
- (IBAction)selectAddressBtnClick:(UIButton *)sender {
    
    [[SXD_AddressPickerView addressPickerViewWithDelegate:self] show];
}


@end
