//
//  ModelDAO.m
//  MyBrowseOverflow
//
//  Created by JarDar on 13/8/30.
//  Copyright (c) 2013年 JarDar. All rights reserved.
//

#import "ModelHelper.h"

SKItemLocation SKItemLocationMake(unsigned int section,unsigned int item) {
    SKItemLocation ret={section,item};
    return ret;
}

@interface ModelHelper() {
    int *internalMapStorage;
    int **map;
    int maxMapRow;
    int maxMapColumn;
}
@property(nonatomic,strong) NSMutableDictionary *model;
@property(nonatomic,strong) NSMutableArray *orderedSectionNames;
@property(nonatomic,strong) NSString *lastCriteria;

@end
@implementation ModelHelper

-(id) initWithDictionary:(NSDictionary *)data {
    if (self =[super init]) {
        _model = [data mutableCopy]; //this will cause all objects mutable in hierarchy
        _orderedSectionNames = [[[_model allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] mutableCopy];
        [self initAndSetupMap];
    }
    return self;
}
-(void)initAndSetupMap {
    maxMapRow = [_orderedSectionNames count];
    maxMapColumn = [self getMaxMapColumn]+1;
    int row =maxMapRow,
        column=maxMapColumn;
    //    int *itemMap=new int[row];
    internalMapStorage = malloc(row*column*sizeof(int));
    map = malloc(row*sizeof(int*));
    for (int i=0; i<row; i++)
        map[i]=internalMapStorage+i*column;
    
    for (int i=0;i<row;i++)
        for (int j=0;j<column;j++)
            map[i][j]=-1;
    
    for (int i=0;i<row;i++)
        for (int j=0;j<[_model[_orderedSectionNames[i]] count];j++)
            map[i][j]=j;

}
-(int)getMaxMapColumn {
    __block int retColumn=0;
    [_model enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        retColumn = MAX(retColumn, [obj count]);
    }];
    return retColumn;
}

-(void)dealloc {
    //TODO: make sure it really free memory here in ARC
    free(map);
    free(internalMapStorage);
}

-(NSString *)selectionNameAt:(int)sectionIndex {
    NSAssert(sectionIndex>=0, @"invalid parameter");
    if (_orderedSectionNames!=nil)
        return _orderedSectionNames[sectionIndex];
    else return nil;
}
-(NSDictionary *)itemAt:(SKItemLocation) location {
    id ret=nil;
    if (self.model !=nil)
        ret = self.model[self.orderedSectionNames[location.section]] [map[location.section][location.item]];
    return ret;
}
//
//-(NSArray *)sectionNames {
//    //TODO: might remove
//    return _orderedSectionNames;
//}

-(int)numberOfSection {
    return [_orderedSectionNames count];
}

-(int)numberOfItemsAtSection:(int)secIdx {
    int len =0;
    for (int y=0;y<maxMapColumn;y++) {
        if (map[secIdx][y]==-1) break;
        len++;
    }
    return len;
}

-(void)selectByDescription:(NSString *)searchTerm {
    if (self.model ==nil ) return;
    self.lastCriteria = searchTerm;
    
    int row =maxMapRow, //[self.orderedSectionNames count],
        column=maxMapColumn;
    for (int i=0;i<row;i++)
        for (int j=0;j<column;j++)
            map[i][j]=-1;
    
    self.orderedSectionNames = nil;
    if (searchTerm == nil || [searchTerm length]==0 ) {
        self.orderedSectionNames = [[[self.model allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] mutableCopy];
        for (int i=0;i<row;i++)
            for (int j=0;j<[self.model[self.orderedSectionNames[i]] count];j++)
                map[i][j]=j;
        return;
    } else {
        NSMutableArray *tempSectionNames=[@[] mutableCopy];
        self.orderedSectionNames = [[[self.model allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] mutableCopy];
        int count = [self.orderedSectionNames count];
        for (int i=0;i<count;i++) {
            NSMutableArray *row = self.model[self.orderedSectionNames[i]];
            NSIndexSet *match = [row indexesOfObjectsWithOptions:NSEnumerationConcurrent passingTest:^BOOL(id itemObj, NSUInteger idx, BOOL *stop) {
                NSMutableDictionary *item = (NSMutableDictionary *)itemObj;
                return [item[@"description"] hasPrefix:searchTerm];
            }];
            if ( [match count] >0 ) {
                [tempSectionNames addObject:self.orderedSectionNames[i]];
                int x = [tempSectionNames indexOfObject:self.orderedSectionNames[i]];
                __block int y=0;
                [match enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                map[x][y++]=idx;
                }];
            }
        }
        self.orderedSectionNames=tempSectionNames;
        
    }
//    //[self.model enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id key, id obj, BOOL *stop) {
//    self.orderedSectionNames = [@[] mutableCopy];
//    [self.model enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//         
//        NSMutableArray *row = (NSMutableArray *)obj;
//        
//        NSIndexSet *match = [row indexesOfObjectsWithOptions:NSEnumerationConcurrent passingTest:^BOOL(id itemObj, NSUInteger idx, BOOL *stop) {
//            NSMutableDictionary *item = (NSMutableDictionary *)itemObj;
//            return [item[@"description"] hasPrefix:searchTerm];
//        }];
//        NSLog(@"=====index set count=%d",[match count]);
//        //if ([match count]>0) {
//            [self.orderedSectionNames addObject:key];
//            int x = [self.orderedSectionNames indexOfObject:key];
//            __block int y=0;
//            [match enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
//                map[x][y++]=idx;
//            }];
//        //}//if
//    }];
    //re-order sectionNames & map
    NSLog(@"**********after search");
    [self dumpMap];
}

-(void)updateDescriptionByLocation:(SKItemLocation)location value:(NSString *)value {
    NSMutableDictionary *item = self.model[self.orderedSectionNames[location.section]] [map[location.section][location.item]];
    item[@"description"] = value;
}
-(void)updateFavoriteByLocation:(SKItemLocation)location value:(BOOL)likeOrNot {
    NSMutableDictionary *item = self.model[self.orderedSectionNames[location.section]] [map[location.section][location.item]];
    item[@"favorite"] = [NSNumber numberWithBool:likeOrNot] ;
}

-(void)deleteItemAt:(SKItemLocation)location {
    NSLog(@"========before delete\n");
    [self dumpMap];
    NSMutableArray *thatRow = self.model[self.orderedSectionNames[location.section]];
    [thatRow removeObjectAtIndex:map[location.section][location.item] ];
//    NSLog(@"model array=%@",self.model[self.orderedSectionNames[location.section]]);
    for (int i=0;i<maxMapColumn;i++ ) map[location.section][i]=-1;
    
    if (self.lastCriteria == nil || [self.lastCriteria length]==0) {
        [thatRow enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            map[location.section][idx]=idx;
        }];

    }else {
    
        NSIndexSet *match =
            [thatRow indexesOfObjectsWithOptions:NSEnumerationConcurrent passingTest:^BOOL(id itemObj, NSUInteger idx, BOOL *stop) {
                    NSMutableDictionary *item = (NSMutableDictionary *)itemObj;
                return [item[@"description"] hasPrefix:self.lastCriteria];
            }];
        __block int y=0;
        [match enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            map[location.section][y++]=idx;
        }];
    }
   
    
    NSLog(@"========after delete\n");
    [self dumpMap];
}
//-(int)lengthOfRow:(int)x {
//    int count=0;
//    while (map[x][count]>=0)
//        count++;
//    return count;
//}
//for dirty test
-(void)dumpMap {
    int row =[self.orderedSectionNames count],
        column=maxMapColumn;
    NSString *dump = [NSString stringWithFormat:@"===========MAP below:(row=%d,column=%d)",row,column];
    for (int i=0;i<row;i++) {
        dump =[dump stringByAppendingFormat:@"\nrow %d: ",i];
        for (int j=0;j<column;j++)
            dump =[dump stringByAppendingFormat:@"%d ",map[i][j]];
    }
    NSLog(@"%@",dump);      
    
}
-(NSMutableDictionary *)quickTestMutable {
   // int cSection = [self.model count];
    [self.model enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSMutableArray *row = (NSMutableArray *)obj;
        // get nsdic and update content directly
        [row enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSLog(@"***********idx=%d",idx);
            NSMutableDictionary *item = (NSMutableDictionary *)obj;
            item[@"description"] = @"mutable";
        }];
        
        [row removeLastObject];
        
    }];
    [self.model removeObjectForKey:[self.model allKeys][0]];
    return self.model;
}
@end
