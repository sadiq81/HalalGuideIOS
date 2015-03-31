//
// Created by Privat on 09/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Parse/Parse.h>
#import <Crashlytics/Crashlytics.h>
#import "HGErrorReporting.h"


@implementation HGErrorReporting {

}

+ (HGErrorReporting *)instance {
    static HGErrorReporting *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (void)reportError:(NSError *)error {

    NSString *codeString = [NSString stringWithFormat:@"%ld", (long) [error code]];
    NSString *caller = [NSString stringWithFormat:@"Origin: [%@]", [[[[NSThread callStackSymbols] objectAtIndex:1] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[]"]] objectAtIndex:1]];
    caller = [caller stringByReplacingOccurrencesOfString:@" " withString:@""];
    CLS_LOG(@"Error: %@", codeString);
}

@end