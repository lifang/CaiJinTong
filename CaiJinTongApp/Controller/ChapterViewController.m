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
    flowLayout.itemSize = (CGSize){250, 215};
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 17, 35, 17);
    [self.collectionView setCollectionViewLayout:flowLayout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerClass:[CollectionCell class] forCellWithReuseIdentifier:@"cell"];
    self.dataArray = [NSMutableArray arrayWithArray:[TestModelData getLessonArr]];//测试数据
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

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGRect frame = self.collectionView.frame;
    if (self.isSearch) {
        frame.origin.y = 144;
        frame.size.height = 1024-144;
    }else {
        frame.origin.y = 54;
        frame.size.height = 1024-54;
    }
    self.collectionView.frame = frame;
}

-(void)reloadDataWithDataArray:(NSArray*)data{
    self.recentArray = data;
    DLog(@"count = %d",data.count);
    if (self.recentArray.count>0) {
        self.dataArray = [NSMutableArray arrayWithArray:self.recentArray];
        dispatch_async(dispatch_get_main_queue(),  ^{
            [self.collectionView reloadData];
        });
        
    }
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
        LessonModel *section = (LessonModel *)result;
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
        dispatch_async(dispatch_get_main_queue(),  ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (![[result objectForKey:@"sectionList"]isKindOfClass:[NSNull class]] && [result objectForKey:@"sectionList"]!=nil) {
                NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:[result objectForKey:@"sectionList"]];
                [self reloadDataWithDataArray:[TestModelData getLessonArr]];
                
            }else{
             [self.searchBar addSearchText:self.oldSearchText];
            }
        });
    });
}

-(void)getSearchLessonInfoDidFailed:(NSString *)errorMsg{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.searchBar addSearchText:self.oldSearchText];
    [Utility errorAlert:errorMsg];
}
#pragma mark --

#pragma mark -- ChapterInfoInterfaceDelegate

-(void)getChapterInfoDidFinished:(NSDictionary *)result {  //章节信息查询完毕,显示章节界面
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (![[result objectForKey:@"sectionList"]isKindOfClass:[NSNull class]] && [result objectForKey:@"sectionList"]!=nil) {
                NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:[result objectForKey:@"sectionList"]];
                [self reloadDataWithDataArray:[TestModelData getLessonArr]];
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
    [self initButton:button withCollectionHeaderView:toolbar];
    self.dataArray = nil;
    self.dataArray = [NSMutableArray arrayWithArray:self.recentArray];
    [self.collectionView reloadData];
}
//学习进度
- (void)tappedInToolbar:(CollectionHeader *)toolbar progressButton:(UIButton *)button {
    if (self.progressArray.count >0) {
        [self initButton:button withCollectionHeaderView:toolbar];
        self.dataArray = [NSMutableArray arrayWithArray:self.progressArray];
        [self.collectionView reloadData];
    }else {
        if (self.dataArray.count>0) {
            [self bubbleSort:self.dataArray];
            [self initButton:button withCollectionHeaderView:toolbar];
            self.progressArray = [NSArray arrayWithArray:self.dataArray];
            [self.collectionView reloadData];
        }
    }
}
//名称(A-Z)
- (void)tappedInToolbar:(CollectionHeader *)toolbar nameButton:(UIButton *)button {
    if (self.nameArray.count>0) {
        [self initButton:button withCollectionHeaderView:toolbar];
        self.dataArray = [NSMutableArray arrayWithArray:self.nameArray];
        [self.collectionView reloadData];
    }else {
        if (self.dataArray.count>0) {
            [self letterSort:self.dataArray];
            [self initButton:button withCollectionHeaderView:toolbar];
            self.nameArray = [NSArray arrayWithArray:self.dataArray];
            [self.collectionView reloadData];
        }
    }
}

#pragma mark -- UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqual:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView  = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CollectionHeader" forIndexPath:indexPath];
        return headerView;
    }
    return nil;
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
//    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
//    SectionViewController *sectionView = [story instantiateViewControllerWithIdentifier:@"SectionViewController"];
//    [self.navigationController pushViewController:sectionView animated:YES];
//    return;
    LessonModel *lesson = (LessonModel *)[self.dataArray objectAtIndex:indexPath.row];
    AppDelegate *app = [AppDelegate sharedInstance];
    if (app.isLocal == YES) {
//        Section *sectionDb = [[Section alloc]init];
//        //笔记
//        NSArray *noteArray = [sectionDb getNoteInfoWithSid:section.sectionId];
//        section.noteList = [[NSMutableArray alloc]initWithArray:noteArray];
//        //章节下载列表
//        NSArray *section_chapterArray = [sectionDb getChapterInfoWithSid:section.sectionId];
//        section.sectionList  =[[NSMutableArray alloc]initWithArray:section_chapterArray];
//        
//        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
//        SectionViewController *sectionView = [story instantiateViewControllerWithIdentifier:@"SectionViewController"];
//        sectionView.section = section;
//        [self.navigationController pushViewController:sectionView animated:YES];
        
    }else {
        //根据sectionID获取单个视频的详细信息
        if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
            [Utility errorAlert:@"暂无网络!"];
        }else {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            SectionInfoInterface *sectionInter = [[SectionInfoInterface alloc]init];
            self.sectionInterface = sectionInter;
            self.sectionInterface.delegate = self;
            [self.sectionInterface getSectionInfoInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andSectionId:lesson.lessonId];
        }
    }
}

@end
