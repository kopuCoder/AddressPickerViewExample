//
//  SXD_AddressAction.h
//  SXD_Project
//
//  Created by Bruce Chin on 2017/8/17.
//  Copyright © 2017年 Bruce Chin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressPch.h"
#import "SXD_AddressModel.h"

@interface SXD_AddressAction : NSObject

+ (instancetype)start;

#pragma mark ---地址选择--
- (NSArray<SXD_AddressModel *> *)getPickerViewComponentDataWithComponent:(NSUInteger)component;

- (SXD_AddressModel *)getPickerViewModelWithComponentIndex:(NSUInteger)component pickerViewRow:(NSUInteger)row;


- (void)pickerViewDidSelectedComponetIndex:(NSUInteger)conponent rowIndex:(NSUInteger)row finishBlock:(void(^)(void))finishBlock;

/**获取选中的地址*/
- (NSString *)getSelectAddress;

@end
