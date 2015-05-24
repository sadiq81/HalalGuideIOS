//
// Created by Privat on 16/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import "HGENumberScraper.h"
#import "HGSmiley.h"
#import "TFHpple.h"


@implementation HGENumberScraper {

}

+ (void)eNumbersOnCompletion:(void (^)(NSArray *numbers))completion {

    NSMutableArray *numbers = [[NSMutableArray alloc] init];

    NSString *urlString = @"http://www.alahazrat.net/islam/e-numbers-listing-halal-o-haram-ingredients.php";
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSURLSessionDataTask *task = [session dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        TFHpple *parser = [TFHpple hppleWithHTMLData:data];

        NSString *tutorialsXpathQueryString = @"//table[@id='AutoNumber3']/tbody/tr";
        NSArray *tutorialsNodes = [parser searchWithXPathQuery:tutorialsXpathQueryString];

        for (int i = 1; i < [tutorialsNodes count] - 1; i++) {
            TFHppleElement *element = tutorialsNodes[i];
            int i = 0;
        }
/*        for (TFHppleElement *element in tutorialsNodes) {
            int i = 0;

            NSString *report = [element.attributes valueForKey:@"href"];
            TFHppleElement *imageElement = element.children[0];
            NSString *image = [imageElement.attributes valueForKey:@"src"];
            NSString *smileyType = [NSString stringWithFormat:@"%@%@", @"http://www.findsmiley.dk", image];
            TFHppleElement *dateElement = element.children[2];
            NSString *date = dateElement.content;
            HGSmiley *smiley = [[HGSmiley alloc] initWithReport:report smiley:smileyType date:date];
            [enumbers addObject:smiley];

        }*/

        completion(numbers);

    }];
    [task resume];
    [session finishTasksAndInvalidate];
}

@end