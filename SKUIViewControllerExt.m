//
//  SKUIViewControllerExt.m
//  SKModuleTestBed
//
//  Created by abyss on 13/7/10.
//  Copyright (c) 2013年 eyesmedia. All rights reserved.
//

#import "SKUIViewControllerExt.h"

@implementation UIViewController(SKUIViewControllerExt)

- (void)runWithParameters:(NSString*)paramStr :(NSString*)queryString
{
    //SKLOG(@"Run Parameters with prototype. params=%@", paramStr);
}

- (void)run:(NSString *)action withParameters:(NSDictionary *)parametersMayEmpty {
    
}
- (void)updateMain:(NSURL *)url
{

}
- (void)OpenRightPanel:(NSString *)command query:(NSString *)query
{}
- (void)updateCurrentMoudle
{

}
// SKLauncher.currentModule return a specified contentViewController to PopoverController when SORT/FILTER/SEARCH pressed
// All operations in this contentViewController are managed by SKLauncher.currentModule
- (UIViewController *)contentViewControllerForSearch
{
    return nil;
}
- (UIViewController *)contentViewControllerForFilter
{
    return nil;
}
- (UIViewController *)contentViewControllerForSort
{
    return nil;
}
@end
