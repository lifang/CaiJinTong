//
//  LHLTakingMovieNoteViewController.m
//  CaiJinTongApp
//
//  Created by apple on 13-12-11.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "LHLTakingMovieNoteViewController.h"


@implementation LHLTakingMovieNoteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.noteTimeLabel.text = [Utility getNowDateFromatAnDate];
    
    UIImage *btnImageHighlighted = [[UIImage imageNamed:@"btn0.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6) resizingMode:UIImageResizingModeStretch];
    UIImage *btnImageNormal = [[UIImage imageNamed:@"btn1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6) resizingMode:UIImageResizingModeStretch];
    [self.cancelBtn setBackgroundImage:btnImageNormal forState:UIControlStateNormal];
    [self.cancelBtn setBackgroundImage:btnImageHighlighted forState:UIControlStateHighlighted];
    [self.commitBtn setBackgroundImage:btnImageNormal forState:UIControlStateNormal];
    [self.commitBtn setBackgroundImage:btnImageHighlighted forState:UIControlStateHighlighted];
    
    self.contentField.layer.borderColor = [UIColor grayColor].CGColor;
    self.contentField.layer.borderWidth =1.0;
    self.contentField.layer.cornerRadius =5.0;
    
    [self.view.layer setCornerRadius:6];
    [self.view.layer setMasksToBounds:YES];
    
    //添加键盘消失键
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, IP5(568, 480), 25)];
    [topView setBarStyle:UIBarStyleBlack];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(spaceAreaClicked:)];
    
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    [topView setItems:buttonsArray];
    [self.contentField setInputAccessoryView:topView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)spaceAreaClicked:(id)sender {
    [self.contentField resignFirstResponder];
}

- (IBAction)cancelBtnClicked:(UIButton *)sender {
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopTop];
    if (self.delegate && [self.delegate respondsToSelector:@selector(takingMovieNoteControllerCancel)]) {
        [self.delegate takingMovieNoteControllerCancel];
    }
}

- (IBAction)commitBtnClicked:(UIButton *)sender {
    if (self.contentField.text == nil || [[self.contentField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [Utility errorAlert:@"内容不能为空"];
    }else {
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopTop];
        if (self.delegate && [self.delegate respondsToSelector:@selector(takingMovieNoteController:commitNote: andTime:)]) {
            [self.delegate takingMovieNoteController:self commitNote:self.contentField.text andTime:self.noteTimeLabel.text];
        }
    }
}



@end