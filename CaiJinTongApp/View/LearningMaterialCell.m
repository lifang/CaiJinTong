//
//  LearningMaterialCell.m
//  CaiJinTongApp
//
//  Created by david on 14-1-9.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "LearningMaterialCell.h"

@interface LearningMaterialCell()
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *materialCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileSizeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *fileCategoryImageView;
@property (weak, nonatomic) IBOutlet UILabel *fileSearchTimeLabel;
@property (weak, nonatomic) IBOutlet DownloadDataButton *downloadBt;
@property (weak, nonatomic) IBOutlet UIView *fileScanView;
@property (weak, nonatomic) IBOutlet UILabel *fileCreateDateLabel;
@property (assign,nonatomic) DownloadStatus fileDownloadStatus;
@property (nonatomic,strong)  LearningMaterials  *materialModel;

- (IBAction)scanBtClicked:(id)sender;

@end
@implementation LearningMaterialCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)scanBtClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(learningMaterialCell:scanLearningMaterialFileAtIndexPath:)]) {
        [self.delegate learningMaterialCell:self scanLearningMaterialFileAtIndexPath:self.path];
    }
}

-(void)setLearningMaterialData:(LearningMaterials*)learningMaterial{
    [self.downloadBt.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didStartDownloadFile:) name:DownloadDataButton_Notification_DidStartDownload object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFailureDownloadFile:) name:DownloadDataButton_Notification_Failure object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedDownloadFile:) name:DownloadDataButton_Notification_DidFinished object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPauseDownloadFile:) name:DownloadDataButton_Notification_Pause object:nil];
    self.materialModel = learningMaterial;
    //ipad和iPhone不同
    if(isPAD){
        self.fileNameLabel.text = learningMaterial.materialName;
        self.materialCategoryLabel.text = learningMaterial.materialLessonCategoryName;
        self.fileSizeLabel.text = learningMaterial.materialFileSize;
        self.fileSearchTimeLabel.text = learningMaterial.materialSearchCount;
        self.fileCreateDateLabel.text = learningMaterial.materialCreateDate;
    }else{
        self.fileNameLabel.text = learningMaterial.materialName;
        NSMutableString *categoryText = [NSMutableString stringWithFormat:@"分类:%@",learningMaterial.materialLessonCategoryName];
        self.materialCategoryLabel.text = categoryText;
        self.fileSizeLabel.text = [NSString stringWithFormat:@"大小:%@",learningMaterial.materialFileSize];
        self.fileSearchTimeLabel.text = [NSString stringWithFormat:@"次数:%@", learningMaterial.materialSearchCount];
        self.fileCreateDateLabel.text = [NSString stringWithFormat:@"上传日期:%@", learningMaterial.materialCreateDate];
    }
    
    UserModel *user = [[CaiJinTongManager shared] user];
     DownloadStatus status = [[Section defaultSection] searchLearningMaterialsDownloadStatusWithMaterialId:learningMaterial.materialId withUserId:user.userId];
    self.fileDownloadStatus = status;
    DownloadDataButtonStatus downloadButtonStatus;
    switch (status) {
        case DownloadStatus_UnDownload:
            downloadButtonStatus = DownloadDataButtonStatus_UnDownload;
            break;
        case DownloadStatus_Downloading:
            downloadButtonStatus = DownloadDataButtonStatus_Downloading;
            break;
        case DownloadStatus_Downloaded:
        {
            downloadButtonStatus = DownloadDataButtonStatus_Downloaded;
            learningMaterial.materialFileLocalPath = [[Section defaultSection] searchLearningMaterialsLocalPathWithMaterialId:learningMaterial.materialId withUserId:user.userId];
            break;
        }
        case DownloadStatus_Pause:
            downloadButtonStatus = DownloadDataButtonStatus_Pause;
            break;
        default:
            break;
    }
//    [self.downloadBt setDownloadUrl:[NSURL URLWithString:learningMaterial.materialFileDownloadURL] withDownloadStatus:downloadButtonStatus withIsPostNotification:YES];
    [self.downloadBt setDownloadLearningMaterial:learningMaterial withDownloadStatus:downloadButtonStatus withIsPostNotification:YES];
    
    switch (learningMaterial.materialFileType) {
        case LearningMaterialsFileType_pdf:
            self.fileCategoryImageView.image = [UIImage imageNamed:@"pdf.png"];
            break;
        case LearningMaterialsFileType_jpg:
            self.fileCategoryImageView.image = [UIImage imageNamed:@"image.png"];
            break;
        case LearningMaterialsFileType_ppt:
            self.fileCategoryImageView.image = [UIImage imageNamed:@"ppt.png"];
            break;
        case LearningMaterialsFileType_zip:
            self.fileCategoryImageView.image = [UIImage imageNamed:@"Q&A-myq_15.png"];
            break;
        case LearningMaterialsFileType_word:
            self.fileCategoryImageView.image = [UIImage imageNamed:@"word.png"];
            break;
        case LearningMaterialsFileType_text:
            self.fileCategoryImageView.image = [UIImage imageNamed:@"text.png"];
            break;
        case LearningMaterialsFileType_other:
            self.fileCategoryImageView.image = [UIImage imageNamed:@"Q&A-myq_15.png"];
            break;
        default:
            break;
    }
    
}


#pragma mark downloadNotification
-(void)didStartDownloadFile:(NSNotification*)notification{
    if ([[notification.userInfo objectForKey:URLKey] isEqualToString:self.materialModel.materialFileDownloadURL]) {
        self.fileDownloadStatus = DownloadStatus_Downloading;
        UserModel *user = [[CaiJinTongManager shared] user];
        self.materialModel.materialFileDownloadStaus = DownloadStatus_Downloading;
        [[Section defaultSection] updateLeariningMaterial:self.materialModel withUserId:user.userId];
    }
}

-(void)didFinishedDownloadFile:(NSNotification*)notification{
    if ([[notification.userInfo objectForKey:URLKey] isEqualToString:self.materialModel.materialFileDownloadURL]) {
        self.fileDownloadStatus = DownloadStatus_Downloaded;
        UserModel *user = [[CaiJinTongManager shared] user];
        self.materialModel.materialFileDownloadStaus = DownloadStatus_Downloaded;
        self.materialModel.materialSearchCount = [notification.userInfo objectForKey:@"downloadCount"];
        
        self.materialModel.materialFileLocalPath = [notification.userInfo objectForKey:URLLocalPath];
        
        [[Section defaultSection] updateLeariningMaterial:self.materialModel withUserId:user.userId];
        [self setLearningMaterialData:self.materialModel];
    }
}
-(void)didFailureDownloadFile:(NSNotification*)notification{
    if ([[notification.userInfo objectForKey:URLKey] isEqualToString:self.materialModel.materialFileDownloadURL]) {
        UserModel *user = [[CaiJinTongManager shared] user];
        if (self.downloadBt.downloadFileStatus == DownloadDataButtonStatus_Pause) {
            self.fileDownloadStatus = DownloadStatus_Pause;
            self.materialModel.materialFileDownloadStaus = DownloadStatus_Pause;
        }else{
            self.fileDownloadStatus = DownloadStatus_UnDownload;
            
            self.materialModel.materialFileDownloadStaus = DownloadStatus_UnDownload;
        }
        
        [[Section defaultSection] updateLeariningMaterial:self.materialModel withUserId:user.userId];
    }
}
-(void)didPauseDownloadFile:(NSNotification*)notification{
    if ([[notification.userInfo objectForKey:URLKey] isEqualToString:self.materialModel.materialFileDownloadURL]) {
        self.fileDownloadStatus = DownloadStatus_Pause;
        UserModel *user = [[CaiJinTongManager shared] user];
        self.materialModel.materialFileDownloadStaus = DownloadStatus_Pause;
        self.materialModel.materialFileLocalPath = [notification.userInfo objectForKey:URLLocalPath];
        [[Section defaultSection] updateLeariningMaterial:self.materialModel withUserId:user.userId];
    }
}

#pragma mark --
#pragma mark property
-(void)setFileDownloadStatus:(DownloadStatus)fileDownloadStatus{
    _fileDownloadStatus = fileDownloadStatus;
    switch (fileDownloadStatus) {
        case DownloadStatus_UnDownload:
        case DownloadStatus_Pause:
        case DownloadStatus_Downloading:
        {
            [self.fileScanView setHidden:YES];
            [self.downloadBt setHidden:NO];
        }
            break;
        case DownloadStatus_Downloaded:
        {
            [self.fileScanView setHidden:NO];
            [self.downloadBt setHidden:YES];
        }
            break;
        default:
            break;
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark --
@end
