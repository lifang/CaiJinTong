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
#import "Section.h"
#define ItemWidth 250
#define ItemWidthSpace 23
#define ItemHeight 215
#define ItemHeightSpace 4
#define ItemLabel 30
@interface ChapterViewController ()
@property (nonatomic,strong) SearchLessonInterface *searchLessonInter;
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

-(void)willDismissPopoupController{
    CGPoint offset = self.myScrollView.contentOffset;
    [self.myScrollView setContentOffset:offset animated:NO];
}

-(void)drnavigationBarRightItemClicked:(id)sender{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftRight];
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
    self.searchBar.delegate = self;
    self.searchBar.searchTextField.returnKeyType = UIReturnKeySearch;
    [self.searchBar.searchTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.view addSubview:self.searchBar];

    [self.searchBar setHidden:!self.isSearch];
    self.mainToolBar.backgroundColor = [UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:232.0/255.0 alpha:1.0]; 
    
    [self.drnavigationBar.navigationRightItem setTitle:@"返回" forState:UIControlStateNormal];
    [self.drnavigationBar.navigationRightItem setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
}

-(void)reloadDataWithDataArray:(NSArray*)data{
    self.recentArray = data;
    DLog(@"count = %d",data.count);
    if (self.recentArray.count>0) {
        self.dataArray = [NSMutableArray arrayWithArray:self.recentArray];
        [self displayNewView];
    }
}

#pragma mark ChapterSearchBarDelegate
-(void)chapterSeachBar:(ChapterSearchBar *)searchBar beginningSearchString:(NSString *)searchText{
    if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
        [Utility errorAlert:@"暂无网络!"];
    }else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        SearchLessonInterface *searchLessonInter = [[SearchLessonInterface alloc]init];
        self.searchLessonInter = searchLessonInter;
        self.searchLessonInter.delegate = self;
        [self.searchLessonInter getSearchLessonInterfaceDelegateWithUserId:[[CaiJinTongManager shared] userId] andText:searchText];
    } 
}
#pragma mark --

#pragma -- 页面布局

-(void)displayNewView {
    [self.myScrollView removeFromSuperview];
    if (self.dataArray.count>0) {
        NSInteger count = ([self.dataArray count]-1)/6+1;  //有几页
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
        self.myScrollView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.myScrollView];
        
        for (int i=0; i<count; i++) {
            self.myTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0+self.myScrollView.frame.size.height*i, self.myScrollView.frame.size.width, self.myScrollView.frame.size.height)];//创建每一页的tableview
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
    int maxIndex = (row*2+2);
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
    sv.tag = currentTag;
    self.sectionView = sv;

    [self.sectionView addTarget:self  action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:self.sectionView];
    NSLog(@"---contentView.subviews.count: %i----",cell.contentView.subviews.count);
    sv = nil;
}
-(void)imageButtonClick:(id)sender {
    UIControl *button = sender;
    DLog(@"imageTag = %d",button.tag);
    SectionModel *section = (SectionModel *)[self.dataArray objectAtIndex:button.tag];
    DLog(@"sid = %@",section.sectionId);
    AppDelegate *app = [AppDelegate sharedInstance];
    if (app.isLocal == YES) {
        Section *sectionDb = [[Section alloc]init];
        //笔记
        NSArray *noteArray = [sectionDb getNoteInfoWithSid:section.sectionId];
        section.noteList = [[NSMutableArray alloc]initWithArray:noteArray];
        //章节下载列表
        NSArray *section_chapterArray = [sectionDb getChapterInfoWithSid:section.sectionId];
        section.sectionList  =[[NSMutableArray alloc]initWithArray:section_chapterArray];
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        SectionViewController *sectionView = [story instantiateViewControllerWithIdentifier:@"SectionViewController"];
        sectionView.section = section;
        [self.navigationController pushViewController:sectionView animated:YES];
        
    }else {
        //根据sectionID获取单个视频的详细信息
        if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
            [Utility errorAlert:@"暂无网络!"];
        }else {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            SectionInfoInterface *sectionInter = [[SectionInfoInterface alloc]init];
            self.sectionInterface = sectionInter;
            self.sectionInterface.delegate = self;
            [self.sectionInterface getSectionInfoInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andSectionId:section.sectionId];
        }
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
        SectionModel *section = (SectionModel *)result;
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
            SectionViewController *sectionView = [story instantiateViewControllerWithIdentifier:@"SectionViewController"];
            sectionView.section = section;
            [self.navigationController pushViewController:sectionView animated:YES];
        });
    });
}
-(void)getSectionInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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

#pragma mark SearchLessonInterfaceDelegate
-(void)getSearchLessonInfoDidFinished:(NSDictionary *)result{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (![[result objectForKey:@"sectionList"]isKindOfClass:[NSNull class]] && [result objectForKey:@"sectionList"]!=nil) {
                NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:[result objectForKey:@"sectionList"]];
                [self reloadDataWithDataArray:tempArray];
                
            }else{
            self.searchBar.searchTipLabel.text = @"无搜索结果";
            }
        });
    });
}

-(void)getSearchLessonInfoDidFailed:(NSString *)errorMsg{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:@"搜索失败"];
}
#pragma mark --

#pragma mark -- ChapterInfoInterfaceDelegate

-(void)getChapterInfoDidFinished:(NSDictionary *)result {  //章节信息查询完毕,显示章节界面
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (![[result objectForKey:@"sectionList"]isKindOfClass:[NSNull class]] && [result objectForKey:@"sectionList"]!=nil) {
                NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:[result objectForKey:@"sectionList"]];
                [self reloadDataWithDataArray:tempArray];
            }else{
                self.searchBar.searchTipLabel.text = @"无搜索结果";
            }
        });
    });
}
-(void)getChapterInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}

@end
