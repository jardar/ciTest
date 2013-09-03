//
//  ModelDAO.h
//  MyBrowseOverflow
//
//  Created by JarDar on 13/8/30.
//  Copyright (c) 2013年 JarDar. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef struct SKItemLocation {
    unsigned int section; //row == section
    unsigned int item; //column == item's loction
} SKItemLocation;

extern SKItemLocation SKItemLocationMake(unsigned int section,unsigned int item);

@interface ModelHelper : NSObject

//@property(nonatomic,readonly) NSArray *sectionNames;
@property(nonatomic,readonly) int numberOfSection;

-(id) initWithDictionary:(NSDictionary *)data;
-(int)numberOfItemsAtSection:(int)sectionIndex;
-(NSString *)selectionNameAt:(int)sectionIndex;
-(NSDictionary *)itemAt:(SKItemLocation) location;

-(void)selectByDescription:(NSString *)searchTerm;
-(void)updateDescriptionByLocation:(SKItemLocation)location value:(NSString *)value;
-(void)updateFavoriteByLocation:(SKItemLocation)location value:(BOOL)likeOrNot;
-(void)deleteItemAt:(SKItemLocation)location;


//for test temporary
-(NSMutableDictionary *)quickTestMutable;
@end
