//
// Created by Privat on 13/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "HGReviewDetailViewController.h"
#import "HGLocationDetailViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/View+MASAdditions.h>
#import "HGPictureCollectionViewCell.h"
#import "NSString+Extensions.h"

#define kHeaderHeight 250
#define kStandardOffsetToEdges 8
#define kReviewElementsHeight 21
#define kReviewHeight 100
#define kSubmitterImageSides 128

@interface HGReviewDetailViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(strong, nonatomic) UIView *headerView;
@property(strong, nonatomic) AsyncImageView *submitterImage;
@property(strong, nonatomic) UILabel *submitterName;
@property(strong, nonatomic) EDStarRating *rating;
@property(strong, nonatomic) UITextView *review;
@property(strong, nonatomic) UILabel *date;

@property(strong, nonatomic) UICollectionViewFlowLayout *layout;
@property(strong, nonatomic) UICollectionView *images;

@property(strong, nonatomic) HGReviewDetailViewModel *viewModel;

@end


@implementation HGReviewDetailViewController {

}

- (instancetype)initWithViewModel:(HGReviewDetailViewModel *)model {
    self = [super init];
    if (self) {
        self.viewModel = model;
        [self setupViews];
        [self setupRating];
        [self setupViewModel];
        [self setupCollectionView];
        [self updateViewConstraints];

        [PFAnalytics trackEvent:@"ReviewDetailView" dimensions:@{@"Review" :self.viewModel.review.objectId}];
    }

    return self;
}

+ (instancetype)controllerWithViewModel:(HGReviewDetailViewModel *)model {
    return [[self alloc] initWithViewModel:model];
}


- (void)setupViews {

    self.screenName = @"Review detail";

    self.view.backgroundColor = [UIColor whiteColor];

    self.layout = [[UICollectionViewFlowLayout alloc] init];
    self.layout.minimumInteritemSpacing = 0.0f;
    self.layout.minimumLineSpacing = 0.0f;

    self.images = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    [self.view addSubview:self.images];

    self.headerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.images addSubview:self.headerView];

    self.submitterImage = [[AsyncImageView alloc] initWithFrame:CGRectZero];
    [self.headerView addSubview:self.submitterImage];

    self.submitterName = [[UILabel alloc] initWithFrame:CGRectZero];
    self.submitterName.adjustsFontSizeToFitWidth = true;
    self.submitterName.minimumScaleFactor = 0.5;
    [self.headerView addSubview:self.submitterName];

    self.date = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.headerView addSubview:self.date];

    self.rating = [[EDStarRating alloc] initWithFrame:CGRectZero];
    [self.headerView addSubview:self.rating];

    self.review = [[UITextView alloc] initWithFrame:CGRectZero];
    self.review.editable = false;
    [self.review sizeToFit];
    [self.headerView addSubview:self.review];


}

- (void)setupRating {

    self.rating.starImage = [UIImage imageNamed:@"HGReviewDetailViewController.star.unselected"];
    self.rating.starHighlightedImage = [UIImage imageNamed:@"HGReviewDetailViewController.star.selected"];
    self.rating.backgroundColor = [UIColor whiteColor];
}

- (void)setupViewModel {

    RAC(self.submitterName, text) = RACObserve(self, viewModel.submitterName);
    RAC(self.submitterImage, imageURL) = RACObserve(self, viewModel.submitterImageLarge);

    RAC(self.date, text) = RACObserve(self, viewModel.date);

    RAC(self.review, text) = RACObserve(self, viewModel.reviewText);
    RAC(self.rating, rating) = RACObserve(self, viewModel.rating);

    [[RACObserve(self, viewModel.reviewImages) ignore:nil] subscribeNext:^(NSArray *images) {
        [self.images reloadData];
    }];
}

- (void)setupCollectionView {
    self.images.delegate = self;
    self.images.dataSource = self;

    self.images.backgroundColor = [UIColor clearColor];
    [self.images registerClass:[HGPictureCollectionViewCell class] forCellWithReuseIdentifier:@"HGPictureCollectionViewCell"];

    self.images.contentInset = UIEdgeInsetsMake(kHeaderHeight, 0, 0, 0);
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel.reviewImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HGPictureCollectionViewCell *cell = (HGPictureCollectionViewCell *) [self.images dequeueReusableCellWithReuseIdentifier:@"HGPictureCollectionViewCell" forIndexPath:indexPath];
    HGLocationPicture *locationPicture = self.viewModel.reviewImages[(NSUInteger) indexPath.item];
    cell.imageView.imageURL = locationPicture.picture.url.toURL;
    [cell setChosen:cell.isSelected animated:false];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float edge = floorf((CGRectGetWidth(self.view.frame) / 2));
    return CGSizeMake(edge, edge);
}

- (void)updateViewConstraints {

    [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.images).offset(-kHeaderHeight);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@kHeaderHeight);
    }];

    [self.submitterImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView).offset(kStandardOffsetToEdges);
        make.left.equalTo(self.headerView).offset(kStandardOffsetToEdges);
        make.width.equalTo(@(kSubmitterImageSides));
        make.height.equalTo(@(kSubmitterImageSides));
    }];

    [self.submitterName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView).offset(kStandardOffsetToEdges);
        make.left.equalTo(self.submitterImage.mas_right).offset(kStandardOffsetToEdges);
        make.right.equalTo(self.headerView).offset(-kStandardOffsetToEdges);
        make.height.equalTo(@(kReviewElementsHeight));
    }];

    [self.date mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.submitterName.mas_bottom).offset(4);
        make.left.equalTo(self.submitterImage.mas_right).offset(kStandardOffsetToEdges);
        make.right.equalTo(self.headerView).offset(-kStandardOffsetToEdges);
        make.height.equalTo(@(kReviewElementsHeight));
    }];

    [self.rating mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.submitterImage.mas_right).offset(kStandardOffsetToEdges);
        make.right.equalTo(self.headerView).offset(-kStandardOffsetToEdges);
        make.bottom.equalTo(self.submitterImage);
        make.height.equalTo(@(kReviewElementsHeight));
    }];

    [self.review mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.submitterImage.mas_bottom).offset(kStandardOffsetToEdges);
        make.left.equalTo(self.headerView).offset(kStandardOffsetToEdges);
        make.right.equalTo(self.headerView).offset(-kStandardOffsetToEdges);
        make.height.equalTo(@(kReviewHeight));
    }];

    [self.images mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

    [super updateViewConstraints];
}


@end