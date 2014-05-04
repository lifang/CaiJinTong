//
//  LearningMaterialCell.h
//  CaiJinTongApp
//
//  Created by david on 14-1-9.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadDataButton.h"
#import "LearningMaterials.h"
@protocol LearningMaterialCellDelegate;
@interface LearningMaterialCell : UITableViewCell
@property (weak,nonatomic) IBOutlet id<LearningMaterialCellDelegate> delegate;
@property (strong,nonatomic) NSIndexPath *path;
@property (weak, nonatomic) IBOutlet UIView *cellBackView;
-(void)setLearningMaterialData:(LearningMaterials*)learningMaterial;
@end

@protocol LearningMaterialCellDelegate <NSObject>

-(void)learningMaterialCell:(LearningMaterialCell*)cell scanLearningMaterialFileAtIndexPath:(NSIndexPath*)path;
-(void)learningMaterialCell:(LearningMaterialCell*)cell deleteLearningMaterialFileAtIndexPath:(NSIndexPath*)path;
@end