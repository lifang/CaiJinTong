//
//  Section_ChapterCell.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-5.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMProgressView.h"
@interface Section_ChapterCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *nameLab;//标题
@property (nonatomic, strong) IBOutlet UILabel *statusLab;//正在下载／未下咋
@property (nonatomic, strong) IBOutlet UILabel *lengthLab;//视频大小：80/M
@property (nonatomic, strong) IBOutlet UILabel *timeLab;//视频时长
@property (nonatomic, strong) AMProgressView *pv;//视频下载进度
@property (nonatomic, strong) IBOutlet UIButton *btn;//下载按钮
@end
