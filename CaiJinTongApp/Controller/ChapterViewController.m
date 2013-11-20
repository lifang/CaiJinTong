//
//  ChapterViewController.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-4.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "ChapterViewController.h"
#import "SectionModel.h"
#import "ChineseString.h"
#import "pinyin.h"
#import "NoteModel.h"
#import "CommentModel.h"
#import "SectionViewController.h"

#define ItemWidth 250
#define ItemWidthSpace 23
#define ItemHeight 215
#define ItemHeightSpace 4
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
    CJTMainToolbar *mainBar = [[CJTMainToolbar alloc]initWithFrame:CGRectMake (50, 64, 468, 44)];
	self.mainToolBar = mainBar;
    self.mainToolBar.delegate = self;
    [self.view addSubview:self.mainToolBar];
    [self.mainToolBar setHidden:self.isSearch];
    mainBar = nil;
    
    self.searchBar = [[ChapterSearchBar alloc] initWithFrame:(CGRect){50, 64, (self.view.frame.size.width - 200 - 100), 74}];
    [self.view addSubview:self.searchBar];

    [self.searchBar setHidden:!self.isSearch];
    self.mainToolBar.backgroundColor = [UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:232.0/255.0 alpha:1.0];
    
    [self.searchBar.searchBt addTarget:self action:@selector(searchBtClicked) forControlEvents:UIControlEventTouchUpInside];
}


-(void)reloadDataWithDataArray:(NSArray*)data{
    self.recentArray = data;
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
        if (self.isSearch) {
            self.myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 148, self.view.frame.size.width, self.view.frame.size.height-50)];
        }else {
            self.myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 118, self.view.frame.size.width, self.view.frame.size.height-20)];
        }
        
        self.myScrollView.delegate = self;
        self.myScrollView.contentSize = CGSizeMake(self.myScrollView.frame.size.width, self.myScrollView.frame.size.height*count);
        [self.myScrollView setPagingEnabled:YES];
        self.myScrollView.showsVerticalScrollIndicator = NO;
        self.myScrollView.showsHorizontalScrollIndicator = NO;
        self.myScrollView.backgroundColor = [UIColor orangeColor];
        [self.view addSubview:self.myScrollView];
        
        for (int i=0; i<count; i++) {
            self.myTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0+self.myScrollView.frame.size.height*i, self.myScrollView.frame.size.width, self.myScrollView.frame.size.height)];
            self.myTable.tag = i;
            self.myTable.delegate = self;
            self.myTable.dataSource = self;
            self.myTable.scrollEnabled = NO;
            self.myTable.backgroundColor = [UIColor redColor];
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

#pragma mark -- UITableViewDelegate
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
    NSInteger count = ([self.dataArray count]-1)/6+1;//页数
    
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
    SectionCustomView *sv = [[SectionCustomView alloc]initWithFrame:CGRectMake(ItemWidthSpace+(ItemWidthSpace+ItemWidth)*col, ItemHeightSpace, ItemWidth, ItemHeight) andSection:section andItemLabel:ItemLabel];
    self.sectionView = sv;

    [self.sectionView addTarget:self  action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:self.sectionView];
    sv = nil;
}
-(void)imageButtonClick:(id)sender {
    UIControl *button = sender;
    DLog(@"imageTag = %d",button.tag);
    /*
    //根据sectionID获取单个视频的详细信息
    if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
        [Utility errorAlert:@"暂无网络!"];
    }else {
        [SVProgressHUD showWithStatus:@"玩命加载中..."];
        SectionInfoInterface *sectionInter = [[SectionInfoInterface alloc]init];
        self.sectionInterface = sectionInter;
        self.sectionInterface.delegate = self;
        [self.sectionInterface getSectionInfoInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andSectionId:[NSString stringWithFormat:@"%d",button.tag]];
    }
     */
    //数据来源
    NSDictionary *dictionary = [Utility initWithJSONFile:@"sectionInfo"];
    NSDictionary *dic = [dictionary objectForKey:@"ReturnObject"];
    if (dic.count>0) {
        SectionModel *section = [[SectionModel alloc]init];
        section.sectionId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sectionId"]];
        section.sectionName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sectionName"]];
        section.sectionImg = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sectionImg"]];
        section.sectionProgress = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sectionProgress"]];
        section.sectionSD = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sectionSD"]];
        section.sectionHD = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sectionHD"]];
        section.sectionScore = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sectionScore"]];
        section.isGrade = [NSString stringWithFormat:@"%@",[dic objectForKey:@"isGrade"]];
        section.lessonInfo = [NSString stringWithFormat:@"%@",[dic objectForKey:@"lessonInfo"]];
        section.sectionTeacher = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sectionTeacher"]];
        section.sectionDownload = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sectionDownload"]];
        section.sectionStudy = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sectionStudy"]];
        section.sectionLastTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sectionLastTime"]];
        //笔记
        NSArray *noteList = [NSArray arrayWithArray:[dic objectForKey:@"noteList"]];
        if (noteList.count>0) {
            NSMutableArray *note_tempArray = [[NSMutableArray alloc]init];
            for (int i=0; i<noteList.count; i++) {
                NSDictionary *dic = [noteList objectAtIndex:i];
                NoteModel *note = [[NoteModel alloc]init];
                note.noteText = [NSString stringWithFormat:@"%@",[dic objectForKey:@"noteText"]];
                note.noteTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"noteTime"]];
                [note_tempArray addObject:note];
            }
            if (note_tempArray.count>0) {
                section.noteList = [NSMutableArray arrayWithArray:note_tempArray];
            }
        }
        //评论
        NSArray *commentList = [NSArray arrayWithArray:[dic objectForKey:@"commentList"]];
        if (commentList.count>0) {
            NSMutableArray *comment_tempArray = [[NSMutableArray alloc]init];
            for (int i=0; i<commentList.count; i++) {
                NSDictionary *dic = [commentList objectAtIndex:i];
                CommentModel *comment = [[CommentModel alloc]init];
                comment.nickName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"nickName"]];
                comment.time = [NSString stringWithFormat:@"%@",[dic objectForKey:@"time"]];
                comment.content = [NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]];
                comment.pageIndex = [[dic objectForKey:@"pageIndex"]intValue];
                comment.pageCount = [[dic objectForKey:@"pageCount"]intValue];
                [comment_tempArray addObject:comment];
            }
            if (comment_tempArray.count>0) {
                section.commentList = [NSMutableArray arrayWithArray:comment_tempArray];
            }
        }
        //章节目录
        NSArray *sectionList = [NSArray arrayWithArray:[dic objectForKey:@"sectionList"]];
        if (sectionList.count>0) {
            NSMutableArray *section_tempArray = [[NSMutableArray alloc]init];
            for (int i=0; i<sectionList.count; i++) {
                NSDictionary *dic = [sectionList objectAtIndex:i];
                SectionModel *section = [[SectionModel alloc]init];
                section.sectionId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sectionId"]];
                section.sectionName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sectionName"]];
                section.sectionDownload = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sectionDownload"]];
                section.sectionLastTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sectionLastTime"]];
                [section_tempArray addObject:section];
            }
            if (section_tempArray.count>0) {
                section.sectionList = [NSMutableArray arrayWithArray:section_tempArray];
            }
        }
        //
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        SectionViewController *sectionView = [story instantiateViewControllerWithIdentifier:@"SectionViewController"];

        sectionView.section = section;
        sectionView.title = section.sectionName;
        [self.navigationController pushViewController:sectionView animated:YES];

        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-- 筛选
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
//按字母排序
-(void)letterSort:(NSMutableArray *)array {
    NSMutableArray *tempArray = array;
    self.dataArray = nil;
    self.dataArray = [[NSMutableArray alloc]init];
    NSMutableArray *chineseStringsArray=[NSMutableArray array];
    for(int i=0;i<[array count];i++){
        ChineseString *chineseString=[[ChineseString alloc]init];
        
        SectionModel *section = (SectionModel *)[array objectAtIndex:i];
        chineseString.string=[NSString stringWithString:section.sectionName];
        
        if(chineseString.string==nil){
            chineseString.string=@"";
        }
        
        if(![chineseString.string isEqualToString:@""]){
            NSString *pinYinResult=[NSString string];
            
            NSString *regexCall = @"[\u4E00-\u9FFF]+$";
            NSPredicate *predicateCall = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexCall];
            //是汉字
            if ([predicateCall evaluateWithObject:[chineseString.string substringToIndex:1]]) {
                for(int j=0;j<chineseString.string.length;j++){
                    NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                    
                    pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
                }
            }else {//非汉字
                pinYinResult = [pinYinResult stringByAppendingString:[[chineseString.string substringToIndex:1]uppercaseString]];
            }
            chineseString.pinYin=pinYinResult;
        }else{
            chineseString.pinYin=@"";
        }
        [chineseStringsArray addObject:chineseString];
    }

    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    NSMutableArray *result=[NSMutableArray array];
    for(int i=0;i<[chineseStringsArray count];i++){
        [result addObject:((ChineseString*)[chineseStringsArray objectAtIndex:i]).string];
    }
    for(int i=0;i<[result count];i++){
        NSString *string = [result objectAtIndex:i];
        for (int k=0; k<tempArray.count; k++) {
            SectionModel *section = (SectionModel *)[array objectAtIndex:k];
            if ([string isEqualToString:section.sectionName]) {
                [self.dataArray addObject:section];
            }
        }
    }
}
#pragma mark -- CJTMainToolbarDelegate
//按学习进度排序
-(void)initButton:(UIButton *)button {
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSArray *subViews = [self.mainToolBar subviews];
    if (subViews.count>0) {
        for (UIView *vv in subViews) {
            if ([vv isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)vv;
                if (![btn isEqual:button]) {
                    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                }
            }
        }
    }
}

//默认(最近播放)
- (void)tappedInToolbar:(CJTMainToolbar *)toolbar recentButton:(UIButton *)button {
    [self initButton:button];
    self.dataArray = nil;
    self.dataArray = [NSMutableArray arrayWithArray:self.recentArray];
    [self displayNewView];
}
//学习进度
- (void)tappedInToolbar:(CJTMainToolbar *)toolbar progressButton:(UIButton *)button {
    if (self.progressArray.count >0) {
        [self initButton:button];
        self.dataArray = [NSMutableArray arrayWithArray:self.progressArray];
        [self displayNewView];
    }else {
        if (self.dataArray.count>0) {
            [self bubbleSort:self.dataArray];
            [self initButton:button];
            self.progressArray = [NSArray arrayWithArray:self.dataArray];
            [self displayNewView];
        }
    }
}
//名称(A-Z)
- (void)tappedInToolbar:(CJTMainToolbar *)toolbar nameButton:(UIButton *)button {
    if (self.nameArray.count>0) {
        [self initButton:button];
        self.dataArray = [NSMutableArray arrayWithArray:self.nameArray];
        [self displayNewView];
    }else {
        if (self.dataArray.count>0) {
            [self letterSort:self.dataArray];
            [self initButton:button];
            self.nameArray = [NSArray arrayWithArray:self.dataArray];
            [self displayNewView];
        }
    }
}

#pragma mark -- SectionInfoInterface
-(void)getSectionInfoDidFinished:(SectionModel *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SVProgressHUD dismissWithSuccess:@"获取数据成功!"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
}
-(void)getSectionInfoDidFailed:(NSString *)errorMsg {
    [SVProgressHUD dismiss];
    [Utility errorAlert:errorMsg];
}


#pragma mark property
-(void)setIsSearch:(BOOL)isSearch{
    _isSearch = isSearch;
    [self.searchBar setHidden:!isSearch];
    [self.mainToolBar setHidden:isSearch];
    
    UIBarButtonItem *tempBarButtonItem = (UIBarButtonItem *)self.navigationItem.backBarButtonItem;
    tempBarButtonItem.target = self;

    if(self.isSearch){
        tempBarButtonItem.title = @"搜索";
    }else{
        tempBarButtonItem.title = @"返回";
    }
}
#pragma mark -- search methods
-(void)searchBtClicked{
    DLog(@"搜索按钮按下!");
    if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
        [Utility errorAlert:@"暂无网络!"];
    }else {
        [SVProgressHUD showWithStatus:@"玩命加载中..."];
        ChapterInfoInterface *chapterInter = [[ChapterInfoInterface alloc]init];
        self.chapterInfoInterface = chapterInter;
        self.chapterInfoInterface.delegate = self;
        [self.chapterInfoInterface getChapterInfoInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andChapterId:nil];
    }

}

#pragma mark -- ChapterInfoInterfaceDelegate

-(void)getChapterInfoDidFinished:(NSDictionary *)result {  //章节信息查询完毕,显示章节界面
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SVProgressHUD dismissWithSuccess:@"获取数据成功!"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![[result objectForKey:@"sectionList"]isKindOfClass:[NSNull class]] && [result objectForKey:@"sectionList"]!=nil) {
                NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:[result objectForKey:@"sectionList"]];
                if(self.searchBar.searchTextField.text != nil && ![self.searchBar.searchTextField.text isEqualToString:@""] && tempArray.count > 0){
                    NSString *keyword = self.searchBar.searchTextField.text;
                    NSMutableArray *ary = [NSMutableArray arrayWithCapacity:5];
                    for(int i = 0 ; i < tempArray.count ; i++){
                        SectionModel *section = [tempArray objectAtIndex:i];
                        NSLog(@"sectionName: %@",section.sectionName);
                        NSRange range = [section.sectionName rangeOfString:[NSString stringWithFormat:@"(%@)+",keyword] options:NSRegularExpressionSearch];
                        if(range.location != NSNotFound){
                            [ary addObject:section];
                        }
                    }
                    tempArray = [NSMutableArray arrayWithArray:ary];
                }
//                self.dataArray = [[NSMutableArray alloc]initWithArray:tempArray];
                [self reloadDataWithDataArray:tempArray];
            }
        });
    });
}
-(void)getChapterInfoDidFailed:(NSString *)errorMsg {
    [SVProgressHUD dismiss];
    [Utility errorAlert:errorMsg];
}

@end
