//
//  SXD_AddressAction.m
//  SXD_Project
//
//  Created by Bruce Chin on 2017/8/17.
//  Copyright © 2017年 Bruce Chin. All rights reserved.
//

#import "SXD_AddressAction.h"

@interface SXD_AddressAction()

/** 省份*/
@property (nonatomic,strong)NSMutableArray * provincesData;
/**市 */
@property (nonatomic,strong)NSMutableArray * citiesData;

/**区 */
@property (nonatomic,strong)NSMutableArray * areasData;

/** 临时选中市数据*/
@property (nonatomic,strong)NSMutableArray * tempCitiesArray;
/**临时选中区数据*/
@property (nonatomic,strong)NSMutableArray * tempAreasArray;

/** 选中的数据*/
@property (nonatomic,strong)NSMutableArray * selectComponentArray;


@end

@implementation SXD_AddressAction

+ (instancetype)start{
    return [[SXD_AddressAction alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadLocalProvincesData];
        [self loadLocalCitiesData];
        [self loadLocalAreasData];
    }
    return self;
}


/**HDAddress_Provinces.json*/
- (void)loadLocalProvincesData{
    NSArray * Provinces = [self loadLocalJsonParseFromFile:[self getSpecialPathWithSource:@"sxd_Address_Provinces.json"] andType:nil];
    
    for (NSDictionary * province in Provinces) {
        SXD_AddressModel * model = [SXD_AddressModel mj_objectWithKeyValues:province];
        if(model){
            [self.provincesData addObject:model];
        }
    }
}

/**市数据*/
- (void)loadLocalCitiesData{
    NSArray * Provinces = [self loadLocalJsonParseFromFile:[self getSpecialPathWithSource:@"sxd_Address_Cities.json"] andType:nil];
    for (NSDictionary * province in Provinces) {
        SXD_AddressModel * model = [SXD_AddressModel mj_objectWithKeyValues:province];
        if(model){
            [self.citiesData addObject:model];
        }
//        NSLog(@"name:%@",model.name);
    }
}

/**区数据*/
- (void)loadLocalAreasData{
    
    NSArray * Provinces = [self loadLocalJsonParseFromFile:[self getSpecialPathWithSource:@"sxd_Address_Areas.json"] andType:nil];
    for (NSDictionary * province in Provinces) {
        SXD_AddressModel * model = [SXD_AddressModel mj_objectWithKeyValues:province];
        if(model){
            [self.areasData addObject:model];
        }
//        NSLog(@"name:%@",model.name);
    }
}

- (NSString *)getSpecialPathWithSource:(NSString *)source{
    return [NSString stringWithFormat:@"Address.bundle/%@",source];
}


- (id)loadLocalJsonParseFromFile:(NSString*)fileName andType:(NSString*)type{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (data.length == 0) {
        return nil;
    }
    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return object;
}




#pragma mark ---地址信息---


- (NSArray<SXD_AddressModel *> *)getPickerViewComponentDataWithComponent:(NSUInteger)component{
    if(0 == component) return self.provincesData;
    if(1 == component) return self.tempCitiesArray;
    if(2 == component) return self.tempAreasArray;
    return nil;
}


- (SXD_AddressModel *)getPickerViewModelWithComponentIndex:(NSUInteger)component pickerViewRow:(NSUInteger)row{
    if(0 == component){
        if(row<self.provincesData.count) return self.provincesData[row];
        return nil;
    }else if (1 == component){
        if(row>=self.tempCitiesArray.count) return nil;
        return self.tempCitiesArray[row];
    }else{
        if(row>=self.tempAreasArray.count) return nil;
        return self.tempAreasArray[row];
    }
}

- (void)pickerViewDidSelectedComponetIndex:(NSUInteger)component rowIndex:(NSUInteger)row finishBlock:(void(^)(void))finishBlock{
    NSString * tempCode = nil;
    
    if(0 == component){
        if(row>=self.provincesData.count) return;
        [self.selectComponentArray removeAllObjects]; //清空之前的选中数据
        
        //进行市数据筛选
        SXD_AddressModel *model = self.provincesData[row];
        tempCode = [model.code copy];
        [self.selectComponentArray addObject:model];
        
    }else if (1 == component){
        if(row>=self.tempCitiesArray.count) return;
        //进行区数据筛选
        SXD_AddressModel *model = self.tempCitiesArray[row];
        tempCode = [model.code copy];
        
        [self.selectComponentArray removeObjectsInRange:NSMakeRange(1, MAX(0, self.selectComponentArray.count - 1))];
        [self.selectComponentArray addObject:model];
    }
    
    [self refreshSelectDataWithComponent:component parent_code:tempCode];
    
    if(self.tempCitiesArray.count == 1){ //只有一个市的情况，就是几个直辖市，需要直接展示区数据
        SXD_AddressModel * onlyModel= [self.tempCitiesArray firstObject];
        [self refreshSelectDataWithComponent:1 parent_code:onlyModel.code];
    }
    
    if(1 == component){ //默认取区的第一位
        if(self.tempAreasArray.count>0){
            SXD_AddressModel * firstModel= [self.tempAreasArray firstObject];
            if(self.selectComponentArray.count>2){
                [self.selectComponentArray removeLastObject];
            }
            [self.selectComponentArray addObject:firstModel];
        }
        
    }
    
    if(2 == component){
        if(self.selectComponentArray.count>2){
            [self.selectComponentArray removeObjectsInRange:NSMakeRange(2, self.selectComponentArray.count -2)];
        }
        if(row<self.tempAreasArray.count){
            [self.selectComponentArray addObject:self.tempAreasArray[row]];
        }else{
            NSLog(@"row:%ld--->count:%ld,name:%@",row,self.tempAreasArray.count,[[self.tempAreasArray lastObject] name]);
        }
    }
    
    if(finishBlock){
        finishBlock();
    }
}

- (void)refreshSelectDataWithComponent:(NSUInteger)component  parent_code:(NSString *)parent_code{
    
    
    if(parent_code.length == 0) return;
    if(0 == component){
     //进行市数据赛选
        [self.tempCitiesArray removeAllObjects];
        [self.tempAreasArray removeAllObjects];
        
        for (SXD_AddressModel *model in self.citiesData) {
            if([model.parent_code isEqualToString:parent_code]){
                [self.tempCitiesArray addObject:model];
//                NSLog(@"name:%@",model.name);
            }
        }
    }else if (1 == component){
        //进行区数据筛选
        [self.tempAreasArray removeAllObjects];
        
        for (SXD_AddressModel *model in self.areasData) {
            if([model.parent_code isEqualToString:parent_code]){
                [self.tempAreasArray addObject:model];
//                NSLog(@"name:%@",model.name);
            }
        }
        
    }
    
}

/**获取选中的地址*/
- (NSString *)getSelectAddress{
    NSArray * selectData = [self.selectComponentArray valueForKeyPath:@"name"];
    return [selectData componentsJoinedByString:@" "];
    NSLog(@"选中的地址：%@",[selectData componentsJoinedByString:@" "]);
}

#pragma mark ---setter/getter---


- (NSMutableArray *)selectComponentArray{
    if (!_selectComponentArray) {
        _selectComponentArray = [[NSMutableArray alloc] init];
    }
    return _selectComponentArray;
}

- (NSMutableArray *)tempAreasArray{
    if (!_tempAreasArray) {
        _tempAreasArray = [[NSMutableArray alloc] init];
    }
    return _tempAreasArray;
}

- (NSMutableArray *)tempCitiesArray{
    if (!_tempCitiesArray) {
        _tempCitiesArray = [[NSMutableArray alloc] init];
    }
    return _tempCitiesArray;
}


- (NSMutableArray *)provincesData{
    if (!_provincesData) {
        _provincesData = [[NSMutableArray alloc] init];
    }
    return _provincesData;
}

- (NSMutableArray *)citiesData{
    if (!_citiesData) {
        _citiesData = [[NSMutableArray alloc] init];
    }
    return _citiesData;
}

- (NSMutableArray *)areasData{
    if (!_areasData) {
        _areasData = [[NSMutableArray alloc] init];
    }
    return _areasData;
}


@end
