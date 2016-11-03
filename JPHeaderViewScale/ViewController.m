//
//  ViewController.m
//  JPHeaderViewScale
//
//  Created by tztddong on 2016/11/3.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    [self.navigationController.navigationBar setHidden:NO];
}

@end
