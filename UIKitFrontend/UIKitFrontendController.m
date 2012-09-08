//
//  UIKitFrontendController.m
//  Unity-iPhone
//
//  Created by Juan Manuel Serruya on 8/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIKitFrontendController.h"
#import "LoadingViewController.h"

@implementation UIKitFrontendController
@synthesize window;
@synthesize currentViewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	[application setStatusBarHidden:YES animated:NO];
	
	// Clear keys that signal transitions back and forth from Unity, just in case
	[UIKitPlayerPrefs deleteKey:@"_start_unity"];
	[UIKitPlayerPrefs deleteKey:@"_start_cocoa"];
	
	
	// Start listening for signal to return to menus
	[NSTimer scheduledTimerWithTimeInterval:1.0 target:self 
								   selector:@selector(checkForReturnToMenu:) 
								   userInfo:nil repeats:YES];
	[self launchFrontend];
}

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    [application setStatusBarHidden:YES animated:NO];
	
	// Clear keys that signal transitions back and forth from Unity, just in case
	[UIKitPlayerPrefs deleteKey:@"_start_unity"];
	[UIKitPlayerPrefs deleteKey:@"_start_cocoa"];
	
	
	// Start listening for signal to return to menus
	[NSTimer scheduledTimerWithTimeInterval:1.0 target:self 
								   selector:@selector(checkForReturnToMenu:) 
								   userInfo:nil repeats:YES];
    pLaunchOptions = launchOptions;
	[self launchFrontend];
    
    return NO;
}

/*ica
 * Checks whether Unity content has set the PlayerPrefs key indicating we should
 * return to the menu. Re-launch frontend if found
 */
- (void)checkForReturnToMenu:(NSTimer *)timer
{
	if([UIKitPlayerPrefs getInt:@"_start_cocoa" orDefault:0] == 1)
	{
		[UIKitPlayerPrefs deleteKey:@"_start_cocoa"];
		[self launchFrontend];
	}
}

/*
 * Launches the frontend menu system
 */
- (void)launchFrontend
{
	// re-sync the PlayerPrefs file
	[UIKitPlayerPrefs readPrefsFile];
	
	// Create the window if we don't already have one
	if([UIApplication sharedApplication].keyWindow == nil)
	{
		window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		[window makeKeyAndVisible];
	}
	
	// Check to see if any views are exclusive/multitouch (ie find the Unity 
	// EAGLView). Temporarily disable it, and tag it so we can find it later
	for(UIView *v in window.subviews)
	{
		if(v.exclusiveTouch && v.multipleTouchEnabled)
		{
			v.exclusiveTouch = NO;
			v.multipleTouchEnabled = NO;
			v.tag = UNITY_VIEW_TAG;
			v.hidden = YES;
		}
	}
	
	// load loading scene
    UIViewController *aViewController = [[[LoadingViewController alloc] init] autorelease];
    self.currentViewController = aViewController;
    [window addSubview:[self.currentViewController view]];
	
	// start the first scene
	//[UIKitSceneManager startScene:FIRST_SCENE withTransition:UIKitSceneTransitionNone];
}

/*
 * Launches the Unity content
 */
- (void)launchUnity
{
	[self cleanupFrontend];
	// Tell Unity loading scene to stop holding
	[UIKitPlayerPrefs setInt:1 withKey:@"_start_unity"];
	[UIKitPlayerPrefs saveAndUnload];
	
	// If we've not yet started the Unity content, run its startup
	if(unityController == nil)
	{
		unityController = [[AppController alloc] init];
        if ([UIDevice currentDevice].generatesDeviceOrientationNotifications == NO)
            [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
        [unityController setOrientations:pLaunchOptions];
		[unityController startUnity:[UIApplication sharedApplication]];
		
		// Set our window to the one created by ReJ's AppController, for any 
		// future use
        
        window = [unityController getWindow];
		//window = unityController->_window;
	}
	
	// If we've already got Unity content running, show it and return its 
	// Exclusive/multitouch status
	else
	{
		for(UIView *v in window.subviews)
		{
			if(v.tag == UNITY_VIEW_TAG)
			{
				v.exclusiveTouch = YES;
				v.multipleTouchEnabled = YES;
				v.hidden = NO;
				[window bringSubviewToFront:v];
			}
		}
	}
}

/*
 * Cleans up the frontend in preparation for Unity content startup
 */
- (void)cleanupFrontend
{
	// cleanup any scenes in the SceneManager
	//[UIKitSceneManager clearScenes];
}

#pragma mark ---- Application Notifications Forwarded to Unity AppController ----

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	if(unityController != nil)
		[unityController applicationDidBecomeActive:application];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	if(unityController != nil)
		[unityController applicationWillResignActive:application];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	if(unityController != nil)
		[unityController applicationDidReceiveMemoryWarning:application];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	if(unityController != nil)
		[unityController applicationWillTerminate:application];
}

- (void)dealloc
{
	[self cleanupFrontend];
	[window release];
	[unityController release];
    [pLaunchOptions release];
	[super dealloc];
    
}

@end
