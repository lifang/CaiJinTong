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
@property (nonatomic,strong) SearchLessonInterface *searchLessonInter;
@property (nonatomic,strong) MJRefreshHeaderView *headerRefreshView;
@property (nonatomic,strong) MJRefreshFooterView *footerRefreshView;
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
    flowLayout.minimumLineSpacing = 30;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.itemSize = (CGSize){300, 270};
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 50, 50, 17);
    [self.collectionView setCollectionViewLayout:flowLayout];
    [self.headerRefreshView endRefreshing];
    self.headerRefreshView.isForbidden = NO;
    [self.footerRefreshView endRefreshing];
    self.footerRefreshView.isForbidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerClass:[CollectionCell class] forCellWithReuseIdentifier:@"cell"];
//    self.dataArray = [NSMutableArray arrayWithArray:[TestModelData getLessonArr]];//测试数据
    [self initCollectionView];
    
    self.searchBar = [[ChapterSearchBar alloc] initWithFrame:(CGRect){50, 54, (self.view.frame.size.width - 200 - 100), 70}];
    self.searchBar.delegate = self;
    self.searchBar.searchTextField.returnKeyType = UIReturnKeySearch;
    [self.searchBar.searchTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.view addSubview:self.searchBar];
    [self.searchBar setHidden:!self.isSearch];

    [self.drnavigationBar.navigationRightItem setHidden:YES];
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

#pragma mark ChapterSearchBarDelegate
-(void)chapterSeachBar:(ChapterSearchBar *)searchBar beginningSearchString:(NSString *)searchText{
    if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
        [Utility errorAlert:@"暂无网络!"];
    }else {
        if (!self.oldSearchText) {
            self.oldSearchText = searchText;
        }
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.searchLessonInter getSearchLessonInterfaceDelegateWithUserId:[[CaiJinTongManager shared] userId] andText:searchText withPageIndex:0 withSortType:self.sortType];
    } 
}
#pragma mark --

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


#pragma mark-- 筛选
//学习进度
- (void)bubbleSort:(NSMutableArray *)array {
    int i, y;
    BOOL bFinish = YES;
    for (i = 1; i<= [array count] && bFinish; i++) {
        bFinish = NO;
        for (y = (int)[array count]-1; y>=i; y--) {
            LessonModel *section1 = (LessonModel *)[array objectAtIndex:y];
            LessonModel *section2 = (LessonModel *)[array objectAtIndex:y-1];
            if (([section1.lessonStudyProgress floatValue] - [section2.lessonStudyProgress floatValue])<0.000001) {
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
        
        LessonModel *section = (LessonModel *)[array objectAtIndex:i];
        chineseString.string=[NSString stringWithString:section.lessonName];
        
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
            LessonModel *section = (LessonModel *)[array objectAtIndex:k];
            if ([string isEqualToString:section.lessonName]) {
                [self.dataArray addObject:section];
            }
        }
    }
}


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

-(SearchLessonInterface *)searchLessonInter{
    if (!_searchLessonInter) {
        _searchLessonInter = [[SearchLessonInterface alloc]init];
        _searchLessonInter.delegate = self;
    }
    return _searchLessonInter;
}

#pragma mark MJRefreshBaseViewDelegate 分页加载
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    if (self.isSearch) {
                [self.searchLessonInter getSearchLessonInterfaceDelegateWithUserId:[[CaiJinTongManager shared] userId] andText:self.oldSearchText withPageIndex:self.searchLessonInter.currentPageIndex+1 withSortType:self.sortType];
    }else{
        if (self.headerRefreshView == refreshView) {
            self.footerRefreshView.isForbidden = YES;
            UserModel *user = [[CaiJinTongManager shared] user];
            [self.lessonListForCategory downloadLessonListForCategoryId:nil withUserId:user.userId withPageIndex:0 withSortType:self.sortType];
        }else{
            self.headerRefreshView.isForbidden = YES;
            UserModel *user = [[CaiJinTongManager shared] user];
            [self.lessonListForCategory downloadLessonListForCategoryId:self.lessonCategoryId withUserId:user.userId withPageIndex:self.lessonListForCategory.currentPageIndex+1 withSortType:self.sortType];;
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
         [self.searchBar addSearchText:self.oldSearchText];
        [self.headerRefreshView endRefreshing];
        self.headerRefreshView.isForbidden = NO;
        [self.footerRefreshView endRefreshing];
        self.footerRefreshView.isForbidden = NO;
        [Utility errorAlert:errorMsg];
    });
}

#pragma mark --

#pragma mark -- ChapterInfoInterfaceDelegate

-(void)getChapterInfoDidFinished:(NSDictionary *)result {  //章节信息查询完毕,显示章节界面
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (![[result objectForKey:@"sectionList"]isKindOfClass:[NSNull class]] && [result objectForKey:@"sectionList"]!=nil) {
                NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:[result objectForKey:@"sectionList"]];
                [self reloadDataWithDataArray:[TestModelData getLessonArr] withCategoryId:self.lessonCategoryId];
            }else{
                self.searchBar.searchTipLabel.text = @"无搜索结果";
            }
        });
    });
}
-(void)getChapterInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.searchBar.searchTipLabel.text = @"无搜索结果";
    [Utility errorAlert:errorMsg];
}
#pragma mark -- CollectionHeaderDelegate
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
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    CollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CollectionHeader" forIndexPath:indexPath];
    
    header.delegate = self;
    return header;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    LessonModel *lesson = (LessonModel *)[self.dataArray objectAtIndex:indexPath.row];
    cell.contentView.backgroundColor = [UIColor clearColor];
    //名称
    cell.nameLab.text = [NSString stringWithFormat:@"%@",lesson.lessonName];
    //视频封面
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",lesson.lessonImageURL]];
    [cell.imageView setImageWithURL:url placeholderImage:Image(@"loginBgImage_v.png")];
    //学习进度
    CGFloat xx = [lesson.lessonStudyProgress floatValue];
    if ( xx-100 >0) {
        xx=100;
    }
    if (!xx) {
        xx = 0;
    }
    cell.pv.value = xx;
    //
    cell.progressLabel.text = [NSString stringWithFormat:@"学习进度:%.2f%%",xx];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = CGSizeMake(568, 44);
    return size;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return TRUE;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    LessonModel *lesson = (LessonModel *)[self.dataArray objectAtIndex:indexPath.row];
    [self getLessonInfoWithLessonId:lesson.lessonId];
}

@end
