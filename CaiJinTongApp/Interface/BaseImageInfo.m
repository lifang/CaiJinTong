//
//  BaseImageInfo.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-25.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseImageInfo.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "InterfaceCache.h"

@implementation BaseImageInfo
@synthesize baseDelegate = _baseDelegate , request = _request;
@synthesize interfaceUrl = _interfaceUrl , headers = _headers , bodys = _bodys;

-(NSString *)createPostURL:(NSDictionary *)params
{
    NSString *postString=@"";
    for(NSString *key in [params allKeys])
    {
        NSString *value=[params objectForKey:key];
        postString=[postString stringByAppendingFormat:@"%@=%@&",key,value];
    }
    if([postString length]>1)
    {
        postString=[postString substringToIndex:[postString length]-1];
    }
    return postString;
}

-(void)connect {
    if (self.interfaceUrl) {
        NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@",self.interfaceUrl];
        //url含中文转化UTF8
        urlStr = (NSMutableString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                            (CFStringRef)urlStr,
                                                                            NULL,
                                                                            NULL,
                                                                            kCFStringEncodingUTF8);
        NSURL *url = [[NSURL alloc]initWithString:urlStr];
        if (url) {
            self.request = [ASIFormDataRequest requestWithURL:url];
        }
        
        [url release];
        
        //设置缓存机制
        [[InterfaceCache sharedCache] setShouldRespectCacheControlHeaders:NO];
        [self.request setDownloadCache:[InterfaceCache sharedCache]];
        [self.request setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
        [self.request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        
        [self.request setTimeOutSeconds:60];
        NSString *postURL=[self createPostURL:self.headers];
        NSMutableData *postData = [[NSMutableData alloc]initWithData:[postURL dataUsingEncoding:NSUTF8StringEncoding]];
        [self.request setPostBody:postData];
        [self.request setData:self.imageData withFileName:@"header.png" andContentType:@"image/jpeg" forKey:@"img"];
        [self.request setRequestMethod:@"POST"];
        if (self.headers) {
            for (NSString *key in self.headers) {
                [self.request addRequestHeader:key value:[self.headers objectForKey:key]];
            }//添加getter请求参数
        }
        [self.request setDelegate:self];
        [self.request startAsynchronous];
        
    }else{
        //抛出异常
    }
}
#pragma mark - ASIHttpRequestDelegate
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders {
    responseHeaders = [responseHeaders allKeytoLowerCase];
    
}

-(void)requestFinished:(ASIHTTPRequest *)request {
    
    [self.baseDelegate parseResult:request];
}

-(void)requestFailed:(ASIHTTPRequest *)request {
    DLog(@"error");
    [_baseDelegate requestIsFailed:request.error];
}


-(void)dealloc {
    self.baseDelegate = nil;
    [self.request clearDelegatesAndCancel];
    self.request = nil;
    self.interfaceUrl = nil;
    self.headers = nil;
    self.bodys = nil;
    
    [super dealloc];
}

@end
