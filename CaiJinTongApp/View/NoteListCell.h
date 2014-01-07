//
//  NoteListCell.h
//  CaiJinTongApp
//
//  Created by david on 14-1-7.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteModel.h"
#define NoteListCell_Width 800
@protocol NoteListCellDelegate;
@interface NoteListCell : UITableViewCell<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *titleBackView;
@property (weak, nonatomic) IBOutlet UILabel *noteTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteDateLabel;
@property (weak, nonatomic) IBOutlet UIView *controlBackView;
@property (weak, nonatomic) IBOutlet UITextView *noteContentTextView;
@property (weak, nonatomic) IBOutlet id<NoteListCellDelegate> delegate;
@property (strong,nonatomic) NSIndexPath *path;
- (IBAction)editNoteBtClicked:(id)sender;
- (IBAction)deleteNoteBtClicked:(id)sender;
- (IBAction)titleBtClicked:(id)sender;
+(float)getNoteCellHeightWithNoteModel:(NoteModel*)noteModel;//计算cell高度
-(void)setNoteDateWithnoteModel:(NoteModel*)noteModel withIsEditing:(BOOL)isEditing;
@end

@protocol NoteListCellDelegate <NSObject>

-(void)noteListCell:(NoteListCell*)cell playTitleBtClickedAtIndexPath:(NSIndexPath*)path;

-(void)noteListCell:(NoteListCell*)cell willDeleteCellAtIndexPath:(NSIndexPath*)path;

-(void)noteListCell:(NoteListCell*)cell willModifyCellAtIndexPath:(NSIndexPath*)path withNoteContent:(NSString*)noteContent;
@end