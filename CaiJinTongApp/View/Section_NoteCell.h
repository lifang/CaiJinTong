//
//  Section_NoteCell.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-7.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Section_NoteCell : UITableViewCell
//@property (weak, nonatomic) IBOutlet UILabel *sectionNameLab;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (nonatomic, strong) IBOutlet UILabel *contentLab, *timeLab;
@end
