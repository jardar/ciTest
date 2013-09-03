//
//  Person.m
//  MyBrowseOverflow
//
//  Created by JarDar on 13/8/30.
//  Copyright (c) 2013年 JarDar. All rights reserved.
//

#import "Person.h"

@implementation Person
@synthesize name,avatarURL;

- (id)initWithName:(NSString *)aName avatarLocation:(NSString *)location {
    if ((self = [super init])) {
    name = [aName copy];
    avatarURL = [[NSURL alloc] initWithString: location]; }
    return self;
}
@end
