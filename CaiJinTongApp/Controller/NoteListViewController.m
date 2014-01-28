//
//  NoteListViewController.m
//  CaiJinTongApp
//
//  Created by david on 14-1-7.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "NoteListViewController.h"
#import "NoteListCell.h"
#import "Section.h"
#import "SectionModel.h"
#import "DRMoviePlayViewController.h"

@interface NoteListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *noteListTableView;
@property (strong,nonatomic) UILabel *tipLabel;
@property (strong,nonatomic) NoteListInterface *noteListInterface;//获取笔记列表
@property (strong,nonatomic)  ModifyNoteInterface *modifyNoteInterface;//修改笔记接口
@property (strong,nonatomic)  DeleteNoteInterface *deleteNoteInterface;//删除笔记接口
@property (strong,nonatomic) SearchNoteInterface *searchNoteInterface;//搜索笔记接口
@property (nonatomic, strong) LessonInfoInterface *lessonInterface;//获取课程详细信息
@property (nonatomic,assign) BOOL isEditing;//是否处于编辑状态
@property (nonatomic, strong)  NSIndexPath *editPath;
@property (strong,nonatomic) NSMutableArray *noteDateList;//存放笔记数组
@property (nonatomic,strong) NSMutableArray *searchArray;//存放搜索结果
@property (nonatomic, strong) LessonModel *lessonModel;
@property (nonatomic, strong) NoteModel *playNoteModel;//将要播放的笔记
@property (nonatomic, strong) NSString *searchText;//笔记搜索关键字
@property (nonatomic,strong) MJRefreshHeaderView *headerRefreshView;
@property (nonatomic,strong) MJRefreshFooterView *footerRefreshView;
@property (nonatomic,assign) BOOL isSearchRefreshing;//判断是否是搜索
@end

@implementation NoteListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)drnavigationBarRightItemClicked:(id)sender{

}

-(void)willDismissPopoupController{//当要退出当前界面时调用

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UserModel *user = [[CaiJinTongManager shared] user];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.noteListInterface downloadNoteListWithUserId:user.userId withPageIndex:0];
}

-(void)dealloc{
    [self.headerRefreshView free];
    [self.footerRefreshView free];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.drnavigationBar.titleLabel.text = @"我的笔记";
    self.drnavigationBar.searchBar.searchTextLabel.placeholder = @"搜索笔记";
    self.isEditing = NO;
//    [self.drnavigationBar.navigationRightItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self.drnavigationBar.navigationRightItem setTitle:@"编辑" forState:UIControlStateNormal];
    [self.headerRefreshView endRefreshing];
    [self.footerRefreshView endRefreshing];
    [self.drnavigationBar hiddleBackButton:YES];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark DRMoviePlayViewControllerDelegate 提交笔记成功
-(void)drMoviePlayerViewController:(DRMoviePlayViewController *)playerController commitNotesSuccess:(NSString *)noteText andTime:(NSString *)noteTime{
    
}

-(LessonModel *)lessonModelForDrMoviePlayerViewController{
    return self.lessonModel;
}
#pragma mark --


#pragma mark MJRefreshBaseViewDelegate 分页加载
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    UserModel *user = [[CaiJinTongManager shared] user];
    if (self.headerRefreshView == refreshView) {
        self.footerRefreshView.isForbidden = YES;
        if (self.isSearchRefreshing) {
            [self.searchNoteInterface searchNoteListWithUserId:user.userId withSearchContent:self.searchText withPageIndex:0];
        }else{
            [self.noteListInterface downloadNoteListWithUserId:user.userId withPageIndex:0];
        }
    }else{
        self.headerRefreshView.isForbidden = YES;
        if (self.isSearchRefreshing) {
            [self.searchNoteInterface searchNoteListWithUserId:user.userId withSearchContent:self.searchText withPageIndex:self.searchNoteInterface.currentPageIndex+1];
        }else{
            [self.noteListInterface downloadNoteListWithUserId:user.userId withPageIndex:self.noteListInterface.currentPageIndex+1];
        }
    }
}

#pragma mark --

#pragma mark NoteListCellDelegate
-(void)noteListCell:(NoteListCell *)cell playTitleBtClickedAtIndexPath:(NSIndexPath *)path{
    if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
        [Utility errorAlert:@"暂无网络!"];
    }else {
        NoteModel *note = self.isSearchRefreshing ? [self.searchArray objectAtIndex:path.row]: [self.noteDateList objectAtIndex:path.row];
        self.playNoteModel = note;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        UserModel *user = [[CaiJinTongManager shared] user];
        [self.lessonInterface downloadLessonInfoWithLessonId:note.noteLessonId withUserId:user.userId];
    }
}

-(void)noteListCell:(NoteListCell *)cell willDeleteCellAtIndexPath:(NSIndexPath *)path{
    NoteModel *note = self.isSearchRefreshing ?[self.searchArray objectAtIndex:path.row]:[self.noteDateList objectAtIndex:path.row];
    UserModel *user = [[CaiJinTongManager shared] user];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.deleteNoteInterface.path = path;
    [self.deleteNoteInterface deleteNoteWithUserId:user.userId withNoteId:note.noteId];
}

-(void)noteListCell:(NoteListCell*)cell willModifyCellAtIndexPath:(NSIndexPath*)path{
    self.isEditing = YES;
    self.editPath = path;
    [self.noteListTableView reloadData];
}

-(void)noteListCell:(NoteListCell*)cell didTypeTextViewAtCellAtIndexPath:(NSIndexPath*)path{//开始输入
    CGRect cellRect = [self.noteListTableView rectForRowAtIndexPath:path];
    float maxCellY = CGRectGetMaxY(cellRect) - self.noteListTableView.contentOffset.y;
    float scrollHeight = 500 - (CGRectGetMaxY(self.noteListTableView.frame) - maxCellY) ;
    if (CGRectGetMaxY(self.noteListTableView.frame) - maxCellY < 500) {
        [self.noteListTableView setContentOffset:(CGPoint){self.noteListTableView.contentOffset.x,self.noteListTableView.contentOffset.y + scrollHeight} animated:YES];
    }
}
-(void)noteListCell:(NoteListCell*)cell didModifyCellAtIndexPath:(NSIndexPath*)path withNoteContent:(NSString*)noteContent{
    NoteModel *note = self.isSearchRefreshing ?[self.searchArray objectAtIndex:path.row] : [self.noteDateList objectAtIndex:path.row];
    UserModel *user = [[CaiJinTongManager shared] user];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.modifyNoteInterface.path = path;
    [self.modifyNoteInterface modifyNoteWithUserId:user.userId withNoteId:note.noteId withNoteContent:noteContent];
}

-(void)noteListCell:(NoteListCell*)cell cancelModifyCellAtIndexPath:(NSIndexPath*)path withNoteContent:(NSString*)noteContent{
    self.isEditing = NO;
    self.editPath = nil;
    [self.noteListTableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark --

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark --

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoteListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.path = indexPath;
    cell.delegate = self;
    NoteModel *note = self.isSearchRefreshing ? [self.searchArray objectAtIndex:indexPath.row]: [self.noteDateList objectAtIndex:indexPath.row];
    if (self.isEditing && self.editPath && self.editPath.row == indexPath.row) {
        [cell setNoteDateWithnoteModel:note withIsEditing:YES];
    }else{
        [cell setNoteDateWithnoteModel:note withIsEditing:NO];
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoteModel *note = self.isSearchRefreshing ?[self.searchArray objectAtIndex:indexPath.row]:[self.noteDateList objectAtIndex:indexPath.row];
    if (self.isEditing && self.editPath && self.editPath.row == indexPath.row) {
        return [NoteListCell getNoteCellHeightWithNoteModel:note isEdit:YES];
    }else{
        return [NoteListCell getNoteCellHeightWithNoteModel:note isEdit:NO];
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isSearchRefreshing) {
        if (self.searchArray.count <= 0) {
            [self.tipLabel removeFromSuperview];
            [self.noteListTableView addSubview:self.tipLabel];
        }else{
            [self.tipLabel removeFromSuperview];
        }
    }else{
        if (self.noteDateList.count <= 0) {
            [self.tipLabel removeFromSuperview];
            [self.noteListTableView addSubview:self.tipLabel];
        }else{
            [self.tipLabel removeFromSuperview];
        }
    }
   
    return self.isSearchRefreshing ?self.searchArray.count: self.noteDateList.count;
}

#pragma mark --


#pragma mark DRSearchBarDelegate搜索
-(void)drSearchBar:(DRSearchBar *)searchBar didBeginSearchText:(NSString *)searchText{
    self.isSearchRefreshing = YES;
    [searchBar resignFirstResponder];
    UserModel *user = [[CaiJinTongManager shared] user];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.searchText = searchText;
    [self.searchNoteInterface searchNoteListWithUserId:user.userId withSearchContent:searchText withPageIndex:0];
}

-(void)drSearchBar:(DRSearchBar *)searchBar didCancelSearchText:(NSString *)searchText{
    self.isSearchRefreshing = NO;
    [self.noteListTableView reloadData];
}
#pragma mark --

/*
#pragma mark UISearchBarDelegate 查询代理
-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [super searchBar:searchBar textDidChange:searchText];
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [super searchBarSearchButtonClicked:searchBar];
    NSString *searchText = [searchBar.text?:@"" stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([searchText isEqualToString:@""]) {
        [Utility errorAlert:@"要搜索的内容不能为空"];
        return;
    }
    self.isSearchRefreshing = YES;
    [searchBar resignFirstResponder];
    UserModel *user = [[CaiJinTongManager shared] user];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.searchText = searchText;
    [self.searchNoteInterface searchNoteListWithUserId:user.userId withSearchContent:searchText withPageIndex:0];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [super searchBarTextDidEndEditing:searchBar];
    NSString *searchText = [searchBar.text?:@"" stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([searchText isEqualToString:@""] && self.isSearchRefreshing) {
        self.isSearchRefreshing = NO;
        [self.noteListTableView reloadData];
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [super searchBarCancelButtonClicked:searchBar];
    self.isSearchRefreshing = NO;
    [self.noteListTableView reloadData];
}
#pragma mark --
*/

#pragma mark-- LessonInfoInterfaceDelegate加载课程详细信息
-(void)getLessonInfoDidFinished:(LessonModel*)lesson{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.lessonModel = lesson;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        DRMoviePlayViewController *movieController =  [self.storyboard instantiateViewControllerWithIdentifier:@"DRMoviePlayViewController"];
        SectionModel *section = [[Section defaultSection] getSectionModelWithSid:self.playNoteModel.noteSectionId];
        BOOL downloadStatus = [[Section defaultSection] HasTheDataDownloadWithSid:self.playNoteModel.noteSectionId];//1 下载完成
        [self presentViewController:movieController animated:YES completion:^{
            
        }];
        if (section && downloadStatus == 1) {
            [movieController playMovieWithSectionModel:section withFileType:MPMovieSourceTypeFile];
        }else{
            SectionModel *tempSection = nil;
            BOOL isReturn = NO;
            for (chapterModel *chapter in self.lessonModel.chapterList) {
                for (SectionModel *sec in chapter.sectionList) {
                    if ([sec.sectionId isEqualToString:self.playNoteModel.noteSectionId]) {
                        tempSection = sec;
                        isReturn = YES;
                    }
                }
                if (isReturn) {
                    break;
                }
            }
            [movieController playMovieWithSectionModel:tempSection?:section withFileType:MPMovieSourceTypeStreaming];
        }
    });
}
-(void)getLessonInfoDidFailed:(NSString *)errorMsg{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utility errorAlert:errorMsg];
    });
    
}

#pragma mark --

#pragma mark NoteListInterfaceDelegate获取笔记列表
-(void)getNoteListDataDidFinished:(NSArray *)noteList withCurrentPageIndex:(int)pageIndex withTotalCount:(int)allDataCount{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (pageIndex <= 0) {
            self.noteDateList = [NSMutableArray arrayWithArray:noteList];
        }else{
            [self.noteDateList addObjectsFromArray:noteList];
        }
        
        [self.noteListTableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.headerRefreshView endRefreshing];
        [self.footerRefreshView endRefreshing];
        self.headerRefreshView.isForbidden = NO;
        self.footerRefreshView.isForbidden = NO;
    });
}

-(void)getNoteListDataFailure:(NSString *)errorMsg{
dispatch_async(dispatch_get_main_queue(), ^{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.headerRefreshView endRefreshing];
    [self.footerRefreshView endRefreshing];
    self.headerRefreshView.isForbidden = NO;
    self.footerRefreshView.isForbidden = NO;
    [Utility errorAlert:errorMsg];
});
}
#pragma mark --

#pragma mark ModifyNoteInterfaceDelegate修改笔记
-(void)modifyNoteDidFinished:(NSString *)success{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.modifyNoteInterface.path) {
            NoteModel *note = self.isSearchRefreshing ?[self.searchArray objectAtIndex:self.modifyNoteInterface.path.row]: [self.noteDateList objectAtIndex:self.modifyNoteInterface.path.row];
            note.noteText = self.modifyNoteInterface.modifyContent;
            self.isEditing = NO;
            self.editPath = nil;
            [self.noteListTableView reloadData];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utility errorAlert:success];
    });
}

-(void)modifyNoteFailure:(NSString *)errorMsg{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utility errorAlert:errorMsg];
    });
}
#pragma mark --

#pragma mark DeleteNoteInterfaceDelegate删除笔记
-(void)deleteNoteDidFinished:(NSString *)success{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.deleteNoteInterface.path) {
            self.isSearchRefreshing?[self.searchArray removeObjectAtIndex:self.deleteNoteInterface.path.row]: [self.noteDateList removeObjectAtIndex:self.deleteNoteInterface.path.row];
            [self.noteListTableView reloadData];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utility errorAlert:success];
    });
}

-(void)deleteNoteFailure:(NSString *)errorMsg{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utility errorAlert:errorMsg];
    });
}
#pragma mark --


#pragma mark SearchNoteInterfaceDelegate搜索笔记
-(void)searchNoteListDataDidFinished:(NSArray *)noteList withCurrentPageIndex:(int)pageIndex withTotalCount:(int)allDataCount{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (pageIndex <= 0) {
            self.searchArray = [NSMutableArray arrayWithArray:noteList];
        }else{
            [self.searchArray addObjectsFromArray:noteList];
        }
        [self.noteListTableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.headerRefreshView endRefreshing];
        [self.footerRefreshView endRefreshing];
        self.headerRefreshView.isForbidden = NO;
        self.footerRefreshView.isForbidden = NO;
    });
}

-(void)searchNoteListDataFailure:(NSString *)errorMsg{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.searchArray.count > 0) {
            
        }else{
            self.isSearchRefreshing = NO;
            [self.noteListTableView reloadData];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.headerRefreshView endRefreshing];
        [self.footerRefreshView endRefreshing];
        self.headerRefreshView.isForbidden = NO;
        self.footerRefreshView.isForbidden = NO;
        [Utility errorAlert:errorMsg];
    });
}
#pragma mark --

#pragma mark property

-(LessonInfoInterface *)lessonInterface{
    if (!_lessonInterface) {
        _lessonInterface = [[LessonInfoInterface alloc] init];
        _lessonInterface.delegate = self;
    }
    return _lessonInterface;
}

-(ModifyNoteInterface *)modifyNoteInterface{
    if (!_modifyNoteInterface) {
        _modifyNoteInterface = [[ModifyNoteInterface alloc] init];
        _modifyNoteInterface.delegate = self;
    }
    return _modifyNoteInterface;
}

-(NoteListInterface *)noteListInterface{
    if (!_noteListInterface) {
        _noteListInterface = [[NoteListInterface alloc] init];
        _noteListInterface.delegate = self;
    }
    return _noteListInterface;
}

-(DeleteNoteInterface *)deleteNoteInterface{
    if (!_deleteNoteInterface) {
        _deleteNoteInterface = [[DeleteNoteInterface alloc] init];
        _deleteNoteInterface.delegate = self;
    }
    return _deleteNoteInterface;
}

-(SearchNoteInterface *)searchNoteInterface{
    if (!_searchNoteInterface) {
        _searchNoteInterface = [[SearchNoteInterface alloc] init];
        _searchNoteInterface.delegate =self;
    }
    return _searchNoteInterface;
}

-(NSMutableArray *)noteDateList{
    if (!_noteDateList) {
        _noteDateList = [NSMutableArray array];
    }
    return _noteDateList;
}

-(NSMutableArray *)searchArray{
    if (!_searchArray) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}

-(MJRefreshHeaderView *)headerRefreshView{
    if (!_headerRefreshView) {
        _headerRefreshView = [[MJRefreshHeaderView alloc] init];
        _headerRefreshView.scrollView = self.noteListTableView;
        _headerRefreshView.delegate = self;
    }
    return _headerRefreshView;
}

-(MJRefreshFooterView *)footerRefreshView{
    if (!_footerRefreshView) {
        _footerRefreshView = [[MJRefreshFooterView alloc] init];
        _footerRefreshView.delegate = self;
        _footerRefreshView.scrollView = self.noteListTableView;
        
    }
    return _footerRefreshView;
}

-(UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:(CGRect){0,0,NoteListCell_Width,self.noteListTableView.frame.size.height}];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = [UIColor grayColor];
        _tipLabel.font = [UIFont systemFontOfSize:30];
        [_tipLabel setText:@"没有数据"];
    }
    return _tipLabel;
}

#pragma mark --
@end
