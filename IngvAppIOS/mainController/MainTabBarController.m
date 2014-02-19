//
//  PCMainTabBarController.m
//  Project
//
//  Created by Lorenzo Spataro  on 1/9/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

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
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f],
                                                        NSForegroundColorAttributeName : [UIColor whiteColor]
                                                        } forState:UIControlStateSelected];
    
    
    // doing this results in an easier to read unselected state then the default iOS 7 one
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f],
                                                        NSForegroundColorAttributeName : [UIColor blackColor]
                                                        } forState:UIControlStateNormal];

    
    UITabBarItem *item0 = [self.tabBar.items objectAtIndex:0];
    item0.image = [[UIImage imageNamed:@"mainTabBar1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
   item0.title=@" Informazioni";
   
    
    UITabBarItem *item1 = [self.tabBar.items objectAtIndex:1];
   item1.image = [[UIImage imageNamed:@"mainTabBar2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.title=@" Sismografo";
    
    
    UITabBarItem *item2 = [self.tabBar.items objectAtIndex:2];
    item2.image = [[UIImage imageNamed:@"mainTabBar1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.title=@" Be alerted";
    
  
    UITabBarItem *item3 = [self.tabBar.items objectAtIndex:3];
    item3.image = [[UIImage imageNamed:@"mainTabBar1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.title=@" More";
    
    
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
