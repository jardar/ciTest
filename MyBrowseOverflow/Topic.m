//
//  Topic.m
//  MyBrowseOverflow
//
//  Created by JarDar on 13/8/30.
//  Copyright (c) 2013年 JarDar. All rights reserved.
//

#import "Topic.h"
#import "Question.h"

@implementation Topic {
    NSArray *questions;
}
@synthesize name,tag;

- (id)initWithName:(NSString *)newName tag:(NSString *)newTag {
    if ((self = [super init])) {
        name = [newName copy];
        tag = [newTag copy];
        questions = [[NSArray alloc] init];
    }
    return self;
}
- (NSArray *)sortQuestionsLatestFirst: (NSArray *)questionList {
    return [questionList sortedArrayUsingComparator:
            ^(id obj1, id obj2) {
                Question *q1 = (Question *)obj1; Question *q2 = (Question *)obj2;
                return [q2.date compare: q1.date];
            }];
}
- (NSArray *)recentQuestions {
    return [self sortQuestionsLatestFirst: questions];
}

- (void)addQuestion: (Question *)question {
    NSArray *newQuestions = [questions arrayByAddingObject: question]; if ([newQuestions count] > 20) {
        newQuestions = [self sortQuestionsLatestFirst: newQuestions];
        newQuestions = [newQuestions subarrayWithRange: NSMakeRange(0, 20)];
    }
    questions = newQuestions;
}
@end
