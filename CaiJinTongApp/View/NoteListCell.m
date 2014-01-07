//
//  NoteListCell.m
//  CaiJinTongApp
//
//  Created by david on 14-1-7.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "NoteListCell.h"
#define NoteListCell_Content_Font [UIFont systemFontOfSize:17]
#define NoteListCell_Title_Font [UIFont systemFontOfSize:17]

typedef enum {AlertType_DeleteCell = 12,AlertType_ModifyCell}AlertType;
@implementation NoteListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+(float)getNoteCellHeightWithNoteModel:(NoteModel*)noteModel{
    if (!noteModel) {
        return 50;
    }
    CGSize size = [Utility getTextSizeWithString:noteModel.noteText withFont:NoteListCell_Content_Font withWidth:NoteListCell_Width];
    return 50 + 20 + size.height;
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == AlertType_ModifyCell) {
        if (buttonIndex == 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(noteListCell:willModifyCellAtIndexPath: withNoteContent:)]) {
                [self.delegate noteListCell:self willModifyCellAtIndexPath:self.path withNoteContent:self.noteContentTextView.text];
            }
        }
    }else
    if (alertView.tag == AlertType_DeleteCell) {
        if (buttonIndex == 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(noteListCell:willDeleteCellAtIndexPath:)]) {
                [self.delegate noteListCell:self willDeleteCellAtIndexPath:self.path];
            }
        }
    }
    
}
#pragma mark --

-(void)setNoteDateWithnoteModel:(NoteModel*)noteModel withIsEditing:(BOOL)isEditing{
    [self.noteContentTextView setFont:NoteListCell_Content_Font];
    [self.noteTitleLabel setFont:NoteListCell_Title_Font];
    self.noteTitleLabel.text = [NSString stringWithFormat:@"%@ > %@ > %@",noteModel.noteLessonName,noteModel.noteChapterName,noteModel.noteSectionName];
    self.noteDateLabel.text = noteModel.noteTime;
    self.noteContentTextView.text = noteModel.noteText;
    [self.controlBackView setHidden:!isEditing];
    self.noteContentTextView.layer.borderWidth = 2.0;
    self.noteContentTextView.layer.borderColor = [[UIColor colorWithRed:244.0/255.0 green:243.0/255.0 blue:244.0/255.0 alpha:1.0] CGColor];
    [self.noteContentTextView setScrollEnabled:NO];
    [self.noteContentTextView setEditable:isEditing];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)editNoteBtClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确认修改" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认",@"取消", nil];
    alert.tag = AlertType_ModifyCell;
    [alert show];
}

- (IBAction)deleteNoteBtClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确认删除" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认",@"取消", nil];
    alert.tag = AlertType_DeleteCell;
    [alert show];
}

- (IBAction)titleBtClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(noteListCell:playTitleBtClickedAtIndexPath:)]) {
        [self.delegate noteListCell:self playTitleBtClickedAtIndexPath:self.path];
    }
}
@end
