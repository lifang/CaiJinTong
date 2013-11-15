//
//  CustomButton.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-6.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionSaveModel.h"
#import "SectionInfoInterface.h"
@interface CustomButton : UIButton<SectionInfoInterfaceDelegate>

@property (nonatomic, strong) SectionSaveModel *buttonModel;
@property (nonatomic, strong) SectionInfoInterface *sectionInterface;
@end
