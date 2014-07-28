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
#import "SUNSlideSwitchView_iPhone.h"
#import "Section_ChapterViewController_iPhone.h"
#import "Section_NoteViewController_iPhone.h"
#import "Section_GradeViewController_iPhone.h"
#import "CommentModel.h"
#import "LHLMoviePlayViewController.h"
#import "SplitLessonTableView.h"

@interface SectionViewController_iPhone : LHLNavigationBarViewController<SUNSlideSwitchView_iPhoneDelegate,UIScrollViewDelegate,LHLMoviePlayViewControllerDelegate,PlayVideoInterfaceDelegate,LessonInfoInterfaceDelegate,Section_NoteViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>

//界面
@property (nonatomic,strong) SectionCustomView_iPhone *sectionView;
@property (nonatomic, strong) UILabel *nameLab,*teacherlab,*infoLab,*lastLab,*studyLab;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic, strong) CustomLabel_iPhone *scoreLab;
@property (nonatomic,strong) UIButton *playBtn;
@property (strong, nonatomic) SUNSlideSwitchView_iPhone *slideSwitchView;
@property (nonatomic, strong) Section_ChapterViewController_iPhone *section_ChapterView;
@property (nonatomic, strong) Section_GradeViewController_iPhone *section_GradeView;
@property (nonatomic, strong) Section_NoteViewController_iPhone *section_NoteView;
//@property (nonatomic,strong) LHLMoviePlayViewController *playerController;
//数据
@property (nonatomic,strong) SectionModel *section;
@property (nonatomic,strong) LessonModel *lessonModel;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) PlayVideoInterface *playVideoInterface;

//- (void)initAppear;
//- (void)initAppear_slide;

@end
