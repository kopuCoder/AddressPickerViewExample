//
//  AddressPch.h
//  AddressPickerView
//
//  Created by Bruce Chin on 2017/8/26.
//  Copyright © 2017年 Bruce Chin. All rights reserved.
//

#ifndef AddressPch_H
#define AddressPch_H
#import "UIColor+Extension.h"
#import "Masonry.h"
#import "MJExtension.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kNavBarH 64

//calculate width/height scale
#define RationW(width) (width)*kWidth/375.0
#define RationH(height) (height)*kHeight/667.0
#define RationWH_equalTo(WH) MIN(RationW(WH), RationH(WH))


//calculate font scale
#define RationFont(size) [UIFont systemFontOfSize:(RationWH_equalTo(size))]


/**quick create color by UIColor+Extension.h*/
#define kHexColor(hexColor,alph) [UIColor colorWithHexString:[NSString stringWithFormat:@"%@",[hexColor hasPrefix:@"#"]?hexColor:[NSString stringWithFormat:@"#%@",hexColor]] alpha:alph]

#define kRGBA(R,G,B,A)	[UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]



#endif
