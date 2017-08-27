//
//  SXD_AddressModel.h
//  SXD_Project
//
//  Created by Bruce Chin on 2017/8/17.
//  Copyright © 2017年 Bruce Chin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SXD_AddressModel : NSObject

/**"code": "130100",*/
@property (nonatomic,copy)NSString * code;

/**"name": "石家庄市",*/
@property (nonatomic,copy)NSString * name;

/**"parent_code": "130000"*/
@property (nonatomic,copy)NSString * parent_code;

@end
