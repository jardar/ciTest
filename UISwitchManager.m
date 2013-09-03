//
//  UISwitchManager.m
//  RefactorSKLauncher
//
//  Created by Chia ta Tsai on 13/8/20.
//  Copyright (c) 2013年 dj. All rights reserved.
//

#import "UISwitchManager.h"
#import "SKUIViewControllerExt.h"

static UISwitchManager *instance=nil;

@interface UISwitchManager()
@property(nonatomic,strong)UIViewController *parentVC;
@property(nonatomic,strong)UIViewController *childVC;
@property(nonatomic,strong)UIViewController *currentChildVC;
@end

@implementation UISwitchManager

+(UISwitchManager*)getInstance {
    if ( instance == nil ) {
        instance = [[UISwitchManager alloc] init];
    }
    return instance;
}

-(id<Launchable>)getWorker:(NSString *)func withParentVC:(UIViewController *)parentViewController  {
    self.parentVC = parentViewController;
    NSArray *components = [func componentsSeparatedByString:@"/"];
    NSString *clsName = [components lastObject];
    NSAssert(clsName,@"at least one in URL's path(not include domain");
    self.childVC = [self getChildViewController:clsName];
    
    return self;
}

-(id)getChildViewController:(NSString *)clsName {
    Class classType = NSClassFromString(clsName);
    NSAssert(classType , @"there is no class with this name %@",clsName);
    return [[classType alloc] initWithNibName:clsName bundle:nil];
}

-(void) run:(NSString *)action withParameters:(NSDictionary *)parametersMayEmpty delegate:(id)delegate {
    [self removeCurrentChildVC];
    
    self.childVC.view.frame = self.parentVC.view.bounds;
    [self.parentVC addChildViewController:self.childVC];
    [self.parentVC.view addSubview:self.childVC.view];
    self.currentChildVC = self.childVC;
    
    if ( [self.childVC respondsToSelector:@selector(run:withParameters:)])
        [self.childVC run:action withParameters:parametersMayEmpty] ;
    
}

-(void)removeCurrentChildVC {
    UIViewController *viewControlelr = self.currentChildVC;
    [viewControlelr removeFromParentViewController];
    [viewControlelr.view removeFromSuperview];
    viewControlelr = nil;
    self.currentChildVC = nil;
}
@end
