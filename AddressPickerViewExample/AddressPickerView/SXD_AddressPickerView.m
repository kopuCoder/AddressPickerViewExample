//
//  SXD_AddressPickerView.m
//  SXD_Project
//
//  Created by Bruce Chin on 2017/8/17.
//  Copyright © 2017年 Bruce Chin. All rights reserved.
//

#import "SXD_AddressPickerView.h"
#import "SXD_PickerViewCell.h"
#import "SXD_AddressAction.h"

#define kTitleFont kFontDefault(18)
#define KTitleColor [UIColor colorWithHexString:@"#333333"]
#define changeAnimationDuration 0.3
#define perCellH RealValueH(108*0.5)
#define tempSectionHeaderH  RealValueH(5)
#define CoverViewAlphe 0.3 //覆盖层的黑色透明度

#define columnCount 3 //省市区三列
#define kRowH RationH(55) //行高


@interface SXD_AddressBtn :UIButton
@end

@implementation SXD_AddressBtn

/**cancle  highlighted */
- (void)setHighlighted:(BOOL)highlighted{}
@end


@interface SXD_AddressPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,weak)id<SXD_AddressPickerViewDelegate>delegate;

/**  */
@property (nonatomic,weak)UIPickerView *  pickerView;

@property (nonatomic,weak)UIView *  toolBar;
/**  */
@property (nonatomic,weak)UIView *  toolBarTopView;

/**  */
@property (nonatomic,weak)SXD_AddressBtn *  cancleBtn;

@property (nonatomic,weak)SXD_AddressBtn *  confirmBtn;

/** <#property desc#> */
@property (nonatomic,weak)UIView *  bottomContentView;

/**  */
@property (nonatomic,weak)UIView *  windowCoverView;

/**  */
@property (nonatomic,weak)UIView * coverView;

/** <#property desc#> */
@property (nonatomic,weak)UIPickerView *  tempPickerView;

/** <#property desc#>*/
@property (nonatomic,strong)SXD_AddressAction * addressAction;

@end

@implementation SXD_AddressPickerView


#pragma mark ---action---

- (void)show{
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    
    UIView * windowCoverView = [[UIView alloc] initWithFrame:keyWindow.bounds];
    windowCoverView.backgroundColor = [UIColor blackColor];
    windowCoverView.alpha = CoverViewAlphe;
    [keyWindow addSubview:windowCoverView];
    self.windowCoverView = windowCoverView;
    [keyWindow addSubview:self];
    
    [self.pickerView reloadAllComponents];
    [self.pickerView.delegate pickerView:self.pickerView didSelectRow:0 inComponent:0];
    
    [UIView animateWithDuration:changeAnimationDuration animations:^{
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
    }completion:^(BOOL finished) {
        [self.windowCoverView removeFromSuperview];
        self.coverView.hidden =NO;
    }];
    
}
- (void)dismiss{
    
    [UIView animateWithDuration:changeAnimationDuration animations:^{
        self.coverView.hidden =YES;
        
        self.frame = CGRectMake(0, kHeight, kWidth, kHeight);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


/**cancle btn click*/
- (void)toolBarCancleBtnClick{
    [self dismiss];
}


/**confirm btn click*/
- (void)toolBarConfirmBtnClick{
    
    if([self.delegate respondsToSelector:@selector(addressPickerView:didSelectAddressInfo:)]){
        [self.delegate addressPickerView:self didSelectAddressInfo:[self.addressAction getSelectAddress]];
    }
    [self dismiss];
}



#pragma mark ---pickerView delegate---

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    self.tempPickerView = pickerView;
    return columnCount;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    self.tempPickerView = pickerView;
    return [[self.addressAction getPickerViewComponentDataWithComponent:component] count];
}

// returns width of column and height of row for each component.
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    self.tempPickerView = pickerView;
    return (kWidth - 15)/columnCount;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    self.tempPickerView = pickerView;
    return kRowH;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{
    SXD_PickerViewCell * cell = (SXD_PickerViewCell*)view;
    
    if(!cell){
        cell = [SXD_PickerViewCell mainViewWithDelegate:nil];
    }
    SXD_AddressModel * model = [self.addressAction getPickerViewModelWithComponentIndex:component pickerViewRow:row];
    cell.contentInfo = model.name;
    return cell;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    __weak typeof(self)weakSelf = self;
    [self.addressAction pickerViewDidSelectedComponetIndex:component rowIndex:row finishBlock:^{
        if(0 == component){
            [weakSelf.tempPickerView reloadComponent:1];
            [weakSelf.tempPickerView reloadComponent:2];
            
            //自动填充2、3列数据
            [weakSelf.tempPickerView.delegate pickerView:weakSelf.tempPickerView didSelectRow:0 inComponent:1];
            
            [weakSelf.tempPickerView.delegate pickerView:weakSelf.tempPickerView didSelectRow:0 inComponent:2];
            
            //让2、3列数据滚动到顶部
            [weakSelf.tempPickerView selectRow:0 inComponent:1 animated:YES];
            [weakSelf.tempPickerView selectRow:0 inComponent:2 animated:YES];
        }else if (1 == component){
            [weakSelf.tempPickerView reloadComponent:2];
        }
    }];
}


#pragma mark --- create View---

+(instancetype)addressPickerViewWithDelegate:(id<SXD_AddressPickerViewDelegate>)delegate{
    
    SXD_AddressPickerView * cusView = [[SXD_AddressPickerView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    cusView.delegate = delegate;
    return cusView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    self.userInteractionEnabled = YES;
    
    UIView * coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    coverView.userInteractionEnabled =YES;
    UITapGestureRecognizer * dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [coverView addGestureRecognizer:dismissTap];
    coverView.backgroundColor = [UIColor clearColor];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = CoverViewAlphe;
    coverView.hidden =YES;
    [self addSubview:coverView];
    self.coverView = coverView;
    
    
    CGFloat contentH = RationH(530*0.5);
    UIView *  bottomContentView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight - contentH, kWidth, contentH)];
    bottomContentView.userInteractionEnabled = YES;
    [self addSubview:bottomContentView];
    self.bottomContentView = bottomContentView;
    
 
    UIView *  toolBar = [[UIView alloc] init];
    toolBar.backgroundColor = kHexColor(@"dddddd", 1);
    toolBar.userInteractionEnabled = YES;
    [self addSubview:toolBar];
    self.toolBar = toolBar;
    
    UIView *  toolBarTopView = [[UIView alloc] init];
    toolBarTopView.backgroundColor = [UIColor whiteColor];
    toolBarTopView.userInteractionEnabled = YES;
    [toolBar addSubview:toolBarTopView];
    self.toolBarTopView = toolBarTopView;
    
    SXD_AddressBtn * cancleBtn = [self createBtnWithTitle:@"取消" titleFont:RationFont(18) titleColor:kHexColor(@"333333", 1) target:self action:@selector(toolBarCancleBtnClick) contentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [toolBarTopView addSubview:cancleBtn];
    self.cancleBtn = cancleBtn;
    
    SXD_AddressBtn * confirmBtn = [self createBtnWithTitle:@"确定" titleFont:RationFont(18) titleColor:kHexColor(@"333333", 1) target:self action:@selector(toolBarConfirmBtnClick) contentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [toolBarTopView addSubview:confirmBtn];
    self.confirmBtn = confirmBtn;

    
    UIPickerView * pickerView = [[UIPickerView alloc] init];
    pickerView.showsSelectionIndicator = YES;
    [pickerView selectRow:0 inComponent:0 animated:YES];
    pickerView.backgroundColor = kHexColor(@"#F5F8FA", 1);
    pickerView.delegate = self;
    pickerView.dataSource = self;
    
    [self.bottomContentView addSubview:pickerView];
    self.pickerView = pickerView;
    
    [self updateConstraintsIfNeeded];
}

- (SXD_AddressBtn *)createBtnWithTitle:(NSString *)title titleFont:(UIFont *)font titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action contentHorizontalAlignment:(UIControlContentHorizontalAlignment)contentAlign{
    
    SXD_AddressBtn * tmpBtn = [[SXD_AddressBtn alloc] init];
    [tmpBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    tmpBtn.contentHorizontalAlignment = contentAlign;
    tmpBtn.titleLabel.font = font;
    [tmpBtn setTitle:title forState:UIControlStateNormal];
    [tmpBtn setTitleColor:titleColor forState:UIControlStateNormal];
    return tmpBtn;
}

- (void)updateConstraints{
    [super updateConstraints];
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.bottomContentView);
        make.height.mas_equalTo(RationH(55));
    }];
    
    [self.toolBarTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.toolBar);
        make.bottom.mas_equalTo(self.toolBar.mas_bottom).offset(-2);
    }];
    
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.toolBarTopView);
        make.left.mas_equalTo(self.toolBarTopView.mas_left).offset(RationW(16));
        make.width.mas_equalTo(RationW(44));
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.toolBarTopView);
         make.right.mas_equalTo(self.toolBarTopView.mas_right).offset(RationW(-16));
        make.width.mas_equalTo(RationW(44));
    }];
    
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.toolBar.mas_bottom);
        make.left.bottom.right.mas_equalTo(self.bottomContentView);
    }];
}


#pragma mark ---getter---

- (SXD_AddressAction *)addressAction{
    if (!_addressAction) {
        
        _addressAction = [SXD_AddressAction start];
    }
    return _addressAction;
}


@end
