//
//  UserInfoTableViewController.m
//  CaiJinTongApp
//
//  Created by apple on 13-11-20.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "UserInfoTableViewController.h"
#import "FixTableViewController.h"

@interface UserInfoTableViewController ()

@end

static NSString *passValue;

@implementation UserInfoTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的资料";
    
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);

    [self.addressLabel setNumberOfLines:0];
    CGSize size = CGSizeMake(320, 2000);
    CGSize newSize = [self.addressLabel.text sizeWithFont:self.addressLabel.font constrainedToSize:size];
    CGRect rect = self.addressLabel.frame;
    rect.size = newSize;
    [self.addressLabel setFrame:rect];
    
//    ((UITableViewCell *)self.tableView.visibleCells[3]).
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-  (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
//    FixTableViewController *fixVC = [story instantiateViewControllerWithIdentifier:@"FixTableViewController"];
//    switch (indexPath.row) {
//        case 0:
//            break;
//        case 1:
//            passValue = self.birthLabel.text;
//            break;
//        case 2:
//            passValue = self.sexLabel.text;
//            break;
//        case 3:
//            passValue = self.addressLabel.text;
//        default:
//            break;
//    }
//    [self.navigationController pushViewController:fixVC animated:YES];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = 0.0;
    switch (indexPath.row) {
        case 0:
            rowHeight = 132.0;
            break;
        case 1:
        case 2:
            rowHeight = 66.0;
            break;
        case 3:
            rowHeight = self.addressLabel.frame.size.height+44.0;
            NSLog(@"self.addressLabel.frame.size.height:%f",self.addressLabel.frame.size.height);
            break;
        default:
            break;
    }
    return rowHeight;
}

+ (NSString *)passValue {
    return passValue;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
