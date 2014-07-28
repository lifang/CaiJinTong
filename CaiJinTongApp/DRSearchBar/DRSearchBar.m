//
//  DRSearchBar.m
//  DRSearchBar
//
//  Created by david on 14-1-13.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "DRSearchBar.h"
#define kpadding 10
#define kcancelButtonWidth  40
#define kcancelButtonFont [UIFont systemFontOfSize:15]
@interface DRSearchBar()
@property (strong, nonatomic)  UIImageView *searchBackView;
@property (strong, nonatomic)  UIButton *cancelBt;
@property (strong, nonatomic)  UIButton *searchBt;

@end
@implementation DRSearchBar
- (void)cancelBtClicked:(id)sender {
    _isSearch = NO;
    self.searchTextLabel.text = @"";
    [self.cancelBt setHidden:YES];
    [self.searchTextLabel resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(drSearchBar:didCancelSearchText:)]) {
        [self.delegate drSearchBar:self didCancelSearchText:self.searchTextLabel.text];
    }
}
- (void)searchBarClicked:(id)sender {
    if (!self.searchTextLabel.text || [self.searchTextLabel.text isEqualToString:@""]) {
        return;
    }
     [self.searchTextLabel resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(drSearchBar:didBeginSearchText:)]) {
        [self.delegate drSearchBar:self didBeginSearchText:self.searchTextLabel.text];
    }
}

#pragma mark UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *oldString = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *newString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([newString isEqualToString:@""] && oldString.length > 0) {
        oldString = [oldString stringByReplacingCharactersInRange:NSMakeRange(oldString.length-1, 1) withString:newString];
    }else{
        oldString = [NSString stringWithFormat:@"%@%@",oldString,newString];
    }
    
    if ([oldString isEqualToString:@""] ) {
        [self.cancelBt setHidden:YES];
    }else{
        [self.cancelBt setHidden:NO];
    }
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.isSearch = YES;
    if ([textField.text isEqualToString:@""]) {
        [self.cancelBt setHidden:YES];
    }else{
        [self.cancelBt setHidden:NO];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(drSearchBar:didBeginSearchText:)]) {
        [self.delegate drSearchBar:self didBeginSearchText:self.searchTextLabel.text];
    }
    return YES;
}
#pragma mark --


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.searchBackView = [[UIImageView alloc] initWithFrame:(CGRect){0,0,frame.size}];
        self.searchBackView.image = [UIImage imageNamed:@"searchBar_Backview.png"];
        self.searchBackView.autoresizingMask = UIViewAutoresizingNone;
        [self addSubview:self.searchBackView];
        
        self.searchBt = [[UIButton alloc] initWithFrame:(CGRect){0,0,frame.size.height,frame.size.height}];
        [self.searchBt setBackgroundColor:[UIColor clearColor]];
        [self.searchBt addTarget:self action:@selector(searchBarClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.searchBt setImage:[UIImage imageNamed:@"navi_search_blue.png"] forState:UIControlStateNormal];
        self.searchBt.autoresizingMask = UIViewAutoresizingNone;
        [self addSubview:self.searchBt];
        
        if (platform>=7.0) {
            self.searchTextLabel = [[UITextField alloc] initWithFrame:(CGRect){CGRectGetMaxX(self.searchBt.frame),0,frame.size.width - CGRectGetMaxX(self.searchBt.frame) - kcancelButtonWidth,frame.size.height}];
        }else {
            self.searchTextLabel = [[UITextField alloc] initWithFrame:(CGRect){CGRectGetMaxX(self.searchBt.frame),5,frame.size.width - CGRectGetMaxX(self.searchBt.frame) - kcancelButtonWidth,frame.size.height}];
        }
        
        self.searchTextLabel.delegate = self;
        self.searchTextLabel.borderStyle = UITextBorderStyleNone;
        self.searchTextLabel.enablesReturnKeyAutomatically = YES;
        self.searchTextLabel.returnKeyType = UIReturnKeySearch;
        self.searchTextLabel.backgroundColor = [UIColor clearColor];
        self.searchTextLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.searchTextLabel];
        
        self.cancelBt = [[UIButton alloc] initWithFrame:(CGRect){frame.size.width - kcancelButtonWidth - kpadding,0,kcancelButtonWidth,frame.size.height}];
        [self.cancelBt setBackgroundColor:[UIColor clearColor]];
        [self.cancelBt setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelBt.titleLabel setFont:kcancelButtonFont];
        self.cancelBt.autoresizingMask = UIViewAutoresizingNone;
        [self.cancelBt addTarget:self action:@selector(cancelBtClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelBt setHidden:YES];
        [self addSubview:self.cancelBt];
        
    }
    return self;
}

#pragma mark property
-(NSString *)searchText{
    return self.searchTextLabel.text;
}

-(void)setIsSearch:(BOOL)isSearch{
    _isSearch = isSearch;
    if (!isSearch) {
        self.searchTextLabel.text = @"";
        [self.searchTextLabel resignFirstResponder];
        [self.cancelBt setHidden:YES];
    }
}
#pragma mark --
@end
