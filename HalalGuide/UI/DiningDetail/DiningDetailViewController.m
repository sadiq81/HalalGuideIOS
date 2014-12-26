//
//  DiningDetailViewController.m
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ALActionBlocks/UIControl+ALActionBlocks.h>
#import <UIAlertController+Blocks/UIAlertController+Blocks.h>
#import <ParseUI/ParseUI.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "DiningDetailViewController.h"
#import "CreateReviewViewModel.h"
#import "Review.h"
#import "CreateDiningViewModel.h"
#import "DiningDetailTopView.h"
#import "HalalGuideNumberFormatter.h"
#import "LocationPicture.h"
#import "ReviewCell.h"
#import "ReviewDetailViewModel.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "UIView+Extensions.h"
#import "HalalGuideOnboarding.h"

//TODO Onboarding - Tap for call/directions
@implementation DiningDetailViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [DiningDetailViewModel instance].reviewDelegate = self;
    [DiningDetailViewModel instance].pictureDelegate = self;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    [super prepareForSegue:segue sender:sender];

    if ([segue.identifier isEqualToString:@"CreateReview"]) {
        [CreateReviewViewModel instance].reviewedLocation = [DiningDetailViewModel instance].location;
    }
    else if ([segue.identifier isEqualToString:@"ReviewDetails"]) {
        NSIndexPath *selected = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
        Review *review = [[[DiningDetailViewModel instance] reviews] objectAtIndex:selected.item];
        [ReviewDetailViewModel instance].review = review;
    }

}

#pragma mark - Mail composer

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {

    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ImagePicker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    [self.parentViewController dismissViewControllerAnimated:true completion:nil];

    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];

    //TODO Ugly hack, fix with TODO below
    [CreateDiningViewModel instance].createdLocation = [DiningDetailViewModel instance].location;
    [[CreateDiningViewModel instance] savePicture:image onCompletion:^(CreateEntityResult result) {
        [CreateDiningViewModel instance].createdLocation = nil;
        //TODO Error handling like CreateDiningViewController, share code somehow
    }];
}

#pragma mark - CollectionView


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger reviews = [[[DiningDetailViewModel instance] reviews] count];
    if (reviews == 0) {
        return 1;
    } else {
        return reviews;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewCell *cell;
    if ([[[DiningDetailViewModel instance] reviews] count] > 0) {
        Review *review = [[[DiningDetailViewModel instance] reviews] objectAtIndex:indexPath.item];
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
        self.headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@ "DiningDetailTopView" forIndexPath:indexPath];

        Location *loc = [DiningDetailViewModel instance].location;

        self.headerView.carousel.type = iCarouselTypeCoverFlow2;
        //headerView.carousel.delegate = self;
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

        self.headerView.category.text = [loc categoriesString];
        [self.headerView.porkImage configureViewForLocation:loc];
        [self.headerView.alcoholImage configureViewForLocation:loc];
        [self.headerView.halalImage configureViewForLocation:loc];
        [self.headerView.porkLabel configureViewForLocation:loc];
        [self.headerView.alcoholLabel configureViewForLocation:loc];
        [self.headerView.halalLabel configureViewForLocation:loc];

        __weak typeof(self) weakSelf = self;
        [self.headerView.addPicture handleControlEvents:UIControlEventTouchUpInside withBlock:^(UIButton *weakSender) {
            [[DiningDetailViewModel instance] getPicture:weakSelf withDelegate:weakSelf];
        }];
        [self.headerView.report handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
            [[DiningDetailViewModel instance] report:weakSelf];
        }];

        reusableView = self.headerView;
    }

    return reusableView;
}

//TODO Select whether to call restaurant or open in maps
- (void)openMaps:(UITapGestureRecognizer *)recognizer {


    [UIAlertController showAlertInViewController:self withTitle:NSLocalizedString(@"action", nil)
                                         message:nil
                               cancelButtonTitle:NSLocalizedString(@"regret", nil)
                          destructiveButtonTitle:nil
                               otherButtonTitles:@[NSLocalizedString(@"directions", nil), [DiningDetailViewModel instance].location.telephone ? NSLocalizedString(@"call", nil): nil]

                                        tapBlock:^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex) {
                                            if (buttonIndex == UIAlertControllerBlocksFirstOtherButtonIndex) {
                                                PFGeoPoint *point = [[DiningDetailViewModel instance].location point];
                                                MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(point.latitude, point.longitude) addressDictionary:nil];
                                                MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
                                                [mapItem setName:[DiningDetailViewModel instance].location.name];

                                                // Set the directions mode to "Driving"
                                                // Can use MKLaunchOptionsDirectionsModeWalking instead
                                                NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};

                                                // Get the "Current User Location" MKMapItem
                                                MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];

                                                // Pass the current location and destination map items to the Maps app
                                                // Set the direction mode in the launchOptions dictionary
                                                [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem] launchOptions:launchOptions];
                                            }
                                            else if (buttonIndex == 3) {

                                                NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", [DiningDetailViewModel instance].location.telephone]];

                                                if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
                                                    [[UIApplication sharedApplication] openURL:phoneUrl];
                                                } else {
                                                    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"warning", nil) message:NSLocalizedString(@"callNotAvaileble", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil, nil] show];
                                                }
                                            }
                                        }];
}

#pragma mark - CollectionView - Pictures

- (void)reloadCollectionView {
    if ([[DiningDetailViewModel instance].locationPictures count] == 0) {
        self.headerView.noPicturesLabel.hidden = false;
    } else {
        self.headerView.noPicturesLabel.hidden = true;
        [self.headerView.carousel reloadData];
    }
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return [[DiningDetailViewModel instance].locationPictures count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {

    UIImageView *temp;
    LocationPicture *picture = [[DiningDetailViewModel instance] pictureForRow:index];

    if (view == nil) {
        view = temp = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 180.0f, 180.0f)];
        temp.contentMode = UIViewContentModeScaleAspectFit;
    }
    //TODO Adjust frame so that portrait and landspace pictures are both max height

    [temp setImageWithURL:[[NSURL alloc] initWithString:picture.picture.url] placeholderImage:[UIImage imageNamed:@"dining"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    return view;
}


- (void)reloadCollectionView:(NSUInteger)oldItemsCount insertNewItems:(NSUInteger)newItemsCount {

    self.headerView.rating.rating = [[[DiningDetailViewModel instance] averageRating] floatValue];

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
