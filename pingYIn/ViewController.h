//
//  ViewController.h
//  pingYIn
//
//  Created by Robin on 13-8-2.
//  Copyright (c) 2013年 Robin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (retain, nonatomic) IBOutlet UITableView *table;

@end
