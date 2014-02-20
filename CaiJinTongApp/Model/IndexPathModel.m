//
//  IndexPathModel.m
//  CaiJinTongApp
//
//  Created by david on 14-2-20.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "IndexPathModel.h"

@implementation IndexPathModel
+(IndexPathModel*)initWithRow:(int)row withSection:(int)section{
    IndexPathModel *model = [[IndexPathModel alloc] init];
    model.row = row;
    model.section = section;
    return model;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"IndexPathModel:row=%d,section=%d",self.row,self.section];
}
-(NSIndexPath*)getIndexPath{
    return [NSIndexPath indexPathForRow:self.row inSection:self.section];
}
@end
