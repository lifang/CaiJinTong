//
//  DownLoadInformView.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-6.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionSaveModel.h"

@interface DownLoadInformView : UIView

@property (nonatomic, strong)IBOutlet UILabel*mLable;
@property (nonatomic, strong)IBOutlet UIButton*downStateBtn;
@property (nonatomic, strong)IBOutlet UIButton*canceLoadBtn;
@property (nonatomic, strong)IBOutlet UIImageView*mImageView;
@property (nonatomic, strong)IBOutlet UIView *mview;

@property (nonatomic, strong) SectionSaveModel *nm1;

-(IBAction)cancleAction:(id)sender;
@end
