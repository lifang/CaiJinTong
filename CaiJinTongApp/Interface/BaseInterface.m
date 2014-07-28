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
//    if([postString length]>1)
//    {
//        postString=[postString substringToIndex:[postString length]-1];
//    }
    return postString;
}

-(NSString *)createPostURLLogin:(NSDictionary *)params
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
-(void)connectMethod:(NSString*)method{
    if (self.interfaceUrl) {
        DLog(@"url:%@",self.interfaceUrl);
        NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@",self.interfaceUrl];
        //url含中文转化UTF8
        urlStr = (__bridge_transfer NSMutableString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                              (CFStringRef)urlStr,
                                                                                              NULL,
                                                                                              NULL,
                                                                                              kCFStringEncodingUTF8);
        NSURL *url = [[NSURL alloc]initWithString:urlStr];
        if (url) {
            self.request = [ASIHTTPRequest requestWithURL:url];
        }
        //设置缓存机制
        [[InterfaceCache sharedCache] setShouldRespectCacheControlHeaders:NO];
        [self.request setDownloadCache:[InterfaceCache sharedCache]];
        [self.request setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
        [self.request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        
        [self.request setTimeOutSeconds:60];
        NSString *postURL=[self createPostURL:self.headers];
        NSMutableData *postData = [[NSMutableData alloc]initWithData:[postURL dataUsingEncoding:NSUTF8StringEncoding]];
        
        [self.request setPostBody:postData];
        [self.request setRequestMethod:method];
        [self.request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
        [self.request setDelegate:self];
        [self.request startAsynchronous];
        
    }else{
        //抛出异常
    }
}
-(void)connectLogin{
    if (self.interfaceUrl) {
        DLog(@"url:%@",self.interfaceUrl);
        NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@",self.interfaceUrl];
        //url含中文转化UTF8
        urlStr = (__bridge_transfer NSMutableString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                              (CFStringRef)urlStr,
                                                                                              NULL,
                                                                                              NULL,
                                                                                              kCFStringEncodingUTF8);
        NSURL *url = [[NSURL alloc]initWithString:urlStr];
        if (url) {
            self.request = [ASIHTTPRequest requestWithURL:url];
        }
        //设置缓存机制
        [[InterfaceCache sharedCache] setShouldRespectCacheControlHeaders:NO];
        [self.request setDownloadCache:[InterfaceCache sharedCache]];
        [self.request setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
        [self.request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        
        [self.request setTimeOutSeconds:60];
        NSString *postURL=[self createPostURLLogin:self.headers];
        //        DLog(@"URL:%@?%@",self.interfaceUrl,postURL);
        NSMutableData *postData = [[NSMutableData alloc]initWithData:[postURL dataUsingEncoding:NSUTF8StringEncoding]];
        
        [self.request setPostBody:postData];
        [self.request setRequestMethod:@"POST"];
        [self.request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
        [self.request setDelegate:self];
        [self.request startAsynchronous];
        
    }else{
        //抛出异常
    }
}
-(void)connect {
    if (self.interfaceUrl) {
        DLog(@"url:%@",self.interfaceUrl);
        NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@",self.interfaceUrl];
        //url含中文转化UTF8
        urlStr = (__bridge_transfer NSMutableString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                        (CFStringRef)urlStr,
                                                                        NULL,
                                                                        NULL,
                                                                        kCFStringEncodingUTF8);
        NSURL *url = [[NSURL alloc]initWithString:urlStr];
        if (url) {
            self.request = [ASIHTTPRequest requestWithURL:url];
        }
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
        [self.request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
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
}

@end
