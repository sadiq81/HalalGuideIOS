//
//  HGCreateReviewViewController.m
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ALActionBlocks/UIBarButtonItem+ALActionBlocks.h>
#import <Masonry/View+MASAdditions.h>
#import "HGCreateReviewViewController.h"
#import "HGLocationViewController.h"
#import "HGReview.h"
#import "HGPictureCollectionViewCell.h"
#import "HGReviewPictureCell.h"
#import "HGColor.h"
#import "UIImage+Overlay.h"

@interface HGCreateReviewViewController () <EDStarRatingProtocol, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, HGImagePickerControllerDelegate>

@property(strong, nonatomic) EDStarRating *rating;
@property(strong, nonatomic) SZTextView *review;
@property(strong, nonatomic) UIBarButtonItem *save;

@property(strong, nonatomic) UIButton *addPictures;

@property(strong, nonatomic) UICollectionViewFlowLayout *layout;
@property(strong, nonatomic) UICollectionView *images;

@property(strong, nonatomic) HGCreateReviewViewModel *viewModel;

@end

@implementation HGCreateReviewViewController

- (instancetype)initWithViewModel:(HGCreateReviewViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }

    return self;
}


+ (instancetype)controllerWithViewModel:(HGCreateReviewViewModel *)viewModel {
    return [[self alloc] initWithViewModel:viewModel];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"HGCreateReviewViewController.button.regret", nil) style:UIBarButtonItemStylePlain block:^(id weakReference) {
        [self.presentingViewController dismissViewControllerAnimated:true completion:nil];
    }];
    self.navigationItem.rightBarButtonItem = self.save = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"HGCreateReviewViewController.button.save", nil) style:UIBarButtonItemStylePlain block:^(id weakReference) {
        [self.viewModel saveReview];
    }];

    [self setupViews];
    [self setupViewModel];
    [self setupRating];
    [self setupReview];
    [self setupCollectionView];
    [self updateViewConstraints];
}


- (void)setupViews {

    self.screenName = @"Create review";

    self.view.backgroundColor = [UIColor whiteColor];

    self.rating = [[EDStarRating alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.rating];

    self.review = [[SZTextView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.review];

    self.layout = [[UICollectionViewFlowLayout alloc] init];
    self.layout.minimumInteritemSpacing = 0.0f;
    self.layout.minimumLineSpacing = 0.0f;

    self.images = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    [self.view addSubview:self.images];


    self.addPictures = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.addPictures setTitle:NSLocalizedString(@"HGCreateReviewViewController.button.add.picture", nil) forState:UIControlStateNormal];
    [self.addPictures setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.addPictures.layer.cornerRadius = 5;
    self.addPictures.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.addPictures.layer.borderWidth = 0.5;
    [self.view addSubview:self.addPictures];

}


- (void)setupViewModel {

    [[RACObserve(self.viewModel, progress) skip:1] subscribeNext:^(NSNumber *progress) {
        if (progress.intValue == 1) {
            [SVProgressHUD showWithStatus:NSLocalizedString(@"HGCreateLocationViewController.hud.saving", nil) maskType:SVProgressHUDMaskTypeBlack];
        }
        else if (progress.intValue > 1 && progress.intValue < 99) {
            if ([SVProgressHUD isVisible]) {
                [SVProgressHUD setStatus:[self percentageString:progress.floatValue]];
            } else {
                [SVProgressHUD showWithStatus:[self percentageString:progress.floatValue] maskType:SVProgressHUDMaskTypeBlack];
            }
        } else if (progress.intValue == 100){
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"HGCreateReviewViewController.hud.saved", nil)];
        }
    }];

    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:SVProgressHUDDidDisappearNotification object:nil] takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(NSNotification *notification) {
        NSString *hudText = [[notification userInfo] valueForKey:SVProgressHUDStatusUserInfoKey];
        if ([hudText isEqualToString:NSLocalizedString(@"HGCreateReviewViewController.hud.saved", nil)]) {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }];

    [[RACObserve(self.viewModel, error) throttle:0.5] subscribeNext:^(NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"HGCreateReviewViewController.hud.error", nil)];
        }
    }];

    RACSignal *review = [RACSignal merge:@[[self.review rac_textSignal], RACObserve(self.review, text)]];
    RACSignal *rating = RACObserve(self.rating, rating);

    //TODO is this MVVM?
    RAC(self.viewModel, reviewText) = review;
    RAC(self.viewModel, rating) = rating;

    RAC(self.save, enabled) = [RACSignal combineLatest:@[review, rating] reduce:^(NSString *reviewText, NSNumber *rating) {
        return @([reviewText length] >= 30 && rating.integerValue > 0);
    }];

    RAC(self.addPictures, hidden) = [[RACObserve(self.viewModel, images) ignore:nil] map:^id(NSArray *value) {
        return @([value count]);
    }];

    @weakify(self)
    [[self.addPictures rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self getPictures:5 viewModel:self.viewModel WithDelegate:self];
    }];


}

- (void)setupRating {

    self.rating.starImage = [[UIImage imageNamed:@"HGCreateReviewViewController.star.selected"] imageWithColor:[UIColor blackColor]];
    self.rating.starHighlightedImage = [[UIImage imageNamed:@"HGCreateReviewViewController.star.selected"] imageWithColor:[HGColor greenTintColor]];
    self.rating.maxRating = 5;
    self.rating.backgroundColor = [UIColor whiteColor];
    self.rating.delegate = self;
    self.rating.horizontalMargin = 12;
    self.rating.editable = YES;
    self.rating.rating = 1;
    self.rating.displayMode = EDStarRatingDisplayFull;

}

- (void)setupReview {
    self.review.placeholder = NSLocalizedString(@"HGCreateReviewViewController.textview.placeholder", nil);

    self.review.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.review.layer.borderWidth = 0.5;
    self.review.layer.cornerRadius = 5;
    self.review.clipsToBounds = true;
}

- (void)setupCollectionView {

    self.images.delegate = self;
    self.images.dataSource = self;

    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    self.images.backgroundColor = [UIColor clearColor];
    [self.images registerClass:[HGReviewPictureCell class] forCellWithReuseIdentifier:@"HGReviewPictureCell"];

}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel.images count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HGReviewPictureCell *cell = (HGReviewPictureCell *) [self.images dequeueReusableCellWithReuseIdentifier:@"HGReviewPictureCell" forIndexPath:indexPath];
    cell.imageView.image = [self.viewModel.images objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.viewModel.images];
    [array removeObjectAtIndex:indexPath.item];
    self.viewModel.images = array;
    [collectionView deleteItemsAtIndexPaths:@[indexPath]];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}

- (void)HGImagePickerControllerDidCancel:(HGImagePickerController *)controller {
    [controller dismissViewControllerAnimated:true completion:nil];

}

- (void)HGImagePickerControllerDidConfirm:(HGImagePickerController *)controller pictures:(NSArray *)pictures {
    [controller dismissViewControllerAnimated:true completion:^{
        self.viewModel.images = pictures;
        [self.images reloadData];
    }];
}


#define kStandardOffsetToEdges 8

- (void)updateViewConstraints {

    [self.rating mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kStandardOffsetToEdges);
        make.left.equalTo(self.view).offset(kStandardOffsetToEdges);
        make.right.equalTo(self.view).offset(-kStandardOffsetToEdges);
        make.height.equalTo(@(50));
    }];

    [self.review mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rating.mas_bottom).offset(kStandardOffsetToEdges);
        make.left.equalTo(self.view).offset(kStandardOffsetToEdges);
        make.right.equalTo(self.view).offset(-kStandardOffsetToEdges);
        make.bottom.equalTo(self.view).offset(-116);
    }];

    [self.addPictures mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.review.mas_bottom).offset(kStandardOffsetToEdges);
        make.left.equalTo(self.view).offset(kStandardOffsetToEdges);
        make.right.equalTo(self.view).offset(-kStandardOffsetToEdges);
        make.bottom.equalTo(self.view).offset(-kStandardOffsetToEdges);
    }];

    [self.images mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.review.mas_bottom).offset(kStandardOffsetToEdges);
        make.left.equalTo(self.view).offset(kStandardOffsetToEdges);
        make.right.equalTo(self.view).offset(-kStandardOffsetToEdges);
        make.bottom.equalTo(self.view).offset(-kStandardOffsetToEdges);
    }];

    [super updateViewConstraints];
}


@end
