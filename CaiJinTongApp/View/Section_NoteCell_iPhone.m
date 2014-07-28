//
//  Section_NoteCell_iPhone.m
//  CaiJinTongApp
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "Section_NoteCell_iPhone.h"

@implementation Section_NoteCell_iPhone

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)section_noteTitleClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(section_NoteCell:didSelectedAtIndexPath:)]) {
        [self.delegate section_NoteCell:self didSelectedAtIndexPath:self.path];
    }
}

@end
