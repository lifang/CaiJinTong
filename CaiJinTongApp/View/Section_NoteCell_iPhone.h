//
//  Section_NoteCell_iPhone.h
//  CaiJinTongApp
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Section_NoteCell_iPhone : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (nonatomic, strong) IBOutlet UILabel *contentLab;
@property (nonatomic, strong) IBOutlet UILabel *timeLab;
@end
