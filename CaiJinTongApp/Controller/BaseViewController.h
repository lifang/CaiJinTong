//
//  BaseViewController.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-22.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
- (void)keyBoardWillShow:(id)sender;
- (void)keyBoardWillHide:(id)sender;
-(void)popouViewFinishedFrameRect:(id)sender;
@end
