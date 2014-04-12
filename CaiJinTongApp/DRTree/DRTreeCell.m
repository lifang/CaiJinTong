//
//  DRTreeCell.m
//  DRTreeFolderView
//
//  Created by david on 13-12-18.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "DRTreeCell.h"
#define CELL_PADDING 3
@interface DRTreeCell()
@property (nonatomic,strong) UIImageView *cellImageView;
@property (nonatomic,strong) UILabel *cellNameLabel;
@property (nonatomic,strong) UILabel *cellFlagLabel;
@end

@implementation DRTreeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        UIView *selectedView = [[UIView alloc] init];
        selectedView.backgroundColor = [UIColor lightGrayColor];
        [self setSelectedBackgroundView:selectedView];
        self.cellImageView = [[UIImageView alloc] initWithFrame:(CGRect){CELL_PADDING,CGRectGetHeight(self.frame)/2-10,20,20}];
        self.cellImageView.image = [UIImage imageNamed:@"close@2x.png"];
        self.cellImageView.backgroundColor = [UIColor clearColor];
//        self.cellImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:self.cellImageView];
        
        self.cellNameLabel = [[UILabel alloc] initWithFrame:(CGRect){CGRectGetMaxX(self.cellImageView.frame)+CELL_PADDING,0,CGRectGetWidth(self.frame) - CGRectGetMaxX(self.cellImageView.frame)- CELL_PADDING*2-30,self.frame.size.height}];
        self.cellNameLabel.backgroundColor = [UIColor clearColor];
         self.cellNameLabel.textColor = [UIColor whiteColor];
        if (isPAD) {
            [self.cellNameLabel setFont:[UIFont systemFontOfSize:12]];
        }else{
            [self.cellNameLabel setFont:[UIFont systemFontOfSize:10]];
        }
        
//        self.cellNameLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.cellNameLabel];
        
        self.cellFlagLabel = [[UILabel alloc] initWithFrame:(CGRect){CGRectGetMaxX(self.cellNameLabel.frame)+CELL_PADDING,0,30,self.frame.size.height}];
        self.cellFlagLabel.backgroundColor = [UIColor clearColor];
        self.cellFlagLabel.textColor = [UIColor whiteColor];
        self.cellFlagLabel.textAlignment = NSTextAlignmentRight;
//        self.cellFlagLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
//        [self addSubview:self.cellFlagLabel];
        
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
//    CGContextFillRect(context, rect);
//    self.cellImageView.frame = (CGRect){CELL_PADDING+self.note.noteLevel*10,CGRectGetHeight(self.frame)/2-5,10,10};
//    self.cellNameLabel.frame = (CGRect){CGRectGetMaxX(self.cellImageView.frame)+CELL_PADDING,0,CGRectGetWidth(self.frame) - CGRectGetMaxX(self.cellImageView.frame)- CELL_PADDING*2-30,self.frame.size.height};
//    self.cellFlagLabel.frame = (CGRect){CGRectGetMaxX(self.cellNameLabel.frame)+CELL_PADDING,0,30,self.frame.size.height};
    
    self.cellNameLabel.frame = (CGRect){CELL_PADDING+self.note.noteLevel*10,0,CGRectGetWidth(self.frame)- CELL_PADDING*2-40,self.frame.size.height};
    self.cellImageView.frame = (CGRect){CGRectGetWidth(self.frame)-CELL_PADDING-20,CGRectGetHeight(self.frame)/2-5,10,10};
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setNote:(DRTreeNode *)note{
    _note = note;
    if (note) {
        self.cellNameLabel.text = note.noteContentName;
        if (note.childnotes && note.childnotes.count > 0) {
            if (note.noteIsExtend) {
                self.cellImageView.image = [UIImage imageNamed:@"open@2x.png"];
            }else{
                self.cellImageView.image = [UIImage imageNamed:@"close@2x.png"];
            }
            self.cellFlagLabel.text = [NSString stringWithFormat:@"%d",note.childnotes.count];
        }else{
            self.cellFlagLabel.text = @"";
            self.cellImageView.image = nil;
        }
    }else{
        self.cellNameLabel.text = @"";
        self.cellFlagLabel.text = @"";
        self.cellImageView.image = nil;
    }
    [self setNeedsDisplay];
}
@end
