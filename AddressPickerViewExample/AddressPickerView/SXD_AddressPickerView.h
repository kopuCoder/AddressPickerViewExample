//
//  SXD_AddressPickerView.h
//  SXD_Project
//
//  Created by Bruce Chin on 2017/8/17.
//  Copyright © 2017年 Bruce Chin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@class SXD_AddressPickerView;

@protocol SXD_AddressPickerViewDelegate<NSObject>

@optional

- (void)addressPickerView:(SXD_AddressPickerView *)addressPickerView didSelectAddressInfo:(NSString *)selectedAddress;

@end

@interface SXD_AddressPickerView : UIView

+ (instancetype)addressPickerViewWithDelegate:(id<SXD_AddressPickerViewDelegate>)delegate;

- (void)show;
- (void)dismiss;
@end
