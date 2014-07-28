//
//  Section_ChapterCell.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-5.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMProgressView.h"
#import "CustomButton.h"
#import "SectionModel.h"

@interface Section_ChapterCell : UITableViewCell

@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) IBOutlet UILabel *nameLab;//标题
@property (nonatomic, strong) IBOutlet UILabel *statusLab;//正在下载／未下载
@property (nonatomic, strong) IBOutlet UILabel *lengthLab;//视频大小：80/M
@property (nonatomic, strong) IBOutlet UILabel *timeLab;//视频时长
@property ( nonatomic) double pv;//视频下载进度
@property (strong, nonatomic) IBOutlet UIImageView *sliderFrontView;
@property (weak, nonatomic) IBOutlet UIView *sliderBackView;

@property (nonatomic, strong) IBOutlet CustomButton *btn;//下载按钮
@property (assign,nonatomic) BOOL isMoviePlayView;
@property (nonatomic, strong) IBOutlet UIButton *playBt;
@property (nonatomic, strong)  SectionModel *sectionModel;
-(IBAction)playBtClicked:(id)sender;

///重新加载cell时调用
-(void)continueDownloadFileWithDownloadStatus:(DownloadStatus)status;
-(void)beginReceiveNotification;
@end
