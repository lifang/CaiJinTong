//
//  ShowDownloadDataViewController.m
//  CaiJinTongApp
//
//  Created by david on 14-4-10.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "ShowDownloadDataViewController.h"
#import "CollectionCell.h"
#import "SectionViewController.h"
@interface ShowDownloadDataViewController ()

@property (weak, nonatomic) IBOutlet UIView *lessonBackView;
@property (weak, nonatomic) IBOutlet UIView *learningMaterialBackView;
///切换控件
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentView;
///显示资料列表
@property (weak, nonatomic) IBOutlet UITableView *tableView;
///展示课程列表
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
///课程搜索数组
@property (nonatomic,strong) NSMutableArray *searchLessonArray;
///资料搜索数组
@property (nonatomic,strong) NSMutableArray *searchLearningMaterialArray;

///课程数组
@property (nonatomic,strong) NSMutableArray *lessonDataArray;
///资料数组
@property (nonatomic,strong) NSMutableArray *learningMaterialDataArray;
///没有数据时提示
@property (weak, nonatomic) IBOutlet UILabel *tipLabelView;

@property (nonatomic,assign) BOOL isSearch;//搜索

///加载课程详细信息界面
@property (nonatomic,strong) SectionViewController *sectionViewController;

- (IBAction)segmentControlValueChanged:(id)sender;

@end

@implementation ShowDownloadDataViewController

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
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 20;
    flowLayout.minimumInteritemSpacing = 20;
    flowLayout.itemSize = (CGSize){200, 210};
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.collectionView setCollectionViewLayout:flowLayout];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//TODO:切换课程和资料
- (IBAction)segmentControlValueChanged:(id)sender {
    if (self.segmentView.selectedSegmentIndex == 0) {//显示课程
        [CaiJinTongManager shared].isShowLocalLessonData = YES;
        self.isShowLesson = YES;
        [self.lessonBackView setHidden:NO];
        [self.learningMaterialBackView setHidden:YES];
        [self reloadLessonDataFromDatabase];
    }else{//显示资料
        self.isShowLesson = NO;
        [CaiJinTongManager shared].isShowLocalLessonData = NO;
        [self.lessonBackView setHidden:YES];
        [self.learningMaterialBackView setHidden:NO];
        [self reloadLearningMaterialDataFromDataBase];
    }
}

///根据分类过滤
-(void)filterDataFromCategory:(DRTreeNode*)treeNote{
    NSMutableArray *resultArray = [NSMutableArray array];
    if (self.isShowLesson) {
        if ([[NSString stringWithFormat:@"%d",CategoryType_ALL] isEqualToString:treeNote.noteContentID]) {
            [self reloadLessonDataFromDatabase];
        }else{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [DRFMDBDatabaseTool selectDownloadedMovieFileLessonListWithUserId:[CaiJinTongManager shared].user.userId withFinished:^(NSArray *lessonArray, NSString *errorMsg) {
                [self.collectionView setContentOffset:(CGPoint){self.collectionView.contentOffset.x,0}];
                [self filterArrayData:[NSMutableArray arrayWithArray:lessonArray] withResultArray:resultArray withTreeNode:treeNote];
                self.lessonDataArray = resultArray;
                [self.collectionView reloadData];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
            
        }
        
       
    }else{
        if ([[NSString stringWithFormat:@"%d",CategoryType_ALL] isEqualToString:treeNote.noteContentID]) {
            [self reloadLearningMaterialDataFromDataBase];
        }else{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [DRFMDBDatabaseTool selectDownloadedLearningMaterialsListWithUserId:[CaiJinTongManager shared].user.userId withFinished:^(NSArray *learningMaterialsArray, NSString *errorMsg) {
                [self.tableView setContentOffset:(CGPoint){self.tableView.contentOffset.x,0}];
                [self filterArrayData:[NSMutableArray arrayWithArray:learningMaterialsArray] withResultArray:resultArray withTreeNode:treeNote];
                self.self.learningMaterialDataArray = resultArray;
                [self.tableView reloadData];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
        }
        
        
    }
}

-(void)filterArrayData:(NSMutableArray*)array withResultArray:(NSMutableArray*)resultArray withTreeNode:(DRTreeNode*)node{
    if (node && array && array.count > 0) {
        if (self.isShowLesson) {
            [resultArray addObjectsFromArray:[array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.lessonCategoryId=%@",node.noteContentID]]];
        }else{
            [resultArray addObjectsFromArray:[array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.materialLessonCategoryId=%@",node.noteContentID]]];
        }
        
        for (DRTreeNode *child in node.childnotes) {
            [self filterArrayData:array withResultArray:resultArray withTreeNode:child];
        }
    }
}

///从数据库加载课程信息
-(void)reloadLessonDataFromDatabase{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DRFMDBDatabaseTool selectDownloadedMovieFileLessonListWithUserId:[CaiJinTongManager shared].user.userId withFinished:^(NSArray *lessonArray, NSString *errorMsg) {
        self.lessonDataArray = [NSMutableArray arrayWithArray:lessonArray];
        [self.collectionView setContentOffset:(CGPoint){self.collectionView.contentOffset.x,0}];
        [self.collectionView reloadData];
        [self.tipLabelView setHidden:self.lessonDataArray.count <= 0?NO:YES];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:LoadLocalLessonCategory object:self userInfo:@{LoadLocalNotificationData: lessonArray}];
    }];
}

///从数据库加载资料信息
-(void)reloadLearningMaterialDataFromDataBase{
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DRFMDBDatabaseTool selectDownloadedLearningMaterialsListWithUserId:[CaiJinTongManager shared].user.userId withFinished:^(NSArray *learningMaterialsArray, NSString *errorMsg) {
        self.learningMaterialDataArray = [NSMutableArray arrayWithArray:learningMaterialsArray];
        [self.tableView setContentOffset:(CGPoint){self.tableView.contentOffset.x,0}];
        [self.tableView reloadData];
        [self.tipLabelView setHidden:self.learningMaterialDataArray.count <= 0?NO:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:LoadLocalLearningMaterialCategory object:self userInfo:@{LoadLocalNotificationData: learningMaterialsArray}];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
    LearningMaterials *material = self.isSearch?[self.searchLearningMaterialArray objectAtIndex:indexPath.row]:[self.learningMaterialDataArray objectAtIndex:indexPath.row];
    [cell setLearningMaterialData:material];
    if (indexPath.row%2 == 0) {
        cell.cellBackView.backgroundColor = [UIColor colorWithRed:235/255.0 green:245/255.0 blue:255/255.0 alpha:1];
    }else{
        cell.cellBackView.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.isSearch? [self.searchLearningMaterialArray count]:[self.learningMaterialDataArray count];
}


#pragma mark --


#pragma mark -- UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.lessonDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    LessonModel *lesson = (LessonModel *)[self.lessonDataArray objectAtIndex:indexPath.row];
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
    LessonModel *lesson = (LessonModel *)[self.lessonDataArray objectAtIndex:indexPath.row];
    
    self.sectionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SectionViewController"];
    self.sectionViewController.lessonModel = lesson;
    [CaiJinTongManager shared].lesson = lesson;
    [self.navigationController pushViewController:self.sectionViewController animated:YES];
    
}

#pragma mark --

#pragma mark LearningMaterialCellDelegate
-(void)learningMaterialCell:(LearningMaterialCell *)cell scanLearningMaterialFileAtIndexPath:(NSIndexPath *)path{
    LearningMaterials *material = self.isSearch?[self.searchLearningMaterialArray objectAtIndex:path.row]:[self.learningMaterialDataArray objectAtIndex:path.row];
    if (material.materialFileType == LearningMaterialsFileType_other || material.materialFileType == LearningMaterialsFileType_zip) {
        [Utility errorAlert:@"无法查看文件内容，请到电脑上下载查看！"];
    }else{
        UIWebView *webView = [[UIWebView alloc] initWithFrame:(CGRect){0,0,800,700}];
        webView.scrollView.minimumZoomScale = 0.5;
        webView.scrollView.maximumZoomScale = 2.0;
        webView.scalesPageToFit = YES;
        UIViewController *webController = [[UIViewController alloc]init];
        [webController.view addSubview:webView];
        webController.view.frame = (CGRect){0,0,800,700};
        [webView loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initFileURLWithPath:material.materialFileLocalPath]]];
        [self presentPopupViewController:webController animationType:MJPopupViewAnimationSlideTopTop isAlignmentCenter:YES dismissed:^{
            
        }];
    }
}

- (void)learningMaterialCell:(LearningMaterialCell *)cell deleteLearningMaterialFileAtIndexPath:(NSIndexPath *)path{
    LearningMaterials *material = self.isSearch?[self.searchLearningMaterialArray objectAtIndex:path.row]:[self.learningMaterialDataArray objectAtIndex:path.row];
    [DRFMDBDatabaseTool deleteMaterialWithUserId:[CaiJinTongManager shared].user.userId
                         withLearningMaterialsId:material.materialId
                                    withFinished:^(BOOL flag) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            NSIndexPath *newPath;
                                            if (self.isSearch) {
                                                newPath = [NSIndexPath indexPathForRow:[self.searchLearningMaterialArray indexOfObject:material] inSection:path.section];
                                                [self.searchLearningMaterialArray removeObject:material];
                                            }else{
                                                newPath = [NSIndexPath indexPathForRow:[self.learningMaterialDataArray indexOfObject:material] inSection:path.section];
                                                [self.learningMaterialDataArray removeObject:material];
                                            }
                                            [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
                                            dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, .4 * NSEC_PER_SEC);
                                            dispatch_queue_t concurrentQueue = dispatch_get_main_queue();
                                            dispatch_after(delayInNanoSeconds, concurrentQueue, ^{
                                                [self.tableView reloadData];
                                            });
                                            
                                        });
                                    }];
}

#pragma mark --

#pragma mark property
-(void)setIsShowLesson:(BOOL)isShowLesson{
    _isShowLesson = isShowLesson;
    if (isShowLesson) {
        self.segmentView.selectedSegmentIndex = 0;
        [self.lessonBackView setHidden:NO];
        [self.learningMaterialBackView setHidden:YES];
    }else{
        self.segmentView.selectedSegmentIndex = 1;
        [self.lessonBackView setHidden:YES];
        [self.learningMaterialBackView setHidden:NO];
    }
}
#pragma mark --
@end
