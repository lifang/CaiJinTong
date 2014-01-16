//
//  DRImageButton.h
//  CaiJinTongApp
//
//  Created by david on 14-1-9.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    DRImageButtonType_Default,
    DRImageButtonType_DateSort,
    DRImageButtonType_NameSort,
    DRImageButtonType_Other
}DRImageButtonType;
@protocol DRImageButtonDelegate;
@interface DRImageButton : UIView
@property (weak,nonatomic) IBOutlet UILabel *titleLabel;
@property (weak,nonatomic) IBOutlet UIImageView *titleImageView;
@property (assign,nonatomic) DRImageButtonType imageButtonType;
@property (weak,nonatomic) IBOutlet id<DRImageButtonDelegate> delegate;
-(IBAction)imageButtonClicked:(id)sender;
-(void)setTitle:(NSString*)title withImage:(UIImage*)image withType:(DRImageButtonType)type;
@end

@protocol DRImageButtonDelegate <NSObject>

-(void)imageButton:(DRImageButton*)imageButton withType:(DRImageButtonType)type;

@end