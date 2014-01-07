//
//  LearningMatarilasListInterface.m
//  CaiJinTongApp
//
//  Created by david on 14-1-7.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "LearningMatarilasListInterface.h"

@implementation LearningMatarilasListInterface

#if kUsingTestData
-(void)downloadlearningMaterilasListForCategoryId:(NSString*)categoryId withUserId:(NSString*)userId withPageIndex:(int)pageIndex withSortType:(NSString*)sortType{
    NSString *path = [NSBundle pathForResource:@"LearningMaterials" ofType:@"geojson" inDirectory:[[NSBundle mainBundle] bundlePath]];
    NSData *data = [NSData dataWithContentsOfFile:path];
    id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self parseJsonData:jsonData];
    });
}
#else
-(void)downloadlearningMaterilasListForCategoryId:(NSString*)categoryId withUserId:(NSString*)userId withPageIndex:(int)pageIndex withSortType:(NSString*)sortType{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    self.lessonCategoryId = categoryId;
    //    http://lms.finance365.com/api/ios.ashx?active=learningMaterials&userId=17082&lessonCategoryId=181&pageIndex=0&sortType=1
    self.interfaceUrl = [NSString stringWithFormat:@"%@?active=learningMaterials&userId=%@&lessonCategoryId=%@&pageIndex=%d&sortType=%@",kHost,userId,categoryId,pageIndex+1,sortType];
    self.baseDelegate = self;
    self.headers = reqheaders;
    
    [self connect];
}
#endif


-(void)parseJsonData:(id)jsonObject{
    if (jsonObject !=nil) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)jsonObject;
            DLog(@"data = %@",jsonData);
            if (jsonData) {
                if ([[jsonData objectForKey:@"Status"]intValue] == 1) {
                    @try {
                        self.currentPageIndex = [[jsonData objectForKey:@"pageIndex"] integerValue]-1;
                        self.allDataCount = [[jsonData objectForKey:@"pageCount"] integerValue];
                        NSArray *materialsArr = [jsonData objectForKey:@"learningMaterials"];
                        NSMutableArray *materialsList = [NSMutableArray array];
                        for (NSDictionary *dic in materialsArr) {
                            LearningMaterials *material = [[LearningMaterials alloc] init];
                            material.materialId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"materialId"]];
                            material.materialName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"materialName"]];
                            material.materialLessonCategoryId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"lessonCategoryId"]];
                            material.materialLessonCategoryName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"lessonCategoryName"]];
                            //1:pdf，2:word，3:zip，4:ppt，5:jpg，6:text，7:其他
                            switch ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"materialFileType"]] intValue]) {
                                case 1:
                                    material.materialFileType = LearningMaterialsFileType_pdf;
                                    break;
                                case 2:
                                    material.materialFileType = LearningMaterialsFileType_word;
                                    break;
                                case 3:
                                    material.materialFileType = LearningMaterialsFileType_zip;
                                    break;
                                case 4:
                                    material.materialFileType = LearningMaterialsFileType_ppt;
                                    break;
                                case 5:
                                    material.materialFileType = LearningMaterialsFileType_text;
                                    break;
                                case 6:
                                    material.materialFileType = LearningMaterialsFileType_other;
                                    break;
                                default:
                                    break;
                            }
                            material.materialSearchCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"materialSearchCount"]];
                            material.materialCreateDate = [NSString stringWithFormat:@"%@",[dic objectForKey:@"materialCreateDate"]];
                            material.materialFileDownloadURL = [NSString stringWithFormat:@"%@",[dic objectForKey:@"materialFileDownloadURL"]];
                            [materialsList addObject:material];
                        }
                        if (materialsList.count > 0) {
                            [self.delegate getlearningMaterilasListDataForCategoryDidFinished:materialsList withCurrentPageIndex:self.currentPageIndex withTotalCount:self.allDataCount];
                        }else{
                            [self.delegate getlearningMaterilasListDataForCategoryFailure:@"没有相关资料数据!"];
                        }
                    }
                    @catch (NSException *exception) {
                        [self.delegate getlearningMaterilasListDataForCategoryFailure:@"获取资料列表失败!"];
                    }
                }else
                    if ([[jsonData objectForKey:@"Status"]intValue] == 0){
                        [self.delegate getlearningMaterilasListDataForCategoryFailure:[jsonData objectForKey:@"Msg"]];
                    } else {
                        [self.delegate getlearningMaterilasListDataForCategoryFailure:@"获取资料列表失败!"];
                    }
            }else {
                [self.delegate getlearningMaterilasListDataForCategoryFailure:@"获取资料列表失败!"];
            }
        }else {
            [self.delegate getlearningMaterilasListDataForCategoryFailure:@"获取资料列表失败!"];
        }
    }else {
        [self.delegate getlearningMaterilasListDataForCategoryFailure:@"获取资料列表失败!"];
    }
}

#pragma mark - BaseInterfaceDelegate

-(void)parseResult:(ASIHTTPRequest *)request{
    NSDictionary *resultHeaders = [request responseHeaders];
    if (resultHeaders) {
        NSData *data = [[NSData alloc]initWithData:[request responseData]];
        id jsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        [self parseJsonData:jsonObject];
    }else {
        [self.delegate getlearningMaterilasListDataForCategoryFailure:@"获取资料列表失败!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getlearningMaterilasListDataForCategoryFailure:@"获取资料列表失败!"];
}

@end

