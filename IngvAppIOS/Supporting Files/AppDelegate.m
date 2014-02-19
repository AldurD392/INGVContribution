//
//  AppDelegate.m

//
//  Created by Matt Galloway on 29/02/2012.
//  Copyright (c) 2012 Swipe Stack Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "coQuestionTVC.h"
#import "coStartingViewController.h"
#import "MainTabBarController.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
        NSLog(@"Notifica!");
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"mainStoryboard" bundle:nil];
    UIStoryboard *coStoryboard = [UIStoryboard storyboardWithName:@"coStoryboard" bundle:nil];

    MainTabBarController *mainTabBar = [mainStoryboard instantiateInitialViewController];
    mainTabBar.selectedIndex = 0;
    
    UINavigationController *informationNavigationController = mainTabBar.viewControllers[0];
    coStartingViewController *startingViewController = (coStartingViewController *)informationNavigationController.topViewController;
    
    [startingViewController performSegueWithIdentifier:@"coTerremotoDetailSegue" sender:startingViewController];
    
    coQuestionario *questionario = [coQuestionario dictionaryToQuestionario:notification.userInfo];
    coQuestionTVC *firstQuestion = [coStoryboard instantiateViewControllerWithIdentifier:@"coFirstLongQuestion"];
    
    firstQuestion.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Annulla" style:UIBarButtonSystemItemUndo target:firstQuestion action:@selector(cancelButtonPressed:)];
    
    UINavigationController *questionNavigationController = [[UINavigationController alloc] initWithRootViewController:firstQuestion];
    
    firstQuestion.delegate = startingViewController;
    firstQuestion.delegate.questionario = questionario;
    
    self.window.rootViewController = mainTabBar;
    
    [startingViewController presentViewController:questionNavigationController animated:NO completion:nil];
    [self.window makeKeyAndVisible];
}

@end
