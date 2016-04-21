//
//  UIImage+FenzoFilter.h
//  FenzoFilters
//
//  Created by lockerios on 16/4/21.
//  Copyright © 2016年 Fengzo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FenzoFilter)

+ (UIImage*)filteredImage:(UIImage*)image withFilterName:(NSString*)filterName;

@end
