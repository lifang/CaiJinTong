//
//  IndexPathModel.h
//  CaiJinTongApp
//
//  Created by david on 14-2-20.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndexPathModel:NSObject
@property (nonatomic,assign) int row;
@property (nonatomic,assign) int section;
+(IndexPathModel*)initWithRow:(int)row withSection:(int)section;
-(NSIndexPath*)getIndexPath;
@end