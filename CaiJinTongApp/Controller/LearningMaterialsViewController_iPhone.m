//
//  LearningMaterialsViewController_iPhone.m
//  CaiJinTongApp
//
//  Created by apple on 14-1-13.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "LearningMaterialsViewController_iPhone.h"
#import "DRImageButton.h"
#import "CJTMainToolbar_iPhone.h"
/*
 显示资料列表
 */
@interface LearningMaterialsViewController_iPhone ()
- (IBAction)timeSortBtClicked:(id)sender;
- (IBAction)defaultSortBtClicked:(id)sender;
- (IBAction)nameSortBtClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutletCollection(DRImageButton) NSArray *sortButtons;
@property (weak, nonatomic) IBOutlet UIView *titleBar;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (nonatomic,strong) NSMutableArray *searchArray;
@property (nonatomic,assign) BOOL isSearch;
@property (nonatomic,assign) BOOL isReloading;//正在下载中
@property (nonatomic,assign) LearningMaterialsSortType sortType;
@property (nonatomic,strong) NSString *searchContent;

@property (nonatomic,strong) SearchLearningMatarilasListInterface *searchMaterialInterface;
@property (nonatomic,strong) LearningMatarilasCategoryInterface *learningMatarilasCategoryInterface;//加载资料分类
@property (nonatomic,strong) LearningMatarilasListInterface *learningMaterialListInterface;//加载资料列表
@property (nonatomic,strong) MJRefreshHeaderView *headerRefreshView;
@property (nonatomic,strong) MJRefreshFooterView *footerRefreshView;

@property (nonatomic,assign) BOOL menuVisible;//显示/隐藏选择列表
@property (nonatomic,strong) DRTreeTableView *treeView; //选择分类的列表
@property (nonatomic,strong) ChapterSearchBar_iPhone *searchBar; //搜罗栏

@property (nonatomic,strong) CJTMainToolbar_iPhone *mainToolBar;
@end

@implementation LearningMaterialsViewController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    [self.footerRefreshView free];
    [self.headerRefreshView free];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sortType = LearningMaterialsSortType_Default;
    self.isReloading = YES;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UserModel *user = [[CaiJinTongManager shared] user];
    //此处_lessonCategoryId改为要初始显示的分类Id
    [self.learningMaterialListInterface downloadlearningMaterilasListForCategoryId:_lessonCategoryId withUserId:user.userId withPageIndex:0 withSortType:self.sortType];
    [self setSubview];
    [self.view addSubview:self.searchBar];
//    self.lhlNavigationBar.leftItem.hidden = YES;
    
    CJTMainToolbar_iPhone *mainBar = [[CJTMainToolbar_iPhone alloc]initWithFrame:CGRectMake (19, IP5(105, 105), 281, IP5(40, 35))];
	self.mainToolBar = mainBar;
//    self.mainToolBar.delegate = self;
    [self.view addSubview:self.mainToolBar];
    [self.mainToolBar.recentBt setTitle:@"时间" forState:UIControlStateNormal];
    self.mainToolBar.recentBt.center = (CGPoint){self.mainToolBar.recentBt.center.x-25,self.mainToolBar.recentBt.center.y};
    [self.mainToolBar.progressBt setTitle:@"文件名称" forState:UIControlStateNormal];
    self.mainToolBar.progressBt.center = (CGPoint){self.mainToolBar.progressBt.center.x-25,self.mainToolBar.progressBt.center.y};
    [self.mainToolBar.nameBt setTitle:@"默认排序" forState:UIControlStateNormal];
    self.mainToolBar.nameBt.center = (CGPoint){self.mainToolBar.nameBt.center.x-10,self.mainToolBar.nameBt.center.y};
    [self.mainToolBar.recentBt addTarget:self action:@selector(timeSortBtClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainToolBar.progressBt addTarget:self action:@selector(nameSortBtClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainToolBar.nameBt addTarget:self action:@selector(defaultSortBtClicked:) forControlEvents:UIControlEventTouchUpInside];
//    self.mainToolBar
}

-(void)setSubview{
    self.lhlNavigationBar.title.text = @"学习资料";
    for (DRImageButton *btn in self.sortButtons) {
        [btn.layer setCornerRadius:3.0];
    }
//    [self.titleBar setFrame:(CGRect){0,IP5(67,57),320,30}];
//    [self.tableView setFrame:(CGRect){0,IP5(100, 90),320,IP5(405, 340) - 3}];
    
//    [self.searchButton.layer setCornerRadius:3.0];
//    [self.searchButton addTarget:self action:@selector(searchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if (platform >= 7.0) {
        self.tableView.frame = CGRectMake(10,IP5(150, 144), 320,IP5(350, 286) ) ;
    }else{
        self.tableView.frame = CGRectMake(10,IP5(150, 144), 320,IP5(400, 330) ) ;
    }
    [self.headerRefreshView endRefreshing];
    [self.footerRefreshView endRefreshing];
    self.headerRefreshView.isForbidden = NO;
    self.footerRefreshView.isForbidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark sort排序
- (void)timeSortBtClicked:(id)sender {
    [self dealingButtonImg:sender];
    
    self.isSearch = NO;
    self.sortType = LearningMaterialsSortType_Date;
    UserModel *user = [[CaiJinTongManager shared] user];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.isReloading = YES;
    [self.learningMaterialListInterface downloadlearningMaterilasListForCategoryId:self.lessonCategoryId withUserId:user.userId withPageIndex:0 withSortType:self.sortType];
}

- (void)defaultSortBtClicked:(id)sender {
    [self dealingButtonImg:sender];
    
    self.isSearch = NO;
    UserModel *user = [[CaiJinTongManager shared] user];
    self.sortType = LearningMaterialsSortType_Default;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.isReloading = YES;
    [self.learningMaterialListInterface downloadlearningMaterilasListForCategoryId:self.lessonCategoryId withUserId:user.userId withPageIndex:0 withSortType:self.sortType];
}

- (void)nameSortBtClicked:(id)sender {
    [self dealingButtonImg:sender];
    
    self.isSearch = NO;
    UserModel *user = [[CaiJinTongManager shared] user];
    self.sortType = LearningMaterialsSortType_Name;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.isReloading = YES;
    [self.learningMaterialListInterface downloadlearningMaterilasListForCategoryId:self.lessonCategoryId withUserId:user.userId withPageIndex:0 withSortType:self.sortType];
}

-(void)dealingButtonImg:(UIButton*)sender{
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSArray *subViews = [self.mainToolBar subviews];
    if (subViews.count>0) {
        for (UIView *vv in subViews) {
            if ([vv isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)vv;
                if (![btn isEqual:sender]) {
                    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                }
            }
        }
    }
}

#pragma mark --

#pragma mark DRTreeNode

#pragma mark --

#pragma mark action
-(void)rightItemClicked:(id)sender{
    if(!_treeView){
        [self treeView];
        self.menuVisible = YES;
        [self.view addSubview:self.treeView];
    }else{
        self.menuVisible = !self.menuVisible;
    }
    if(self.treeView.noteArr.count < 1){
        [self downloadLessonCategoryInfo];
    }
    [self.searchBar.searchTextField resignFirstResponder];
}

-(void)downloadLessonCategoryInfo{
    //加载资料分类
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UserModel *user = [[CaiJinTongManager shared] user];
    [self.learningMatarilasCategoryInterface downloadLearningMatarilasCategoryDataWithUserId:user.userId];
}

-(void)searchButtonClicked:(UIButton *)sender{
    if(self.searchBar.hidden){
        [self.searchBar setHidden:NO];
        [UIView animateWithDuration:0.5
                         animations:^{
                             //                             [self.searchBar setFrame:CGRectMake(19, IP5(65, 55), 282, 34)];
                             [self.searchBar setAlpha:1.0];
                         }
                         completion:nil];
    }else{
        [self.searchBar.searchTextField resignFirstResponder];
        [UIView animateWithDuration:0.5
                         animations:^{
                             [self.searchBar setAlpha:0.0];
                             //                             [self.searchBar setFrame:CGRectMake(19, IP5(65, 55), 1, 1)];
                         }
                         completion:^ void (BOOL completed){
                             if(completed){
                                 [self.searchBar setHidden:!self.searchBar.hidden];
                             }
                         }];
    }
}

#pragma mark --

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self setMenuVisible:NO];
//    if(!self.searchBar.hidden){
//        [self searchButtonClicked:nil];
//    }
    [self.searchBar.searchTextField resignFirstResponder];
}

#pragma mark --

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LearningMaterialCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.path = indexPath;
    cell.delegate = self;
    LearningMaterials *material = self.isSearch?[self.searchArray objectAtIndex:indexPath.row]:[self.dataArray objectAtIndex:indexPath.row];
    [cell setLearningMaterialData:material];
//    if(self.dataArray.count > 0){
//        LearningMaterials *material = self.isSearch?[self.searchArray objectAtIndex:indexPath.row]:[self.dataArray objectAtIndex:0];
//        [cell setLearningMaterialData:material];
//    }
    
    
    if (indexPath.row%2 == 0) {
        cell.cellBackView.backgroundColor = [UIColor colorWithRed:235/255.0 green:245/255.0 blue:255/255.0 alpha:1];
    }else{
        cell.cellBackView.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 22;
    return self.isSearch? [self.searchArray count]:[self.dataArray count];
}


#pragma mark --

#pragma mark LearningMaterialCellDelegate
-(void)learningMaterialCell:(LearningMaterialCell *)cell scanLearningMaterialFileAtIndexPath:(NSIndexPath *)path{
    LearningMaterials *material = self.isSearch ? (self.searchArray[path.row]) : (self.dataArray[path.row]);
    if(!material.materialFileLocalPath){
        [Utility errorAlert:@"没有本地文件地址!"];
    }else{
        UIWebView *webView = [[UIWebView alloc] initWithFrame:(CGRect){0,IP5(65, 55),320,IP5(503, 425)}];
        LHLNavigationBarViewController *webController = [[LHLNavigationBarViewController alloc]init];
        [webController.view addSubview:webView];
        [self.navigationController pushViewController:webController animated:YES];
        webController.lhlNavigationBar.title.text = material.materialName;
        webController.lhlNavigationBar.rightItem.hidden = YES;
        NSURL *url = [NSURL fileURLWithPath:material.materialFileLocalPath];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
        webView.scalesPageToFit = YES;
        
    }
}
#pragma mark --


#pragma mark MJRefreshBaseViewDelegate 分页加载
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    UserModel *user = [[CaiJinTongManager shared] user];
    if (self.headerRefreshView == refreshView) {
        self.footerRefreshView.isForbidden = YES;
        if (self.isSearch) {
            [self.searchMaterialInterface searchLearningMaterilasListWithUserId:user.userId withSearchContent:self.searchBar.searchTextField.text withPageIndex:0 withSortType:self.sortType];
        }else{
            [self.learningMaterialListInterface downloadlearningMaterilasListForCategoryId:self.lessonCategoryId withUserId:user.userId withPageIndex:0 withSortType:self.sortType];
        }
    }else{
        self.headerRefreshView.isForbidden = YES;
        if (self.isSearch) {
            [self.searchMaterialInterface searchLearningMaterilasListWithUserId:user.userId withSearchContent:self.searchBar.searchTextField.text withPageIndex:self.searchMaterialInterface.currentPageIndex+1 withSortType:self.sortType];
        }else{
            [self.learningMaterialListInterface downloadlearningMaterilasListForCategoryId:self.lessonCategoryId withUserId:user.userId withPageIndex:self.learningMaterialListInterface.currentPageIndex+1 withSortType:self.sortType];
        }
    }
}

#pragma mark --

#pragma mark SearchLearningMatarilasListInterfaceDelegate
-(void)searchLearningMaterilasListDataForCategoryDidFinished:(NSArray *)lessonList withCurrentPageIndex:(int)pageIndex withTotalCount:(int)allDataCount{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isSearch = YES;
        if(pageIndex > 0){
            [self.searchArray addObjectsFromArray:lessonList];
        }else{
            self.searchArray = [NSMutableArray arrayWithArray:lessonList];
        }
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.headerRefreshView endRefreshing];
        [self.footerRefreshView endRefreshing];
        self.headerRefreshView.isForbidden = NO;
        self.footerRefreshView.isForbidden = NO;
        self.isReloading = NO;
        self.lhlNavigationBar.title.text = [NSString stringWithFormat:@"目前有(%i)份资料",allDataCount];
    });
}

-(void)searchLearningMaterilasListDataForCategoryFailure:(NSString *)errorMsg{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.headerRefreshView endRefreshing];
        [self.footerRefreshView endRefreshing];
        self.headerRefreshView.isForbidden = NO;
        self.footerRefreshView.isForbidden = NO;
        self.isReloading = NO;
        self.searchBar.searchTextField.text = nil;
        [Utility errorAlert:errorMsg];
    });
}
#pragma mark --

#pragma mark LearningMatarilasListInterfaceDelegate
-(void)getlearningMaterilasListDataForCategoryDidFinished:(NSArray *)lessonList withCurrentPageIndex:(int)pageIndex withTotalCount:(int)allDataCount{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(pageIndex > 0){
            [self.dataArray addObjectsFromArray:lessonList];
        }else{
            self.dataArray = [NSMutableArray arrayWithArray:lessonList];
        }
        
        [self.tableView reloadData];
        [self.headerRefreshView endRefreshing];
        [self.footerRefreshView endRefreshing];
        if(!self.headerRefreshView.isForbidden){
            self.tableView.contentOffset = CGPointZero;
        }
        self.headerRefreshView.isForbidden = NO;
        self.footerRefreshView.isForbidden = NO;
        self.isReloading = NO;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        self.menuVisible = NO;
        self.lhlNavigationBar.title.text = [NSString stringWithFormat:@"目前有(%i)份资料",allDataCount];
    });
}

-(void)getlearningMaterilasListDataForCategoryFailure:(NSString *)errorMsg{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.headerRefreshView endRefreshing];
        [self.footerRefreshView endRefreshing];
        self.headerRefreshView.isForbidden = NO;
        self.footerRefreshView.isForbidden = NO;
        self.isReloading = NO;
        [Utility errorAlert:errorMsg];
    });
}
#pragma mark --

#pragma mark property
-(ChapterSearchBar_iPhone *)searchBar{
    if(!_searchBar){
        _searchBar = [[ChapterSearchBar_iPhone alloc] initWithFrame:CGRectMake(19, IP5(63, 63), 282, 34)];
        _searchBar.delegate = self;
//        [_searchBar setHidden:YES];
//        [_searchBar setAlpha:0.0];
        [_searchBar.searchTextField setPlaceholder:@"搜索资料"];
//        [self.view addSubview:_searchBar];
    }
    return _searchBar;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(NSMutableArray *)searchArray{
    if (!_searchArray) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}

-(void)setMenuVisible:(BOOL)menuVisible{
    _menuVisible = menuVisible;
    [UIView animateWithDuration:0.3 animations:^{
        if(menuVisible){
            self.treeView.frame = CGRectMake(120,IP5(65, 55), 200, SCREEN_HEIGHT - IP5(63, 50) - IP5(65, 55));
        }else{
            self.treeView.frame = CGRectMake(320,IP5(65, 55), 200, SCREEN_HEIGHT - IP5(63, 50) - IP5(65, 55));
        }
    }];
}

-(SearchLearningMatarilasListInterface *)searchMaterialInterface{
    if (!_searchMaterialInterface) {
        _searchMaterialInterface = [[SearchLearningMatarilasListInterface alloc] init];
        _searchMaterialInterface.delegate = self;
    }
    return _searchMaterialInterface;
}

-(LearningMatarilasListInterface *)learningMaterialListInterface{
    if (!_learningMaterialListInterface) {
        _learningMaterialListInterface = [[LearningMatarilasListInterface alloc] init];
        _learningMaterialListInterface.delegate =self;
    }
    return _learningMaterialListInterface;
}

-(MJRefreshHeaderView *)headerRefreshView{
    if (!_headerRefreshView) {
        _headerRefreshView = [[MJRefreshHeaderView alloc] init];
        _headerRefreshView.scrollView = self.tableView;
        _headerRefreshView.delegate = self;
    }
    return _headerRefreshView;
}

-(MJRefreshFooterView *)footerRefreshView{
    if (!_footerRefreshView) {
        _footerRefreshView = [[MJRefreshFooterView alloc] init];
        _footerRefreshView.delegate = self;
        _footerRefreshView.scrollView = self.tableView;
        
    }
    return _footerRefreshView;
}

-(void)setLessonCategoryId:(NSString *)lessonCategoryId{
    if (self.isReloading) {
        return;
    }
    _lessonCategoryId = lessonCategoryId?:@"";
    if (lessonCategoryId) {
        self.isReloading = YES;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        UserModel *user = [[CaiJinTongManager shared] user];
        [self.learningMaterialListInterface downloadlearningMaterilasListForCategoryId:_lessonCategoryId withUserId:user.userId withPageIndex:0 withSortType:self.sortType];
    }
}

-(LearningMatarilasCategoryInterface *)learningMatarilasCategoryInterface{
    if (!_learningMatarilasCategoryInterface) {
        _learningMatarilasCategoryInterface = [[LearningMatarilasCategoryInterface alloc] init];
        _learningMatarilasCategoryInterface.delegate = self;
    }
    return _learningMatarilasCategoryInterface;
}

-(DRTreeTableView *)treeView{
    if(!_treeView){
        _treeView = [[DRTreeTableView alloc] initWithFrame:CGRectMake(320,IP5(65, 55), 200, SCREEN_HEIGHT - IP5(63, 50) - IP5(65, 55)) withTreeNodeArr:nil];
        _treeView.delegate = self;
        [_treeView setBackgroundColor:[UIColor colorWithRed:6.0/255.0 green:18.0/255.0 blue:27.0/255.0 alpha:1.0]];
        [self.view addSubview:_treeView];
    }
    return _treeView;
}

#pragma mark --


#pragma mark LearningMatarilasCategoryInterfaceDelegate加载资料分类列表
-(void)getLearningMatarilasCategoryDataDidFinished:(NSArray *)categoryLearningMatarilas{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.treeView.noteArr = [NSMutableArray arrayWithArray:categoryLearningMatarilas];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

-(void)getLearningMatarilasCategoryDataFailure:(NSString *)errorMsg{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utility errorAlert:errorMsg];
    });
}
#pragma mark --

#pragma mark DRTreeTableViewDelegate //选择一个分类
-(void)drTreeTableView:(DRTreeTableView *)treeView didSelectedTreeNode:(DRTreeNode *)selectedNote{
    self.isSearch = NO; // isLessonListForCategory
    self.lessonCategoryId = selectedNote.noteContentID;
    self.menuVisible = NO;
    self.searchBar.searchTextField.text = nil;
}

-(BOOL)drTreeTableView:(DRTreeTableView *)treeView isExtendChildSelectedTreeNode:(DRTreeNode *)selectedNote{
    return YES;
}

-(void)drTreeTableView:(DRTreeTableView*)treeView didExtendChildTreeNode:(DRTreeNode*)extendNote{
    self.isSearch = NO; // isLessonListForCategory
    self.lessonCategoryId = extendNote.noteContentID;
    self.searchBar.searchTextField.text = nil;
}

-(void)drTreeTableView:(DRTreeTableView*)treeView didCloseChildTreeNode:(DRTreeNode*)extendNote{
    
}

#pragma mark --

#pragma mark -- ChapterSearchBarDelegate
-(void)chapterSeachBar_iPhone:(ChapterSearchBar_iPhone*)searchBar beginningSearchString:(NSString*)searchText{
    if (self.searchBar.searchTextField.text.length == 0) {
        [Utility errorAlert:@"请输入搜索内容!"];
    }else {
        [self.searchBar.searchTextField resignFirstResponder];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
            if ([networkStatus isEqualToString:@"NotReachable"]) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [Utility errorAlert:@"暂无网络"];
            }else{
                //            self.isSearching = YES;
                [self searchButtonClicked:nil];
                [self.searchMaterialInterface searchLearningMaterilasListWithUserId:[CaiJinTongManager shared].userId withSearchContent:self.searchBar.searchTextField.text withPageIndex:0 withSortType:self.sortType];
            }
        }];
    }
}

-(void)chapterSeachBar_iPhone:(ChapterSearchBar_iPhone*)searchBar clearSearchString:(NSString*)searchText{

}
#pragma mark --
@end
