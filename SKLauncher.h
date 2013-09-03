//
//  SKLauncher.h
//  RefactorSKLauncher
//
//  Created by Chia ta Tsai on 13/8/20.
//  Copyright (c) 2013年 dj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKLauncher : NSObject

@property (nonatomic, strong)       UIViewController *contentViewController;
@property (nonatomic,strong) NSMutableArray *tableSysFn;

// Get Singleton
+ (SKLauncher*)getInstance;
// Destroy Singleton
+ (void)destroyInstance;
// Parse URL Scheme
+ (NSDictionary*)parseQueryStringToDictionary:(NSString*)queryString;
// Encode Dictionary to queryString
// Notice: only one level encoding
+ (NSString*)encodeQueryStringByDictionary:(NSDictionary*)dict;

+ (BOOL)openModuleWithURLScheme:(NSString*)urlStr delegate:(id)delegate;

- (BOOL)openFile:(NSString*)fileName;
// Status Change Function
- (void)pause;
- (void)resume;

@end
