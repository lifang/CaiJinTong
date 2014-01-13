//
//  SearchLearningMatarilasListInterface.m
//  CaiJinTongApp
//
//  Created by david on 14-1-7.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "SearchLearningMatarilasListInterface.h"

@implementation SearchLearningMatarilasListInterface

#if kUsingTestData
-(void)searchLearningMaterilasListWithUserId:(NSString*)userId withSearchContent:(NSString*)searchContent withPageIndex:(int)pageIndex withSortType:(NSString*)sortType{
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
-(void)searchLearningMaterilasListWithUserId:(NSString*)userId withSearchContent:(NSString*)searchContent withPageIndex:(int)pageIndex withSortType:(LearningMaterialsSortType)sortType{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
//http://lms.finance365.com/api/ios.ashx?active=searchLearningMaterials&userId=17082&searchContent=181&pageIndex=0&sortType=1
    NSString *sort = @"1";
    switch (sortType) {
        case LearningMaterialsSortType_Default:
            sort = @"1";
            break;
        case LearningMaterialsSortType_Date:
            sort = @"1";
            break;
        case LearningMaterialsSortType_Name:
            sort = @"2";
            break;
        default:
            break;
    }
    self.interfaceUrl = [NSString stringWithFormat:@"%@?active=searchLearningMaterials&userId=%@&searchContent=%@&pageIndex=%d&sortType=%@",kHost,userId,searchContent,pageIndex+1,sort];
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
                            material.materialFileSize = [NSString stringWithFormat:@"%@",[dic objectForKey:@"materialFileSize"]];
                            if (material.materialFileSize) {
                                material.materialFileSize = [Utility convertFileSizeUnitWithBytes:material.materialFileSize];
                            }
                            [materialsList addObject:material];
                            
                        }
                        if (materialsList.count > 0) {
                            [self.delegate searchLearningMaterilasListDataForCategoryDidFinished:materialsList withCurrentPageIndex:self.currentPageIndex withTotalCount:self.allDataCount];
                        }else{
                            [self.delegate searchLearningMaterilasListDataForCategoryFailure:@"没有搜索到相关资料数据!"];
                        }
                    }
                    @catch (NSException *exception) {
                        [self.delegate searchLearningMaterilasListDataForCategoryFailure:@"搜索学习资料列表失败!"];
                    }
                }else
                    if ([[jsonData objectForKey:@"Status"]intValue] == 0){
                        [self.delegate searchLearningMaterilasListDataForCategoryFailure:[jsonData objectForKey:@"Msg"]];
                    } else {
                        [self.delegate searchLearningMaterilasListDataForCategoryFailure:@"搜索学习资料列表失败!"];
                    }
            }else {
                [self.delegate searchLearningMaterilasListDataForCategoryFailure:@"搜索学习资料列表失败!"];
            }
        }else {
            [self.delegate searchLearningMaterilasListDataForCategoryFailure:@"搜索学习资料列表失败!"];
        }
    }else {
        [self.delegate searchLearningMaterilasListDataForCategoryFailure:@"搜索学习资料列表失败!"];
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
        [self.delegate searchLearningMaterilasListDataForCategoryFailure:@"搜索学习资料列表失败!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate searchLearningMaterilasListDataForCategoryFailure:@"搜索学习资料列表失败!"];
}

@end

