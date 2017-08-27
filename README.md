# AddressPickerViewExample
* 提供省、市、区三级联动PickerView，实现一行代码快速集成地址选择，对项目零入侵
* 喜欢的话，给颗星吧！
* 缩略图：
* ![Aaron Swartz](https://github.com/kopuCoder/AddressPickerViewExample/blob/master/addressPickerView.gif)

## <a id="user"></a> 集成说明

### 集成说明【暂时只支持手动导入】
- Drag all source files under floder `AddressPickerView` to your project.【将`AddressPickerView`文件夹中的所有源代码拽入项目中】
- Import the main header file：`#import "SXD_AddressPickerView.h"`【导入主头文件：`#import "SXD_AddressPickerView.h"`】

# <a id="Examples"></a> Examples【示例】

### <a id="topCode"></a> 导入`SXD_AddressPickerView.h` 遵守`SXD_AddressPickerViewDelegate`协议

```objc

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
/***********************************************/
```

### <a id="More_use_cases"></a> 依赖说明

- 因项目中涉及到布局以及模型解析，所以需要依赖两个三方库：`Masonry` and `MJExtension`,只要保证项目中有这两个三方库即可(不论你是使用cocoapods集成的还是直接拖拽进入项目的均可)


