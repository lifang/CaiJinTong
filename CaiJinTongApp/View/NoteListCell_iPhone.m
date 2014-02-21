//
//  NoteListCell_iPhone.m
//  CaiJinTongApp
//
//  Created by apple on 14-1-16.
//  Copyright (c) 2014年 david. All rights reserved.
//
#import "NoteListCell_iPhone.h"
#define NoteListCell_iPhone_Content_Font [UIFont systemFontOfSize:11]
#define NoteListCell_iPhone_Title_Font [UIFont systemFontOfSize:11]

typedef enum {AlertType_DeleteCell = 12,AlertType_ModifyCell}AlertType;
@interface NoteListCell_iPhone ()
@property (nonatomic,strong) NoteModel *noteModel;
@end

@implementation NoteListCell_iPhone

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
        return 10 + 26 + 25;
    }
    CGSize size = [Utility getTextSizeWithString:noteModel.noteText withFont:NoteListCell_iPhone_Content_Font withWidth:NoteListCell_iPhone_Width - 15];
    
    if (isEdit) {
        return  10 + 26 + size.height + 17 + 30;
    }
    return 10 + 26 + size.height + 17;
}

#pragma mark UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *oldText = [self.noteModel.noteText?:@"" stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *newText = [[textView.text stringByAppendingString:text]?:@"" stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![oldText isEqualToString:newText]) {
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
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(NoteListCell_iPhone:textViewShouldBeginEditing:)]){
        [self.delegate NoteListCell_iPhone:self textViewShouldBeginEditing:textView];
    }
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if(self.delegate && [self.delegate respondsToSelector:@selector(NoteListCell_iPhone:textViewDidEndEditing:)]){
        [self.delegate NoteListCell_iPhone:self textViewDidEndEditing:textView];
    }
}

#pragma mark --

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == AlertType_ModifyCell) {
        if (buttonIndex == 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(NoteListCell_iPhone:didModifyCellAtIndexPath:withNoteContent:)]) {
                [self.delegate NoteListCell_iPhone:self didModifyCellAtIndexPath:self.path withNoteContent:self.noteContentTextView.text];
            }
        }
    }else
        if (alertView.tag == AlertType_DeleteCell) {
            if (buttonIndex == 0) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(NoteListCell_iPhone:willDeleteCellAtIndexPath:)]) {
                    [self.delegate NoteListCell_iPhone:self willDeleteCellAtIndexPath:self.path];
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
    NSRange lessonRange = NSMakeRange(0, noteObj.noteLessonName.length+noteObj.noteChapterName.length+3);
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:lessonRange];
    int lenght = string.length-lessonRange.length >0?(string.length-lessonRange.length):0;
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(lessonRange.length,lenght)];
    return string;
}
-(NSAttributedString*)getFlagAttributedString:(int)row{
    NSString *rowString = row >9?[NSString stringWithFormat:@"%d",row]:[NSString stringWithFormat:@"0%d",row];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:rowString];
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-BoldOblique" size:20] range:NSMakeRange(0, string.length)];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, string.length)];
    //    [string addAttribute:NSFontAttributeName value:self.flagNumberLabel.font range:NSMakeRange(0, string.length)];
    return string;
}
-(void)setNoteDateWithnoteModel:(NoteModel*)noteModel withIsEditing:(BOOL)isEditing{
    self.noteModel = noteModel;
    [self.noteContentTextView setFont:NoteListCell_iPhone_Content_Font];
    [self.noteTitleLabel setFont:NoteListCell_iPhone_Title_Font];
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(NoteListCell_iPhone:willModifyCellAtIndexPath:)]) {
        [self.delegate NoteListCell_iPhone:self willModifyCellAtIndexPath:self.path];
    }
    //    [self appearEditView];
}

- (IBAction)deleteNoteBtClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确认删除" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认",@"取消", nil];
    alert.tag = AlertType_DeleteCell;
    [alert show];
}

- (IBAction)titleBtClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(NoteListCell_iPhone:playTitleBtClickedAtIndexPath:)]) {
        [self.delegate NoteListCell_iPhone:self playTitleBtClickedAtIndexPath:self.path];
    }
}

- (IBAction)commitBtClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确认修改" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认",@"取消", nil];
    alert.tag = AlertType_ModifyCell;
    [alert show];
}

- (IBAction)cancelBtClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(NoteListCell_iPhone:cancelModifyCellAtIndexPath:withNoteContent:)]) {
        [self.delegate NoteListCell_iPhone:self cancelModifyCellAtIndexPath:self.path withNoteContent:self.noteContentTextView.text];
    }
    //    [self hiddleEditView];UITextView
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
    CGSize size = [Utility getTextSizeWithString:self.noteModel.noteText withFont:NoteListCell_iPhone_Content_Font withWidth:NoteListCell_iPhone_Width - 15];
    self.noteContentTextView.frame = (CGRect){contentRect.origin,NoteListCell_iPhone_Width,size.height + 17};
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
    CGSize size = [Utility getTextSizeWithString:self.noteModel.noteText withFont:NoteListCell_iPhone_Content_Font withWidth:NoteListCell_iPhone_Width - 15];
    self.noteContentTextView.frame = (CGRect){contentRect.origin,NoteListCell_iPhone_Width,size.height + 17};
    //    [self.noteContentTextView becomeFirstResponder];
}
@end
