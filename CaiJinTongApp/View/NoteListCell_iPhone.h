//
//  NoteListCell_iPhone.h
//  CaiJinTongApp
//
//  Created by apple on 14-1-16.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteModel.h"
#define NoteListCell_iPhone_Width 275
@protocol NoteListCell_iPhoneDelegate;
@interface NoteListCell_iPhone : UITableViewCell<UIAlertViewDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *titleBackView;
@property (weak, nonatomic) IBOutlet UILabel *noteTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteDateLabel;
@property (weak, nonatomic) IBOutlet UIView *controlBackView;
@property (weak, nonatomic) IBOutlet UIView *editView;
@property (weak, nonatomic) IBOutlet UITextView *noteContentTextView;
@property (weak, nonatomic) IBOutlet UIButton *commitBt;
@property (weak, nonatomic) IBOutlet UIButton *cancelBt;
@property (weak, nonatomic) IBOutlet id<NoteListCell_iPhoneDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *modifyBt;
@property (weak, nonatomic) IBOutlet UIView *contentViewBackView;
@property (weak, nonatomic) IBOutlet UIView *flagBackView;
@property (weak, nonatomic) IBOutlet UILabel *flagNumberLabel;
@property (strong,nonatomic) NSIndexPath *path;
- (IBAction)editNoteBtClicked:(id)sender;
- (IBAction)deleteNoteBtClicked:(id)sender;
- (IBAction)titleBtClicked:(id)sender;
- (IBAction)commitBtClicked:(id)sender;
- (IBAction)cancelBtClicked:(id)sender;
+(float)getNoteCellHeightWithNoteModel:(NoteModel*)noteModel isEdit:(BOOL)isEdit ;//计算cell高度
-(void)setNoteDateWithnoteModel:(NoteModel*)noteModel withIsEditing:(BOOL)isEditing;
@end

@protocol NoteListCell_iPhoneDelegate <NSObject>

-(void)NoteListCell_iPhone:(NoteListCell_iPhone*)cell playTitleBtClickedAtIndexPath:(NSIndexPath*)path;

-(void)NoteListCell_iPhone:(NoteListCell_iPhone*)cell willDeleteCellAtIndexPath:(NSIndexPath*)path;

-(void)NoteListCell_iPhone:(NoteListCell_iPhone*)cell willModifyCellAtIndexPath:(NSIndexPath*)path;
-(void)NoteListCell_iPhone:(NoteListCell_iPhone*)cell didModifyCellAtIndexPath:(NSIndexPath*)path withNoteContent:(NSString*)noteContent;
-(void)NoteListCell_iPhone:(NoteListCell_iPhone*)cell cancelModifyCellAtIndexPath:(NSIndexPath*)path withNoteContent:(NSString*)noteContent;
@end