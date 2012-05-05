#import "AppDelegate.h"
#import "MainViewController.h"
#import "loginViewController.h"
#import "SignupViewController.h"
#import <Crashlytics/Crashlytics.h>

@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
	[_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    [Crashlytics startWithAPIKey:@"e1f57e48a9ae2fb1989097f760e6fc0fcd62d90d"];
    
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
	
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
	
	//MainViewController *vc = [[MainViewController alloc] init];
	//self.window.rootViewController = vc;
    
    //Testing login ViewController
    loginViewController *loginvc = [[loginViewController alloc] init];
    self.window.rootViewController = loginvc;
    
    //Testing Sign up ViewController
    //SignupViewController *signupvc = [[SignupViewController alloc] init];
    //self.window.rootViewController = signupvc;
    
    /*//Testing Push Notification Start
    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge;
    [application registerForRemoteNotificationTypes:myTypes];    
    Testing Push Notification End*/
    
    //Testing Write File to plist  -   Start
    /*NSError *err;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //getting the path to document directory for the file
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [paths objectAtIndex:0];
    NSString *path = [documentDir stringByAppendingPathComponent:@"UserInfo.plist"];
    
    //checking to see of the file already exist
    if(![fileManager fileExistsAtPath:path])
    {
        //if doesnt exist get the the file path from bindle
        NSString *correctPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"UserInfo.plist"];
        //copy the file from bundle to document dir
        [fileManager copyItemAtPath:correctPath toPath:path error:&err]; 
    }*/
    //Testing Write File to plist   -   End
    
    
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

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    
}




@end
