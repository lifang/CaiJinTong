//
//  BaseInterface.h
//  CaiJinTong
//
//  Created by comdosoft on 13-9-17.
//  Copyright (c) 2013年 CaiJinTong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h" 

@protocol BaseInterfaceDelegate;
@interface BaseInterface : NSObject

@property (nonatomic, retain) ASIHTTPRequest *request;
@property (nonatomic, retain) NSString *interfaceUrl;
@property (nonatomic, retain) NSDictionary *headers;
@property (nonatomic, retain) NSDictionary *bodys;
@property (nonatomic, assign) id<BaseInterfaceDelegate> baseDelegate;

-(void)connect;
@end

@protocol BaseInterfaceDelegate <NSObject>

@required
-(void)parseResult:(ASIHTTPRequest *)request;
-(void)requestIsFailed:(NSError *)error;

@optional

@end