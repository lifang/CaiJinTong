//
//  DRNaviGationBarController.m
//  CaiJinTongApp
//
//  Created by david on 13-10-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "DRNaviGationBarController.h"

@interface DRNaviGationBarController ()

@end

@implementation DRNaviGationBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//当popoup view退出当前界面时调用
-(void)willDismissPopoupController{

}

- (void)viewDidLoad
{
     [self.view addSubview:self.drnavigationBar];
     self.drnavigationBar.searchBar.delegate = self;
     self.drnavigationBar.frame = (CGRect){0,0,900,60};
     self.drnavigationBar.backgroundColor = [UIColor redColor];
     [self.drnavigationBar.navigationRightItem addTarget:self action:@selector(drnavigationBarRightItemClicked:) forControlEvents:UIControlEventTouchUpInside];

     [super viewDidLoad];
     
}

//- (void)viewDidLoad
//{
//     if(!self.drnavigationBar){
//          UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
//          UIViewController *controller =    (UIViewController*)[story instantiateViewControllerWithIdentifier:@"DRNaviBar"];
//          [self addChildViewController:controller];
//          self.drnavigationBar = (DRNavigationBar*)[controller view];
//     }
//    [self.view addSubview:self.drnavigationBar];
//     [self.view bringSubviewToFront:self.drnavigationBar];
//     [self.drnavigationBar.navigationRightItem addTarget:self action:@selector(drnavigationBarRightItemClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [super viewDidLoad];
//}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drnavigationBarRightItemClicked:(id)sender {
    
}

#pragma mark UISearchBarDelegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
     searchBar.text = @"";
     searchBar.showsCancelButton = NO;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
     
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
     if (![searchBar.text isEqualToString:@""]) {
          searchBar.showsCancelButton = YES;
     }
     
     return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
     searchBar.showsCancelButton = YES;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
     searchBar.showsCancelButton = NO;
}
#pragma mark --

#pragma mark property
-(UIStoryboard *)story{
    return [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
}

-(DRNavigationBar *)drnavigationBar{
     if (!_drnavigationBar) {

          NSArray *xibs = [[NSBundle mainBundle] loadNibNamed:@"DRNavigationBar" owner:[DRNaviGationBarController class] options:nil];
          NSLog(@"%@",xibs);
          
          _drnavigationBar = (xibs && xibs.count > 0)?[xibs firstObject]:nil;
          NSLog(@"%@",_drnavigationBar.subviews);
     }
     return _drnavigationBar;
}
//-(DRNavigationBar *)drnavigationBar{
//    if (!_drnavigationBar) {
//        _drnavigationBar = [[DRNavigationBar alloc] initWithFrame:CGRectMake(0,0,768,44)];
//        [self.view addSubview:_drnavigationBar];
//        
//    }
//    return _drnavigationBar;
//}
#pragma --
@end
