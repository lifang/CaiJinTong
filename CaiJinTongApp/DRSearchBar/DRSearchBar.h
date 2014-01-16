//
//  DRSearchBar.h
//  DRSearchBar
//
//  Created by david on 14-1-13.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DRSearchBarDelegate;
@interface DRSearchBar : UIView<UITextFieldDelegate>
@property (strong,nonatomic) NSString *searchText;
@property (weak,nonatomic) id<DRSearchBarDelegate> delegate;
@property (strong, nonatomic)  UITextField *searchTextLabel;
@property (assign,nonatomic) BOOL isSearch;
@end

@protocol DRSearchBarDelegate <NSObject>

-(void)drSearchBar:(DRSearchBar*)searchBar didBeginSearchText:(NSString*)searchText;
-(void)drSearchBar:(DRSearchBar*)searchBar didCancelSearchText:(NSString*)searchText;
@end