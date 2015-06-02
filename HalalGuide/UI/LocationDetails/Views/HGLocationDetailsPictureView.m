//
// Created by Privat on 11/03/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <AsyncImageView/AsyncImageView.h>
#import <ALActionBlocks/UIGestureRecognizer+ALActionBlocks.h>
#import "HGLocationDetailsPictureView.h"
#import "ReactiveCocoa.h"
#import "Masonry.h"
#import "HGSmileyCell.h"
#import "HGSmiley.h"
#import "UIView+HGBorders.h"
#import "UIImageView+AFNetworking.h"
#import "NSString+Extensions.h"
#import "UIView+FrameAdditions.h"

@interface HGLocationDetailsPictureView () <iCarouselDataSource, iCarouselDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property(strong) UIButton *report;
@property(strong) UIButton *addReview;
@property(strong) UIButton *addPicture;
@property(strong) iCarousel *pictures;

@property(strong, nonatomic) UICollectionView *smileys;
@property(strong, nonatomic) UICollectionViewFlowLayout *layout;
@property(strong, nonatomic) UILabel *noSmileysLabel;

@property(strong, nonatomic) UILabel *noPicturesLabel;

@property(strong) HGLocationDetailViewModel *viewModel;

- (instancetype)initWithViewModel:(HGLocationDetailViewModel *)viewModel;

+ (instancetype)viewWithViewModel:(HGLocationDetailViewModel *)viewModel;
@end

@implementation HGLocationDetailsPictureView {
    UIImageView *fullPictureView;
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
    self.report.layer.cornerRadius = 5;
    self.report.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.report.layer.borderWidth = 0.5;

    [self addSubview:self.report];

    self.pictures = [[iCarousel alloc] initWithFrame:CGRectZero];
    self.pictures.type = iCarouselTypeCoverFlow2;
    self.pictures.delegate = self;
    self.pictures.dataSource = self;
    self.pictures.decelerationRate = 0.0f;
    self.pictures.scrollSpeed = 0.5f;
    self.pictures.bounces = false;
    self.pictures.pagingEnabled = true;
    self.pictures.clipsToBounds = true;
    [self addSubview:self.pictures];

    self.addReview = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.addReview setTitle:NSLocalizedString(@"HGLocationDetailsPictureView.button.add.review", nil) forState:UIControlStateNormal];
    self.addReview.layer.cornerRadius = 5;
    self.addReview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.addReview.layer.borderWidth = 0.5;
    [self addSubview:self.addReview];

    self.addPicture = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.addPicture setTitle:NSLocalizedString(@"HGLocationDetailsPictureView.button.add.picture", nil) forState:UIControlStateNormal];
    self.addPicture.layer.cornerRadius = 5;
    self.addPicture.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.addPicture.layer.borderWidth = 0.5;
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
        return @true;//@([pictures count]);
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
    return 2;//[self.viewModel.locationPictures count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {

    //HGLocationPicture *picture = self.viewModel.locationPictures[index];

    if (view == nil) {
        view = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, 101.0f, 180.0f)];
        view.userInteractionEnabled = true;
        view.contentMode = UIViewContentModeScaleAspectFit;
    }
    //TODO Adjust frame so that portrait and landspace pictures are both max height
    //[((AsyncImageView *) view) setImageWithURL:[picture.mediumPicture.url toURL] placeholderImage:[UIImage imageNamed:@"dining"]];
    ((AsyncImageView *) view).image = [UIImage imageNamed:@"temp"];
    return view;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {

    UIWindow *window = [UIApplication sharedApplication].delegate.window;

    AsyncImageView *originalPictureView = (AsyncImageView *) [carousel itemViewAtIndex:index];
    CGRect frame = [originalPictureView convertRect:originalPictureView.bounds toView:window];

    UIScrollView *zoomView = [[UIScrollView alloc] initWithFrame:frame];
    zoomView.minimumZoomScale = 1;
    zoomView.maximumZoomScale = 6;
    zoomView.delegate = self;

    [window addSubview:zoomView];

    fullPictureView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(zoomView.frame), CGRectGetHeight(zoomView.frame))];
    fullPictureView.userInteractionEnabled = true;
    fullPictureView.clipsToBounds = true;
    fullPictureView.contentMode = UIViewContentModeScaleAspectFill;
    fullPictureView.image = originalPictureView.image;

    [zoomView addSubview:fullPictureView];

    [UIView animateWithDuration:1 animations:^{
        zoomView.frame = window.frame;
        fullPictureView.frame = CGRectInset(window.frame, 0, 80);
        zoomView.backgroundColor = [UIColor blackColor];
    }                completion:^(BOOL finished) {
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [closeButton setImage:[[UIImage imageNamed:@"HGLocationDetailsPictureView.button.close"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        closeButton.tintColor = [UIColor whiteColor];
        closeButton.frame = CGRectMake(fullPictureView.frame.size.width - 31 + 15, 20, 31, 31);
        [zoomView addSubview:closeButton];
    }];

    @weakify(zoomView)
    @weakify(originalPictureView)
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithBlock:^(id weakSender) {
        @strongify(zoomView)
        @strongify(originalPictureView)

        CGRect frame = [originalPictureView convertRect:originalPictureView.bounds toView:window];
        fullPictureView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        [UIView animateWithDuration:1
                         animations:^{
                             zoomView.frame = frame;
                             zoomView.alpha = 0;
                         } completion:^(BOOL finished) {
                    [((UIView *) zoomView) removeFromSuperview];
                }];

    }];
    [fullPictureView addGestureRecognizer:tapGestureRecognizer];


}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return fullPictureView;
}


- (void)updateConstraints {

    self.translatesAutoresizingMaskIntoConstraints = false;

    [self.report mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8);
        make.left.equalTo(self).offset(8);
        make.right.equalTo(self).offset(-8);
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
        make.left.equalTo(self).offset(8);
        make.right.equalTo(self.mas_centerX).offset(-8);
        make.height.equalTo(@(30));
    }];

    [self.addPicture mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pictures.mas_bottom);
        make.left.equalTo(self.mas_centerX).offset(8);
        make.right.equalTo(self).offset(-8);
        make.height.equalTo(@(30));
    }];

    [self.smileys mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addPicture.mas_bottom).offset(8);
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