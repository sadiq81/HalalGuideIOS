//
// Created by Privat on 11/03/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <UIActivityIndicator-for-SDWebImage/UIImageView+UIActivityIndicatorForSDWebImage.h>
#import "HGLocationDetailsPictureView.h"
#import "ReactiveCocoa.h"
#import "Masonry.h"

@interface HGLocationDetailsPictureView ()<iCarouselDataSource, iCarouselDelegate>

@property(strong) UIButton *report;
@property(strong) UIButton *addReview;
@property(strong) UIButton *addPicture;
@property(strong) iCarousel *pictures;
@property(strong, nonatomic) UILabel *noPicturesLabel;

@property(strong) LocationDetailViewModel *viewModel;

- (instancetype)initWithViewModel:(LocationDetailViewModel *)viewModel;

+ (instancetype)viewWithViewModel:(LocationDetailViewModel *)viewModel;
@end

@implementation HGLocationDetailsPictureView {

}

- (instancetype)initWithViewModel:(LocationDetailViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
        [self setupViews];
        [self setupViewModel];
    }

    return self;
}

+ (instancetype)viewWithViewModel:(LocationDetailViewModel *)viewModel {
    return [[self alloc] initWithViewModel:viewModel];
}

- (void)setupViews {
    self.report = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.report setTitle:NSLocalizedString(@"LocationDetailViewController.button.report", nil) forState:UIControlStateNormal];
    [self addSubview:self.report];

    self.pictures = [[iCarousel alloc] initWithFrame:CGRectZero];
    self.pictures.type = iCarouselTypeCoverFlow2;
    self.pictures.delegate = self;
    self.pictures.dataSource = self;
    self.pictures.clipsToBounds = true;
    [self addSubview:self.pictures];

    self.addReview = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.addReview setTitle:NSLocalizedString(@"LocationDetailViewController.button.add.review", nil) forState:UIControlStateNormal];
    [self addSubview:self.addReview];

    self.addPicture = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.addPicture setTitle:NSLocalizedString(@"LocationDetailViewController.button.add.picture", nil) forState:UIControlStateNormal];
    [self addSubview:self.addPicture];

    self.noPicturesLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.noPicturesLabel.text = NSLocalizedString(@"HGLocationDetailsPictureView.label.no.pictures", nil);
    self.noPicturesLabel.numberOfLines =0;
    self.noPicturesLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.noPicturesLabel];
}

- (void)setupViewModel {

    @weakify(self)
    RACSignal *pictures = RACObserve(self.viewModel, locationPictures);

    [pictures subscribeNext:^(NSArray *locations) {
        @strongify(self)
        [self.pictures reloadData];
    }];

    RAC(self.noPicturesLabel, hidden) = [pictures map:^(NSArray *pictures) {
        return @([pictures count]);
    }];

}

#pragma mark - CollectionView - Pictures

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return [self.viewModel.locationPictures count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {

    LocationPicture *picture = [self.viewModel.locationPictures objectAtIndex:index];

    if (view == nil) {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 180.0f, 180.0f)];
        view.contentMode = UIViewContentModeScaleAspectFit;
    }
    //TODO Adjust frame so that portrait and landspace pictures are both max height

    [(UIImageView *) view setImageWithURL:[[NSURL alloc] initWithString:picture.mediumPicture.url] placeholderImage:[UIImage imageNamed:@"dining"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    return view;
}

- (void)updateConstraints {

    self.translatesAutoresizingMaskIntoConstraints = false;

    [self.report mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@(30));
    }];

    [self.pictures mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.report.mas_bottom);
        make.left.equalTo(self).offset(8);
        make.right.equalTo(self).offset(-8);
        make.height.equalTo(@(200));
    }];

    [self.noPicturesLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.pictures);
        make.centerY.equalTo(self.pictures);
        make.left.equalTo(self).offset(8);
        make.right.equalTo(self).offset(-8);
    }];

    [self.addReview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pictures.mas_bottom);
        make.left.equalTo(self);
        make.right.equalTo(self.mas_centerX);
        make.height.equalTo(@(30));
        make.bottom.equalTo(self);
    }];

    [self.addPicture mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pictures.mas_bottom);
        make.left.equalTo(self.mas_centerX);
        make.right.equalTo(self);
        make.height.equalTo(@(30));
        make.bottom.equalTo(self);
    }];

    [super updateConstraints];
}


@end