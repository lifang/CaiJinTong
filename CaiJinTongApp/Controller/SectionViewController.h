//
//  SectionViewController.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-5.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "DRNaviGationBarController.h"
#import "SectionCustomView.h"
#import "SectionModel.h"
#import "SUNSlideSwitchView.h"
#import "Section_ChapterViewController.h"
#import "Section_GradeViewController.h"
#import "Section_NoteViewController.h"
#import "CustomLabel.h"

@interface SectionViewController : DRNaviGationBarController<SUNSlideSwitchViewDelegate>

@property (nonatomic, strong) SectionCustomView *sectionView;
@property (nonatomic, strong) SectionModel *section;

@property (nonatomic, strong) IBOutlet SUNSlideSwitchView *slideSwitchView;
@property (nonatomic, strong) Section_ChapterViewController *section_ChapterView;
@property (nonatomic, strong) Section_GradeViewController *section_GradeView;
@property (nonatomic, strong) Section_NoteViewController *section_NoteView;


@property (nonatomic, strong) UILabel *nameLab,*infoLab,*teacherlab,*studyLab,*lastLab;
@property (nonatomic, strong) CustomLabel *scoreLab;
@property (nonatomic, strong) UIButton *playBtn;
@end
