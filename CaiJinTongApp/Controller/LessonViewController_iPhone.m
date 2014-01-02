//
//  LessonViewController_iPhone.m
//  CaiJinTongApp
//
//  Created by apple on 13-11-25.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "LessonViewController_iPhone.h"
#define CELL_REUSE_IDENTIFIER @"CollectionCell"
@interface LessonViewController_iPhone ()
@property (nonatomic,strong) LessonCategoryInterface *lessonCategoryInterface;
@property (strong,nonatomic) LessonListForCategory *lessonListForCategory;//根据分类获取课程列表
@property (nonatomic,strong) DRTreeTableView *drTreeTableView;
@property (nonatomic,strong) MJRefreshHeaderView *headerRefreshView;
@property (nonatomic,strong) MJRefreshFooterView *footerRefreshView;
@property (nonatomic,strong) LessonInfoInterface *lessonInterface;
@property (assign,nonatomic) BOOL isSearch;
@property (assign,nonatomic) BOOL isRefreshing;
@end
@implementation LessonViewController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#pragma mark -- init settings

//获取课程分类信息
-(void)downloadLessonCategoryInfo{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.lessonCategoryInterface downloadLessonCategoryDataWithUserId:[CaiJinTongManager shared].userId];
}

-(void)downloadLessonListForCatogory{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UserModel *user = [[CaiJinTongManager shared] user];
    [self.lessonListForCategory downloadLessonListForCategoryId:nil withUserId:user.userId withPageIndex:0 withSortType:self.sortType];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[CaiJinTongManager shared] setUserId:@"17082"];
    NSLog(@"%@",NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES)[0]);
    
    [self setCollectionView];
    self.sortType = LESSONSORTTYPE_CurrentStudy;
    [self initData];
    [self setTabBar];
    if(!self.searchBar){
        self.searchBar = [[ChapterSearchBar_iPhone alloc] init];
        self.searchBar.frame = CGRectMake(19, IP5(78, 63), 282, 34);
        [self.view addSubview:self.searchBar];
        self.searchBar.delegate = self;
        self.isSearch = NO;
    }
    self.isRefreshing = NO;
    
    CJTMainToolbar_iPhone *mainBar = [[CJTMainToolbar_iPhone alloc]initWithFrame:CGRectMake (19, IP5(125, 105), 281, IP5(40, 35))];
	self.mainToolBar = mainBar;
    self.mainToolBar.delegate = self;
    [self.view addSubview:self.mainToolBar];
    
    self.lhlNavigationBar.title.text = @"我的课程";
}

//collectionView加载设置
-(void)setCollectionView{
    self.collectionView.frame = CGRectMake(0,IP5(166, 144), 320,IP5(339, 286) ) ;
    [self.collectionView setPagingEnabled:NO];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELL_REUSE_IDENTIFIER];
    //定制布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(160, 155);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    self.collectionView.collectionViewLayout = flowLayout;
    
    [self.headerRefreshView endRefreshing];
    self.headerRefreshView.isForbidden = NO;
    [self.footerRefreshView endRefreshing];
    self.footerRefreshView.isForbidden = NO;
}

//加载数据
-(void) initData{
    if([[Utility isExistenceNetwork] isEqualToString:@"NotReachable"]){
        [Utility errorAlert:@"暂无网络!"];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.lessonListForCategory downloadLessonListForCategoryId:nil withUserId:[CaiJinTongManager shared].userId withPageIndex:0 withSortType:LESSONSORTTYPE_CurrentStudy];
    }
}

//-(void) initData{
//    chapterModel *chapter = [[chapterModel alloc] init];
//    chapter.chapterId = @"708";
//    if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
//        [Utility errorAlert:@"暂无网络!"];
//    }else {
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        ChapterInfoInterface *chapterInter = [[ChapterInfoInterface alloc]init];
//        self.chapterInterface = chapterInter;
//        self.chapterInterface.delegate = self;
//        [self.chapterInterface getChapterInfoInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andChapterId:chapter.chapterId];
//    }
//
//}

//设置tabBar
-(void)setTabBar{
    UITabBar *bar = self.tabBarController.tabBar;
    [bar setFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - IP5(63, 50), 320, IP5(63, 50))];
    bar.layer.contents = (id)[UIImage imageNamed:@"barbg.png"].CGImage ;
    [bar setTintColor:[UIColor colorWithRed:10.0/255.0 green:35.0/255.0 blue:56.0/255.0 alpha:1.0]];
    [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"play-table.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"play-table.png"]];//iOS 7 本语句失效
}

//#pragma mark --ChapterInfoDelegate
//-(void)getChapterInfoDidFinished:(NSDictionary *)result {  //章节信息查询完毕,显示章节界面
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            if (![[result objectForKey:@"sectionList"]isKindOfClass:[NSNull class]] && [result objectForKey:@"sectionList"]!=nil) {
//                self.recentArray = [[NSMutableArray alloc]initWithArray:[result objectForKey:@"sectionList"]];
//                self.sectionList = self.recentArray;
//                [self.collectionView reloadData];
//            }
//        });
//    });
//}
//-(void)getChapterInfoDidFailed:(NSString *)errorMsg {
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    [Utility errorAlert:errorMsg];
//}



//-(void)getSearchLessonInfoDidFinished:(NSDictionary *)result {
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            if (([[result objectForKey:@"sectionList"] isKindOfClass:[NSNull class]]) || ([result objectForKey:@"sectionList"] == nil) || ([[NSMutableArray alloc]initWithArray:[result objectForKey:@"sectionList"]].count < 1)) {
//                [MBProgressHUD showHUDAddedTo:self.view animated:YES].labelText = @"搜索完毕,没有符合条件的结果!";
//            }else{
//                NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:[result objectForKey:@"sectionList"]];
//                if(self.searchBar.searchTextField.text != nil && ![self.searchBar.searchTextField.text isEqualToString:@""] && tempArray.count > 0){
//                    NSString *keyword = [self.searchBar.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//                    NSMutableArray *ary = [NSMutableArray arrayWithCapacity:5];
//                    for(int i = 0 ; i < tempArray.count ; i++){
//                        SectionModel *section = [tempArray objectAtIndex:i];
//                        NSRange range = [section.sectionName rangeOfString:[NSString stringWithFormat:@"(%@)+",keyword] options:NSRegularExpressionSearch];
//                        if(range.location != NSNotFound){
//                            [ary addObject:section];
//                        }
//                    }
//                    tempArray = [NSMutableArray arrayWithArray:ary];
//                }
//                if(tempArray.count == 0){
//                }else{
//                    self.recentArray = tempArray;
//                    self.sectionList = self.recentArray;
//                    
//                    //搜索成功则清除旧的筛选记录
//                    self.progressArray = nil;
//                    self.nameArray = nil;
//                    
//                    //对搜索结果进行筛选排序
//                    switch (self.filterStatus) {
//                        case progress:{
//                            [self bubbleSort:self.sectionList];
//                        }
//                            break;
//                        case a_z:{
//                            [self letterSort:self.sectionList];
//                        }
//                            break;
//                        default:
//                            break;
//                    }
//                    [self displayNewView];
//                }
//            }
//        });
//    });
//}
//-(void)getSearchLessonInfoDidFailed:(NSString *)errorMsg {
////    [MBProgressHUD dismiss];
//    [Utility errorAlert:errorMsg];
//}


#pragma mark --CollectionViewDelegate
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
    
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.sectionList.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_REUSE_IDENTIFIER forIndexPath:indexPath];
    //如何实现subView的复用 (因为没有重写cell类)
    BOOL flag = YES;//是否init新sectioncustomview
    for(id son in cell.contentView.subviews){
        if([son isKindOfClass:[SectionCustomView_iPhone class]]){
            flag = NO;
            self.sectionCustomView = (SectionCustomView_iPhone *)son;
            break;
        }
    }
    if(flag){
        self.sectionCustomView = [[SectionCustomView_iPhone alloc] initWithFrame:CGRectMake(18, 10, 125, 145) andSection:(SectionModel *)self.sectionList[indexPath.row] andItemLabel:20];
        [self.sectionCustomView addTarget:self action:@selector(cellClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.clipsToBounds = NO;
        [cell.contentView addSubview:self.sectionCustomView];
    }else{
        [self.sectionCustomView refreshDataWithSection:self.sectionList[indexPath.row]];
    }
    return cell;
}
//绘制cell  (注:  160*153)

- (void) cellClicked:(id)sender{
    [self.searchBar.searchTextField resignFirstResponder];
    if([[Utility isExistenceNetwork] isEqualToString:@"NotReachable"]){
        [Utility errorAlert:@"暂无网络!"];
    }else{
        UserModel *user = [[CaiJinTongManager shared] user];
        [self.lessonInterface downloadLessonInfoWithLessonId:((SectionCustomView_iPhone *)sender).sectionId withUserId:user.userId];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    self.menuVisible = NO;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchBar.searchTextField resignFirstResponder];
    self.menuVisible = NO;
}


#pragma mark -- CJTMainToolbar_iPhoneDelegate
//正确显示排序按钮
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



//最近播放(默认)
- (void)tappedInToolbar:(CJTMainToolbar_iPhone *)toolbar recentButton:(UIButton *) button{
    if (self.headerRefreshView.isForbidden || self.footerRefreshView.isForbidden) {
        return;
    }
    [self initButton:button];
    self.sortType = LESSONSORTTYPE_CurrentStudy;
    if(self.isSearch){
        [self chapterSeachBar_iPhone:self.searchBar beginningSearchString:self.searchBar.searchTextField.text];
        return;
    }
    UserModel *user = [[CaiJinTongManager shared] user];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.lessonListForCategory downloadLessonListForCategoryId:self.lessonListForCategory.lessonCategoryId withUserId:user.userId withPageIndex:0 withSortType:self.sortType];
    
//    self.sectionList = nil;
//    self.sectionList = [NSMutableArray arrayWithArray:self.recentArray];
//    self.filterStatus = recent;
//    [self displayNewView];
}
//学习进度
- (void)tappedInToolbar:(CJTMainToolbar_iPhone *)toolbar progressButton:(UIButton *)button {
    if (self.headerRefreshView.isForbidden || self.footerRefreshView.isForbidden) {
        return;
    }
    [self initButton:button];
    self.sortType = LESSONSORTTYPE_ProgressStudy;
    if(self.isSearch){
        [self chapterSeachBar_iPhone:self.searchBar beginningSearchString:self.searchBar.searchTextField.text];
        return;
    }
    UserModel *user = [[CaiJinTongManager shared] user];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.lessonListForCategory downloadLessonListForCategoryId:self.lessonListForCategory.lessonCategoryId withUserId:user.userId withPageIndex:0 withSortType:self.sortType];
}
//名称(A-Z)
- (void)tappedInToolbar:(CJTMainToolbar_iPhone *)toolbar nameButton:(UIButton *)button {
    if (self.headerRefreshView.isForbidden || self.footerRefreshView.isForbidden) {
        return;
    }
    [self initButton:button];
    self.sortType = LESSONSORTTYPE_LessonName;
    if(self.isSearch){
        [self chapterSeachBar_iPhone:self.searchBar beginningSearchString:self.searchBar.searchTextField.text];
        return;
    }
    UserModel *user = [[CaiJinTongManager shared] user];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.lessonListForCategory downloadLessonListForCategoryId:self.lessonListForCategory.lessonCategoryId withUserId:user.userId withPageIndex:0 withSortType:self.sortType];
}

#pragma mark arctions
-(void)reloadDataWithDataArray:(NSArray*)data withCategoryId:(NSString*)lessonCategoryId{
    self.sectionList = [NSMutableArray arrayWithArray:data];
    dispatch_async(dispatch_get_main_queue(),  ^{
        [self.collectionView reloadData];
    });
}

//加载下一页数据
-(void)loadNextPageDataWithDataArray:(NSArray*)data withCategoryId:(NSString*)lessonCategoryId{
    [self.sectionList addObjectsFromArray:data];
    dispatch_async(dispatch_get_main_queue(),  ^{
        [self.collectionView reloadData];
    });
}

//#pragma mark-- 筛选
////学习进度
//- (void)bubbleSort:(NSMutableArray *)array {
//    int i, y;
//    BOOL bFinish = YES;
//    for (i = 1; i<= [array count] && bFinish; i++) {
//        bFinish = NO;
//        for (y = (int)[array count]-1; y>=i; y--) {
//            SectionModel *section1 = (SectionModel *)[array objectAtIndex:y];
//            SectionModel *section2 = (SectionModel *)[array objectAtIndex:y-1];
//            if (([section1.sectionProgress floatValue] - [section2.sectionProgress floatValue])<0.000001) {
//                [array exchangeObjectAtIndex:y-1 withObjectAtIndex:y];
//                bFinish = YES;
//            }
//        }
//    }
//}
////按字母排序
//-(void)letterSort:(NSMutableArray *)array {
//    NSMutableArray *tempArray = array;
//    self.sectionList = nil;
//    self.sectionList = [[NSMutableArray alloc]init];
//    NSMutableArray *chineseStringsArray=[NSMutableArray array];
//    for(int i=0;i<[array count];i++){
//        ChineseString *chineseString=[[ChineseString alloc]init];
//        
//        SectionModel *section = (SectionModel *)[array objectAtIndex:i];
//        chineseString.string=[NSString stringWithString:section.sectionName];
//        
//        if(chineseString.string==nil){
//            chineseString.string=@"";
//        }
//        
//        if(![chineseString.string isEqualToString:@""]){
//            NSString *pinYinResult=[NSString string];
//            
//            NSString *regexCall = @"[\u4E00-\u9FFF]+$";
//            NSPredicate *predicateCall = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexCall];
//            //是汉字
//            if ([predicateCall evaluateWithObject:[chineseString.string substringToIndex:1]]) {
//                for(int j=0;j<chineseString.string.length;j++){
//                    NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
//                    
//                    pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
//                }
//            }else {//非汉字
//                pinYinResult = [pinYinResult stringByAppendingString:[[chineseString.string substringToIndex:1]uppercaseString]];
//            }
//            chineseString.pinYin=pinYinResult;
//        }else{
//            chineseString.pinYin=@"";
//        }
//        [chineseStringsArray addObject:chineseString];
//    }
//    
//    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
//    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
//    NSMutableArray *result=[NSMutableArray array];
//    for(int i=0;i<[chineseStringsArray count];i++){
//        [result addObject:((ChineseString*)[chineseStringsArray objectAtIndex:i]).string];
//    }
//    for(int i=0;i<[result count];i++){
//        NSString *string = [result objectAtIndex:i];
//        for (int k=0; k<tempArray.count; k++) {
//            SectionModel *section = (SectionModel *)[array objectAtIndex:k];
//            if ([string isEqualToString:section.sectionName]) {
//                [self.sectionList addObject:section];
//            }
//        }
//    }
//}

//#pragma mark -- SectionInfoInterface
//-(void)getSectionInfoDidFinished:(SectionModel *)result {
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        SectionModel *section = (SectionModel *)result;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
//            SectionViewController_iPhone *sectionViewController = [story instantiateViewControllerWithIdentifier:@"SectionViewController_iPhone"];
//            
//            sectionViewController.section = section;
//            sectionViewController.section_ChapterView.dataArray = [NSMutableArray arrayWithArray:sectionViewController.section.sectionList];
//            [sectionViewController.section_ChapterView.tableViewList reloadData];
//            [sectionViewController initAppear];          //界面上半部分
//            [sectionViewController initAppear_slide];    //界面下半部分(滑动视图)
//            [self.navigationController pushViewController:sectionViewController animated:YES];
//        });
//    });
//}
//
//-(void)getSectionInfoDidFailed:(NSString *)errorMsg {
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    [Utility errorAlert:errorMsg];
//}



#pragma mark -- search Bar delegate
-(void)chapterSeachBar_iPhone:(ChapterSearchBar_iPhone *)searchBar beginningSearchString:(NSString *)searchText{
    if (self.searchBar.searchTextField.text.length == 0) {
        [Utility errorAlert:@"请输入搜索内容!"];
    }else {
        [self.searchBar resignFirstResponder];
        if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
            [Utility errorAlert:@"暂无网络!"];
        }else {
            self.isSearch = YES;
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.oldSearchText = searchText;
            SearchLessonInterface *searchLessonInter = [[SearchLessonInterface alloc]init];
            self.searchInterface = searchLessonInter;
            self.searchInterface.delegate = self;
            [self.searchInterface getSearchLessonInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andText:[self.searchBar.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] withPageIndex:0 withSortType:self.sortType];
        }
    }
}

#pragma mark -- 页面布局
//collection重载数据
-(void)displayNewView {
    [self.collectionView reloadData];
    [self.collectionView setContentOffset:CGPointMake(0, 0)];
}

#pragma mark lhlNavigationBar

-(void)leftItemClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightItemClicked:(id)sender{
    if(!_drTreeTableView){
        [self downloadLessonCategoryInfo];
        [self drTreeTableView];
        self.menuVisible = YES;
        [self.view addSubview:self.drTreeTableView];
        [self.drTreeTableView setBackgroundColor:[UIColor colorWithRed:6.0/255.0 green:18.0/255.0 blue:27.0/255.0 alpha:1.0]];
    }else{
        self.menuVisible = !self.menuVisible;
    }
    [self.searchBar.searchTextField resignFirstResponder];
}

-(void)setMenuVisible:(BOOL)menuVisible{
    _menuVisible = menuVisible;
    [UIView animateWithDuration:0.3 animations:^{
        if(menuVisible){
            self.drTreeTableView.frame = CGRectMake(120,IP5(65, 55), 200, SCREEN_HEIGHT - IP5(63, 50) - IP5(65, 55));
        }else{
            self.drTreeTableView.frame = CGRectMake(320,IP5(65, 55), 200, SCREEN_HEIGHT - IP5(63, 50) - IP5(65, 55));
        }
    }];
}

#pragma mark --

#pragma mark LessonCategoryInterfaceDelegate获取课程分类信息
-(void)getLessonCategoryDataDidFinished:(NSArray *)categoryNotes{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.drTreeTableView.noteArr = [NSMutableArray arrayWithArray:categoryNotes];
        [[CaiJinTongManager shared] setLessonCategoryArr:[NSMutableArray arrayWithArray:categoryNotes]];
    });
}

-(void)getLessonCategoryDataFailure:(NSString *)errorMsg{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utility errorAlert:errorMsg];
    });
}

#pragma mark LessonListForCategoryDelegate 根据分类获取课程信息
-(void)getLessonListDataForCategoryDidFinished:(NSArray *)lessonList withCurrentPageIndex:(int)pageIndex withTotalCount:(int)allDataCount{
    if(self.isRefreshing){   //回调方法如果是因为分页加载被调用,则:
        dispatch_async(dispatch_get_main_queue(), ^{
            if (pageIndex > 0) {
                [self loadNextPageDataWithDataArray:lessonList withCategoryId:self.lessonListForCategory.lessonCategoryId];
            }else{
                [self  reloadDataWithDataArray:lessonList withCategoryId:self.lessonListForCategory.lessonCategoryId];
            }
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.headerRefreshView endRefreshing];
            self.headerRefreshView.isForbidden = NO;
            [self.footerRefreshView endRefreshing];
            self.footerRefreshView.isForbidden = NO;
            self.isRefreshing = NO;
        });
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{    //因选择分类被调用
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.lessonListForCategory.currentPageIndex = 0;
        self.isSearch = NO;
        [self reloadDataWithDataArray:lessonList withCategoryId:self.lessonListForCategory.lessonCategoryId];
    });
}

-(void)getLessonListDataForCategoryFailure:(NSString *)errorMsg{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(self.isRefreshing){
            [self.headerRefreshView endRefreshing];
            self.headerRefreshView.isForbidden = NO;
            [self.footerRefreshView endRefreshing];
            self.footerRefreshView.isForbidden = NO;
            self.isRefreshing = NO;
        }
        [Utility errorAlert:errorMsg];
    });
}

#pragma mark

#pragma mark-- LessonInfoInterfaceDelegate加载课程详细信息
-(void)getLessonInfoDidFinished:(LessonModel*)lesson{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        SectionViewController_iPhone *sectionView = [story instantiateViewControllerWithIdentifier:@"SectionViewController_iPhone"];
        sectionView.section = (SectionModel *)lesson;
//        NSMutableArray *a = [NSMutableArray arrayWithArray:sectionView.section.sectionList];
//        Section_ChapterViewController_iPhone *scvc = [story instantiateViewControllerWithIdentifier:@"Section_ChapterViewController_iPhone"];
//        scvc.dataArray = [NSMutableArray arrayWithArray:a];
//        [scvc.view frame];
//        [scvc.tableViewList setFrame:CGRectMake(22, 0, 276, 433)];
//        [self.navigationController pushViewController:scvc animated:YES];
//        sectionView.section_ChapterView.dataArray = [NSMutableArray arrayWithArray:lesson.chapterList];
//        [sectionView.section_ChapterView.tableViewList reloadData];
//        [sectionView initAppear];          //界面上半部分
//        [sectionView initAppear_slide];    //界面下半部分(滑动视图)
        [self.navigationController pushViewController:sectionView animated:YES];
    });
}
-(void)getLessonInfoDidFailed:(NSString *)errorMsg{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}

#pragma mark -- Search Lesson InterfaceDelegate 搜索课程

-(void)getSearchLessonListDataForCategoryDidFinished:(NSArray *)lessonList withCurrentPageIndex:(int)pageIndex withTotalCount:(int)allDataCount{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (pageIndex > 0) {
            [self loadNextPageDataWithDataArray:lessonList withCategoryId:self.lessonListForCategory.lessonCategoryId];
        }else{
            [self  reloadDataWithDataArray:lessonList withCategoryId:self.lessonListForCategory.lessonCategoryId];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.headerRefreshView endRefreshing];
        self.headerRefreshView.isForbidden = NO;
        [self.footerRefreshView endRefreshing];
        self.footerRefreshView.isForbidden = NO;
    });
}

-(void)getSearchLessonListDataForCategoryFailure:(NSString *)errorMsg{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.searchBar.searchTextField.text = self.oldSearchText;
        [self.headerRefreshView endRefreshing];
        self.headerRefreshView.isForbidden = NO;
        [self.footerRefreshView endRefreshing];
        self.footerRefreshView.isForbidden = NO;
        [Utility errorAlert:errorMsg];
    });
}

#pragma mark DRTreeTableViewDelegate //选择一个分类
-(void)drTreeTableView:(DRTreeTableView *)treeView didSelectedTreeNode:(DRTreeNode *)selectedNote{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.isSearch = NO; // isLessonListForCategory
    UserModel *user = [[CaiJinTongManager shared] user];
    [self.lessonListForCategory downloadLessonListForCategoryId:selectedNote.noteContentID withUserId:user.userId withPageIndex:0 withSortType:self.sortType];
}

-(BOOL)drTreeTableView:(DRTreeTableView *)treeView isExtendChildSelectedTreeNode:(DRTreeNode *)selectedNote{
    return YES;
}

#pragma mark MJRefreshBaseViewDelegate 分页加载
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    if (self.isSearch) {
        [self.searchInterface getSearchLessonInterfaceDelegateWithUserId:[[CaiJinTongManager shared] userId] andText:self.oldSearchText withPageIndex:self.searchInterface.currentPageIndex+1 withSortType:self.sortType];
    }else{
        if (self.headerRefreshView == refreshView) {
            self.footerRefreshView.isForbidden = YES;
            UserModel *user = [[CaiJinTongManager shared] user];
            [self.lessonListForCategory downloadLessonListForCategoryId:nil withUserId:user.userId withPageIndex:0 withSortType:self.sortType];
        }else{
            self.isRefreshing = YES;
            self.headerRefreshView.isForbidden = YES;
            UserModel *user = [[CaiJinTongManager shared] user];
            [self.lessonListForCategory downloadLessonListForCategoryId:self.lessonListForCategory.lessonCategoryId withUserId:user.userId withPageIndex:self.lessonListForCategory.currentPageIndex+1 withSortType:self.sortType];
            NSLog(@"%i顶顶顶顶",self.lessonListForCategory.currentPageIndex);
        }
    }
}

#pragma  mark property

-(DRTreeTableView *)drTreeTableView{
    if (!_drTreeTableView) {
        _drTreeTableView = [[DRTreeTableView alloc] initWithFrame:CGRectMake(320,IP5(65, 55), 200, SCREEN_HEIGHT - IP5(63, 50) - IP5(65, 55)) withTreeNodeArr:nil];
        _drTreeTableView.delegate = self;
    }
    return _drTreeTableView;
}

-(LessonCategoryInterface *)lessonCategoryInterface{
    if (!_lessonCategoryInterface) {
        _lessonCategoryInterface = [[LessonCategoryInterface alloc] init];
        _lessonCategoryInterface.delegate = self;
    }
    return _lessonCategoryInterface;
}

-(LessonListForCategory *)lessonListForCategory{
    if (!_lessonListForCategory) {
        _lessonListForCategory = [[LessonListForCategory alloc] init];
        _lessonListForCategory.delegate = self;
    }
    return _lessonListForCategory;
}

-(MJRefreshHeaderView *)headerRefreshView{
    if (!_headerRefreshView) {
        _headerRefreshView = [[MJRefreshHeaderView alloc] init];
        _headerRefreshView.scrollView = self.collectionView;
        _headerRefreshView.delegate = self;
    }
    return _headerRefreshView;
}

-(MJRefreshFooterView *)footerRefreshView{
    if (!_footerRefreshView) {
        _footerRefreshView = [[MJRefreshFooterView alloc] init];
        _footerRefreshView.delegate = self;
        _footerRefreshView.scrollView = self.collectionView;
        
    }
    return _footerRefreshView;
}

-(LessonInfoInterface *)lessonInterface{
    if (!_lessonInterface) {
        _lessonInterface = [[LessonInfoInterface alloc] init];
        _lessonInterface.delegate = self;
    }
    return _lessonInterface;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
