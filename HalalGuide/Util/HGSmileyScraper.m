//
// Created by Privat on 16/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import "HGSmileyScraper.h"
#import "HTMLElement.h"
#import "HTMLDocument.h"
#import "HTMLSelector.h"
#import "HGSmiley.h"
#import "HTMLTextNode.h"


@implementation HGSmileyScraper {

}

+ (void)smileyLinksForLocation:(HGLocation *)location onCompletion:(void (^)(NSArray *smileys))completion {

    NSMutableArray *smileys = [[NSMutableArray alloc] init];
    if (location.navneloebenummer != nil && [location.navneloebenummer count] > 0) {
        for (int i = 0; i < [location.navneloebenummer count]; i++) {
            NSString *urlString = [NSString stringWithFormat:@"%@%@", @"http://www.findsmiley.dk/da-DK/Searching/DetailsView.htm?virk=", [location.navneloebenummer objectAtIndex:i]];
            NSURL *URL = [NSURL URLWithString:urlString];
            NSURLSession *session = [NSURLSession sharedSession];
            [[session dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                NSString *contentType = nil;
                if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                    NSDictionary *headers = [(NSHTTPURLResponse *) response allHeaderFields];
                    contentType = headers[@"Content-Type"];
                }

                HTMLDocument *home = [HTMLDocument documentWithData:data contentTypeHeader:contentType];
                NSArray *nodesMatchingSelector = [home nodesMatchingSelector:@"a[href^=\"http://www.findsmiley.dk/KontrolRapport.aspx\"]"];
                for (HTMLElement *element in nodesMatchingSelector) {

                    NSString *report = [element.attributes valueForKey:@"href"];
                    NSString *smileyType = nil;
                    NSString *date = nil;

                    NSOrderedSet *children = element.children;

                    for (id inner in children) {
                        if ([inner isKindOfClass:[HTMLElement class]] && [((HTMLElement *) inner).tagName isEqualToString:@"img"]) {
                            smileyType = [NSString stringWithFormat:@"%@%@", @"http://www.findsmiley.dk", [((HTMLElement *) inner).attributes valueForKey:@"src"]];
                        }
                        else if ([inner isKindOfClass:[HTMLTextNode class]]) {
                            date = ((HTMLTextNode *) inner).data;
                        }
                    }

                    HGSmiley *smiley = [[HGSmiley alloc] initWithReport:report smiley:smileyType date:date];
                    [smileys addObject:smiley];
                }
                completion(smileys);
            }] resume];
        }
    } else {
        completion(smileys);
    }

}

@end