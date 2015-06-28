//
// Created by Privat on 12/06/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import "NSObject+HGJSON.h"


@implementation NSObject (HGJSON)

- (NSString *)bv_jsonDataWithPrettyPrint:(BOOL)prettyPrint{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions) (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];

    if (! jsonData) {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"[]";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}
@end