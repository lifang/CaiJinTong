//
//  SectionCustomView_iPhone.m
//  CaiJinTongApp
//
//  Created by apple on 13-11-26.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "SectionCustomView_iPhone.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

@implementation SectionCustomView_iPhone

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame andLesson:nil andItemLabel:20];
}
- (id)initWithFrame:(CGRect)frame andLesson:(LessonModel *)lesson andItemLabel:(float)itemLabel{
    self = [super initWithFrame:frame];
    if (self) {
            self.sectionId = lesson.lessonId;
            
            //照片底板
            UIImageView *photoBg = [[UIImageView alloc] initWithFrame:CGRectMake(-3, itemLabel - 3, 132, 132)];
            [photoBg setBackgroundColor:[UIColor whiteColor]];
            [photoBg.layer setCornerRadius:2.0];
            photoBg.image = [UIImage imageNamed:@"photoBg.png"];
            [self addSubview:photoBg];
            
            //视频封面
            CGRect imageViewFrame = CGRectMake(5, 6, photoBg.frame.size.width - 11, photoBg.frame.size.height - 11);
            UIImageView *imageViewC = [[UIImageView alloc]initWithFrame:imageViewFrame];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",lesson.lessonImageURL]];
            [imageViewC setImageWithURL:url placeholderImage:Image(@"_money.png")];
            imageViewC.tag = [lesson.lessonId intValue];
            [imageViewC setClipsToBounds:YES];
            self.imageView = imageViewC;
            [photoBg addSubview:self.imageView];
            imageViewC = nil;
            
            //视频进度条
            self.pv = [[UISlider alloc] initWithFrame:CGRectMake(-2, imageViewFrame.size.height-22, imageViewFrame.size.width+4, 20)];
            UIImage *frontImage = [[UIImage imageNamed:@"progressBar-front.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
            UIImage *backgroundImage = [[UIImage imageNamed:@"progressBar-background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
            [self.pv setMinimumTrackImage:frontImage forState:UIControlStateNormal];
            [self.pv setMaximumTrackImage:backgroundImage forState:UIControlStateNormal];
            [self.pv setThumbImage:[UIImage imageNamed:@"nothing"] forState:UIControlStateNormal];
            [self.pv setMaximumValue:100.0];
            [self.pv setMinimumValue:0.0];
            //进度条label
            self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, imageViewFrame.size.height - 18, imageViewFrame.size.width, 20)];
            self.progressLabel.font = [UIFont systemFontOfSize:12.0];
            CGFloat xx = [lesson.lessonStudyProgress floatValue];
            if ( xx-100 >0) {
                xx=100;
            }
            if (!xx) {
                xx = 0;
            }
        self.pv.value = xx;
            self.progressLabel.text = [NSString stringWithFormat:@"完成进度:%.2f%%",xx];
            self.progressLabel.textAlignment = NSTextAlignmentLeft;
            self.progressLabel.backgroundColor = [UIColor clearColor];
            [self.imageView addSubview:self.pv];
            [self.imageView addSubview:self.progressLabel];
            
            //视频名称
            if (itemLabel>0) {  //label高度
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, itemLabel)];
                if(lesson.lessonName)nameLabel.text = [NSString stringWithFormat:@"%@",lesson.lessonName];
                nameLabel.textColor = [UIColor blackColor];
                nameLabel.numberOfLines = 0;
                nameLabel.textAlignment = NSTextAlignmentLeft;
                nameLabel.backgroundColor = [UIColor clearColor];
                nameLabel.font = [UIFont systemFontOfSize:14];
                self.nameLab = nameLabel;
                [self addSubview:self.nameLab];
                nameLabel = nil;
            }
    }
    return self;
}

//更新课程名,进度,及图片 ,及sectionId
-(void)refreshDataWithLesson:(LessonModel *)lesson{
    self.sectionId = lesson.lessonId;
    if(!self.pv){
        DLog(@"错误!应先初始化SectionCustomView!");
        return;
    }
    
    self.nameLab.text = lesson.lessonName;
    
    CGFloat xx = [lesson.lessonStudyProgress floatValue];
    if ( xx-100 >0) {
        xx=100;
    }
    if (!xx) {
        xx = 0;
    }
    self.pv.value = xx;
    self.progressLabel.text = [NSString stringWithFormat:@"完成进度:%.2f%%",xx];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",lesson.lessonImageURL]];
    [self.imageView setImageWithURL:url placeholderImage:Image(@"_money.png")];
}

@end
