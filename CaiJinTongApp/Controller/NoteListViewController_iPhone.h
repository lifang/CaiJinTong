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
#import "LHLMoviePlayViewController.h"
#import "MJRefresh.h"
#import "ChapterSearchBar_iPhone.h"
@interface NoteListViewController_iPhone : LHLNavigationBarViewController<NoteListInterfaceDelegate,ModifyNoteInterfaceDelegate,DeleteNoteInterfaceDelegate,SearchNoteInterfaceDelegate,UITableViewDataSource,UITableViewDelegate,NoteListCell_iPhoneDelegate,LHLMoviePlayViewControllerDelegate,LessonInfoInterfaceDelegate,MJRefreshBaseViewDelegate,UITextViewDelegate,ChapterSearchBarDelegate_iPhone>
@end