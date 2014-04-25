//
//  QuestionV2ViewController.m
//  CaiJinTongApp
//
//  Created by david on 14-4-23.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "QuestionV2ViewController.h"
#import "QuestionRequestDataInterface.h"
#import "DRTypeQuestionContentViewController.h"
@interface DRActionSheet : UIActionSheet
@property (nonatomic,strong) NSIndexPath *path;
@property (nonatomic,strong) QuestionModel *questionModel;
@property (nonatomic,strong) AnswerModel *answerModel;
@property (nonatomic,assign) ReaskType reaskType;
@end
@implementation DRActionSheet



@end

@interface QuestionV2ViewController ()
@property (nonatomic,strong) DRActionSheet *actionSheet;
///提交文本控件
@property (nonatomic,strong) DRTypeQuestionContentViewController *typeContentController;
@end

@implementation QuestionV2ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

///重新加载问答数据，所需的分类id，分类类型在CaiJinTongManager单利中
-(void)reloadQuestionData{
    UserModel *user = [[UserModel alloc] init];
    user.userId = @"17082";
    [CaiJinTongManager shared].user = user;
    [CaiJinTongManager shared].userId = @"17082";
    [CaiJinTongManager shared].selectedQuestionCategoryType = CategoryType_MyAnswer;
    ///////////////////////test
    switch ([CaiJinTongManager shared].selectedQuestionCategoryType) {
        case CategoryType_AllQuestion://所有问答
        {
            __weak QuestionV2ViewController *weakSelf = self;
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [QuestionRequestDataInterface downloadALLQuestionListWithUserId:[CaiJinTongManager shared].user.userId andQuestionCategoryId:[CaiJinTongManager shared].selectedQuestionCategoryId andLastQuestionID:nil withSuccess:^(NSArray *questionModelArray) {
                QuestionV2ViewController *tempSelf = weakSelf;
                if (tempSelf) {
                    tempSelf.questionDataArray = questionModelArray;
                    [tempSelf.tableView reloadData];
                    [MBProgressHUD hideHUDForView:tempSelf.view animated:YES];
                }
            } withError:^(NSError *error) {
                QuestionV2ViewController *tempSelf = weakSelf;
                if (tempSelf) {
                    [Utility errorAlert:[error.userInfo  objectForKey:@"msg"]];
                    [MBProgressHUD hideHUDForView:tempSelf.view animated:YES];
                }
            }];
        }
            break;
        case CategoryType_MyQuestion://我的提问
        {
            __weak QuestionV2ViewController *weakSelf = self;
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [QuestionRequestDataInterface downloadUserQuestionListWithUserId:[CaiJinTongManager shared].user.userId andIsMyselfQuestion:@"0" andLastQuestionID:nil withCategoryId:[CaiJinTongManager shared].selectedQuestionCategoryId withSuccess:^(NSArray *questionModelArray) {
                QuestionV2ViewController *tempSelf = weakSelf;
                if (tempSelf) {
                    tempSelf.questionDataArray = questionModelArray;
                    [tempSelf.tableView reloadData];
                    [MBProgressHUD hideHUDForView:tempSelf.view animated:YES];
                }
            } withError:^(NSError *error) {
                QuestionV2ViewController *tempSelf = weakSelf;
                if (tempSelf) {
                    [Utility errorAlert:[error.userInfo  objectForKey:@"msg"]];
                    [MBProgressHUD hideHUDForView:tempSelf.view animated:YES];
                }
            }];
        }
            break;
        case CategoryType_MyAnswer://我的回答
        {
            __weak QuestionV2ViewController *weakSelf = self;
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [QuestionRequestDataInterface downloadUserQuestionListWithUserId:[CaiJinTongManager shared].user.userId andIsMyselfQuestion:@"1" andLastQuestionID:nil withCategoryId:[CaiJinTongManager shared].selectedQuestionCategoryId withSuccess:^(NSArray *questionModelArray) {
                QuestionV2ViewController *tempSelf = weakSelf;
                if (tempSelf) {
                    tempSelf.questionDataArray = questionModelArray;
                    [tempSelf.tableView reloadData];
                    [MBProgressHUD hideHUDForView:tempSelf.view animated:YES];
                }
            } withError:^(NSError *error) {
                QuestionV2ViewController *tempSelf = weakSelf;
                if (tempSelf) {
                    [Utility errorAlert:[error.userInfo  objectForKey:@"msg"]];
                    [MBProgressHUD hideHUDForView:tempSelf.view animated:YES];
                }
            }];
        }
            break;
        default:
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"QuestionCellV2" bundle:nil] forCellReuseIdentifier:@"questionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AnswerForQuestionCellV2" bundle:nil] forCellReuseIdentifier:@"answerCell"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark --

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id model = [self.questionDataArray objectAtIndex:indexPath.row];
    if ([model isKindOfClass:[QuestionModel class]]) {
        QuestionModel *question = (QuestionModel*)model;
        QuestionCellV2 *questionCell = (QuestionCellV2*)[tableView dequeueReusableCellWithIdentifier:@"questionCell"];
        questionCell.path = indexPath;
        questionCell.delegate = self;
        [questionCell refreshCellWithQuestionModel:question];
        return questionCell;
    }else{
        AnswerModel *answer = (AnswerModel*)model;
        AnswerForQuestionCellV2 *answerCell = (AnswerForQuestionCellV2*)[tableView dequeueReusableCellWithIdentifier:@"answerCell"];
        answerCell.path = indexPath;
        answerCell.delegate = self;
        [answerCell refreshCellWithAnswerModel:answer];
        return answerCell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id model = [self.questionDataArray objectAtIndex:indexPath.row];
    if ([model isKindOfClass:[QuestionModel class]]) {
        QuestionModel *question = (QuestionModel*)model;
        CGRect richContentRect = [RichQuestionContentView richQuestionContentStringWithRichContentObjs:question.questionRichContentArray withWidth:260];
        return CGRectGetHeight(richContentRect) + 116;
    }else{
        AnswerModel *answer = (AnswerModel*)model;
        CGRect richContentRect = [RichQuestionContentView richQuestionContentStringWithRichContentObjs:answer.answerRichContentArray withWidth:260];
        return CGRectGetHeight(richContentRect) + 50;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.questionDataArray.count;
}

#pragma mark --



#pragma mark AnswerForQuestionCellV2Delegate 回答类代理
///选中内容图片时调用
-(void)answerForQuestionCellV2:(AnswerForQuestionCellV2*)answerCell selectedImageType:(RichContextObj*)richContentObj AtIndexPath:(NSIndexPath*)path{

}

///选择多动能按钮时调用
-(void)answerForQuestionCellV2:(AnswerForQuestionCellV2*)answerCell selectedMoreButtonAtIndexPath:(NSIndexPath*)path withAnswerType:(ReaskType)answerType{

}
#pragma mark --


#pragma mark QuestionCellV2Delegate 问题cell代理
///选中内容图片时调用
-(void)questionCellV2:(QuestionCellV2*)questionCell selectedImageType:(RichContextObj*)richContentObj AtIndexPath:(NSIndexPath*)path{

}

///选中多功能按钮时调用
-(void)questionCellV2:(QuestionCellV2*)questionCell selectedMenuButtonAtIndexPath:(NSIndexPath*)path{
    self.actionSheet = [[DRActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"回答", nil];
    self.actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    self.actionSheet.questionModel = questionCell.questionModel;
    self.actionSheet.path = path;
    self.actionSheet.reaskType = ReaskType_Answer;
    
    [CaiJinTongManager shared].path = path;
    [CaiJinTongManager shared].questionModel = questionCell.questionModel;
    [CaiJinTongManager shared].reaskType = ReaskType_Answer;
    __weak QuestionV2ViewController *weakSelf = self;
    self.typeContentController.submitFinishedBlock = ^(NSArray *dataArray ,NSString *errorMsg){
        //刷新数据
        dispatch_async(dispatch_get_main_queue(), ^{
            QuestionV2ViewController *tempSelf = weakSelf;
            if (tempSelf) {
                
                [tempSelf.tableView reloadData];
            }
        });
        
        
    };
    [self.actionSheet showInView:self.view];
}

///点击回答或者问题内容时调用,展开回答相关内容
-(void)questionCellV2:(QuestionCellV2*)questionCell extendAnswerContentButtonAtIndexPath:(NSIndexPath*)path{

}

///点击查看附件时调用
-(void)questionCellV2:(QuestionCellV2*)questionCell viewAttachmentButtonAtIndexPath:(NSIndexPath*)path{

}
#pragma mark --

#pragma mark uiactionSheet弹出菜单代理
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    DRActionSheet *sheet = (DRActionSheet*)actionSheet;
    if (sheet.reaskType == ReaskType_Answer) {//回答
        [self presentViewController:self.typeContentController animated:YES completion:^{
            
        }];
    }
}
#pragma mark --


#pragma mark property
-(DRTypeQuestionContentViewController *)typeContentController{
    if (!_typeContentController) {
        _typeContentController = [[DRTypeQuestionContentViewController alloc] initWithNibName:@"DRTypeQuestionContentViewController" bundle:nil];
    }
    return _typeContentController;
}
#pragma mark --
@end
