//
//  FilterViewController.h
//  FenzoFilters
//
//  Created by yangyang on 15/3/4.
//  Copyright (c) 2015年 Fengzo. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^FilterFinishBlk)(UIImage* filterdImage);

@interface FilterViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>

- (void)setUpImage:(UIImage*)image callback:(FilterFinishBlk)callback;

@end
