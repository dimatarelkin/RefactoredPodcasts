//
//  SplitController.m
//  PadcastsApp
//
//  Created by Dzmitry Tarelkin on 7/25/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import "SplitController.h"

@interface SplitController ()

@end

@implementation SplitController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
}


- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    return YES;
}



@end
