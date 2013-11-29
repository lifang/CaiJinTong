//
//  LessonViewController_iPhone.m
//  CaiJinTongApp
//
//  Created by apple on 13-11-25.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "LessonViewController_iPhone.h"
#define CELL_REUSE_IDENTIFIER @"CollectionCell"

@implementation LessonViewController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -- init settings
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setCollectionView];
    [self initData];
    [self setTabBar];
    if(!self.searchBar){
        self.searchBar = [[ChapterSearchBar_iPhone alloc] init];
        self.searchBar.frame = CGRectMake(19, 78, 282, 34);
        [self.view addSubview:self.searchBar];
    }
    
    CJTMainToolbar_iPhone *mainBar = [[CJTMainToolbar_iPhone alloc]initWithFrame:CGRectMake (19, 125, 281, 40)];
	self.mainToolBar = mainBar;
    self.mainToolBar.delegate = self;
    [self.view addSubview:self.mainToolBar];
    
    
}

//collectionView加载设置
-(void)setCollectionView{
    [self.collectionView setPagingEnabled:YES];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELL_REUSE_IDENTIFIER];
    //定制布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(160, 153);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    self.collectionView.collectionViewLayout = flowLayout;
}

//加载数据

-(void) initData{
    chapterModel *chapter = [[chapterModel alloc] init];
    chapter.chapterId = @"3323";
    if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
        [Utility errorAlert:@"暂无网络!"];
    }else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        ChapterInfoInterface *chapterInter = [[ChapterInfoInterface alloc]init];
        self.chapterInterface = chapterInter;
        self.chapterInterface.delegate = self;
        [self.chapterInterface getChapterInfoInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andChapterId:chapter.chapterId];
    }

}

//设置tabBar
-(void)setTabBar{
    UITabBar *bar = self.tabBarController.tabBar;
    [bar setFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 63, 320, 63)];
    bar.layer.contents = (id)[UIImage imageNamed:@"barbg.png"].CGImage ;
    [bar setTintColor:[UIColor colorWithRed:10.0/255.0 green:35.0/255.0 blue:56.0/255.0 alpha:1.0]];
    [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"play-table.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"play-table.png"]];
    
}

//-(void) initData{
//    //测试版 此方法从json中加载lessonList和chapterList
//    self.lessonList = [NSMutableArray arrayWithCapacity:5];
//    NSString *lessonJSONPath = [NSBundle pathForResource:@"lessonInfo" ofType:@"json" inDirectory:[[NSBundle mainBundle] bundlePath]];
//    NSData *lessonData = [NSData dataWithContentsOfFile:lessonJSONPath];
//    id lessonJsonData = [NSJSONSerialization JSONObjectWithData:lessonData options:NSJSONReadingAllowFragments error:nil];
//    if(lessonData != nil && [lessonJsonData isKindOfClass:[NSDictionary class]]){
//        NSDictionary *lessonDic = [NSDictionary dictionaryWithDictionary:(NSDictionary *)lessonJsonData];
//        if (lessonDic) {
//            if ([[lessonDic objectForKey:@"Status"]intValue] == 1) {
//                NSDictionary *dictionary =[lessonDic objectForKey:@"ReturnObject"];
//                    if (dictionary) {
//                        //课程列表
//                        if (![[dictionary objectForKey:@"lessonList"]isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"lessonList"]!=nil) {
//                            NSArray *array = [dictionary objectForKey:@"lessonList"];//lessonList
//                            if (array.count>0) {
//                                for (int i=0; i<array.count; i++) {
//                                    NSDictionary *dic_lessoon = [array objectAtIndex:i];//lesson
//                                    LessonModel *lesson = [[LessonModel alloc]init];
//                                    lesson.lessonId = [NSString stringWithFormat:@"%@",[dic_lessoon objectForKey:@"lessonId"]];
//                                    lesson.lessonName = [NSString stringWithFormat:@"%@",[dic_lessoon objectForKey:@"lessonName"]];
//                                    NSArray *arr_chapter = [dic_lessoon objectForKey:@"chapterList"];//chapterList
//                                    if (arr_chapter.count >0) {
//                                        lesson.chapterList = [[NSMutableArray alloc]init];
//                                        for (int k=0; k<arr_chapter.count; k++) {
//                                            NSDictionary *dic_chapter = [arr_chapter objectAtIndex:k];
//                                            chapterModel *chapter = [[chapterModel alloc]init];
//                                            chapter.chapterId = [NSString stringWithFormat:@"%@",[dic_chapter objectForKey:@"chapterId"]];
//                                            chapter.chapterName = [NSString stringWithFormat:@"%@",[dic_chapter objectForKey:@"chapterName"]];
//                                            chapter.chapterImg =[NSString stringWithFormat:@"%@",@"pdlay-courselistd_07.png"];//json中无此数据 ,随意写一个
//                                            [lesson.chapterList addObject:chapter];
//                                        }
//                                    }
//                                    [self.lessonList  addObject:lesson];
//                                }
//                            }
//                        }
//                    }
//            }
//        }
//    }
//    LessonModel *temp = self.lessonList[1];
//    self.chapterList = [NSMutableArray arrayWithArray:temp.chapterList];
//    DLog(@"%@ self.chapterList",self.chapterList);
//}



#pragma mark --ChapterInfoDelegate
-(void)getChapterInfoDidFinished:(NSDictionary *)result {  //章节信息查询完毕,显示章节界面
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (![[result objectForKey:@"sectionList"]isKindOfClass:[NSNull class]] && [result objectForKey:@"sectionList"]!=nil) {
                self.recentArray = [[NSMutableArray alloc]initWithArray:[result objectForKey:@"sectionList"]];
                self.sectionList = self.recentArray;
                [self.collectionView reloadData];
            }
        });
    });
}
-(void)getChapterInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}



#pragma mark --CollectionViewDelegate
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
    
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return self.sectionList.count;
    return 8;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_REUSE_IDENTIFIER forIndexPath:indexPath];
    self.sectionCustomView = [[SectionCustomView_iPhone alloc] initWithFrame:CGRectMake(18, 0, 125, 125) andSection:(SectionModel *)self.sectionList[0] andItemLabel:20];
//    self.sectionCustomView = [[SectionCustomView_iPhone alloc] initWithFrame:CGRectMake(18, 0, 125, 125) andSection:(SectionModel *)self.sectionList[indexPath.row] andItemLabel:20];
    [self.sectionCustomView addTarget:self action:@selector(cellClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell setBackgroundColor:[UIColor greenColor]];
    cell.clipsToBounds = YES;
    [cell.contentView addSubview:self.sectionCustomView];
    return cell;
}
//绘制cell  (注:  160*153)
//- (void) drawCollectionViewCell:(UICollectionViewCell *) cell index:(NSInteger) row{
//    
//}

- (void) cellClicked:(id)sender{
    DLog(@"%@",sender);
}


#pragma mark -- CJTMainToolbar_iPhoneDelegate
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

//最近播放(默认)
- (void)tappedInToolbar:(CJTMainToolbar_iPhone *)toolbar recentButton:(UIButton *) button{
    [self initButton:button];
    self.sectionList = nil;
    self.sectionList = [NSMutableArray arrayWithArray:self.recentArray];
    [self displayNewView];
}
//学习进度
- (void)tappedInToolbar:(CJTMainToolbar_iPhone *)toolbar progressButton:(UIButton *)button {
    if (self.progressArray.count >0) {
        [self initButton:button];
        self.sectionList = [NSMutableArray arrayWithArray:self.progressArray];
        [self displayNewView];
    }else {
        if (self.sectionList.count>0) {
            [self bubbleSort:self.sectionList];
            [self initButton:button];
            self.progressArray = [NSArray arrayWithArray:self.sectionList];
            [self displayNewView];
        }
    }
}
//名称(A-Z)
- (void)tappedInToolbar:(CJTMainToolbar_iPhone *)toolbar nameButton:(UIButton *)button {
    if (self.nameArray.count>0) {
        [self initButton:button];
        self.sectionList = [NSMutableArray arrayWithArray:self.nameArray];
        [self displayNewView];
    }else {
        if (self.sectionList.count>0) {
            [self letterSort:self.sectionList];
            [self initButton:button];
            self.nameArray = [NSArray arrayWithArray:self.sectionList];
            [self displayNewView];
        }
    }
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
    self.sectionList = nil;
    self.sectionList = [[NSMutableArray alloc]init];
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
                [self.sectionList addObject:section];
            }
        }
    }
}


#pragma -- 页面布局

-(void)displayNewView {
    [self.collectionView reloadData];
//    [self.myScrollView removeFromSuperview];
//    if (self.sectionList.count>0) {
//        NSInteger count = ([self.sectionList count]-1)/6+1;
//        self.myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 148, self.view.frame.size.width, self.view.frame.size.height-50)];
//        
//        self.myScrollView.delegate = self;
//        self.myScrollView.contentSize = CGSizeMake(self.myScrollView.frame.size.width, self.myScrollView.frame.size.height*count);
//        [self.myScrollView setPagingEnabled:YES];
//        self.myScrollView.showsVerticalScrollIndicator = NO;
//        self.myScrollView.showsHorizontalScrollIndicator = NO;
//        self.myScrollView.backgroundColor = [UIColor clearColor];
//        [self.view addSubview:self.myScrollView];
//        
//        for (int i=0; i<count; i++) {
//            self.myTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0+self.myScrollView.frame.size.height*i, self.myScrollView.frame.size.width, self.myScrollView.frame.size.height)];
//            self.myTable.tag = i;
//            self.myTable.delegate = self;
//            self.myTable.dataSource = self;
//            self.myTable.scrollEnabled = NO;
//            self.myTable.backgroundColor = [UIColor clearColor];
//            [self.myScrollView addSubview:self.myTable];
//        }
//        CGRect frame = [self.view bounds];
//        frame.origin.y = 0;
//        frame.origin.x = 0;
//        [self.myScrollView setContentOffset:CGPointMake(frame.origin.x, frame.origin.y)];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
