//
//  Topic.h
//  MyBrowseOverflow
//
//  Created by JarDar on 13/8/30.
//  Copyright (c) 2013年 JarDar. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Question;

@interface Topic : NSObject
@property (readonly) NSString *name;
@property (readonly) NSString *tag;

- (id)initWithName:(NSString *)newName tag:(NSString *)newTag;

- (NSArray *)recentQuestions;
- (void)addQuestion: (Question *)question;

@end
