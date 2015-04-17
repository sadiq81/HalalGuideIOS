//
// Created by Privat on 11/03/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <UIActivityIndicator-for-SDWebImage/UIImageView+UIActivityIndicatorForSDWebImage.h>
#import "HGLocationDetailsPictureView.h"
#import "ReactiveCocoa.h"
#import "Masonry.h"
#import "HGSmileyCell.h"
#import "HGSmiley.h"
#import "UIView+HGBorders.h"

@interface HGLocationDetailsPictureView () <iCarouselDataSource, iCarouselDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate>

@property(strong, nonatomic) UIButton *report;
@property(strong, nonatomic) UIButton *addReview;
@property(strong, nonatomic) UIButton *addPicture;
@property(strong, nonatomic) iCarousel *pictures;

@property(strong, nonatomic) UICollectionView *smileys;
@property(strong, nonatomic) UICollectionViewFlowLayout *layout;
@property(strong, nonatomic) UILabel *noSmileysLabel;

@property(strong, nonatomic) UILabel *noPicturesLabel;

@property(strong) HGLocationDetailViewModel *viewModel;

- (instancetype)initWithViewModel:(HGLocationDetailViewModel *)viewModel;

+ (instancetype)viewWithViewModel:(HGLocationDetailViewModel *)viewModel;
@end

@implementation HGLocationDetailsPictureView {

}

- (instancetype)initWithViewModel:(HGLocationDetailViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
        [self setupViews];
        [self setupCollectionView];
        [self setupViewModel];
    }

    return self;
}

+ (instancetype)viewWithViewModel:(HGLocationDetailViewModel *)viewModel {
    return [[self alloc] initWithViewModel:viewModel];
}

- (void)setupViews {
    self.report = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.report setTitle:NSLocalizedString(@"HGLocationDetailsPictureView.button.report", nil) forState:UIControlStateNormal];
    [self addSubview:self.report];

    self.pictures = [[iCarousel alloc] initWithFrame:CGRectZero];
    self.pictures.type = iCarouselTypeCoverFlow2;
    self.pictures.delegate = self;
    self.pictures.dataSource = self;
    self.pictures.clipsToBounds = true;
    [self addSubview:self.pictures];

    self.addReview = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.addReview setTitle:NSLocalizedString(@"HGLocationDetailsPictureView.button.add.review", nil) forState:UIControlStateNormal];
    [self addSubview:self.addReview];

    self.addPicture = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.addPicture setTitle:NSLocalizedString(@"HGLocationDetailsPictureView.button.add.picture", nil) forState:UIControlStateNormal];
    [self addSubview:self.addPicture];

    self.noPicturesLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.noPicturesLabel.text = NSLocalizedString(@"HGLocationDetailsPictureView.label.no.pictures", nil);
    self.noPicturesLabel.numberOfLines = 0;
    self.noPicturesLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.noPicturesLabel];

    self.layout = [[UICollectionViewFlowLayout alloc] init];
    self.layout.minimumInteritemSpacing = 0.0f;
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    self.smileys = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    self.smileys.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.smileys.layer.borderWidth = 0.5;
    [self addSubview:self.smileys];

    self.noSmileysLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.noSmileysLabel.text = NSLocalizedString(@"HGLocationDetailsPictureView.label.no.smiley", nil);
    self.noSmileysLabel.numberOfLines = 0;
    self.noSmileysLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.noSmileysLabel];
}

- (void)setupViewModel {

    @weakify(self)
    RACSignal *pictures = RACObserve(self.viewModel, locationPictures);
    RAC(self.noPicturesLabel, hidden) = [pictures map:^(NSArray *pictures) {
        return @([pictures count]);
    }];
    [pictures subscribeNext:^(NSArray *locations) {
        @strongify(self)
        [self.pictures reloadData];
    }];

    RACSignal *smileysSignal = RACObserve(self.viewModel, smileys);
    RAC(self.noSmileysLabel, hidden) = [smileysSignal map:^(NSArray *smileys) {
        return @([smileys count]);
    }];
    [smileysSignal subscribeNext:^(NSArray *smileys) {
        @strongify(self)
        [self.smileys reloadData];
    }];

}


#pragma mark - CollectionView - Smiley

- (void)setupCollectionView {

    [self.smileys registerClass:[HGSmileyCell class] forCellWithReuseIdentifier:@"HGSmileyCell"];
    self.smileys.delegate = self;
    self.smileys.dataSource = self;

    self.smileys.backgroundColor = [UIColor whiteColor];
    self.smileys.bounces = YES;
    [self.smileys setShowsHorizontalScrollIndicator:YES];
    [self.smileys setShowsVerticalScrollIndicator:NO];

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel.smileys count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HGSmileyCell *cell = [self.smileys dequeueReusableCellWithReuseIdentifier:@"HGSmileyCell" forIndexPath:indexPath];
    [cell configureForSmiley:[self.viewModel.smileys objectAtIndex:indexPath.row]];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(76, 76);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.smileys deselectItemAtIndexPath:indexPath animated:true];
    HGSmileyCell *cell = (HGSmileyCell *) [self.smileys cellForItemAtIndexPath:indexPath];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"HGLocationDetailsPictureView.alert.smiley.warning", nil) message:NSLocalizedString(@"HGLocationDetailsPictureView.alert.smiley.message", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"HGLocationDetailViewController.alert.ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", cell.smiley.report]];
        [[UIApplication sharedApplication] openURL:url];
    }];
    [alertController addAction:ok];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"HGLocationDetailViewController.alert.regret", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:cancel];
    id rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        rootViewController = [((UINavigationController *) rootViewController).viewControllers objectAtIndex:0];
    }
    [rootViewController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - CollectionView - Pictures

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return [self.viewModel.locationPictures count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {

    HGLocationPicture *picture = [self.viewModel.locationPictures objectAtIndex:index];

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
        make.bottom.equalTo(self.smileys.mas_top);
    }];

    [self.addPicture mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pictures.mas_bottom);
        make.left.equalTo(self.mas_centerX);
        make.right.equalTo(self);
        make.height.equalTo(@(30));
        make.bottom.equalTo(self.smileys.mas_top);
    }];

    [self.smileys mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addPicture.mas_bottom);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];

    [self.noSmileysLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.smileys);
        make.centerY.equalTo(self.smileys);
        make.left.equalTo(self).offset(8);
        make.right.equalTo(self).offset(-8);
    }];


    [super updateConstraints];
}


@end