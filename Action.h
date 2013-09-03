//
//  Action.h
//  RefactorSKLauncher
//
//  Created by Chia ta Tsai on 13/8/20.
//  Copyright (c) 2013年 dj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Action : NSObject {
    NSString *schema;
    NSString *domain;
    NSString *func; // /function/type
    
    NSDictionary *parameters;
}

@property(readonly,strong) NSString *schema;
@property(readonly,strong) NSString *domain;
@property(readonly,strong) NSString *func;
@property(readonly,strong) NSDictionary *parameters;

+(Action *)actionWithString:(NSString *)urlStr;

- (NSString *)getURIWithoutQuery;
- (NSString *)getFullURI;

@end
