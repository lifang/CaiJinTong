//
//  LearningMaterials.h
//  CaiJinTongApp
//
//  Created by david on 14-1-7.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 学习资料
 */
//1:pdf，2:word，3:zip，4:ppt，5:jpg，6:text，7:其他
typedef enum {
    LearningMaterialsFileType_pdf,
    LearningMaterialsFileType_word,
    LearningMaterialsFileType_zip,
    LearningMaterialsFileType_ppt,
    LearningMaterialsFileType_jpg,
    LearningMaterialsFileType_text,
    LearningMaterialsFileType_other
}LearningMaterialsFileType;
@interface LearningMaterials : NSObject
@property (strong,nonatomic) NSString *materialId;//资料id
@property (strong,nonatomic) NSString *materialName;//资料名称
@property (strong,nonatomic) NSString *materialLessonCategoryId;//资料所在的分类ID
@property (strong,nonatomic) NSString *materialLessonCategoryName;//资料所在的分类名称
@property (assign,nonatomic) LearningMaterialsFileType materialFileType;//资料文件类型
@property (strong,nonatomic) NSString *materialFileSize;//资料文件大小
@property (strong,nonatomic) NSString *materialSearchCount;//资料查看次数
@property (strong,nonatomic) NSString *materialCreateDate;//资料创建时间
@property (strong,nonatomic) NSString *materialFileDownloadURL;//资料下载URL
@property (strong,nonatomic) NSString *materialFileLocalPath;//资料本地地址
@property (assign,nonatomic) DownloadStatus materialFileDownloadStaus;//资料本地地址
@end
