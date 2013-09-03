//
//  Action.m
//  RefactorSKLauncher
//
//  Created by Chia ta Tsai on 13/8/20.
//  Copyright (c) 2013年 dj. All rights reserved.
//

#import "Action.h"


@implementation Action {
    NSString *query;
}

+(Action *)actionWithString:(NSString *)urlStr {
    NSAssert(urlStr, @"illegal parameter");
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //SKLOG(@"url=%@",url);
    //SKLOG(@"\nscheme=%@\nhost=%@\nport=%@\npath=%@\nquery=%@\nlastPathComponent=%@\npathComponents=%@ ",
    //[url scheme], [url host],[url port],[url path],[url query],[url lastPathComponent],[url pathComponents]);
    
    if (url == nil) return nil;
    
    return [[Action alloc] initWithURL:url];
}

- (Action *) initWithURL:(NSURL *)url {
    if ((self = [super init])  !=nil) {
        [self parse:url];
    }
    return self;
}

-(void)parse:(NSURL *)url {
    
    self->schema = [url scheme];
    self->domain = [url host] ;
    self->func = [[url path] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self->query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    self->parameters = [self parseQueryStringToDictionary:query];

}

- (NSDictionary*)parseQueryStringToDictionary:(NSString*)queryString {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (queryString !=nil) {
        NSArray *queryParams = [queryString componentsSeparatedByString:@"&"];
    
        for (NSString *param in queryParams ){
            NSArray *keyAndValue = [param componentsSeparatedByString:@"="];
            [dict setObject:[keyAndValue objectAtIndex:1] forKey:[keyAndValue objectAtIndex:0]];
        }
    }
    return dict;
}

- (NSString *)getURIWithoutQuery {
    return [NSString stringWithFormat:@"%@://%@%@",self->schema,self->domain,self->func];
}

- (NSString *)getFullURI {
    return (self->query)? [NSString stringWithFormat:@"%@://%@%@?%@",self->schema,self->domain,self->func,self->query] :
                          [self getURIWithoutQuery];
}

@end
