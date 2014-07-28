//
//  Section_NoteViewController.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-5.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Section_NoteCell.h"
#import "NoteModel.h"
@protocol Section_NoteViewControllerDelegate;
@interface Section_NoteViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,Section_NoteCellDelegate>
- (void)viewDidCurrentView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) IBOutlet UITableView *tableViewList;
@property (weak,nonatomic) id<Section_NoteViewControllerDelegate> delegate;
@end

@protocol Section_NoteViewControllerDelegate <NSObject>
-(void)section_NoteViewController:(Section_NoteViewController*)controller didClickedNoteCellWithObj:(NoteModel*)noteModel;
@end