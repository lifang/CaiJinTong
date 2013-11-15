//
//  LessonViewController.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-10-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LessonListHeaderView.h"
@interface LessonViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,LessonListHeaderViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UIImageView *searchBarView;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIView *lessonListBackgroundView;

@property (weak, nonatomic) IBOutlet UIView *leftBackGroundview;
@property (weak, nonatomic) IBOutlet UIButton *lessonListBt;
@property (weak, nonatomic) IBOutlet UIButton *questionListBt;
@property (weak, nonatomic) IBOutlet UILabel *lessonListTitleLabel;
//@property (weak, nonatomic) IBOutlet UISearchBar *searchBarView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)lessonListBtClicked:(id)sender;
- (IBAction)questionListBtClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *LogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *rightNameLabel;
@property (nonatomic, strong) NSDictionary *lessonDictionary;
@property (nonatomic, strong) NSMutableArray *lessonList;
@property (nonatomic, strong) NSMutableArray *arrSelSection;
@property (nonatomic, assign) NSInteger tmpSection;

@property (nonatomic, strong) NSDictionary *questionDictionary;
@property (nonatomic, strong) NSMutableArray *questionList;
@property (nonatomic, strong) NSMutableArray *questionArrSelSection;
@property (nonatomic, assign) NSInteger questionTmpSection;
@end
