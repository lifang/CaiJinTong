//
//  CaiJinTongManager.h
//  CaiJinTong
//
//  Created by comdosoft on 13-9-16.
//  Copyright (c) 2013年 CaiJinTong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserModel.h"

@interface CaiJinTongManager : NSObject
{
    BOOL _free;
    BOOL _holding;
}

@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) UserModel *user;
@property (nonatomic, strong) NSMutableArray *question;
@property (nonatomic, assign) int tagOfBtn;

@property (nonatomic, assign) BOOL isSettingView;

@property (nonatomic, assign) CGFloat defaultPortraitTopInset;
@property (nonatomic, assign) CGFloat defaultWidth;
@property (nonatomic, assign) CGFloat defaultHeight;
@property (nonatomic, assign) CGFloat defaultLeftInset;
@property (nonatomic, assign) BOOL isLoadLargeImage;//是否加载图片

+ (CaiJinTongManager *)shared;

/** hold the thread when background task will terminate */
- (void)hold;

/** free from holding when applicaiton become active */
- (void)stop;

/** running in background, call this funciton when application become background */
- (void)run;

+(NSString*)getMovieLocalPathWithSectionID:(NSString*)sectionID;
+(NSString*)getMovieLocalTempPathWithSectionID:(NSString*)sectionID;
@end
