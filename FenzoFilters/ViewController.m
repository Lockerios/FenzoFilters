//
//  ViewController.m
//  FenzoFilters
//
//  Created by yangyang on 15/3/4.
//  Copyright (c) 2015年 Fengzo. All rights reserved.
//

#import "ViewController.h"
#import "FilterViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)showFilterVC
{
    FilterViewController* vc = [[FilterViewController alloc] init];

    [vc setUpImage:[UIImage imageNamed:@"1.png"] callback:^(UIImage *filterdImage) {
        
    }];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    [imageView setImage:[UIImage imageNamed:@"1.png"]];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:self.view.frame];
    [btn setTitle:@"打开滤镜" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showFilterVC) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:imageView];
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
