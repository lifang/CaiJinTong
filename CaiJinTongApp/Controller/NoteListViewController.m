//
//  NoteListViewController.m
//  CaiJinTongApp
//
//  Created by david on 14-1-7.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "NoteListViewController.h"
#import "NoteListCell.h"
@interface NoteListViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *noteSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *noteListTableView;
@property (strong,nonatomic) UILabel *tipLabel;
@property (strong,nonatomic) NoteListInterface *noteListInterface;//获取笔记列表
@property (strong,nonatomic)  ModifyNoteInterface *modifyNoteInterface;//修改笔记接口
@property (strong,nonatomic)  DeleteNoteInterface *deleteNoteInterface;//删除笔记接口
@property (strong,nonatomic) SearchNoteInterface *searchNoteInterface;//搜索笔记接口

@property (nonatomic,assign) BOOL isEditing;//是否处于编辑状态
@property (strong,nonatomic) NSMutableArray *noteDateList;//存放笔记数组
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
    self.isEditing = !self.isEditing;
    if (self.isEditing) {
        [self.drnavigationBar.navigationRightItem setTitle:@"取消" forState:UIControlStateNormal];
    }else{
        [self.drnavigationBar.navigationRightItem setTitle:@"编辑" forState:UIControlStateNormal];
    }
    [self.noteListTableView reloadData];
}

-(void)willDismissPopoupController{//当要退出当前界面时调用

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UserModel *user = [[CaiJinTongManager shared] user];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.noteListInterface downloadNoteListWithUserId:user.userId withPageIndex:0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.drnavigationBar.titleLabel.text = @"我的笔记";
    self.isEditing = NO;
    [self.drnavigationBar.navigationRightItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.drnavigationBar.navigationRightItem setTitle:@"编辑" forState:UIControlStateNormal];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark NoteListCellDelegate
-(void)noteListCell:(NoteListCell *)cell playTitleBtClickedAtIndexPath:(NSIndexPath *)path{

}

-(void)noteListCell:(NoteListCell *)cell willDeleteCellAtIndexPath:(NSIndexPath *)path{

}

-(void)noteListCell:(NoteListCell *)cell willModifyCellAtIndexPath:(NSIndexPath *)path{

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
    NoteModel *note = [self.noteDateList objectAtIndex:indexPath.row];
    [cell setNoteDateWithnoteModel:note withIsEditing:self.isEditing];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoteModel *note = [self.noteDateList objectAtIndex:indexPath.row];
    return [NoteListCell getNoteCellHeightWithNoteModel:note];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.noteDateList.count <= 0) {
        [self.tipLabel removeFromSuperview];
        [self.noteListTableView addSubview:self.tipLabel];
    }else{
        [self.tipLabel removeFromSuperview];
    }
    return self.noteDateList.count;
}

#pragma mark --


#pragma mark UISearchBarDelegate 查询代理
-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

}
#pragma mark --

#pragma mark NoteListInterfaceDelegate获取笔记列表
-(void)getNoteListDataDidFinished:(NSArray *)noteList withCurrentPageIndex:(int)pageIndex withTotalCount:(int)allDataCount{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.noteDateList = [NSMutableArray arrayWithArray:noteList];
        [self.noteListTableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    });
}

-(void)getNoteListDataFailure:(NSString *)errorMsg{
dispatch_async(dispatch_get_main_queue(), ^{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
});
}
#pragma mark --

#pragma mark ModifyNoteInterfaceDelegate修改笔记
-(void)modifyNoteDidFinished:(NSString *)success{
    dispatch_async(dispatch_get_main_queue(), ^{
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
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    });
}

-(void)searchNoteListDataFailure:(NSString *)errorMsg{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utility errorAlert:errorMsg];
    });
}
#pragma mark --

#pragma mark property

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
