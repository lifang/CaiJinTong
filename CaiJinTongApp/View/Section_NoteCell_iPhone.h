//
//  Section_NoteCell_iPhone.h
//  CaiJinTongApp
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol Section_NoteCellDelegate;
@interface Section_NoteCell_iPhone : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (nonatomic, strong) IBOutlet UILabel *contentLab;
@property (nonatomic, strong) IBOutlet UILabel *timeLab;
@property (weak,nonatomic) id<Section_NoteCellDelegate> delegate;
@property (strong,nonatomic) NSIndexPath *path;
- (IBAction)section_noteTitleClicked:(id)sender;
@end

@protocol Section_NoteCellDelegate <NSObject>

-(void)section_NoteCell:(Section_NoteCell_iPhone*)cell didSelectedAtIndexPath:(NSIndexPath*)path;

@end
