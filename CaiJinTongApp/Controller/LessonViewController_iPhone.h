//
//  LessonViewController_iPhone.h
//  CaiJinTongApp
//
//  Created by apple on 13-11-25.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LessonViewController_iPhone : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
