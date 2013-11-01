//
//  BaseInterface.m
//  CaiJinTong
//
//  Created by comdosoft on 13-9-17.
//  Copyright (c) 2013年 CaiJinTong. All rights reserved.
//

#import "BaseInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "InterfaceCache.h"

@implementation BaseInterface
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
        NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@%@",self.interfaceUrl,[CaiJinTongManager sharedInstance].sessionId];
        //url含中文转化UTF8
        urlStr = (NSMutableString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                        (CFStringRef)urlStr,
                                                                        NULL,
                                                                        NULL,
                                                                        kCFStringEncodingUTF8);
        NSURL *url = [[NSURL alloc]initWithString:urlStr];
        if (url) {
            self.request = [ASIHTTPRequest requestWithURL:url];
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
        
        [self.request setRequestMethod:@"POST"];
        
        if (self.headers) {
            for (NSString *key in self.headers) {
                [self.request addRequestHeader:key value:[self.headers objectForKey:key]];  
            }
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
    
//    NSString *result = [responseHeaders objectForKey:@"result"];
//    if (![result isEqualToString:@"success"]) {
//        //失败
//        if ([@"102" isEqualToString:[responseHeaders objectForKey:@"error-code"]]) {
//            [self.request clearDelegatesAndCancel];
//            self.request = nil;
//            
//        }
//    }
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
