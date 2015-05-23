//
// Created by Privat on 16/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import "HGSmileyScraper.h"
#import "HGSmiley.h"
#import "TFHpple.h"


@implementation HGSmileyScraper {

}

+ (void)smileyLinksForLocation:(HGLocation *)location onCompletion:(void (^)(NSArray *smileys))completion {

    NSMutableArray *smileys = [[NSMutableArray alloc] init];
    if (location.navneloebenummer != nil && [location.navneloebenummer count] > 0) {
        for (int i = 0; i < [location.navneloebenummer count]; i++) {
            NSString *urlString = [NSString stringWithFormat:@"%@%@", @"http://www.findsmiley.dk/da-DK/Searching/DetailsView.htm?virk=", location.navneloebenummer[i]];
            NSURL *URL = [NSURL URLWithString:urlString];
            NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
            NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
            NSURLSessionDataTask *task = [session dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

                TFHpple *parser = [TFHpple hppleWithHTMLData:data];

                NSString *tutorialsXpathQueryString = @"//a[@class='link_pdf']";
                NSArray *tutorialsNodes = [parser searchWithXPathQuery:tutorialsXpathQueryString];

                for (TFHppleElement *element in tutorialsNodes) {
                    NSString *report = [element.attributes valueForKey:@"href"];
                    TFHppleElement *imageElement = element.children[0];
                    NSString *image = [imageElement.attributes valueForKey:@"src"];
                    NSString *smileyType = [NSString stringWithFormat:@"%@%@", @"http://www.findsmiley.dk", image];
                    TFHppleElement *dateElement = element.children[2];
                    NSString *date = dateElement.content;
                    HGSmiley *smiley = [[HGSmiley alloc] initWithReport:report smiley:smileyType date:date];
                    [smileys addObject:smiley];
                }

                completion(smileys);

            }];
            [task resume];
            [session finishTasksAndInvalidate];
        }
    } else {
        completion(smileys);
    }
}

@end