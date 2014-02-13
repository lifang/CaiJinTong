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
@interface NoteListCell ()
@property (nonatomic,strong) NoteModel *noteModel;
@end

@implementation NoteListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+(float)getNoteCellHeightWithNoteModel:(NoteModel*)noteModel isEdit:(BOOL)isEdit{
    if (!noteModel) {
        return 83;
    }
    CGSize size = [Utility getTextSizeWithString:noteModel.noteText withFont:NoteListCell_Content_Font withWidth:NoteListCell_Width];
    if (isEdit) {
        return  83 + 20 + size.height + 40;
    }
    return 83 + 20 + size.height;
}

#pragma mark UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *oldText = [self.noteModel.noteText?:@"" stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *newText = [[textView.text stringByAppendingString:text]?:@"" stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([text isEqualToString:@""] && ![newText isEqualToString:@""]) {
        newText = [textView.text stringByReplacingCharactersInRange:NSMakeRange(newText.length-1, 1) withString:@""];
    }
    if (![oldText isEqualToString:newText] && ![newText isEqualToString:@""]) {
         [self.commitBt setEnabled:YES];
    }else{
        [self.commitBt setEnabled:NO];
    }
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    NSString *oldText = [self.noteModel.noteText?:@"" stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *newText = [textView.text?:@"" stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![oldText isEqualToString:newText]) {
        [self.commitBt setEnabled:YES];
    }else{
        [self.commitBt setEnabled:NO];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(noteListCell:didTypeTextViewAtCellAtIndexPath:)]) {
        [self.delegate noteListCell:self didTypeTextViewAtCellAtIndexPath:self.path];
    }
    return YES;
}
#pragma mark --

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == AlertType_ModifyCell) {
        if (buttonIndex == 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(noteListCell:didModifyCellAtIndexPath:withNoteContent:)]) {
                [self.delegate noteListCell:self didModifyCellAtIndexPath:self.path withNoteContent:self.noteContentTextView.text];
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

-(NSAttributedString*)getNoteTitleAttributedStringWithNoteObj:(NoteModel*)noteObj{
    if ([noteObj.noteLessonName isEqualToString:@""] || [noteObj.noteSectionName isEqualToString:@""] || [noteObj.noteChapterName isEqualToString:@""]) {
        return nil;
    }
    NSString *title = [NSString stringWithFormat:@"%@(%@) : %@",noteObj.noteLessonName,noteObj.noteChapterName,noteObj.noteSectionName];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:title];
    [string addAttribute:NSFontAttributeName value:self.noteTitleLabel.font range:NSMakeRange(0, string.length)];
    NSRange lessonRange = NSMakeRange(0, [title rangeOfString:noteObj.noteSectionName].location);
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:lessonRange];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange([title rangeOfString:noteObj.noteSectionName].location,string.length - [title rangeOfString:noteObj.noteSectionName].location)];
    return string;
}
-(NSAttributedString*)getFlagAttributedString:(int)row{
    NSString *rowString = row >9?[NSString stringWithFormat:@"%d",row]:[NSString stringWithFormat:@"0%d",row];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:rowString];
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-BoldOblique" size:25] range:NSMakeRange(0, string.length)];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, string.length)];
//    [string addAttribute:NSFontAttributeName value:self.flagNumberLabel.font range:NSMakeRange(0, string.length)];
    return string;
}
-(void)setNoteDateWithnoteModel:(NoteModel*)noteModel withIsEditing:(BOOL)isEditing{
    self.commitBt.layer.cornerRadius = 5;
    self.cancelBt.layer.cornerRadius = 5;
    self.noteModel = noteModel;
    [self.noteContentTextView setFont:NoteListCell_Content_Font];
    [self.noteTitleLabel setFont:NoteListCell_Title_Font];
    self.noteTitleLabel.attributedText = [self getNoteTitleAttributedStringWithNoteObj:noteModel];
    self.noteDateLabel.text = noteModel.noteTime;
    self.noteContentTextView.text = noteModel.noteText;
    self.contentViewBackView.layer.borderWidth = 1.0;
    self.contentViewBackView.layer.borderColor = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.4]CGColor];
    self.flagBackView.layer.cornerRadius = 5;
    self.flagNumberLabel.attributedText = [self getFlagAttributedString:self.path.row+1];
    [self.commitBt setEnabled:NO];
    if (isEditing) {
        [self appearEditView];
    }else{
        [self hiddleEditView];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)editNoteBtClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(noteListCell:willModifyCellAtIndexPath:)]) {
        [self.delegate noteListCell:self willModifyCellAtIndexPath:self.path];
    }
//    [self appearEditView];
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

- (IBAction)commitBtClicked:(id)sender {
    if (!self.noteContentTextView.text || self.noteContentTextView.text.length > 500) {
        [Utility errorAlert:@"字数不能超过500"];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确认修改" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认",@"取消", nil];
    alert.tag = AlertType_ModifyCell;
    [alert show];
}

- (IBAction)cancelBtClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(noteListCell:cancelModifyCellAtIndexPath:withNoteContent:)]) {
        [self.delegate noteListCell:self cancelModifyCellAtIndexPath:self.path withNoteContent:self.noteContentTextView.text];
    }
//    [self hiddleEditView];
}

-(void)hiddleEditView{
    self.contentViewBackView.backgroundColor = [UIColor whiteColor];
    self.noteContentTextView.layer.borderWidth = 0;
    [self.noteDateLabel setHidden:NO];
    [self.editView setHidden:YES];
    [self.noteContentTextView setScrollEnabled:NO];
    [self.noteContentTextView setEditable:NO];
    self.noteContentTextView.backgroundColor = [UIColor clearColor];
    CGRect contentRect = self.noteContentTextView.frame;
    CGSize size = [Utility getTextSizeWithString:self.noteModel.noteText withFont:NoteListCell_Content_Font withWidth:NoteListCell_Width];
    self.noteContentTextView.frame = (CGRect){contentRect.origin,NoteListCell_Width,size.height+20};
}

-(void)appearEditView{
    self.contentViewBackView.backgroundColor = [UIColor colorWithRed:255/255.0 green:230/255.0 blue:214/255.0 alpha:1];
    self.noteContentTextView.layer.borderWidth = 1;
    self.noteContentTextView.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.7].CGColor;
    self.noteContentTextView.backgroundColor = [UIColor whiteColor];
    [self.noteDateLabel setHidden:NO];
    [self.editView setHidden:NO];
    [self.noteDateLabel setHidden:YES];
    [self.noteContentTextView setScrollEnabled:YES];
    [self.noteContentTextView setEditable:YES];
    CGRect contentRect = self.noteContentTextView.frame;
    CGSize size = [Utility getTextSizeWithString:self.noteModel.noteText withFont:NoteListCell_Content_Font withWidth:NoteListCell_Width];
    self.noteContentTextView.frame = (CGRect){contentRect.origin,NoteListCell_Width,size.height+20};
//    [self.noteContentTextView becomeFirstResponder];
}
@end
