//
//  SectionViewController_iPhone.h
//  CaiJinTongApp
//
//  Created by apple on 13-11-28.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "LHLNavigationBarViewController.h"
#import "SectionModel.h"
#import "SectionCustomView_iPhone.h"
#import "CustomLabel_iPhone.h"
#import "SUNSlideSwitchView.h"
@interface SectionViewController_iPhone : LHLNavigationBarViewController<SUNSlideSwitchViewDelegate,UIScrollViewDelegate>

//界面
@property (nonatomic,strong) SectionCustomView_iPhone *sectionView;
@property (nonatomic, strong) UILabel *nameLab,*teacherlab,*infoLab,*lastLab,*studyLab;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic, strong) CustomLabel_iPhone *scoreLab;
@property (nonatomic,strong) UIButton *playBtn;
@property (weak, nonatomic) IBOutlet SUNSlideSwitchView *slideSwitchView;


//数据
@property (nonatomic,strong) SectionModel *section;
@end
