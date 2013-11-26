//
//  MyQuestionAndAnswerViewController.m
//  CaiJinTongApp
//
//  Created by david on 13-11-7.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "MyQuestionAndAnswerViewController.h"
@interface MyQuestionAndAnswerViewController ()
@property (nonatomic,strong) NSMutableArray *myQuestionArr;
@end

@implementation MyQuestionAndAnswerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)drnavigationBarRightItemClicked:(id)sender{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    DRAskQuestionViewController *ask = [story instantiateViewControllerWithIdentifier:@"DRAskQuestionViewController"];
    [self.navigationController pushViewController:ask animated:YES];
    
}


-(void)willDismissPopoupController{
    CGPoint offset = self.tableView.contentOffset;
    [self.tableView setContentOffset:offset animated:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTestData];
    [self.tableView registerClass:[QuestionAndAnswerCellHeaderView class] forHeaderFooterViewReuseIdentifier:@"header"];
    
    self.drnavigationBar.titleLabel.text = @"我的提问";
    [self.drnavigationBar.navigationRightItem setTitle:@"提问" forState:UIControlStateNormal];
    [self.drnavigationBar.navigationRightItem setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.noticeBarImageView.layer setCornerRadius:4];
}

-(void)initTestData{
    for (int index = 0; index < 20; index++) {
        QuestionModel *question = [[QuestionModel alloc] init];
        question.questionName = @"世界会不会有终结一天？";
        question.askerNick = @"雪花飘飘";
        question.askTime = [[NSDate date] description];
        question.praiseCount = @"999";
        question.questionId = [NSString stringWithFormat:@"%d",index];
        NSMutableArray *answerArr = [NSMutableArray array];
        for (int row = 0; row < 20; row++) {
            AnswerModel *answer = [[AnswerModel alloc] init];
            answer.answerNick = @"千里马";
            answer.answerId = [NSString stringWithFormat:@"%d",row];
            answer.answerTime = @"2013.14.21";
            answer.answerPraiseCount = @"10";
            answer.answerContent = @"平行宇宙经常被用以说明：一个事件不同的过程或一个不同的决定的后续发展是存在于不同的平行宇宙中的；这个理论也常被用于解释其他的一些诡论，像关于时间旅行的一些诡论，像“一颗球落入时光隧道，回到了过去撞上了自己因而使得自己无法进入时光隧道”，解决此诡论除了假设时间旅行是不可能的以外，另外也可以以平行宇宙做解释，根据平行宇宙理论的解释：这颗球撞上自己和没有撞上自己是两个不同的平行宇宙";
            [answerArr addObject:answer];
        }
        question.answerList = answerArr;
        [self.myQuestionArr addObject:question];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark QuestionAndAnswerCellHeaderViewDelegate
-(void)questionAndAnswerCellHeaderView:(QuestionAndAnswerCellHeaderView *)header flowerQuestionAtIndexPath:(NSIndexPath *)path{

}
#pragma mark --

#pragma mark QuestionAndAnswerCellDelegate

-(void)questionAndAnswerCell:(QuestionAndAnswerCell *)cell willBeginTypeQuestionTextFieldAtIndexPath:(NSIndexPath *)path{
    CGRect cellRect = [self.tableView rectForRowAtIndexPath:path];
    float cellmaxHeight = CGRectGetMaxY(cellRect) - self.tableView.contentOffset.y;
    float keyheight = CGRectGetMaxY(self.tableView.frame) - 400;
    if (cellmaxHeight > keyheight) {
        [self.tableView setContentOffset:(CGPoint){self.tableView.contentOffset.x,self.tableView.contentOffset.y+ (cellmaxHeight - keyheight)} animated:YES];
    }
}

-(void)questionAndAnswerCell:(QuestionAndAnswerCell *)cell flowerAnswerAtIndexPath:(NSIndexPath *)path{
    QuestionModel *question = [self.myQuestionArr  objectAtIndex:path.section];
    AnswerModel *answer = [question.answerList objectAtIndex:path.row];
    answer.isPraised = YES;
    answer.answerPraiseCount = [NSString stringWithFormat:@"%d",[answer.answerPraiseCount integerValue]+1];;
     [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)questionAndAnswerCell:(QuestionAndAnswerCell *)cell summitQuestion:(NSString *)questionStr atIndexPath:(NSIndexPath *)path{

}

-(void)questionAndAnswerCell:(QuestionAndAnswerCell *)cell isHiddleQuestionView:(BOOL)isHiddle atIndexPath:(NSIndexPath *)path{
    QuestionModel *question = [self.myQuestionArr  objectAtIndex:path.section];
    AnswerModel *answer = [question.answerList objectAtIndex:path.row];
    answer.isEditing = isHiddle;
    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

-(void)questionAndAnswerCell:(QuestionAndAnswerCell *)cell acceptAnswerAtIndexPath:(NSIndexPath *)path{
QuestionModel *question = [self.myQuestionArr  objectAtIndex:path.section];
    question.isAcceptAnswer = [NSString stringWithFormat:@"YES"];
    AnswerModel *answer = [question.answerList objectAtIndex:path.row];
    answer.IsAnswerAccept = [NSString stringWithFormat:@"YES"];
    answer.resultId = question.questionId;
    [question.answerList removeObjectAtIndex:path.row];
    [question.answerList insertObject:answer atIndex:0];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:path.section] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:path.section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
#pragma mark --

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark --

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.myQuestionArr count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuestionAndAnswerCell *cell = (QuestionAndAnswerCell*)[tableView dequeueReusableCellWithIdentifier:@"questionAndAnswerCell"];
    QuestionModel *question = [self.myQuestionArr  objectAtIndex:indexPath.section];
    AnswerModel *answer = [question.answerList objectAtIndex:indexPath.row];
    if (question.isAcceptAnswer && [question.isAcceptAnswer isEqualToString:@"YES"]) {
        [cell setAnswerModel:answer isQuestionID:question.questionId];
    } else {
        [cell setAnswerModel:answer isQuestionID:nil];
    }
    
    cell.delegate = self;
    cell.path = indexPath;
    cell.contentView.frame = (CGRect){cell.contentView.frame.origin,CGRectGetWidth(cell.contentView.frame),[self getTableViewRowHeightWithIndexPath:indexPath]};
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [self getTableViewHeaderHeightWithSection:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float height = [self getTableViewRowHeightWithIndexPath:indexPath];
    return height;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    QuestionModel *question = [self.myQuestionArr  objectAtIndex:section];
    return [question.answerList count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    QuestionAndAnswerCellHeaderView *header = (QuestionAndAnswerCellHeaderView*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    QuestionModel *question = [self.myQuestionArr  objectAtIndex:section];
    [header setQuestionModel:question];
    header.backgroundColor = [UIColor whiteColor];
    header.delegate = self;
    header.path = [NSIndexPath indexPathForRow:0 inSection:section];
    return header;
}

#pragma mark --

#pragma mark action
-(float)getTableViewHeaderHeightWithSection:(NSInteger)section{
    QuestionModel *question = [self.myQuestionArr  objectAtIndex:section];
    return  [Utility getTextSizeWithString:question.questionName withFont:[UIFont systemFontOfSize:TEXT_FONT_SIZE+6] withWidth:CGRectGetWidth(self.tableView.frame)-40].height + TEXT_HEIGHT + TEXT_PADDING;
}

-(float)getTableViewRowHeightWithIndexPath:(NSIndexPath*)path{
    QuestionModel *question = [self.myQuestionArr  objectAtIndex:path.section];
    AnswerModel *answer = [question.answerList objectAtIndex:path.row];
    float questionTextFieldHeight = answer.isEditing?141:0;

    return [Utility getTextSizeWithString:answer.answerContent withFont:[UIFont systemFontOfSize:TEXT_FONT_SIZE+6] withWidth:460].height;
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:answer.answerContent];
//    [str setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:TEXT_FONT_SIZE+6]} range:NSMakeRange(0, answer.answerContent.length)];
//    return [str boundingRectWithSize:CGSizeMake(460, 2000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine context:nil].size.height + TEXT_HEIGHT + TEXT_PADDING*3+ questionTextFieldHeight;
}
#pragma mark --

#pragma mark property

-(NSMutableArray *)myQuestionArr{
    if (!_myQuestionArr) {
        _myQuestionArr = [NSMutableArray array];
    }
    return _myQuestionArr;
}
#pragma mark --
- (IBAction)noticeHideBtnClick:(id)sender {
    [self.noticeBarView setHidden:YES];
    CGRect frame = self.tableView.frame;
    [self.tableView setFrame: CGRectMake(frame.origin.x,frame.origin.y - 35,frame.size.width,frame.size.height)];
}
@end
