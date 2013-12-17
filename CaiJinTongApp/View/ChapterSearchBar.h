//
//  ChapterSearchBar.h
//  CaiJinTongApp
//
//  Created by david on 13-11-17.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChapterSearchBarDelegate;
@interface ChapterSearchBar : UIView<UITextFieldDelegate>
@property (weak,nonatomic) id<ChapterSearchBarDelegate> delegate;
@property (nonatomic,strong) UITextField *searchTextField;
@property (nonatomic,strong) UIButton *searchBt;
@property (nonatomic,strong) UILabel *searchTipLabel;
-(void)addSearchText:(NSString*)searchText;
@end


@protocol ChapterSearchBarDelegate <NSObject>

-(void)chapterSeachBar:(ChapterSearchBar*)searchBar beginningSearchString:(NSString*)searchText;

@end