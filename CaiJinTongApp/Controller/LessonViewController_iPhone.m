//
//  LessonViewController_iPhone.m
//  CaiJinTongApp
//
//  Created by apple on 13-11-25.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "LessonViewController_iPhone.h"
#define CELL_REUSE_IDENTIFIER @"CollectionCell"

@implementation LessonViewController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -- init settings
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setCollectionView];
    
}

//collectionView相关设置
-(void)setCollectionView{
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELL_REUSE_IDENTIFIER];
}

#pragma mark --CollectionViewDelegate
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_REUSE_IDENTIFIER forIndexPath:indexPath];
    [self drawCollectionViewCell:cell index:[indexPath row]];
    return cell;
}
//绘制cell
- (void) drawCollectionViewCell:(UICollectionViewCell *) cell index:(NSInteger) row{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn0.png"]];
    imageView.frame = CGRectMake(0, 0, 35, 35);
    [cell.contentView addSubview:imageView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
