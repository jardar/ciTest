//
//  SKLauncher.m
//  RefactorSKLauncher
//
//  Created by Chia ta Tsai on 13/8/20.
//  Copyright (c) 2013年 dj. All rights reserved.
//

#import "SKLauncher.h"
#import "Action.h"
#import "Launchable.h"
#import "UISwitchManager.h"

#define SCHEMA_HTTP @"http"
#define SCHEMA_SALESKIT @"eyessk"

#define DOMAIN_DATAIO @"dataio"
#define DOMAIN_CONTACT @"contact"
#define DOMAIN_EMAIL @"email"

#define ACTION_READALL_DEVICE_CONTACT @"/readall/devicecontact"
#define ACTION_READALL_FB_CONTACT @"/readall/fbcontact"
#define ACTION_READALL_TWITTER_CONTACT @"/readall/twittercontact"
#define ACTION_READALL_LINKEDIN_CONTACT @"/readall/linkedincontact"
#define ACTION_READALL_GOOGLE_CONTACT @"/readall/gcontact"
#define ACTION_READALL_GOOGLE_EVENT @"/readall/gevent"

#define GEN_SCHEME(a) [NSString stringWithFormat:@"%@://%@", SCHEMA_SALESKIT, a]

#define ActionNull nil

static SKLauncher *instance = nil;
@interface SKLauncher()

- (BOOL)launchWithURLScheme:(NSString*)urlStr delegate:(id)delegate;
@end

@implementation SKLauncher
@synthesize tableSysFn,contentViewController;

#pragma mark - static methods
+ (SKLauncher*)getInstance
{
    if ( instance == nil ) {
        instance = [[SKLauncher alloc] init];
    }
    return instance;
}

+ (void)destroyInstance
{
    //instance.moduleDict = nil;
    instance = nil;
}

+ (NSDictionary*)parseQueryStringToDictionary:(NSString*)queryString
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSArray *queryParams = [queryString componentsSeparatedByString:@"&"];
    
    for (NSString *param in queryParams ){
        NSArray *keyAndValue = [param componentsSeparatedByString:@"="];
        [dict setObject:[keyAndValue objectAtIndex:1] forKey:[keyAndValue objectAtIndex:0]];
    }
    return dict;
}

+ (NSString*)encodeQueryStringByDictionary:(NSDictionary*)dict
{
    NSString *queryString = @"";
    
    NSArray *keys = [dict allKeys];
    
    for ( NSString *key in keys ) {
        queryString = [queryString stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key, [dict objectForKey:key]]];
        if ( key != [keys lastObject] ) {
            queryString = [queryString stringByAppendingString:@"&"];
        }
    }
    return queryString;
}

+ (BOOL)openModuleWithURLScheme:(NSString*)urlStr delegate:(id)delegate {
    return [[SKLauncher getInstance] launchWithURLScheme:urlStr delegate:delegate];
}
#pragma mark - instance methods
- (id)init {
    self = [super init];
    if ( self ) {
        [self loadSysFnTable];
    }
    
    return self;
}
- (void)loadSysFnTable {
    self.tableSysFn = [[NSMutableArray alloc] init];
    NSDictionary *row = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"1", @"id",
                         @"1", @"sys_domain_id",
                         @"DLDropbox", @"name",
                         @"key", @"enable_key",
                         @"eyessk://file/download/dropbox", @"url",
                         @"1", @"enable_op_log",nil];
    [self.tableSysFn addObject:row];
    row = [NSDictionary dictionaryWithObjectsAndKeys:
           @"2", @"id",
           @"1", @"sys_domain_id",
           @"DLGdrive", @"name",
           @"", @"enable_key",
           @"eyessk://file/download/gdrive", @"url",
           @"1", @"enable_op_log",nil];
    [self.tableSysFn addObject:row];
    row = [NSDictionary dictionaryWithObjectsAndKeys:
           @"3", @"id",
           @"4", @"sys_domain_id",
           @"GmailImap", @"name",
           @"key", @"enable_key",
           @"eyessk://email/import/gimap", @"url",
           @"1", @"enable_op_log",nil];
    [self.tableSysFn addObject:row];
    row = [NSDictionary dictionaryWithObjectsAndKeys:
           @"4", @"id",
           @"4", @"sys_domain_id",
           @"GmailPOP3", @"name",
           @"key", @"enable_key",
           @"eyessk://email/import/gpop3", @"url",
           @"1", @"enable_op_log",nil];
    [self.tableSysFn addObject:row];
    row = [NSDictionary dictionaryWithObjectsAndKeys:
           @"5", @"id",
           @"5", @"sys_domain_id",
           @"GCalendar", @"name",
           @"key", @"enable_key",
           @"eyessk://dataio/readall/gevent", @"url",
           @"1", @"enable_op_log",nil];
    [self.tableSysFn addObject:row];
    row = [NSDictionary dictionaryWithObjectsAndKeys:
           @"6", @"id",
           @"6", @"sys_domain_id",
           @"DataioReadallFBContact", @"name",
           @"key", @"enable_key",
           @"eyessk://dataio/readall/fbcontact", @"url",
           @"1", @"enable_op_log",nil];
    [self.tableSysFn addObject:row];
    row = [NSDictionary dictionaryWithObjectsAndKeys:
           @"7", @"id",
           @"7", @"sys_domain_id",
           @"DataioReadallTwitterContact", @"name",
           @"key", @"enable_key",
           @"eyessk://dataio/readall/twittercontact", @"url",
           @"1", @"enable_op_log",nil];
    [self.tableSysFn addObject:row];
    row = [NSDictionary dictionaryWithObjectsAndKeys:
           @"8", @"id",
           @"8", @"sys_domain_id",
           @"DataioReadallLinkedinContact", @"name",
           @"key", @"enable_key",
           @"eyessk://dataio/readall/linkedincontact", @"url",
           @"1", @"enable_op_log",nil];
    [self.tableSysFn addObject:row];
    row = [NSDictionary dictionaryWithObjectsAndKeys:
           @"9", @"id",
           @"9", @"sys_domain_id",
           @"DataioReadallGoogleContact", @"name",
           @"key", @"enable_key",
           @"eyessk://dataio/readall/gcontact", @"url",
           @"1", @"enable_op_log",nil];
    [self.tableSysFn addObject:row];
    row = [NSDictionary dictionaryWithObjectsAndKeys:
           @"9", @"id",
           @"9", @"sys_domain_id",
           @"DataioReadallDeviceContact", @"name",
           @"key", @"enable_key",
           @"eyessk://dataio/readall/devicecontact", @"url",
           @"1", @"enable_op_log",nil];
    [self.tableSysFn addObject:row];
}
- (void)pause
{
    //[self cleanUpLastModule];
}

- (void)resume
{
    //[self openModuleWithURLScheme:[self.pathHistory lastObject]];
}

- (BOOL)launchWithURLScheme:(NSString*)urlStr delegate:(id)delegate {
    Action *action = [Action actionWithString:urlStr];
    
    id<Launchable> worker=nil;
    
    if ( action!=ActionNull && 
         [self isAuthorizated:action] &&
        (worker = [self getAvailabeWorker:action]) ) {
        
        [worker run:action.func withParameters:action.parameters delegate:delegate];
        return TRUE;
    } 
    return FALSE;
}

-(BOOL) isAuthorizated:(Action *)action {
    for (NSDictionary *row in self.tableSysFn) {
        if ([[row objectForKey:@"url"] isEqualToString:[action getURIWithoutQuery] ] ) {
            [self insertOPLog:row url:[action getFullURI]];
            
            if ( [self checkLicenseKey:[row objectForKey:@"enable_key"]] ) return TRUE;
            else return FALSE;
        }
    }
    return FALSE;
}
-(BOOL)checkLicenseKey:(NSString*)key {
    //TODO key algorithm
    if ([key length]>0) return TRUE;
    return FALSE;
}
-(void)insertOPLog:(NSDictionary *)row url:(NSString *)url {
    if ([[row objectForKey:@"enable_op_log"] isEqualToString:@"1"])
        ;//save to op_log table
    //else do nothing
}


-(id<Launchable>) getAvailabeWorker:(Action *)action {
    NSString *schema = action.schema;
    id<Launchable> worker;
    
    if ([schema isEqualToString:SCHEMA_SALESKIT] ) {
        if([action.domain isEqualToString:DOMAIN_DATAIO] ) {
            worker=[self getDataIOWorker:action.func];
        }else if ([action.domain isEqualToString:DOMAIN_CONTACT] ) {
            
        }else if ([action.domain isEqualToString:DOMAIN_EMAIL] ) {
            worker=[self getEmailWorker:action.func];
        }else {
            worker=[[UISwitchManager getInstance] getWorker:action.func withParentVC:self.contentViewController];
        }
    }else if ([schema isEqualToString:SCHEMA_HTTP]) {
        
    }
    
    return worker;
}
- (id<Launchable>)getEmailWorker:(NSString *)path {
    id worker = nil;
    NSString *clsName = @"EmailCommand";
    Class classType = NSClassFromString(clsName);
    NSAssert(classType , @"there is no class with this name %@",clsName);
    worker = [[classType alloc] init];
    return worker;
}

- (id<Launchable>)getDataIOWorker:(NSString *)func {
    //TODO: refactor later
    id worker = nil;
    /*
    if ([func isEqualToString:ACTION_READALL_DEVICE_CONTACT]) {
        command=[SKContactManager getInstance];
    }else if ([func isEqualToString:ACTION_READALL_FB_CONTACT]) {
        command=[SKContactManager getInstance];
        
    }else if ([func isEqualToString:ACTION_READALL_TWITTER_CONTACT]) {
        command=[SKContactManager getInstance];
        
    }else if ([func isEqualToString:ACTION_READALL_LINKEDIN_CONTACT]) {
        command=[SKContactManager getInstance];
        
    }else if ([func isEqualToString:ACTION_READALL_GOOGLE_CONTACT]) {
        command=[SKContactManager getInstance];
        
    }else if ([func isEqualToString:ACTION_READALL_GOOGLE_EVENT]) {
        command= [SKEventManager getInstance];
    }else {
        NSAssert(FALSE, @"contact uri fail,impossible here");
    }
    */
    
    return worker;
}

- (BOOL)openFile:(NSString*)fileName
{
    
    BOOL result = NO;
    /*
    if ( ![[SKFileManager getInstance] checkFileExist:fileName] )
        fileName = [[SKFileManager getInstance] getFullPath:fileName];
    
    if ( ![[SKFileManager getInstance] checkFileExist:fileName] ) {
        SKWARN(@"Launcher open file failed:%@", fileName);
        return NO;
    }
    
    SKLOG(@"Launcher Open FileName=%@", fileName);
    
    // Check isn't it Video file content
    if ( [[SKFileManager getInstance] isVideoExtension:fileName] ) {
        result = YES;
        NSString *urlScheme = [NSString stringWithFormat:@"eyessk://SKMediaPlayerViewer/video?method=play&file=%@", fileName];
        [self openModuleWithURLScheme:urlScheme];
    }
    else if ( [[SKFileManager getInstance] isPDFExtension:fileName] )
    {
        result = YES;
        NSString *urlScheme = [NSString stringWithFormat:@"eyessk://PDFUnit/pdf?method=open&file=%@", fileName];
        [self openModuleWithURLScheme:urlScheme];
    }
    */
    return result;
     
}



@end
