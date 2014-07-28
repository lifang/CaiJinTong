//
//  LHLTakingMovieNoteViewController.m
//  CaiJinTongApp
//
//  Created by apple on 13-12-11.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "LHLTakingMovieNoteViewController.h"
@interface LHLTakingMovieNoteViewController()
@property (nonatomic,assign) CGRect frame;   //3个用于保存初始坐标的变量
@property (nonatomic,assign) CGRect contentTextViewFrame;
@property (nonatomic,assign) CGFloat buttonY;
@property (nonatomic,assign) BOOL originsRecorded;
@end

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
    [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.commitBtn setBackgroundImage:btnImageNormal forState:UIControlStateNormal];
    [self.commitBtn setBackgroundImage:btnImageHighlighted forState:UIControlStateHighlighted];
    [self.commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    self.contentField.layer.borderColor = [UIColor grayColor].CGColor;
    self.contentField.layer.borderWidth =1.0;
    self.contentField.layer.cornerRadius =5.0;
    self.contentField.delegate = self;
    
    [self.view.layer setCornerRadius:6];
    [self.view.layer setMasksToBounds:YES];
    
//    //添加键盘消失键
//    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, IP5(568, 480), 25)];
//    [topView setBarStyle:UIBarStyleBlack];
//    
//    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    
//    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(spaceAreaClicked:)];
//    
//    
//    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
//    [topView setItems:buttonsArray];
//    [self.contentField setInputAccessoryView:topView];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)spaceAreaClicked:(id)sender {
    [self.contentField resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
//        self.view.frame = (CGRect){self.view.frame.origin,self.view.frame.size.width,120};
        self.view.center = (CGPoint){self.view.center.x,150};
    }];
}

- (IBAction)cancelBtnClicked:(UIButton *)sender {
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopTop];
    if (self.delegate && [self.delegate respondsToSelector:@selector(takingMovieNoteControllerCancel)]) {
        [self.delegate takingMovieNoteControllerCancel];
    }
}

- (IBAction)commitBtnClicked:(UIButton *)sender {
    if ([self.contentField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 500) {
        [Utility errorAlert:@"笔记长度不能超过500字!"];
        return;
    }
    if (self.contentField.text == nil || [[self.contentField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [Utility errorAlert:@"内容不能为空"];
    }else {
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopTop];
        if (self.delegate && [self.delegate respondsToSelector:@selector(takingMovieNoteController:commitNote: andTime:)]) {
            [self.delegate takingMovieNoteController:self commitNote:self.contentField.text andTime:self.noteTimeLabel.text];
        }
    }
}

#pragma mark UITextField delegate
//-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    if(!self.originsRecorded){
//        self.frame = self.view.frame;
//        self.contentTextViewFrame = self.contentField.frame;
//        self.buttonY = self.cancelBtn.frame.origin.y;
//    }
//    [UIView animateWithDuration:0.3 animations:^{
//        CGRect frame = self.view.frame;
//        self.view.frame = (CGRect){frame.origin.x,-20,frame.size.width,frame.size.height - 45};
//        frame = self.contentField.frame;
//        self.contentField.frame = (CGRect){frame.origin,frame.size.width,120};
//        CGFloat buttonY = CGRectGetMaxY(self.contentField.frame) + 3;
//        self.cancelBtn.frame = (CGRect){self.cancelBtn.frame.origin.x,buttonY,self.cancelBtn.frame.size};
//        self.commitBtn.frame = (CGRect){self.commitBtn.frame.origin.x,buttonY,self.commitBtn.frame.size};
//    }];
//    return YES;
//}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = (CGRect){self.view.frame.origin,self.view.frame.size.width,120};
        self.view.center = (CGPoint){self.view.center.x,CGRectGetHeight(self.view.frame)/2};
    }];
    return YES;
}
@end