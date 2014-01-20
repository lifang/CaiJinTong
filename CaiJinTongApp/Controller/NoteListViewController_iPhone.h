//
//  NoteListViewController_iPhone.h
//  CaiJinTongApp
//
//  Created by apple on 14-1-16.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "LHLNavigationBarViewController.h"
#import "NoteListInterface.h"
#import "ModifyNoteInterface.h"
#import "DeleteNoteInterface.h"
#import "SearchNoteInterface.h"
#import "NoteListCell_iPhone.h"
#import "DRMoviePlayViewController.h"
#import "MJRefresh.h"
@interface NoteListViewController_iPhone : LHLNavigationBarViewController<NoteListInterfaceDelegate,ModifyNoteInterfaceDelegate,DeleteNoteInterfaceDelegate,SearchNoteInterfaceDelegate,UITableViewDataSource,UITableViewDelegate,NoteListCell_iPhoneDelegate,DRMoviePlayViewControllerDelegate,LessonInfoInterfaceDelegate,MJRefreshBaseViewDelegate>
@end