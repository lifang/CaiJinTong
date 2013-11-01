//
//  LessonViewController.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-10-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LessonViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *lessonTable;
@property (nonatomic, strong) NSDictionary *lessonDictionary;
@property (nonatomic, strong) NSMutableArray *lessonList;
@property (nonatomic, strong) NSMutableArray *arrSelSection;
@property (nonatomic, assign) NSInteger tmpSection;
@end
