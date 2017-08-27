//
//  SXD_PickerViewCell.h
//  SXD_Project
//
//  Created by Bruce Chin on 2017/8/17.
//  Copyright © 2017年 Bruce Chin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AddressPch.h"

@protocol SXD_PickerViewCellDelegate <NSObject>


@end


@interface SXD_PickerViewCell : UIView

+(instancetype)mainViewWithDelegate:(id<SXD_PickerViewCellDelegate>)delegate;

- (void)isSelectPickerViewCell:(BOOL)isSelect;

/**<#desc#>*/
@property (nonatomic,copy)NSString * contentInfo;

- (void)changeSeperatorWithComponent:(NSUInteger)component row:(NSUInteger)row;

@end
