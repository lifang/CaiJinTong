//
//  Section_NoteCell.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-7.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol Section_NoteCellDelegate;
@interface Section_NoteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (nonatomic, strong) IBOutlet UILabel *sectionNameLab;
@property (nonatomic, strong) IBOutlet UILabel *timeLab;
@property (weak,nonatomic) id<Section_NoteCellDelegate> delegate;
@property (strong,nonatomic) NSIndexPath *path;
- (IBAction)section_noteTitleClicked:(id)sender;
@end

@protocol Section_NoteCellDelegate <NSObject>

-(void)section_NoteCell:(Section_NoteCell*)cell didSelectedAtIndexPath:(NSIndexPath*)path;

@end