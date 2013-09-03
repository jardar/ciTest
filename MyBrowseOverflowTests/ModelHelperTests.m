//
//  ModelDAOTests.m
//  MyBrowseOverflow
//
//  Created by JarDar on 13/8/30.
//  Copyright (c) 2013年 JarDar. All rights reserved.
//

#import "ModelHelperTests.h"
#import "ModelHelper.h"
#ifdef RANDOM_DATA
    #define MAX_SECTION 2
    #define MAX_ITEM 30
#else
    #define MAX_SECTION 3
    #define MAX_ITEM 5
#endif

@implementation ModelHelperTests {
    ModelHelper *dao;
    NSDictionary *dummyData;
}

- (void)setUp {
    dummyData = [self dummyData];
    //[self dump:dummyData];
    dao = [[ModelHelper alloc] initWithDictionary:dummyData];
}
- (void)tearDown {
    dao = nil;
    dummyData = nil;
}

-(void)testSectionNamesIsAscendingOrdered {
    NSMutableArray *secNames = [NSMutableArray arrayWithCapacity:[dummyData count]];
    int numberOfSection = [dao numberOfSection];
    for(int i=0;i<numberOfSection ; i++) {
        [secNames addObject:[dao selectionNameAt:i]];
    }
    STAssertEquals(numberOfSection, (int)[dummyData count], @"count should equal");
    [secNames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx == numberOfSection-2) *stop=YES;
        STAssertEquals( [obj compare:secNames[idx+1]],NSOrderedAscending,@"should NSOrderedAscending");
    }];
}


-(void)testSectionNamesIsAscendingOrderedAfterSearch {
    [dao selectByDescription:@"cross section"];
    NSMutableArray *secNames = [NSMutableArray array];
    int numberOfSection = [dao numberOfSection];
    for(int i=0;i<numberOfSection ; i++) {
        [secNames addObject:[dao selectionNameAt:i]];
    }
    STAssertEquals(3, numberOfSection, @"count should equal");
    [secNames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx == numberOfSection-2) *stop=YES;
        STAssertEquals( [obj compare:secNames[idx+1]],NSOrderedAscending,@"should NSOrderedAscending");
    }];
}

-(void)testGetItemAtSec0Item0 {
    id item = [dao itemAt:SKItemLocationMake(0,0)];
    STAssertTrue([item isKindOfClass:[NSDictionary class]], @"should be NSDictionary");
    
    STAssertTrue([item[@"id1"] isEqualToString:@"r0c0id1"], @"id1 shoud have value");
    STAssertTrue([item[@"id2"] isEqualToString:@"r0c0id2"], @"id2 shoud have value");
    STAssertTrue([item[@"description"] isEqualToString:@"row0 col0"], @"description shoud have value");
    STAssertTrue([item[@"favorite"] boolValue]==NO, @"favorite shoud have value");
    STAssertTrue(item[@"imgmain"] !=nil, @"imgmain shoud have value");
    
}
-(void)testGetItemAtSec0Item0AfterSearch {
    [dao selectByDescription:@"cross section"];
    id item = [dao itemAt:SKItemLocationMake(0,0)];
    STAssertTrue([item isKindOfClass:[NSDictionary class]], @"should be NSDictionary");
    
    STAssertTrue([item[@"id1"] isEqualToString:@"r0c3id1"], @"id1 shoud have value");
    STAssertTrue([item[@"id2"] isEqualToString:@"r0c3id2"], @"id2 shoud have value");
    STAssertTrue([item[@"description"] isEqualToString:@"cross section"], @"description shoud have value");
    STAssertTrue([item[@"favorite"] boolValue]==NO, @"favorite shoud have value");
    STAssertTrue(item[@"imgmain"] !=nil, @"imgmain shoud have value");
    
}
-(void)testGetItemAtSec3Item2 {
    id item = [dao itemAt:SKItemLocationMake(3,2)];
            
    STAssertTrue([item isKindOfClass:[NSDictionary class]], @"should be NSDictionary");
    
    STAssertTrue([item[@"id1"] isEqualToString:@"r3c2id1"], @"id1 shoud have value");
    STAssertTrue([item[@"id2"] isEqualToString:@"r3c2id2"], @"id2 shoud have value");
    STAssertTrue([item[@"description"] isEqualToString:@"row3 col2"], @"description shoud have value");
    STAssertTrue([item[@"favorite"] boolValue]==NO, @"favorite shoud have value");
    STAssertTrue(item[@"imgmain"] !=nil, @"imgmain shoud have value");
    
}
-(void)testGetItemAtSec3Item2AfterSearch {
    [dao selectByDescription:@"cross section"];
    id item = [dao itemAt:SKItemLocationMake(2,1)];
    
    STAssertTrue([item isKindOfClass:[NSDictionary class]], @"should be NSDictionary");
    
    STAssertTrue([item[@"id1"] isEqualToString:@"r1c5id1"], @"id1 shoud have value");
    STAssertTrue([item[@"id2"] isEqualToString:@"r1c5id2"], @"id2 shoud have value");
    STAssertTrue([item[@"description"] isEqualToString:@"cross section"], @"description shoud have value");
    STAssertTrue([item[@"favorite"] boolValue]==YES, @"favorite shoud have value");
    STAssertTrue(item[@"imgmain"] !=nil, @"imgmain shoud have value");
}

-(void)testItemCountAfterSearch {
    [dao selectByDescription:@"row1"];
    int rows = [dao numberOfSection];
    STAssertTrue(rows==1, @"selection count should ==1");
    
    STAssertEquals(4,[dao numberOfItemsAtSection:0], @"column must have ==4");
}
-(void)testItemCountAfterSearchNull {
    [dao selectByDescription:@""];
    int rows = [dao numberOfSection];
    STAssertEquals(4,rows, @"selection count should ==1");
    
    STAssertEquals(4,[dao numberOfItemsAtSection:0], @"column must have ==4");
    STAssertEquals(2,[dao numberOfItemsAtSection:1], @"column must have ==4");
    STAssertEquals(6,[dao numberOfItemsAtSection:2], @"column must have ==4");
    STAssertEquals(3,[dao numberOfItemsAtSection:3], @"column must have ==4");
}

-(void)testUpdateDescriptionBeforeSearch {
    [dao updateDescriptionByLocation:SKItemLocationMake(1, 1) value:@"changed row1 col1"];
    id item = [dao itemAt:SKItemLocationMake(1, 1)];
    STAssertTrue([item[@"description"] isEqualToString:@"changed row1 col1"], @"must be update");
}
-(void)testUpdateDescriptionAfterSearch {
    [dao selectByDescription:@"row1 col"];
    
    [dao updateDescriptionByLocation:SKItemLocationMake(0, 0) value:@"changed row1 col1"];
    [dao selectByDescription:nil];
    id item = [dao itemAt:SKItemLocationMake(2, 0)];
    STAssertTrue([item[@"description"] isEqualToString:@"changed row1 col1"], @"must be update");
}
-(void)testDeleteBeforeSearch {
    [dao deleteItemAt:SKItemLocationMake(1, 1)];
    STAssertEquals(1, [dao numberOfItemsAtSection:1], @"==1");
    id item = [dao itemAt:SKItemLocationMake(1, 0)];
    STAssertTrue([item[@"description"] isEqualToString:@"row2 col0"], @"must be another item");
}
-(void)testDeleteAfterSearch {
    [dao selectByDescription:@"row1 col"];
    [dao deleteItemAt:SKItemLocationMake(0, 2)];
    STAssertEquals(3,[dao numberOfItemsAtSection:0], @"==5");
    id item = [dao itemAt:SKItemLocationMake(0, 2)];
    STAssertTrue([item[@"description"] isEqualToString:@"row1 col4"], @"must be update");
}
-(void)dump:(NSDictionary*)dumpData {
    [dumpData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSMutableArray *row = (NSMutableArray *)obj;
        // get nsdic and update content directly
        [row enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSMutableDictionary *item = (NSMutableDictionary *)obj;
            NSLog(@"=========desc=%@",item[@"description"]);
            
        }];
        //
        
    }];
}
//-(void)testThatModelDAO
//-(void)testFor
/*
-(void)testForQuickTest {
    NSMutableDictionary *ret = [dao quickTestMutable];
    NSLog(@"count=%d",[ret count]);
    //STAssertEquals([dummyData count], [ret count], @"the same count");
    //[self dump:dummyData];
    
    [ret enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSMutableArray *row = (NSMutableArray *)obj;
        // get nsdic and update content directly
        [row enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSMutableDictionary *item = (NSMutableDictionary *)obj;
            NSLog(@"=========desc=%@",item[@"description"]);
            STAssertEqualObjects(item[@"description"], @"mutable" , @"should equals");
        }];
        //
        
    }];
}
 */
#pragma mark - setup test data
-(NSDictionary *)dummyData {
    // [section][row]
    // [row] = array of data row
    NSMutableDictionary *data = [@{} mutableCopy];
    //for (int sec=0;sec < MAX_SECTION ;sec++) {
   
#ifdef RANDOM_DATA
     for (int sec=MAX_SECTION-1;sec >=0 ;sec--) {
        [data setObject:[self dummyRow] forKey:[NSString stringWithFormat:@"%d 中文section",sec]];
     }//for
#else
    
    //row 1 : 4 col
    NSMutableArray *row = [NSMutableArray array];
    [row addObject: [self dummyDTOWith:@"r0c0id1" id2:@"r0c0id2" favorite:NO description:@"row0 col0"] ];
    [row addObject: [self dummyDTOWith:@"r0c1id1" id2:@"r0c1id2" favorite:YES description:@"row0 col1"] ];
    [row addObject: [self dummyDTOWith:@"r0c2id1" id2:@"r0c2id2" favorite:NO description:@"row0 col2"] ];
    [row addObject: [self dummyDTOWith:@"r0c3id1" id2:@"r0c3id2" favorite:NO description:@"cross section"] ];
    [data setObject:row forKey:@"1 中文section"];
    //row2 : 6 col
    row = [NSMutableArray array];
    [row addObject: [self dummyDTOWith:@"r1c0id1" id2:@"r1c0id2" favorite:YES description:@"row1 col0"] ];
    [row addObject: [self dummyDTOWith:@"r1c1id1" id2:@"r1c1id2" favorite:NO description:@"row1 col1"] ];
    [row addObject: [self dummyDTOWith:@"r1c2id1" id2:@"r1c2id2" favorite:YES description:@"cross section"] ];
    [row addObject: [self dummyDTOWith:@"r1c3id1" id2:@"r1c3id2" favorite:NO description:@"row1 col3"] ];
    [row addObject: [self dummyDTOWith:@"r1c4id1" id2:@"r1c4id2" favorite:YES description:@"row1 col4"] ];
    [row addObject: [self dummyDTOWith:@"r1c5id1" id2:@"r1c5id2" favorite:YES description:@"cross section"] ];
    [data setObject:row forKey:@"3 姓氏section"];
    //row3 : 2 col
    row = [NSMutableArray array];
    [row addObject: [self dummyDTOWith:@"r2c0id1" id2:@"r2c0id2" favorite:YES description:@"row2 col0"] ];
    [row addObject: [self dummyDTOWith:@"r2c1id1" id2:@"r2c1id2" favorite:YES description:@"cross section"] ];
    [data setObject:row forKey:@"2 名字section"];
    //row4 : 3 col
    row = [NSMutableArray array];
    [row addObject: [self dummyDTOWith:@"r3c0id1" id2:@"r3c0id2" favorite:YES description:@"row3 col0"] ];
    [row addObject: [self dummyDTOWith:@"r3c1id1" id2:@"r3c1id2" favorite:NO description:@"row3 col1"] ];
    [row addObject: [self dummyDTOWith:@"r3c2id1" id2:@"r3c2id2" favorite:NO description:@"row3 col2"] ];
    [data setObject:row forKey:@"4 號碼section"];

#endif  
    
    return data;
}
-(NSDictionary *)dummyDTOWith:(NSString*)id1 id2:(NSString*)id2
                     favorite:(BOOL)like
                  description:(NSString*)desc
{
    NSMutableDictionary *dto = [@{} mutableCopy];
    [dto setObject:id1 forKey:@"id1"];
    [dto setObject:id2 forKey:@"id2"];
    [dto setObject:[NSNumber numberWithBool:like] forKey:@"favorite"];
    [dto setObject:desc forKey:@"description"];
    [dto setObject:[self randomUrl] forKey:@"imgmain"];
    return dto;
}

-(NSArray *)dummyRow {
    NSMutableArray *rows = [@[] mutableCopy];
    for (int row=0; row<MAX_ITEM ; row++) {
        [rows addObject:[self dummyDTO]];
    }
    return rows;
}
-(NSDictionary *)dummyDTO {
    NSMutableDictionary *dto = [@{} mutableCopy];
    [dto setObject:[self randomString:10] forKey:@"id1"];
    [dto setObject:[self randomString:10] forKey:@"id2"];
    [dto setObject:[NSNumber numberWithBool:NO] forKey:@"favorite"];
    [dto setObject:[self randomString:12] forKey:@"description"];
    //[dto setObject:@"abcDDADADF" forKey:@"description"];
    [dto setObject:[self randomUrl] forKey:@"imgmain"];
    return dto;
}
NSString const *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

-(NSString *) randomString: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}
NSString const *baseUrl = @"https://dl.dropboxusercontent.com/u/11236284/";

-(NSString *)randomUrl {
    return [NSString stringWithFormat:@"%@%d.jpg",baseUrl,(arc4random() %14 +1)] ;
}
@end
