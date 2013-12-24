//
//  Section_ChapterCell.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-5.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "Section_ChapterCell.h"
#import "Section.h"
@implementation Section_ChapterCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)changeState:(NSNotification *)info {
    SectionSaveModel *sectionSave = (SectionSaveModel *)[info.userInfo objectForKey:@"SectionSaveModel"];
    if ([self.sid isEqualToString:sectionSave.sid]) {
        self.pv = sectionSave.downloadPercent;
        self.sliderFrontView.frame = CGRectMake(47, 73, 484 * self.pv, 33);
        //查询数据库
        Section *sectionDb = [[Section alloc]init];
        float contentlength = [sectionDb getContentLengthBySid:sectionSave.sid];
        if (contentlength>0) {
            self.lengthLab.text = [NSString stringWithFormat:@"%.2fM/%.2fM",contentlength*sectionSave.downloadPercent,contentlength];
        }
    }
}

-(IBAction)playBtClicked:(id)sender{

}
-(void)layoutSubviews{
    [super layoutSubviews];
    //下载进度条更新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeState:) name:@"DownloadProcessing" object:nil];
}
@end
