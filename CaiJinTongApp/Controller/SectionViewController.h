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
@interface SectionViewController : DRNaviGationBarController

@property (nonatomic, strong) SectionCustomView *sectionView;
@property (nonatomic, strong) SectionModel *section;
@end
