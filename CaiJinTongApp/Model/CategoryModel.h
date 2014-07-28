//
//  CategoryModel.h
//  CaiJinTongApp
//
//  Created by david on 13-12-19.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
//分类
@interface CategoryModel : NSObject
@property (strong,nonatomic) NSString *categoryID;
@property (strong,nonatomic) NSString *categoryName;
@property (strong,nonatomic) NSMutableArray *catogoryChildArr;
@end
