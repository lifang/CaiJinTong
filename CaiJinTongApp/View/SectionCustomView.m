//
//  SectionCustomView.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-4.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "SectionCustomView.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

@implementation SectionCustomView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame andLessonModel:nil andItemLabel:0];
}

-(void)changeLessonModel:(LessonModel *)lesson{
//设置视频名称
    self.nameLab.text = [NSString stringWithFormat:@"%@",lesson.lessonName];
    self.nameLab.textColor = [UIColor blackColor];
    self.nameLab.numberOfLines = 0;
    
    //视频封面
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",lesson.lessonImageURL]];
    [self.imageView setImageWithURL:url placeholderImage:Image(@"loginBgImage_v.png")];
    self.imageView.tag = [lesson.lessonId intValue];
    
     //学习进度
    CGFloat xx = [lesson.lessonStudyProgress floatValue]*100;
    if ( xx-100 >0) {
        xx=100;
    }
    if (!xx) {
        xx = 0;
    }
    self.pv.value = xx;
    self.progressLabel.text = [NSString stringWithFormat:@"学习进度:%.2f%%",xx];
    
    
}

- (id)initWithFrame:(CGRect)frame andLessonModel:(LessonModel *)lesson andItemLabel:(float)itemLabel{
    self = [super initWithFrame:frame];
    if (self) {
        //视频名称
        if (itemLabel>0) {
            UIFont *font = [UIFont systemFontOfSize:20];
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, itemLabel)];
            nameLabel.text = [NSString stringWithFormat:@"%@",lesson.lessonName];
            nameLabel.textColor = [UIColor blackColor];
            nameLabel.numberOfLines = 0;
            nameLabel.textAlignment = NSTextAlignmentLeft;
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.font = font;
            self.nameLab = nameLabel;
            [self addSubview:self.nameLab];
            nameLabel = nil;
        }
        
        //视频封面
        UIImageView *imageViewC = [[UIImageView alloc]initWithFrame:CGRectMake(0, itemLabel, self.frame.size.width, self.frame.size.height)];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",lesson.lessonImageURL]];
        [imageViewC setImageWithURL:url placeholderImage:Image(@"loginBgImage_v.png")];
        
        imageViewC.tag = [lesson.lessonId intValue];
        self.imageView = imageViewC;
        [self addSubview:self.imageView];
        imageViewC = nil;
        
        //学习进度
        CJTSlider *pVV = [[CJTSlider alloc] initWithFrame:CGRectMake(-2, self.frame.size.height+itemLabel-30, self.frame.size.width+4, 37)];
        CGFloat xx = [lesson.lessonStudyProgress floatValue]*100;
        if ( xx-100 >0) {
            xx=100;
        }
        if (!xx) {
            xx = 0;
        }
        
        pVV.value = xx;
        self.pv =pVV;
        [self addSubview:self.pv];
         pVV = nil;
        
        UILabel *progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, self.frame.size.height+itemLabel-28, self.frame.size.width, 30)];
        progressLabel.text = [NSString stringWithFormat:@"学习进度:%.2f%%",xx];
        progressLabel.textAlignment = NSTextAlignmentLeft;
        progressLabel.backgroundColor = [UIColor clearColor];
        self.progressLabel = progressLabel;
        [self addSubview:progressLabel];
        progressLabel = nil;
       
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
