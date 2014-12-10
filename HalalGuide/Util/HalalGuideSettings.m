//
// Created by Privat on 15/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#define kLocationsLastUpdatedKey @"locationsLastupdated"
#define kPicturesLastUpdatedKey @"picturesLastupdated"
#define kReviewsLastUpdatedKey @"reviewsLastupdated"

#import "HalalGuideSettings.h"

@implementation HalalGuideSettings {

}

@synthesize defaults;

+ (HalalGuideSettings *)instance {
    static HalalGuideSettings *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
            _instance.defaults = [NSUserDefaults standardUserDefaults];
        }
    }

    return _instance;
}

- (NSDate *)locationLastUpdatedAt {
    NSDate *lastUpdatedAt = [self.defaults valueForKey:kLocationsLastUpdatedKey];
    if (!lastUpdatedAt) {
        lastUpdatedAt = [NSDate dateWithTimeIntervalSince1970:0];
    }
    return lastUpdatedAt;
}

- (void)setLocationsLastUpdatedAt {
    [self.defaults setValue:[NSDate dateWithTimeIntervalSinceNow:0] forKey:kLocationsLastUpdatedKey];
}

- (NSDate *)picturesLastUpdatedAt {
    NSDate *lastUpdatedAt = [self.defaults valueForKey:kPicturesLastUpdatedKey];
    if (!lastUpdatedAt) {
        lastUpdatedAt = [NSDate dateWithTimeIntervalSince1970:0];
    }
    return lastUpdatedAt;
}

- (void)setPicturesLastUpdatedAt {
    [self.defaults setValue:[NSDate dateWithTimeIntervalSinceNow:0] forKey:kPicturesLastUpdatedKey];
}

- (NSDate *)reviewsLastUpdatedAt {
    NSDate *lastUpdatedAt = [self.defaults valueForKey:kReviewsLastUpdatedKey];
    if (!lastUpdatedAt) {
        lastUpdatedAt = [NSDate dateWithTimeIntervalSince1970:0];
    }
    return lastUpdatedAt;
}

- (void)setReviewsLastUpdatedAt {
    [self.defaults setValue:[NSDate dateWithTimeIntervalSinceNow:0] forKey:kReviewsLastUpdatedKey];
}
@end