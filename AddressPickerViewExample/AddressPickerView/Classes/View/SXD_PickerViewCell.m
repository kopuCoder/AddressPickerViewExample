//
//  SXD_PickerViewCell.m
//  SXD_Project
//
//  Created by Bruce Chin on 2017/8/17.
//  Copyright © 2017年 Bruce Chin. All rights reserved.
//

#define kDefaultColor kHexColor(@"dddddd", 1)
#define kSelectColor kHexColor(@"d3d3d3", 1)

#import "SXD_PickerViewCell.h"

@interface SXD_PickerViewCell()
/**  */
@property (nonatomic,weak)UILabel *  pickerContentLable;

/**  */
@property (nonatomic,weak)UIView *  pickerTopSeperator;
@property (nonatomic,weak)UIView *  pickerBottomSeperator;

@end

@implementation SXD_PickerViewCell
+(instancetype)mainViewWithDelegate:(id<SXD_PickerViewCellDelegate>)delegate{
    
    SXD_PickerViewCell * cell = [[SXD_PickerViewCell alloc] init];
    return cell;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubViews];
    }
    return self;
}
- (void)setupSubViews{
    
    UILabel * contentLalbe = [[UILabel alloc] init];
    contentLalbe.font = RationFont(18);
    contentLalbe.textColor = kHexColor(@"333333", 1);
    contentLalbe.textAlignment = NSTextAlignmentCenter;
    [self addSubview:contentLalbe];
    self.pickerContentLable = contentLalbe;
    
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints{
    [super updateConstraints];
    [self.pickerContentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
    }];
}

- (void)changeSeperatorWithComponent:(NSUInteger)component row:(NSUInteger)row{
    if(row == 0){
        self.pickerBottomSeperator.hidden = NO;
        self.pickerTopSeperator.hidden = NO;
    }else{
        self.pickerBottomSeperator.hidden = NO;
        self.pickerTopSeperator.hidden = YES;
    }
}

- (void)isSelectPickerViewCell:(BOOL)isSelect{
    if(isSelect){
        self.pickerTopSeperator.backgroundColor = kSelectColor;
        self.pickerBottomSeperator.backgroundColor = kSelectColor;
    }else{
        self.pickerTopSeperator.backgroundColor = kDefaultColor;
        self.pickerBottomSeperator.backgroundColor = kDefaultColor;
    }
}

- (void)setContentInfo:(NSString *)contentInfo{
    _contentInfo = contentInfo;
    self.pickerContentLable.text = contentInfo;
}


@end
