//
//  QuestionTests.m
//  MyBrowseOverflow
//
//  Created by JarDar on 13/8/30.
//  Copyright (c) 2013年 JarDar. All rights reserved.
//

#import "QuestionTests.h"
#import "Question.h"

@implementation QuestionTests {
    Question *question;
}
- (void)setUp {
    question = [[Question alloc] init];
    question.date = [NSDate distantPast];
    question.title = @"Do iPhones also dream of electric sheep?";
    question.score = 42;
}
- (void)tearDown {
    question = nil;
}
- (void)testQuestionHasADate {
    NSDate *testDate = [NSDate distantPast];
    question.date = testDate;
    STAssertEqualObjects(question.date, testDate,@"Question needs to provide its date");
}
- (void)testQuestionsKeepScore {
    STAssertEquals(question.score, 42, @"Questions need a numeric score");
}
- (void)testQuestionHasATitle {
    STAssertEqualObjects(question.title, @"Do iPhones also dream of electric sheep?", @"Question should know its title");
}
@end
