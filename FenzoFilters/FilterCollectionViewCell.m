//
//  FilterCollectionViewCell.m
//  FenzoFilters
//
//  Created by yangyang on 15/3/4.
//  Copyright (c) 2015年 Fengzo. All rights reserved.
//

#import "FilterCollectionViewCell.h"

@implementation FilterCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 103, 103)];
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        [_imageView setBackgroundColor:[UIColor clearColor]];
        
        [self.contentView addSubview:_imageView];
    }
    return self;
}

@end
