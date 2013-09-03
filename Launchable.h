//
//  Launchable.h
//  SKModuleTestBed
//
//  Created by JarDar on 13/8/1.
//  Copyright (c) 2013年 eyesmedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Launchable <NSObject>

-(void) run:(NSString *)action withParameters:(NSDictionary *)parametersMayEmpty delegate:(id)delegate;
@end
