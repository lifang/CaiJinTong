//
//  NoteListViewController.h
//  CaiJinTongApp
//
//  Created by david on 14-1-7.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteListInterface.h"
#import "ModifyNoteInterface.h"
#import "DeleteNoteInterface.h"
#import "SearchNoteInterface.h"
#import "NoteListCell.h"
@interface NoteListViewController : DRNaviGationBarController<UISearchBarDelegate,NoteListInterfaceDelegate,ModifyNoteInterfaceDelegate,DeleteNoteInterfaceDelegate,SearchNoteInterfaceDelegate,UITableViewDataSource,UITableViewDelegate,NoteListCellDelegate>

@end
