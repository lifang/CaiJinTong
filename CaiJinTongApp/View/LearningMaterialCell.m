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
//@property (weak, nonatomic) IBOutlet UIView *fileScanView;
@property (weak, nonatomic) IBOutlet UILabel *fileScanLabel;
@property (weak, nonatomic) IBOutlet UIImageView *fileScanImageView;
@property (weak, nonatomic) IBOutlet UILabel *fileCreateDateLabel;
@property (assign,nonatomic) DownloadStatus fileDownloadStatus;
@property (nonatomic,strong)  LearningMaterials  *materialModel;

- (IBAction)scanBtClicked:(id)sender;
- (IBAction)deleteBtClicked:(id)sender;

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

- (IBAction)deleteBtClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(learningMaterialCell:deleteLearningMaterialFileAtIndexPath:)]) {
        [self.delegate learningMaterialCell:self deleteLearningMaterialFileAtIndexPath:self.path];
    }
}

-(void)setLearningMaterialData:(LearningMaterials*)learningMaterial{
    [self.downloadBt.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didStartDownloadFile:) name:DownloadDataButton_Notification_DidStartDownload object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFailureDownloadFile:) name:DownloadDataButton_Notification_Failure object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedDownloadFile:) name:DownloadDataButton_Notification_DidFinished object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPauseDownloadFile:) name:DownloadDataButton_Notification_Pause object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCancelDownloadFile:) name:DownloadDataButton_Notification_Cancel object:nil];
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

    
    self.fileDownloadStatus = learningMaterial.materialFileDownloadStaus;
    [self.downloadBt setDownloadLearningMaterial:learningMaterial withDownloadStatus:learningMaterial.materialFileDownloadStaus withIsPostNotification:YES];
    
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
            self.fileCategoryImageView.image = [UIImage imageNamed:@"Q&A_ukown_attach.png"];
            break;
        case LearningMaterialsFileType_word:
            self.fileCategoryImageView.image = [UIImage imageNamed:@"word.png"];
            break;
        case LearningMaterialsFileType_text:
            self.fileCategoryImageView.image = [UIImage imageNamed:@"text.png"];
            break;
        case LearningMaterialsFileType_other:
            self.fileCategoryImageView.image = [UIImage imageNamed:@"Q&A_ukown_attach.png"];
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
        self.materialModel.materialFileLocalPath = [notification.userInfo objectForKey:URLLocalPath];
        [DRFMDBDatabaseTool insertMaterialObjListWithUserId:user.userId withMaterialObjArray:@[self.materialModel] withFinished:^(BOOL flag) {
            [DRFMDBDatabaseTool updateMaterialObjListWithUserId:user.userId withMaterialId:self.materialModel.materialId withDownloadStatus:DownloadStatus_Downloading withFinished:^(BOOL flag) {
                [DRFMDBDatabaseTool updateMaterialObjListWithUserId:user.userId withMaterialId:self.materialModel.materialId withLocalPath:[notification.userInfo objectForKey:URLLocalPath] withFinished:^(BOOL flag) {
                    
                }];
            }];
        }];
    }
}

-(void)didFinishedDownloadFile:(NSNotification*)notification{
    if ([[notification.userInfo objectForKey:URLKey] isEqualToString:self.materialModel.materialFileDownloadURL]) {
        self.fileDownloadStatus = DownloadStatus_Downloaded;
        UserModel *user = [[CaiJinTongManager shared] user];
        self.materialModel.materialFileDownloadStaus = DownloadStatus_Downloaded;
        self.materialModel.materialSearchCount = [notification.userInfo objectForKey:@"downloadCount"];
        
        self.materialModel.materialFileLocalPath = [notification.userInfo objectForKey:URLLocalPath];
        [DRFMDBDatabaseTool updateMaterialObjListWithUserId:user.userId withMaterialId:self.materialModel.materialId withDownloadStatus:DownloadStatus_Downloaded withFinished:^(BOOL flag) {
            [self setLearningMaterialData:self.materialModel];
        }];
    }
}

-(void)didCancelDownloadFile:(NSNotification*)notification{
    if ([[notification.userInfo objectForKey:URLKey] isEqualToString:self.materialModel.materialFileDownloadURL]) {
        self.fileDownloadStatus = DownloadStatus_UnDownload;
        self.materialModel.materialFileDownloadStaus = DownloadStatus_UnDownload;
        [DRFMDBDatabaseTool deleteMaterialWithUserId:[CaiJinTongManager shared].user.userId withLearningMaterialsId:self.materialModel.materialId withFinished:^(BOOL flag) {
            [self setLearningMaterialData:self.materialModel];
        }];
    }
}

-(void)didFailureDownloadFile:(NSNotification*)notification{
    if ([[notification.userInfo objectForKey:URLKey] isEqualToString:self.materialModel.materialFileDownloadURL]) {
        UserModel *user = [[CaiJinTongManager shared] user];
        if (self.downloadBt.downloadFileStatus == DownloadStatus_Pause) {
            self.fileDownloadStatus = DownloadStatus_Pause;
            self.materialModel.materialFileDownloadStaus = DownloadStatus_Pause;
        }else{
            self.fileDownloadStatus = DownloadStatus_UnDownload;
            
            self.materialModel.materialFileDownloadStaus = DownloadStatus_UnDownload;
        }
        
        [DRFMDBDatabaseTool updateMaterialObjListWithUserId:user.userId withMaterialId:self.materialModel.materialId withDownloadStatus:DownloadStatus_UnDownload withFinished:^(BOOL flag) {
        }];
    }
}
-(void)didPauseDownloadFile:(NSNotification*)notification{
    if ([[notification.userInfo objectForKey:URLKey] isEqualToString:self.materialModel.materialFileDownloadURL]) {
        self.fileDownloadStatus = DownloadStatus_Pause;
        UserModel *user = [[CaiJinTongManager shared] user];
        self.materialModel.materialFileDownloadStaus = DownloadStatus_Pause;
        self.materialModel.materialFileLocalPath = [notification.userInfo objectForKey:URLLocalPath];
        [DRFMDBDatabaseTool updateMaterialObjListWithUserId:user.userId withMaterialId:self.materialModel.materialId withDownloadStatus:DownloadStatus_Pause withFinished:^(BOOL flag) {
            [self setLearningMaterialData:self.materialModel];
        }];
    }
}

#pragma mark -- 属性
#pragma mark property
-(void)setFileDownloadStatus:(DownloadStatus)fileDownloadStatus{
    _fileDownloadStatus = fileDownloadStatus;
    switch (fileDownloadStatus) {
        case DownloadStatus_Pause:
        {
            self.fileScanImageView.image = [UIImage imageNamed:@"download.png"];
            self.fileScanLabel.text = @"暂停";
            [self.downloadBt setHidden:NO];
        }
            break;
        case DownloadStatus_UnDownload:
        case DownloadStatus_Downloading:
        {
            self.fileScanImageView.image = [UIImage imageNamed:@"download.png"];
            self.fileScanLabel.text = @"下载";
            [self.downloadBt setHidden:NO];
        }
            break;
        case DownloadStatus_Downloaded:
        {
            self.fileScanImageView.image = [UIImage imageNamed:@"zoom_icon&48@2x.png"];
            self.fileScanLabel.text = @"查看";
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

- (void)layoutSubviews{
    [super layoutSubviews];
    if (![CaiJinTongManager shared].isShowLocalData && !isPAD) {
        self.downloadBt.center = (CGPoint){265,self.downloadBt.center.y};
        self.scanView.center = self.downloadBt.center;
        self.fileCategoryImageView.center = (CGPoint){225,self.fileCategoryImageView.center.y};
        self.fileNameLabel.frame = (CGRect){3,16,215,21};
        self.fileSizeLabel.center = (CGPoint){210,self.fileSizeLabel.center.y};
        self.deleteView.hidden = YES;
    }else if(!isPAD){
        self.downloadBt.center = (CGPoint){250,self.downloadBt.center.y};
        self.scanView.center = self.downloadBt.center;
        self.fileCategoryImageView.center = (CGPoint){214,self.fileCategoryImageView.center.y};
        self.fileNameLabel.frame = (CGRect){3,16,202,21};
        self.fileSizeLabel.center = (CGPoint){187,self.fileSizeLabel.center.y};
        self.deleteView.hidden = NO;
    }
}

#pragma mark --
@end
