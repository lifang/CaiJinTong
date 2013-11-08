//
//  MyQuestionAndAnswerViewController.m
//  CaiJinTongApp
//
//  Created by david on 13-11-7.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "MyQuestionAndAnswerViewController.h"

@interface MyQuestionAndAnswerViewController ()
@property (nonatomic,strong) NSMutableDictionary *myAnswerDic;
@property (nonatomic,strong) NSMutableDictionary *myQuestionDic;
@end

@implementation MyQuestionAndAnswerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)drnavigationBarRightItemClicked:(id)sender{
    // [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftRight];
    //    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    //    [app.popupedController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftRight];
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftRight];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark QuestionAndAnswerCellDelegate
-(void)questionAndAnswerCell:(QuestionAndAnswerCell *)cell flowerAnswerAtIndexPath:(NSIndexPath *)path{

}

-(void)questionAndAnswerCell:(QuestionAndAnswerCell *)cell summitQuestion:(NSString *)questionStr atIndexPath:(NSIndexPath *)path{

}

-(void)questionAndAnswerCell:(QuestionAndAnswerCell *)cell isHiddleQuestionView:(BOOL)isHiddle atIndexPath:(NSIndexPath *)path{

}

#pragma mark --

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark --

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    
    return view;
}

#pragma mark --
@end
