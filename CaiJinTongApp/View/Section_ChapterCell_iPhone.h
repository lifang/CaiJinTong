//
//  Section_ChapterCell_iPhone.h
//  CaiJinTongApp
//
//  Created by apple on 13-11-29.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@interface Section_ChapterCell_iPhone : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;      //标题
@property (weak, nonatomic) IBOutlet UILabel *statusLab;    //正在下载/未下载
@property (weak, nonatomic) IBOutlet UILabel *lengthLab;    //视频大小: 80M
@property (weak, nonatomic) IBOutlet UILabel *timeLab;      //视频时长
@property (weak, nonatomic) IBOutlet CustomButton *btn;     //下载按钮
@property (weak, nonatomic) IBOutlet UIView *sliderFrontView;//进度条

@property ( nonatomic) double pv;//视频下载进度
@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) SectionSaveModel *sectionS;
@end
