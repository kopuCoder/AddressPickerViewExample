//
//  UIColor+Extension.h
//  templateProject
//
//  Created by Bruce Chin on 2017/8/7.
//  Copyright © 2017年 Bruce Chin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor(Extension)
/**使用十六进制转颜色*/
+ (UIColor *) colorWithHexString: (NSString *)color;

/**使用十六进制转颜色*/
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

+ (UIColor *)colorFromHexValue:(NSInteger)hex;
+ (UIColor *)fromHexValue:(NSUInteger)hex alpha:(CGFloat)alpha;

@end
