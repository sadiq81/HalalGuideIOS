//
// Created by Privat on 13/03/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <CTAssetsPickerController/CTAssetsPickerController.h>
#import <ALActionBlocks/UIBarButtonItem+ALActionBlocks.h>
#import <sys/select.h>
#import "HGImagePickerController.h"
#import "Masonry.h"
#import "HGImagePickerView.h"
#import "POPBasicAnimation.h"
#import "POPAnimatableProperty+Masonry.h"
#import "HGPictureCollectionViewCell.h"
#import "ReactiveCocoa/ReactiveCocoa.h"

#define kImagePickerViewBottomOffset 234.0
#define kImagePickerViewAnimationDuration 0.5

@interface HGImagePickerController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, CTAssetsPickerControllerDelegate>

@property(strong, nonatomic) NSArray *pictures;
@property(strong, nonatomic) NSArray *selected;
@property(strong, nonatomic) UIToolbar *toolbar;
@property(strong, nonatomic) UIView *blockingView;
@property(strong, nonatomic) HGImagePickerView *imagePickerView;
@property(strong, nonatomic) UICollectionView *collectionView;
@property(strong, nonatomic) HGBaseViewModel *viewModel;

@property(strong, nonatomic) MASConstraint *imagePickerViewBottom;


@end

@implementation HGImagePickerController {

}

- (instancetype)initWithViewModel:(HGBaseViewModel *)viewModel {
    self = [super init];
    if (self) {

        self.viewModel = viewModel;
        [self setupViews];
        [self setupViewModel];
        [self setupToolbar];
        [self setupCollectionView];
        [self updateViewConstraints];

    }

    return self;
}


+ (instancetype)controllerWithViewModel:(HGBaseViewModel *)viewModel {
    return [[self alloc] initWithViewModel:viewModel];
}

- (void)setupViews {

    self.view.backgroundColor = [UIColor whiteColor];

    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.toolbar];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0.0f;
    layout.minimumLineSpacing = 0.0f;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:self.collectionView];

    self.blockingView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.blockingView.backgroundColor = [UIColor clearColor];

    self.imagePickerView = [[HGImagePickerView alloc] initWithFrame:CGRectZero];
    [self.blockingView addSubview:self.imagePickerView];

}

- (void)dismissImagePickerView {

    POPBasicAnimation *bottomOffsetAnimation = [POPBasicAnimation new];
    bottomOffsetAnimation.toValue = @(kImagePickerViewBottomOffset);
    bottomOffsetAnimation.property = [POPAnimatableProperty mas_offsetProperty];
    bottomOffsetAnimation.duration = kImagePickerViewAnimationDuration;
    [self.imagePickerViewBottom pop_addAnimation:bottomOffsetAnimation forKey:@"offset"];

    [UIView animateWithDuration:kImagePickerViewAnimationDuration animations:^{
        self.blockingView.backgroundColor = [UIColor clearColor];
        [self.view layoutIfNeeded];
    }                completion:^(BOOL finished) {
        [self.blockingView removeFromSuperview];
    }];

    [self.imagePickerView clearSelected];

    [self.collectionView reloadData];
}

- (void)showImagePickerView {

    [UIView animateWithDuration:kImagePickerViewAnimationDuration animations:^{
        [[[UIApplication sharedApplication] delegate].window addSubview:self.blockingView];
        self.blockingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        [self.view layoutIfNeeded];
    }];

    POPBasicAnimation *bottomOffsetAnimation = [POPBasicAnimation new];
    bottomOffsetAnimation.toValue = @(0);
    bottomOffsetAnimation.property = [POPAnimatableProperty mas_offsetProperty];
    bottomOffsetAnimation.duration = kImagePickerViewAnimationDuration;
    [self.imagePickerViewBottom pop_addAnimation:bottomOffsetAnimation forKey:@"offset"];
}

- (void)deleteSelected {
    NSArray *selected = [self.collectionView indexPathsForSelectedItems];
    NSMutableIndexSet *indexSet = [NSMutableIndexSet new];
    for (NSIndexPath *indexPath in selected) {
        [indexSet addIndex:indexPath.item];
    }
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:self.pictures];
    [temp removeObjectsAtIndexes:indexSet];
    self.pictures = temp;
    [self.collectionView deleteItemsAtIndexPaths:selected];
    self.selected = [NSArray new];
}

- (void)setupViewModel {

    [self.imagePickerView.firstAction handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
        if (self.imagePickerView.selectedItems.firstObject) {
            self.pictures = [self.pictures arrayByAddingObjectsFromArray:self.imagePickerView.selectedItems];
            [self dismissImagePickerView];
        } else {
            CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
            picker.delegate = self;
            [[[UIApplication sharedApplication] delegate].window sendSubviewToBack:self.blockingView];
            [self presentViewController:picker animated:YES completion:nil];
        }
    }];

    [self.imagePickerView.secondAction handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [[[UIApplication sharedApplication] delegate].window sendSubviewToBack:self.blockingView];
        [self presentViewController:picker animated:YES completion:NULL];
    }];

    [self.imagePickerView.thirdAction handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
        [self dismissImagePickerView];
    }];
}

- (void)setupToolbar {
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UIBarButtonImage.Camera"] style:UIBarButtonItemStylePlain target:self action:@selector(showImagePickerView)];
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *delete = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UIBarButtonImage.Trash"] style:UIBarButtonItemStylePlain target:self action:@selector(deleteSelected)];
    RAC(delete, enabled) = [RACObserve(self, selected) map:^id(NSArray *selected) {
        return @([selected count] > 0);
    }];

    [self.toolbar setItems:@[add, flexibleItem, delete]];
}

- (void)setupCollectionView {

    self.pictures = [NSArray new];
    self.selected = [NSArray new];

    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[HGPictureCollectionViewCell class] forCellWithReuseIdentifier:@"HGPictureCollectionViewCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.allowsMultipleSelection = true;

}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.pictures count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HGPictureCollectionViewCell *cell = (HGPictureCollectionViewCell *) [self.collectionView dequeueReusableCellWithReuseIdentifier:@"HGPictureCollectionViewCell" forIndexPath:indexPath];
    cell.imageView.image = [self.pictures objectAtIndex:indexPath.item];
    [cell setChosen:cell.isSelected animated:false];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];
    HGPictureCollectionViewCell *cell = (HGPictureCollectionViewCell *) [self.collectionView cellForItemAtIndexPath:indexPath];
    [cell setChosen:true animated:true];
    self.selected = [collectionView indexPathsForSelectedItems];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];
    HGPictureCollectionViewCell *cell = (HGPictureCollectionViewCell *) [self.collectionView cellForItemAtIndexPath:indexPath];
    [cell setChosen:false animated:true];
    self.selected = [collectionView indexPathsForSelectedItems];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float edge = floorf((CGRectGetWidth(self.view.frame) / 3));
    return CGSizeMake(edge, edge);
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];

    self.pictures = [self.pictures arrayByAddingObject:chosenImage];
    [self.collectionView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    NSMutableArray *temp = [NSMutableArray new];
    for (ALAsset *asset in assets) {
        [temp addObject:[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage]];
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
    self.pictures = [self.pictures arrayByAddingObjectsFromArray:temp];
    [self.collectionView reloadData];
}

- (void)updateViewConstraints {

    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.self.top.equalTo(self.view);
        make.self.bottom.equalTo(self.toolbar.mas_top);
        make.right.equalTo(self.view);
        make.left.equalTo(self.view);
    }];

    [self.toolbar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(@(44));
    }];

    [self.imagePickerView mas_updateConstraints:^(MASConstraintMaker *make) {
        self.imagePickerViewBottom = make.bottom.equalTo(self.blockingView).offset(kImagePickerViewBottomOffset);
        make.left.equalTo(self.blockingView);
        make.right.equalTo(self.blockingView);
    }];

    [super updateViewConstraints];
}
@end