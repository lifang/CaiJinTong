//
//  ChapterSearchBar_iPhone.h
//  CaiJinTongApp
//
//  Created by apple on 13-11-26.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldForSearchBar.h"
@protocol ChapterSearchBarDelegate_iPhone;
@interface ChapterSearchBar_iPhone : UIView<UITextFieldDelegate>
@property (weak,nonatomic) id<ChapterSearchBarDelegate_iPhone> delegate;
@property (nonatomic,strong) TextFieldForSearchBar *searchTextField;
@property (nonatomic,strong) UIButton *searchBt;
@property (nonatomic,strong) UIImageView *backImageView;
@end


@protocol ChapterSearchBarDelegate_iPhone <NSObject>

-(void)chapterSeachBar_iPhone:(ChapterSearchBar_iPhone*)searchBar beginningSearchString:(NSString*)searchText;
-(void)chapterSeachBar_iPhone:(ChapterSearchBar_iPhone*)searchBar clearSearchString:(NSString*)searchText;
@end