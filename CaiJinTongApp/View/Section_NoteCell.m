//
//  Section_NoteCell.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-7.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "Section_NoteCell.h"

@implementation Section_NoteCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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
