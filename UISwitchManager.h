//
//  UISwitchManager.h
//  RefactorSKLauncher
//
//  Created by Chia ta Tsai on 13/8/20.
//  Copyright (c) 2013年 dj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Launchable.h"

@interface UISwitchManager : NSObject<Launchable>

+(UISwitchManager*)getInstance;

-(id<Launchable>)getWorker:(NSString *)func withParentVC:(UIViewController *)parentViewController;

@end
