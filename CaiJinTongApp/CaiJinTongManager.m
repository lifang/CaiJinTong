//
//  CaiJinTongManager.m
//  CaiJinTong
//
//  Created by comdosoft on 13-9-16.
//  Copyright (c) 2013年 CaiJinTong. All rights reserved.
//

#import "CaiJinTongManager.h"

@implementation CaiJinTongManager

+(NSString*)getMovieLocalTempPathWithSectionID:(NSString*)sectionID{
    NSString *documentDir = nil;
    if (platform>5.0) {
        documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }else{
        documentDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    documentDir = [documentDir stringByAppendingPathComponent:@"Application"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentDir isDirectory:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:documentDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *path = [documentDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",sectionID]];
    DLog(@"path = %@",path);//本地保存路径
    return path;
}

+(NSString*)getMovieLocalPathWithSectionID:(NSString*)sectionID withSuffix:(NSString*)suffix{
    NSString *documentDir = nil;
    if (platform>5.0) {
        documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }else{
        documentDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    documentDir = [documentDir stringByAppendingPathComponent:@"Application"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentDir isDirectory:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:documentDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *path = [documentDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",sectionID,suffix?:@"mp4"]];
    DLog(@"path = %@",path);//本地保存路径
    return path;
}
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (CaiJinTongManager *)shared {
    static CaiJinTongManager * caiJinTongManager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        caiJinTongManager = [[super alloc] init];
    });
    return caiJinTongManager;
}
#pragma mark - public method
- (void)hold
{
    _holding = YES;
    while (_holding) {
        [NSThread sleepForTimeInterval:1];
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, TRUE);
    }
}

- (void)stop
{
    _holding = NO;
    DLog(@"end");
    if (background_task != UIBackgroundTaskInvalid) {
        UIApplication *application = [UIApplication sharedApplication];
        [application endBackgroundTask:background_task];
        background_task = UIBackgroundTaskInvalid;
    }
}
 static UIBackgroundTaskIdentifier background_task;
- (void)run
{
    UIApplication *application = [UIApplication sharedApplication];
    
    background_task = [application beginBackgroundTaskWithExpirationHandler: ^ {
//        [self hold];
        [application endBackgroundTask: background_task];
        background_task = UIBackgroundTaskInvalid;
    }];
    
}


-(void)setDefaultLeftInset:(CGFloat)defaultLeftInset {
    if (_defaultLeftInset != defaultLeftInset) {
        _defaultLeftInset = defaultLeftInset;
    }
}
-(void)setDefaultHeight:(CGFloat)defaultHeight {
    if (_defaultHeight != defaultHeight) {
        _defaultHeight = defaultHeight;
    }
}

-(void)setDefaultWidth:(CGFloat)defaultWidth {
    if (_defaultWidth != defaultWidth) {
        _defaultWidth = defaultWidth;
    }
}
-(void)setDefaultPortraitTopInset:(CGFloat)defaultPortraitTopInset {
    if (_defaultPortraitTopInset != defaultPortraitTopInset) {
        _defaultPortraitTopInset = defaultPortraitTopInset;
    }
}

@end
