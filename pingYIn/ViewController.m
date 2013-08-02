//
//  ViewController.m
//  pingYIn
//
//  Created by Robin on 13-8-2.
//  Copyright (c) 2013年 Robin. All rights reserved.
//

#import "ViewController.h"
#import "pinyin.h"
@interface ViewController ()

{
    NSArray *_tableData;
    NSMutableDictionary *dicSort;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTableData];
   // [self test];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [dicSort release];
    [_tableData release];
    [_table release];
    [super dealloc];
}
- (void)initTableData
{
    dicSort = [[NSMutableDictionary alloc] init];
    NSArray *array = [NSArray arrayWithObjects:@"赵",@"钱",@"孙",@"李",@"周",@"吴",@"郑",@"王",@"齐",@"镇",@"韩",@"杨",@"崔", nil];
    // 为每一个字符串添加索引(只取第一个字符)
   [ array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       char index=pinyinFirstLetter([(NSString *)obj characterAtIndex:0]);
       NSString *indexUpper = [[NSString stringWithFormat:@"%c",index] uppercaseString];//转换为大写
      NSMutableArray *tmp =  [dicSort objectForKey:indexUpper];
       if (tmp) {
           [tmp addObject:obj];//添加到对应的字典数组中
       }
       else{
           NSMutableArray *arry = [NSMutableArray arrayWithObjects:obj, nil];//如果该数组还没有创建,先创建
           [dicSort setObject:arry forKey:indexUpper];
       }
       
   }];
    //枚举dic中每一个数组 进行排序后重新赋值
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:dicSort];
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id objArray, BOOL *stop) {
        NSArray *arratInDic = (NSArray *)objArray;
     NSArray  *arrySort =[arratInDic  sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
        {
            int len = [obj1 length] > [obj2 length]?[obj2 length] :[obj1 length] ;//比对长度,按最短的比较
            NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_hans"];//本地化,按照汉字进行排序
            NSComparisonResult ret = [obj1 compare:obj2 options:NSCaseInsensitiveSearch range:NSMakeRange(0, len) locale:local];//对比
            return  ret;
        }];
        [dicSort setObject:arrySort forKey:key];//重新设置该索引对应的数组
    }];
    
    //获取全部key 并进行排序
    NSArray *arryKeys = [dicSort allKeys];
    _tableData = [[arryKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
    }] retain];
    [_table reloadData];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify] autorelease];
        
    }
    NSString *key = [_tableData objectAtIndex:indexPath.section];
    NSString *content = [[dicSort objectForKey:key] objectAtIndex:indexPath.row];
    [cell.textLabel setText:content];
    return cell;
    
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *tmp = [dicSort objectForKey:[_tableData objectAtIndex:section]];
    return [tmp count];
}
- (int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_tableData count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_tableData objectAtIndex:section];
}
@end
