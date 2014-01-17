//
//  MainNavigationController.m
//  Project
//
//  Created by Lorenzo Spataro  on 1/11/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import "MainNavigationController.h"

@interface MainNavigationController ()

@end

@implementation MainNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationBar.barTintColor= [UIColor colorWithRed:66.0f/255.0f green:180.0f/255.0f blue:228.0f/255.0f alpha:1.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)awakeFromNib
{
    NSAssert(self.storyboardName, @"storyboardName is required");
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:self.storyboardName bundle:nil];
    UIViewController *vc = self.sceneIdentifier
    ? [storyboard instantiateViewControllerWithIdentifier:self.sceneIdentifier]
    : [storyboard instantiateInitialViewController];
    
    self.viewControllers = @[vc];
}


@end
