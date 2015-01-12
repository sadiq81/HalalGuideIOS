//
//  LocationDetailViewController.m
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ALActionBlocks/UIControl+ALActionBlocks.h>
#import <UIAlertController+Blocks/UIAlertController+Blocks.h>
#import <ParseUI/ParseUI.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MZFormSheetController/MZFormSheetSegue.h>
#import "LocationDetailViewController.h"
#import "CreateReviewViewModel.h"
#import "Review.h"
#import "CreateLocationViewModel.h"
#import "LocationDetail.h"
#import "HalalGuideNumberFormatter.h"
#import "LocationPicture.h"
#import "ReviewCell.h"
#import "ReviewDetailViewModel.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "UIView+Extensions.h"
#import "HalalGuideOnboarding.h"
#import "SlideShowViewController.h"
#import "UIViewController+Extension.h"

@implementation LocationDetailViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [LocationDetailViewModel instance].reviewDelegate = self;
    [LocationDetailViewModel instance].pictureDelegate = self;

    self.navigationItem.title = [LocationDetailViewModel instance].location.name;
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {

    if ([identifier isEqualToString:@"CreateLocation"] || [identifier isEqualToString:@"CreateReview"]) {

        if (![[LocationDetailViewModel instance] isAuthenticated]) {

            [[LocationDetailViewModel instance] authenticate:self onCompletion:^(BOOL succeeded, NSError *error) {

                if (!error) {
                    [self performSegueWithIdentifier:identifier sender:self];
                }
            }];
            return false;
        } else {
            return true;
        }
    } else {
        return true;
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    [super prepareForSegue:segue sender:sender];

    if ([segue.identifier isEqualToString:@"CreateReview"]) {
        [CreateReviewViewModel instance].reviewedLocation = [LocationDetailViewModel instance].location;
    }
    else if ([segue.identifier isEqualToString:@"ReviewDetails"]) {
        NSIndexPath *selected = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
        Review *review = [[[LocationDetailViewModel instance] reviews] objectAtIndex:selected.item];
        [ReviewDetailViewModel instance].review = review;
    }

    else if ([segue.identifier isEqualToString:@"SlideShow"]) {
        MZFormSheetSegue *formSheetSegue = (MZFormSheetSegue *) segue;
        MZFormSheetController *formSheet = formSheetSegue.formSheetController;

        formSheet.portraitTopInset = 6;
        formSheet.cornerRadius = 6;
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        formSheet.presentedFormSheetSize = CGSizeMake(screenSize.width * 0.95f, screenSize.height * 0.95f);
        formSheet.transitionStyle = MZFormSheetTransitionStyleFade;
    }

}

#pragma mark - Mail composer

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {

    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ImagePicker

- (void)finishedPickingImages {
    [super finishedPickingImages];

    [[LocationDetailViewModel instance] saveMultiplePictures:self.images forLocation:[LocationDetailViewModel instance].location showFeedback:true onCompletion:nil];
}

#pragma mark - CollectionView


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger reviews = [[[LocationDetailViewModel instance] reviews] count];
    if (reviews == 0) {
        return 1;
    } else {
        return reviews;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewCell *cell;
    if ([[[LocationDetailViewModel instance] reviews] count] > 0) {
        Review *review = [[[LocationDetailViewModel instance] reviews] objectAtIndex:indexPath.item];
        ReviewCell *reviewCell = (ReviewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:kReviewCellIdentifer forIndexPath:indexPath];
        [reviewCell configure:review];
        cell = reviewCell;
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"placeholder" forIndexPath:indexPath];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    UICollectionReusableView *reusableView = nil;

    if (kind == UICollectionElementKindSectionHeader) {

        //TODO Bad design
        self.headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@ "LocationDetail" forIndexPath:indexPath];

        Location *loc = [LocationDetailViewModel instance].location;

        self.headerView.carousel.type = iCarouselTypeCoverFlow2;
        self.headerView.carousel.delegate = self;
        self.headerView.carousel.dataSource = self;

        self.headerView.name.text = loc.name;
        self.headerView.address.text = [[NSString alloc] initWithFormat:@"%@ %@\n%@ %@", loc.addressRoad, loc.addressRoadNumber, loc.addressPostalCode, loc.addressCity];
        [self.headerView.address addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openMaps:)]];

        if (![[HalalGuideOnboarding instance] wasOnBoardingShow:kDiningDetailAddressTelephoneOptionsOnBoardingKey]) {
            [self.headerView.address showOnBoardingWithHintKey:kDiningDetailAddressTelephoneOptionsOnBoardingKey withDelegate:nil];
        }

        self.headerView.distance.text = [[HalalGuideNumberFormatter instance] stringFromNumber:loc.distance];

        self.headerView.rating.starImage = [UIImage imageNamed:@"starSmall"];
        self.headerView.rating.displayMode = EDStarRatingDisplayHalf;
        self.headerView.rating.starHighlightedImage = [UIImage imageNamed:@"starSmallSelected"];
        self.headerView.rating.rating = 0;

        if ([[LocationDetailViewModel instance].location.locationType isEqualToNumber:@(LocationTypeDining)]) {
            self.headerView.category.text = [loc categoriesString];
            [self.headerView.porkImage configureViewForLocation:loc];
            [self.headerView.alcoholImage configureViewForLocation:loc];
            [self.headerView.halalImage configureViewForLocation:loc];
            [self.headerView.porkLabel configureViewForLocation:loc];
            [self.headerView.alcoholLabel configureViewForLocation:loc];
            [self.headerView.halalLabel configureViewForLocation:loc];
        } else {

            if ([[LocationDetailViewModel instance].location.locationType isEqualToNumber:@(LocationTypeMosque)]) {
                self.headerView.halalLabel.text = NSLocalizedString(LanguageString([[LocationDetailViewModel instance].location.language integerValue]), nil);
                self.headerView.halalImage.image = [UIImage imageNamed:LanguageString([[LocationDetailViewModel instance].location.language integerValue])];
            } else {
                [self.headerView.halalLabel removeFromSuperview];
                [self.headerView.halalImage removeFromSuperview];
            }

            [self.headerView.category removeFromSuperview];
            [self.headerView.porkLabel removeFromSuperview];
            [self.headerView.porkImage removeFromSuperview];
            [self.headerView.alcoholImage removeFromSuperview];
            [self.headerView.alcoholLabel removeFromSuperview];

        }

        __weak typeof(self) weakSelf = self;

        [self.headerView.addPicture handleControlEvents:UIControlEventTouchUpInside withBlock:^(UIButton *weakSender) {
            [[LocationDetailViewModel instance] getPicture:weakSelf];
        }];
        [self.headerView.report handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
            [[LocationDetailViewModel instance] report:weakSelf];
        }];

        reusableView = self.headerView;
    }

    return reusableView;
}

//TODO Select whether to call restaurant or open in maps
- (void)openMaps:(UITapGestureRecognizer *)recognizer {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"addPicture", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    if ([LocationDetailViewModel instance].location.addressRoad) {
        UIAlertAction *directions = [UIAlertAction actionWithTitle:NSLocalizedString(@"directions", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            PFGeoPoint *point = [[LocationDetailViewModel instance].location point];
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(point.latitude, point.longitude) addressDictionary:nil];
            MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
            [mapItem setName:[LocationDetailViewModel instance].location.name];

            // Set the directions mode to "Driving"
            // Can use MKLaunchOptionsDirectionsModeWalking instead
            NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};

            // Get the "Current User Location" MKMapItem
            MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];

            // Pass the current location and destination map items to the Maps app
            // Set the direction mode in the launchOptions dictionary
            [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem] launchOptions:launchOptions];
        }];
        [alertController addAction:directions];
    }
    if ([LocationDetailViewModel instance].location.telephone) {
        UIAlertAction *call = [UIAlertAction actionWithTitle:NSLocalizedString(@"call", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

            NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", [LocationDetailViewModel instance].location.telephone]];

            if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
                [[UIApplication sharedApplication] openURL:phoneUrl];
            } else {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"warning", nil) message:NSLocalizedString(@"callNotAvaileble", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil, nil] show];
            }

        }];
        [alertController addAction:call];
    }
    if ([LocationDetailViewModel instance].location.homePage && [[LocationDetailViewModel instance].location.homePage length] > 0) {
        UIAlertAction *homepage = [UIAlertAction actionWithTitle:NSLocalizedString(@"homepage", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //TODO Add http if missing
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [LocationDetailViewModel instance].location.homePage]];
            [[UIApplication sharedApplication] openURL:url];
        }];
        [alertController addAction:homepage];
    }

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"regret", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:cancel];

    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - CollectionView - Pictures

- (void)reloadCollectionView {
    if ([[LocationDetailViewModel instance].locationPictures count] == 0) {
        self.headerView.noPicturesLabel.hidden = false;
    } else {
        self.headerView.noPicturesLabel.hidden = true;
        [self.headerView.carousel reloadData];
    }
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return [[LocationDetailViewModel instance].locationPictures count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {


    LocationPicture *picture = [[LocationDetailViewModel instance] pictureForRow:index];

    if (view == nil) {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 180.0f, 180.0f)];
        view.contentMode = UIViewContentModeScaleAspectFit;
    }
    //TODO Adjust frame so that portrait and landspace pictures are both max height

    [(UIImageView *) view setImageWithURL:[[NSURL alloc] initWithString:picture.picture.url] placeholderImage:[UIImage imageNamed:@"dining"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    return view;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {

    [LocationDetailViewModel instance].indexOfSelectedImage = index;

    [self performSegueWithIdentifier:@"SlideShow" sender:self];
}

- (void)reloadCollectionView:(NSUInteger)oldItemsCount insertNewItems:(NSUInteger)newItemsCount {

    self.headerView.rating.rating = [[[LocationDetailViewModel instance] averageRating] floatValue];

    [self.collectionView performBatchUpdates:^{

        NSMutableArray *arrayWithIndexPathsDelete = [NSMutableArray array];
        NSMutableArray *arrayWithIndexPathsInsert = [NSMutableArray array];

        //If empty we have a placeholder we need to remove
        if (oldItemsCount == 0) {
            [arrayWithIndexPathsDelete addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
        } else {
            for (int item = 0; item < oldItemsCount; item++) {
                [arrayWithIndexPathsDelete addObject:[NSIndexPath indexPathForRow:item inSection:0]];
            }
        }

        [self.collectionView deleteItemsAtIndexPaths:arrayWithIndexPathsDelete];

        if (newItemsCount == 0) {
            [arrayWithIndexPathsInsert addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
        } else {
            for (int i = 0; i < newItemsCount; i++) {
                [arrayWithIndexPathsInsert addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
        }

        [self.collectionView insertItemsAtIndexPaths:arrayWithIndexPathsInsert];

    }                             completion:nil];

}


@end
