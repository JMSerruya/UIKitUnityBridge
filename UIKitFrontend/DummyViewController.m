//
//  DummyViewController.m
//  Unity-iPhone
//
//  Created by Juan Manuel Serruya on 8/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DummyViewController.h"
#import "UIKitFrontendController.h"

@interface DummyViewController ()

@end

@implementation DummyViewController

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
    // Do any additional setup after loading the view from its nib.
} 

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);    
}
- (IBAction)btnButton1:(id)sender
{
    [(UIKitFrontendController *)[UIApplication
                              sharedApplication].delegate launchUnity];
}

@end
