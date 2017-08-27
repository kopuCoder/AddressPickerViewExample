//
//  SXD_AddressModel.m
//  SXD_Project
//
//  Created by Bruce Chin on 2017/8/17.
//  Copyright © 2017年 Bruce Chin. All rights reserved.
//

#import "SXD_AddressModel.h"

@implementation SXD_AddressModel

- (void)setParent_code:(NSString *)parent_code{
    _parent_code = [NSString stringWithFormat:@"%@",parent_code];
}
@end
