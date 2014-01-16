//
//  ChapterViewController.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-4.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "ChapterViewController.h"
#import "ChineseString.h"
#import "pinyin.h"
#import "NoteModel.h"
#import "CommentModel.h"
#import "SectionViewController.h"
#import "Section.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "CollectionHeader.h"

#define ItemWidth 250
#define ItemWidthSpace 23
#define ItemHeight 215
#define ItemHeightSpace 4
#define ItemLabel 30
@interface ChapterViewController ()
@property (nonatomic,strong) SearchLessonInterface *searchLessonInterface;
@property (nonatomic,strong) MJRefreshHeaderView *headerRefreshView;
@property (nonatomic,strong) MJRefreshFooterView *footerRefreshView;
@property (assign,nonatomic) BOOL isSearch;//是否是搜索
@property (nonatomic,strong) NSString *searchContent;//搜索之前字符串
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
    if (platform >= 7.0) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    }else{
        CGPoint offset = self.collectionView.contentOffset;
        [self.collectionView setContentOffset:offset animated:NO];
    }
}


-(void)drnavigationBarRightItemClicked:(id)sender{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftRight];
}

-(void)initCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 20;
    flowLayout.minimumInteritemSpacing = 20;
    flowLayout.itemSize = (CGSize){200, 210};
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.collectionView setCollectionViewLayout:flowLayout];
    [self.headerRefreshView endRefreshing];
    self.headerRefreshView.isForbidden = NO;
    [self.footerRefreshView endRefreshing];
    self.footerRefreshView.isForbidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.dataArray = [NSMutableArray arrayWithArray:[TestModelData getLessonArr]];//测试数据
    [self initCollectionView];
    self.drnavigationBar.searchBar.searchTextLabel.placeholder = @"搜索课程";
    [self.drnavigationBar hiddleBackButton:YES];
    self.drnavigationBar.titleLabel.text = @"课程";
}

//-(void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    CGRect frame = self.collectionView.frame;
//    if (self.isSearch) {
//        frame.origin.y = 144;
//        frame.size.height = 1024-144;
//    }else {
//        frame.origin.y = 54;
//        frame.size.height = 1024-54;
//    }
//    self.collectionView.frame = frame;
//}

-(void)reloadDataWithDataArray:(NSArray*)data withCategoryId:(NSString*)lessonCategoryId{
    self.lessonCategoryId = lessonCategoryId;
    DLog(@"count = %d",data.count);
    self.dataArray = [NSMutableArray arrayWithArray:data];
    dispatch_async(dispatch_get_main_queue(),  ^{
        [self.collectionView reloadData];
    });
}

//加载下一页数据
-(void)loadNextPageDataWithDataArray:(NSArray*)data withCategoryId:(NSString*)lessonCategoryId{
    DLog(@"count = %d",data.count);
    [self.dataArray addObjectsFromArray:data];
    dispatch_async(dispatch_get_main_queue(),  ^{
        [self.collectionView reloadData];
    });
}


#pragma -- 页面布局
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark action
//加载课程详细信息
-(void)getLessonInfoWithLessonId:(NSString*)lessonId{
    if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
        [Utility errorAlert:@"暂无网络!"];
    }else{
        UserModel *user = [[CaiJinTongManager shared] user];
        [self.lessonInterface downloadLessonInfoWithLessonId:lessonId withUserId:user.userId];
    }
}
#pragma mark --

#pragma mark DRSearchBarDelegate搜索
-(void)drSearchBar:(DRSearchBar *)searchBar didBeginSearchText:(NSString *)searchText{
    self.isSearch = YES;
    UserModel *user = [[CaiJinTongManager shared] user];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.searchContent = searchText;
    [self.searchLessonInterface getSearchLessonInterfaceDelegateWithUserId:user.userId andText:self.searchContent withPageIndex:self.searchLessonInterface.currentPageIndex+1 withSortType:self.sortType];
}

-(void)drSearchBar:(DRSearchBar *)searchBar didCancelSearchText:(NSString *)searchText{
    self.isSearch = NO;
    [self.collectionView reloadData];
}
#pragma mark --

#pragma mark sort 排序
- (IBAction)studyProgressSortBtClicked:(id)sender {
    self.sortType = LESSONSORTTYPE_ProgressStudy;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UserModel *user = [[CaiJinTongManager shared] user];
    if (self.isSearch) {
        [self.searchLessonInterface getSearchLessonInterfaceDelegateWithUserId:user.userId andText:self.searchContent withPageIndex:0 withSortType:self.sortType];
    }else{
        
        [self.lessonListForCategory downloadLessonListForCategoryId:self.lessonCategoryId withUserId:user.userId withPageIndex:0 withSortType:self.sortType];
    }
    
}
- (IBAction)defaultSortBtClicked:(id)sender {
    self.sortType = LESSONSORTTYPE_CurrentStudy;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UserModel *user = [[CaiJinTongManager shared] user];
    if (self.isSearch) {
        [self.searchLessonInterface getSearchLessonInterfaceDelegateWithUserId:user.userId andText:self.searchContent withPageIndex:0 withSortType:self.sortType];
    }else{
        
        [self.lessonListForCategory downloadLessonListForCategoryId:self.lessonCategoryId withUserId:user.userId withPageIndex:0 withSortType:self.sortType];
    }
    
}
- (IBAction)nameSortBtClicked:(id)sender {
    self.sortType = LESSONSORTTYPE_LessonName;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UserModel *user = [[CaiJinTongManager shared] user];
    if (self.isSearch) {
        [self.searchLessonInterface getSearchLessonInterfaceDelegateWithUserId:user.userId andText:self.searchContent withPageIndex:0 withSortType:self.sortType];
    }else{
        
        [self.lessonListForCategory downloadLessonListForCategoryId:self.lessonCategoryId withUserId:user.userId withPageIndex:0 withSortType:self.sortType];
    }
}

#pragma mark --

#pragma mark -- SectionInfoInterface
-(void)getSectionInfoDidFinished:(LessonModel *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        LessonModel *lesson = (LessonModel *)result;
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
            SectionViewController *sectionView = [story instantiateViewControllerWithIdentifier:@"SectionViewController"];
            sectionView.lessonModel = lesson;
            [self.navigationController pushViewController:sectionView animated:YES];
        });
    });
}
-(void)getSectionInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}


#pragma mark property

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


//-(void)setIsSearch:(BOOL)isSearch{
//    _isSearch = isSearch;
//    [self.searchBar setHidden:!isSearch];
//    [self.mainToolBar setHidden:isSearch];
//    
//    UIBarButtonItem *tempBarButtonItem = (UIBarButtonItem *)self.navigationItem.backBarButtonItem;
//    tempBarButtonItem.target = self;
//
//    if(self.isSearch){
//        tempBarButtonItem.title = @"搜索";
//    }else{
//        tempBarButtonItem.title = @"返回";
//    }
//}

-(LessonInfoInterface *)lessonInterface{
    if (!_lessonInterface) {
        _lessonInterface = [[LessonInfoInterface alloc] init];
        _lessonInterface.delegate = self;
    }
    return _lessonInterface;
}

-(LessonListForCategory *)lessonListForCategory{
    if (!_lessonListForCategory) {
        _lessonListForCategory = [[LessonListForCategory alloc] init];
        _lessonListForCategory.delegate = self;
    }
    return _lessonListForCategory;
}

-(SearchLessonInterface *)searchLessonInterface{
    if (!_searchLessonInterface) {
        _searchLessonInterface = [[SearchLessonInterface alloc]init];
        _searchLessonInterface.delegate = self;
    }
    return _searchLessonInterface;
}

#pragma mark MJRefreshBaseViewDelegate 分页加载
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    if (self.headerRefreshView == refreshView) {
        self.footerRefreshView.isForbidden = YES;
        UserModel *user = [[CaiJinTongManager shared] user];
        if (self.isSearch) {
            [self.searchLessonInterface getSearchLessonInterfaceDelegateWithUserId:[[CaiJinTongManager shared] userId] andText:self.searchContent withPageIndex:0 withSortType:self.sortType];
        }else{
            [self.lessonListForCategory downloadLessonListForCategoryId:nil withUserId:user.userId withPageIndex:0 withSortType:self.sortType];
        }
    }else{
        self.headerRefreshView.isForbidden = YES;
        UserModel *user = [[CaiJinTongManager shared] user];
        if (self.isSearch) {
            [self.searchLessonInterface getSearchLessonInterfaceDelegateWithUserId:[[CaiJinTongManager shared] userId] andText:self.searchContent withPageIndex:self.searchLessonInterface.currentPageIndex+1 withSortType:self.sortType];
        }else{
            [self.lessonListForCategory downloadLessonListForCategoryId:self.lessonCategoryId withUserId:user.userId withPageIndex:self.lessonListForCategory.currentPageIndex+1 withSortType:self.sortType];
        }
    }

}

#pragma mark --


#pragma mark-- LessonInfoInterfaceDelegate加载课程详细信息
-(void)getLessonInfoDidFinished:(LessonModel*)lesson{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        SectionViewController *sectionView = [story instantiateViewControllerWithIdentifier:@"SectionViewController"];
        sectionView.lessonModel = lesson;
        [self.navigationController pushViewController:sectionView animated:YES];
    });
}
-(void)getLessonInfoDidFailed:(NSString *)errorMsg{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utility errorAlert:errorMsg];
    });
   
}

#pragma mark --

#pragma mark LessonListForCategoryDelegate 根据分类获取课程信息
-(void)getLessonListDataForCategoryDidFinished:(NSArray *)lessonList withCurrentPageIndex:(int)pageIndex withTotalCount:(int)allDataCount{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (pageIndex > 0) {
            [self loadNextPageDataWithDataArray:lessonList withCategoryId:self.lessonCategoryId];
        }else{
            [self  reloadDataWithDataArray:lessonList withCategoryId:self.lessonCategoryId];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.headerRefreshView endRefreshing];
        self.headerRefreshView.isForbidden = NO;
        [self.footerRefreshView endRefreshing];
        self.footerRefreshView.isForbidden = NO;
    });
}

-(void)getLessonListDataForCategoryFailure:(NSString *)errorMsg{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.headerRefreshView endRefreshing];
        self.headerRefreshView.isForbidden = NO;
        [self.footerRefreshView endRefreshing];
        self.footerRefreshView.isForbidden = NO;
        [Utility errorAlert:errorMsg];
    });
}

#pragma mark --

#pragma mark SearchLessonInterfaceDelegate
-(void)getSearchLessonListDataForCategoryDidFinished:(NSArray *)lessonList withCurrentPageIndex:(int)pageIndex withTotalCount:(int)allDataCount{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (pageIndex > 0) {
            [self loadNextPageDataWithDataArray:lessonList withCategoryId:self.lessonCategoryId];
        }else{
            [self  reloadDataWithDataArray:lessonList withCategoryId:self.lessonCategoryId];
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
        [self.headerRefreshView endRefreshing];
        self.headerRefreshView.isForbidden = NO;
        [self.footerRefreshView endRefreshing];
        self.footerRefreshView.isForbidden = NO;
        [Utility errorAlert:errorMsg];
    });
}

#pragma mark --
//按学习进度排序
-(void)initButton:(UIButton *)button  withCollectionHeaderView:(CollectionHeader*)header{
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSArray *subViews = [header subviews];
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
- (void)tappedInToolbar:(CollectionHeader *)toolbar recentButton:(UIButton *)button {
    if (self.headerRefreshView.isForbidden || self.headerRefreshView.isForbidden) {
        return;
    }
    [self initButton:button withCollectionHeaderView:toolbar];
    self.sortType = LESSONSORTTYPE_CurrentStudy;
    UserModel *user = [[CaiJinTongManager shared] user];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.lessonListForCategory downloadLessonListForCategoryId:nil withUserId:user.userId withPageIndex:0 withSortType:self.sortType];
}
//学习进度
- (void)tappedInToolbar:(CollectionHeader *)toolbar progressButton:(UIButton *)button {
    if (self.headerRefreshView.isForbidden || self.headerRefreshView.isForbidden) {
        return;
    }
    [self initButton:button withCollectionHeaderView:toolbar];
    self.sortType = LESSONSORTTYPE_ProgressStudy;
    UserModel *user = [[CaiJinTongManager shared] user];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.lessonListForCategory downloadLessonListForCategoryId:nil withUserId:user.userId withPageIndex:0 withSortType:self.sortType];
}
//名称(A-Z)
- (void)tappedInToolbar:(CollectionHeader *)toolbar nameButton:(UIButton *)button {
    if (self.headerRefreshView.isForbidden || self.headerRefreshView.isForbidden) {
        return;
    }
    [self initButton:button withCollectionHeaderView:toolbar];
    self.sortType = LESSONSORTTYPE_LessonName;
    UserModel *user = [[CaiJinTongManager shared] user];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.lessonListForCategory downloadLessonListForCategoryId:nil withUserId:user.userId withPageIndex:0 withSortType:self.sortType];
}

#pragma mark -- UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    LessonModel *lesson = (LessonModel *)[self.dataArray objectAtIndex:indexPath.row];
    [cell changeLessonModel:lesson];
    return cell;
    
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    CGSize size = CGSizeMake(568, 44);
//    return size;
//}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return TRUE;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    LessonModel *lesson = (LessonModel *)[self.dataArray objectAtIndex:indexPath.row];
    [self getLessonInfoWithLessonId:lesson.lessonId];
}

@end
