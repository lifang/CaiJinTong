//
//  ChapterViewController.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-4.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "ChapterViewController.h"
#import "SectionModel.h"


#define ItemWidth 250
#define ItemWidthSpace 23
#define ItemHeight 280
#define ItemHeightSpace 19
#define ItemLabel 30
@interface ChapterViewController () 
@end

@implementation ChapterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CJTMainToolbar *mainBar = [[CJTMainToolbar alloc]initWithFrame:CGRectMake (0, 44, self.view.frame.size.width, 44)];
	self.mainToolBar = mainBar;
    self.mainToolBar.delegate = self;
    [self.view addSubview:self.mainToolBar];
    mainBar = nil;
}
-(void)drnavigationBarRightItemClicked:(id)sender{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftRight];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.recentArray.count>0) {
        self.dataArray = [NSMutableArray arrayWithArray:self.recentArray];
        [self displayNewView];
    }
}
#pragma -- 页面布局

-(void)displayNewView {
    [self.myScrollView removeFromSuperview];
    if (self.dataArray.count>0) {
        NSInteger count = ([self.dataArray count]-1)/6+1;
        self.myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 88, self.view.frame.size.width, self.view.frame.size.height-20)];
        
        self.myScrollView.delegate = self;
        self.myScrollView.contentSize = CGSizeMake(self.myScrollView.frame.size.width, self.myScrollView.frame.size.height*count);
        [self.myScrollView setPagingEnabled:YES];
        self.myScrollView.showsVerticalScrollIndicator = NO;
        self.myScrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:self.myScrollView];
        
        for (int i=0; i<count; i++) {
            self.myTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0+self.myScrollView.frame.size.height*i, self.myScrollView.frame.size.width, self.myScrollView.frame.size.height)];
            self.myTable.tag = i;
            self.myTable.delegate = self;
            self.myTable.dataSource = self;
            self.myTable.scrollEnabled = NO;
            self.myTable.backgroundColor = [UIColor clearColor];
            [self.myScrollView addSubview:self.myTable];
        }
        CGRect frame = [self.view bounds];
        frame.origin.y = 0;
        frame.origin.x = 0;
        [self.myScrollView setContentOffset:CGPointMake(frame.origin.x, frame.origin.y)];
    }
}

#pragma -- UIScrollViewDelegate
//控制滑动的时候分页按钮对应去显示
-(void)scrollViewDidScroll:(UIScrollView *)sender
{
}
#pragma -- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger count = ([self.dataArray count]-1)/6+1;
    
    static NSString *CellIdentifier = @"Cell";
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for (int i = 0; i<count; i++) {
            if (tableView.tag==i) {
                [self drawTableViewCell:cell index:[indexPath row] category:i];
            }
        }
	}
    
    return cell;
}
//绘制tableview的cell
-(void)drawTableViewCell:(UITableViewCell *)cell index:(int)row category:(int)category{
    int maxIndex = (row*2+3);
    int number = [self.dataArray count]-6*category;
	if(maxIndex < number) {
		for (int i=0; i<2; i++) {
			[self displayPhotoes:cell row:row col:i category:category];
		}
		return;
	}
	else if(maxIndex-1 < number) {
		for (int i=0; i<1; i++) {
			[self displayPhotoes:cell row:row col:i category:category];
		}
		return;
	}
	else if(maxIndex-2 < number) {
		for (int i=0; i<2; i++) {
			[self displayPhotoes:cell row:row col:i category:category];
		}
		return;
	}
	else if(maxIndex-3 < number) {
		[self displayPhotoes:cell row:row col:0 category:category];
		return;
	}
}
-(void)displayPhotoes:(UITableViewCell *)cell row:(int)row col:(int)col category:(int)category
{
    NSInteger currentTag = 2*row+col+category*6;
    
    SectionModel *section = (SectionModel *)[self.dataArray objectAtIndex:currentTag];
    //自定义view
    SectionCustomView *sv = [[SectionCustomView alloc]initWithFrame:CGRectMake(ItemWidthSpace+(ItemWidthSpace+ItemWidth)*col, ItemHeightSpace, ItemWidth, ItemHeight) andSection:section];
    self.sectionView = sv;

    [self.sectionView addTarget:self  action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:self.sectionView];
    sv = nil;
}
-(void)imageButtonClick:(id)sender {
    UIControl *button = sender;
    DLog(@"imageTag = %d",button.tag);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//学习进度
- (void)bubbleSort:(NSMutableArray *)array {
    int i, y;
    BOOL bFinish = YES;
    for (i = 1; i<= [array count] && bFinish; i++) {
        bFinish = NO;
        for (y = (int)[array count]-1; y>=i; y--) {
            SectionModel *section1 = (SectionModel *)[array objectAtIndex:y];
            SectionModel *section2 = (SectionModel *)[array objectAtIndex:y-1];
            if (([section1.sectionProgress floatValue] - [section2.sectionProgress floatValue])<0.000001) {
                [array exchangeObjectAtIndex:y-1 withObjectAtIndex:y];
                bFinish = YES;
            }
        }
    }
}
//名称

#pragma -- CJTMainToolbarDelegate
- (void)tappedInToolbar:(CJTMainToolbar *)toolbar recentButton:(UIButton *)button {
    
}
- (void)tappedInToolbar:(CJTMainToolbar *)toolbar progressButton:(UIButton *)button {
    [self bubbleSort:self.dataArray];
    for (int i=0; i<self.dataArray.count; i++) {
        SectionModel *section = (SectionModel *)[self.dataArray objectAtIndex:i];
//        DLog(@"%@",section.sectionProgress);
    }
    self.progressArray = [NSArray arrayWithArray:self.dataArray];
    self.dataArray = nil;
    self.dataArray = [NSMutableArray arrayWithArray:self.progressArray];
    [self displayNewView];
}
- (void)tappedInToolbar:(CJTMainToolbar *)toolbar nameButton:(UIButton *)button {
    
}

@end
