//
//  ViewController.m
//  RefactorSKLauncher
//
//  Created by Chia ta Tsai on 13/8/20.
//  Copyright (c) 2013年 dj. All rights reserved.
//

#import "ViewController.h"
#import "SKLauncher.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnLaunch:(id)sender {
    BOOL isAvailable = [SKLauncher openModuleWithURLScheme:@"http://domain.com/func/type?p1=pa1&p2=pa2" delegate:self];
    
    NSLog(@"isAvailable=%d",isAvailable);
}
@end
