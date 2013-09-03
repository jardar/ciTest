//
//  SKUIViewControllerExt.h
//  SKModuleTestBed
//
//  Created by abyss on 13/7/10.
//  Copyright (c) 2013年 eyesmedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController(SKUIViewControllerExt)

- (void)runWithParameters:(NSString*)paramStr :(NSString*)queryString;
- (void)run:(NSString *)action withParameters:(NSDictionary *)parametersMayEmpty ;

- (void)updateMain:(NSURL *)url;
- (void)OpenRightPanel:(NSString *)command query:(NSString *)query;
- (void)updateCurrentMoudle;


#pragma mark - 
//  SKLauncher.currentModule return a specified contentViewController to PopoverController when SORT/FILTER/SEARCH pressed
//  All operations in this contentViewController are managed by SKLauncher.currentModule
- (UIViewController *)contentViewControllerForSearch;
- (UIViewController *)contentViewControllerForFilter;
- (UIViewController *)contentViewControllerForSort;

@end
