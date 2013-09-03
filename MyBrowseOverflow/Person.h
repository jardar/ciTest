//
//  Person.h
//  MyBrowseOverflow
//
//  Created by JarDar on 13/8/30.
//  Copyright (c) 2013年 JarDar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
@property(readonly) NSString *name ;
@property(readonly) NSURL *avatarURL;

- (id)initWithName:(NSString *)aName avatarLocation:(NSString *)location;
@end
