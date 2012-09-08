//
//  UIKitFrontendController.h
//  Unity-iPhone
//
//  Created by Juan Manuel Serruya on 8/14/12.
//  

#import "AppController.h"
#import "UIKitPlayerPrefs.h"

#define UNITY_VIEW_TAG 1

@interface UIKitFrontendController : NSObject <UIApplicationDelegate>
{
	UIWindow *window;
    UIViewController *currentViewController;
	AppController *unityController;
    NSDictionary* pLaunchOptions;
}

- (void)checkForReturnToMenu:(NSTimer *)timer;
- (void)launchFrontend;
- (void)launchUnity;
- (void)cleanupFrontend;

@property (retain) UIViewController *currentViewController;

//  NOTE: There is an implicit UIWindow @property (see UIApplicationDelegate protocol)
@end
