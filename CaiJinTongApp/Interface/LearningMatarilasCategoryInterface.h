//
//  LearningMatarilasCategoryInterface.h
//  CaiJinTongApp
//
//  Created by david on 14-1-16.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "BaseInterface.h"
/*
 加载学习资料分类信息
 */
@protocol LearningMatarilasCategoryInterfaceDelegate;
@interface LearningMatarilasCategoryInterface : BaseInterface<BaseInterfaceDelegate>
@property (nonatomic, weak) id<LearningMatarilasCategoryInterfaceDelegate>delegate;
-(void)downloadLearningMatarilasCategoryDataWithUserId:(NSString*)userId;
@end
@protocol LearningMatarilasCategoryInterfaceDelegate <NSObject>
-(void)getLearningMatarilasCategoryDataDidFinished:(NSArray*)categoryLearningMatarilas;

-(void)getLearningMatarilasCategoryDataFailure:(NSString*)errorMsg;
@end
