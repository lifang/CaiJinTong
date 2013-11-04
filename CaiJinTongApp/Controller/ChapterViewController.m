//
//  ChapterViewController.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-4.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "ChapterViewController.h"
#import "SectionModel.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "AMProgressView.h"

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
	
}
-(void)drnavigationBarRightItemClicked:(id)sender{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftRight];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.chapterArray.count>0) {
        DLog(@"count = %d",self.chapterArray.count);
        [self displayNewView];
    }
}
#pragma -- 页面布局

-(void)displayNewView {
    [self.myScrollView removeFromSuperview];
    if (self.chapterArray.count>0) {
        DLog(@"width = %f",self.view.frame.size.width);
        UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 44)];
        topView.backgroundColor = [UIColor redColor];
        [self.view addSubview:topView];
        
        NSInteger count = ([self.chapterArray count]-1)/6+1;
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
    NSInteger count = ([self.chapterArray count]-1)/6+1;
    
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
    int number = [self.chapterArray count]-6*category;
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
    
    SectionModel *section = (SectionModel *)[self.chapterArray objectAtIndex:currentTag];
    DLog(@"name = %@",section.sectionName);
    //自定义view
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(ItemWidthSpace+(ItemWidthSpace+ItemWidth)*col, ItemHeightSpace, ItemWidth, ItemHeight)];
    //视频名称
    UIFont *font = [UIFont systemFontOfSize:14];
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ItemWidth, ItemLabel)];
    nameLab.text = [NSString stringWithFormat:@"%@",section.sectionName];
    nameLab.textColor = [UIColor blackColor];
    nameLab.numberOfLines = 0;
    nameLab.textAlignment = NSTextAlignmentLeft;
    nameLab.backgroundColor = [UIColor clearColor];
    nameLab.font = font;
    [myView addSubview:nameLab];
    //视频封面
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, ItemLabel, ItemWidth, ItemWidth)];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",section.sectionImg]];
    [imageView setImageWithURL:url placeholderImage:Image(@"loginBgImage_v.png")];
    
    imageView.tag = [section.sectionId intValue];
    [myView addSubview:imageView];
    
    UIButton  *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageBtn.frame = imageView.frame;
    imageBtn.tag = imageView.tag;
    [imageBtn addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:imageBtn];
    //视频进度
    AMProgressView *pv = [[AMProgressView alloc] initWithFrame:CGRectMake(0, ItemHeight-ItemLabel, ItemWidth, ItemLabel)
                                              andGradientColors:nil
                                               andOutsideBorder:YES
                                                    andVertical:NO];
    pv.progress = [section.sectionProgress floatValue];
    float pgress = [section.sectionProgress floatValue]*100;
    pv.text = [NSString stringWithFormat:@"学习进度:%.f%%",pgress];
    [myView addSubview:pv];

    [cell.contentView addSubview:myView];
}
-(void)imageButtonClick:(id)sender {
    UIButton *button = sender;
    DLog(@"imageTag = %d",button.tag);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
