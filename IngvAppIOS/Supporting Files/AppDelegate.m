//
//  AppDelegate.m

//
//  Created by Matt Galloway on 29/02/2012.
//  Copyright (c) 2012 Swipe Stack Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "coCheckmarkQuestionTVC.h"
#import "coStartingViewController.h"
#import "MainTabBarController.h"
#import <CoreLocation/CoreLocation.h>

#import "Server.h"

@interface AppDelegate () <CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager* backgroundLocationManager;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@end

@implementation AppDelegate

@synthesize window = _window;

# pragma mark - background location manager 
- (CLLocationManager *) backgroundLocationManager {
    if (!_backgroundLocationManager) {
        _backgroundLocationManager = [[CLLocationManager alloc] init];
        _backgroundLocationManager.delegate = self;
    }
    return _backgroundLocationManager;
}

# pragma mark - CLLocationManagerDelegate Methods
- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    // Handle location updates as normal
    CLLocation *location = [locations lastObject];
//    NSLog(@"%f, %f", coordinate.latitude, coordinate.longitude);
    [self sendBackgroundLocationToServer:location];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
//    Debugging purposes
    localNotification.alertBody = [NSString stringWithFormat:@"Nuova posizione: %f, %f", location.coordinate.latitude, location.coordinate.longitude];
    localNotification.hasAction = NO;
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    
    [manager stopMonitoringSignificantLocationChanges];
    [manager performSelector:@selector(startMonitoringSignificantLocationChanges) withObject:nil afterDelay:50*60];
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//    What else could we do? We're in background!
    NSLog(@"Background location manager error: %@", error);
}

- (void) sendBackgroundLocationToServer: (CLLocation *) location
{
    // REMEMBER. We are running in the background if this is being executed.
    // We can't assume normal network access.
    // bgTask is defined as an instance variable of type UIBackgroundTaskIdentifier
 
    // Note that the expiration handler block simply ends the task. It is important that we always
    // end tasks that we have started.
    
    self.backgroundTaskIdentifier = [[UIApplication sharedApplication]
              beginBackgroundTaskWithExpirationHandler:
              ^{
                  [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
                }];
    
    //TODO: UserID!
#define USER_ID 41
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSString *postString = [[NSString alloc] initWithFormat:@"lat=%f&lng=%f&devid=%d",
                      coordinate.latitude,
                      coordinate.longitude,
                      USER_ID
                      ];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@", SERVER, LOCALIZATION]];
    NSMutableURLRequest *rqst = [NSMutableURLRequest requestWithURL:url];
    rqst.HTTPBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
    rqst.HTTPMethod = @"POST";
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:rqst completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
            NSLog(@"Data = %@",text);
            [session invalidateAndCancel];
        } else {
            NSLog(@"%@", error);
        }
    }];
    
    [postDataTask resume];

    if (self.backgroundTaskIdentifier != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
         self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    }
}

# pragma mark - Application life cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeNone | UIRemoteNotificationTypeNewsstandContentAvailability)];
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
//        Al primo avvio, chiediamo all'utente i permessi giusti.
        [self.backgroundLocationManager startMonitoringSignificantLocationChanges];
    }
    
//    Notifiche locali
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotification) {
        [self handleLongQuestionarioNotification:localNotification.userInfo];
    }
    
//    Notifiche push
    NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {
        [self handleQuestionarioPushNotification:[remoteNotification objectForKey:TERREMOTO_ID]];
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
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
        if ([CLLocationManager locationServicesEnabled]) {
            if (application.backgroundRefreshStatus == UIBackgroundRefreshStatusAvailable) {
                [self.backgroundLocationManager startMonitoringSignificantLocationChanges];
            }
        }
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self.backgroundLocationManager stopMonitoringSignificantLocationChanges];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
}

# pragma mark - Handle local notifications

- (void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if ([application applicationState] == UIApplicationStateInactive) {
        [self handleLongQuestionarioNotification:notification.userInfo];

        [[UIApplication sharedApplication] cancelLocalNotification:notification];
    }
}

- (void) handleLongQuestionarioNotification:(NSDictionary *)questionarioDictionary {
/*    TODO: Questo metodo si occupa di aprire la pagina dei dettagli del terremoto per cui compilare il questionario completo.
    Probabilmente andrà modificato in base allo storyboard utilizzato dal gruppo "Information"
    Quello che dev'essere fatto, in pratica, è caricare la tabbar, settare la sezione a quella di informatione poi aprire
    i dettagli del terremoto in oggetto, avendo cura di permettere all'utente di tornare indietro, quindi implementando a dovere
    lo stack della navigation bar.
*/
    
//    Gli storyboard
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"mainStoryboard" bundle:nil];
    UIStoryboard *coStoryboard = [UIStoryboard storyboardWithName:@"coStoryboard" bundle:nil];
    
//    Tab bar principale
    MainTabBarController *mainTabBar = [mainStoryboard instantiateInitialViewController];
    mainTabBar.selectedIndex = 0;
    
//    Navigation controller di Information
    UINavigationController *informationNavigationController = mainTabBar.viewControllers[0];
    coStartingViewController *startingViewController = (coStartingViewController *)informationNavigationController.topViewController;
    
//    Segue ai dettagli del terremoto
    [startingViewController performSegueWithIdentifier:@"coTerremotoDetailSegue" sender:startingViewController];
    
// Da qui in poi non dovrebbe esservi bisogno di modificare nulla!
    coQuestionario *questionario = [coQuestionario dictionaryToQuestionario:questionarioDictionary];
    coCheckmarkQuestionTVC *firstQuestion = [coStoryboard instantiateViewControllerWithIdentifier:@"coFirstLongQuestion"];
    
    firstQuestion.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Annulla" style:UIBarButtonSystemItemUndo target:firstQuestion action:@selector(cancelButtonPressed:)];
    
    UINavigationController *questionNavigationController = [[UINavigationController alloc] initWithRootViewController:firstQuestion];
    
    firstQuestion.delegate = startingViewController;
    firstQuestion.delegate.questionario = questionario;
    firstQuestion.resume = YES;
    
    self.window.rootViewController = mainTabBar;
    
    [startingViewController presentViewController:questionNavigationController animated:NO completion:nil];
    [self.window makeKeyAndVisible];
}

# pragma mark - Handle remote notification
- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if ([application applicationState] == UIApplicationStateInactive) {
        [self handleQuestionarioPushNotification:[userInfo objectForKey:TERREMOTO_ID]];
    }
}

- (void) handleQuestionarioPushNotification: (NSNumber *)terremotoID {
    /*    TODO: Questo metodo si occupa di aprire la pagina dei dettagli del terremoto per cui compilare il questionario completo.
     Probabilmente andrà modificato in base allo storyboard utilizzato dal gruppo "Information"
     Quello che dev'essere fatto, in pratica, è caricare la tabbar, settare la sezione a quella di informatione poi aprire
     i dettagli del terremoto in oggetto, avendo cura di permettere all'utente di tornare indietro, quindi implementando a dovere
     lo stack della navigation bar.
     */
    
    //    Gli storyboard
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"mainStoryboard" bundle:nil];
    
    //    Tab bar principale
    MainTabBarController *mainTabBar = [mainStoryboard instantiateInitialViewController];
    mainTabBar.selectedIndex = 0;
    
    self.window.rootViewController = mainTabBar;
    
    //    Navigation controller di Information
    UINavigationController *informationNavigationController = mainTabBar.viewControllers[0];
    coStartingViewController *startingViewController = (coStartingViewController *)informationNavigationController.topViewController;
    
    //    Inseriamo l'id del terremoto da visualizzare:
    startingViewController.terremotoID = terremotoID;
    
    //    Segue ai dettagli del terremoto
    [startingViewController performSegueWithIdentifier:@"coTerremotoDetailSegue" sender:startingViewController];
    
    //    Schermata di dettagli terremoto
    coStartingViewController *exampleTerremotoDetailVC = (coStartingViewController *)informationNavigationController.visibleViewController;
    [exampleTerremotoDetailVC performSegueWithIdentifier:@"coQuestionarioTerremotoSegueNoAnimation" sender:exampleTerremotoDetailVC];
    
    // Da qui in poi non dovrebbe esservi bisogno di modificare nulla!
    [self.window makeKeyAndVisible];
}

# pragma mark - Remote notifications tokens
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"Remote notification token is: %@", deviceToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}
@end
