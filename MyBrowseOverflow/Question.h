//
//  Question.h
//  MyBrowseOverflow
//
//  Created by JarDar on 13/8/30.
//  Copyright (c) 2013年 JarDar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject
@property (nonatomic,readwrite) NSDate *date;
@property (nonatomic,readwrite) NSString *title;
@property (nonatomic,readwrite) NSInteger score;
@end
