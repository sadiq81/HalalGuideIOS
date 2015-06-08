//
//  HGCreateLocationViewController.m
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ALActionBlocks/UIControl+ALActionBlocks.h>
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "HGCreateLocationViewController.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "HGOnboarding.h"
#import "UIViewController+Extension.h"
#import "JSBadgeView.h"
#import "NSTimer+Block.h"
#import "HGOpeningsHoursViewController.h"
#import "HGCategoriesView.h"
#import "HGCreateSwitchView.h"
#import "UITextField+HGTextFieldStyling.h"
#import "KASlideShow.h"
#import "HGCategoriesViewController.h"
#import <ALActionBlocks/UIBarButtonItem+ALActionBlocks.h>
#import <Masonry/View+MASAdditions.h>
#import <MZFormSheetController/MZFormSheetController.h>
#import "UIAlertController+Blocks.m"
#import "HGReviewPictureCell.h"
#import "HGNewLocationPictureCell.h"

@interface HGCreateLocationViewController () <UINavigationControllerDelegate, HTAutocompleteDataSource, UITextFieldDelegate, HGImagePickerControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(strong, nonatomic) UIScrollView *scrollView;

@property(strong, nonatomic) UICollectionViewFlowLayout *layout;
@property(strong, nonatomic) UICollectionView *images;

@property(strong, nonatomic) UIButton *pickImage;
@property(strong, nonatomic) UITextField *name;
@property(strong, nonatomic) HTAutocompleteTextField *road;
@property(strong, nonatomic) HTAutocompleteTextField *roadNumber;
@property(strong, nonatomic) UITextField *postalCode;
@property(strong, nonatomic) UITextField *city;
@property(strong, nonatomic) UITextField *telephone;
@property(strong, nonatomic) UITextField *website;
@property(strong, nonatomic) HGCreateSwitchView *switchView;
@property(strong, nonatomic) HGCategoriesView *categoriesView;
@property(strong, nonatomic) UIBarButtonItem *regret;
@property(strong, nonatomic) UIBarButtonItem *save;
@property(strong, nonatomic) IQKeyboardReturnKeyHandler *returnKeyHandler;
@property(nonatomic) NSUInteger index;

@property(strong, nonatomic) HGCreateLocationViewModel *viewModel;

@end

@implementation HGCreateLocationViewController {

}

@synthesize viewModel;

- (instancetype)initWithViewModel:(HGCreateLocationViewModel *)model {
    self = [super init];
    if (self) {
        self.viewModel = model;
    }

    return self;
}

+ (instancetype)controllerWithViewModel:(HGCreateLocationViewModel *)model {
    return [[self alloc] initWithViewModel:model];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupViews];
    [self setupCollectionView];
    [self setupNavigationBar];
    [self setupViewModel];

    [self checkForExistingLocation];

    [self setupIQKeyboardReturnKeyHandler];
    [self updateViewConstraints];
}


- (void)setupViews {

    self.view.backgroundColor = [UIColor whiteColor];

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.scrollView];

    self.layout = [[UICollectionViewFlowLayout alloc] init];
    self.layout.minimumInteritemSpacing = 0.0f;
    self.layout.minimumLineSpacing = 0.0f;

    self.images = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    [self.scrollView addSubview:self.images];

    self.pickImage = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.pickImage setTitle:NSLocalizedString(@"HGCreateLocationViewController.button.add.picture", nil) forState:UIControlStateNormal];
    [self.pickImage setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.pickImage.layer.cornerRadius = 5;
    self.pickImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.pickImage.layer.borderWidth = 0.5;
    [self.scrollView addSubview:self.pickImage];

    self.name = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.name styleWithPlaceHolder:NSLocalizedString(@"HGCreateLocationViewController.placeholder.name", nil) andKeyBoardType:UIKeyboardTypeDefault andAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [self.scrollView addSubview:self.name];

    self.road = [[HTAutocompleteTextField alloc] initWithFrame:CGRectZero];
    [self.road styleWithPlaceHolder:NSLocalizedString(@"HGCreateLocationViewController.placeholder.road", nil) andKeyBoardType:UIKeyboardTypeDefault andAutocapitalizationType:UITextAutocapitalizationTypeWords];
    self.road.autocompleteDataSource = self;
    [self.scrollView addSubview:self.road];

    self.roadNumber = [[HTAutocompleteTextField alloc] initWithFrame:CGRectZero];
    [self.roadNumber styleWithPlaceHolder:NSLocalizedString(@"HGCreateLocationViewController.placeholder.road.number", nil) andKeyBoardType:UIKeyboardTypeDefault andAutocapitalizationType:UITextAutocapitalizationTypeWords];
    self.roadNumber.autocompleteDataSource = self;
    [self.scrollView addSubview:self.roadNumber];

    self.postalCode = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.postalCode styleWithPlaceHolder:NSLocalizedString(@"HGCreateLocationViewController.placeholder.postal.code", nil) andKeyBoardType:UIKeyboardTypeNumberPad andAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.scrollView addSubview:self.postalCode];

    self.city = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.city styleWithPlaceHolder:NSLocalizedString(@"HGCreateLocationViewController.placeholder.city", nil) andKeyBoardType:UIKeyboardTypeDefault andAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [self.scrollView addSubview:self.city];

    self.telephone = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.telephone styleWithPlaceHolder:NSLocalizedString(@"HGCreateLocationViewController.placeholder.telephone", nil) andKeyBoardType:UIKeyboardTypePhonePad andAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.scrollView addSubview:self.telephone];

    self.website = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.website styleWithPlaceHolder:NSLocalizedString(@"HGCreateLocationViewController.placeholder.website", nil) andKeyBoardType:UIKeyboardTypeURL andAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.scrollView addSubview:self.website];

    self.switchView = [[HGCreateSwitchView alloc] initWithViewModel:self.viewModel];
    [self.scrollView addSubview:self.switchView];

    self.categoriesView = [[HGCategoriesView alloc] initWithViewModel:self.viewModel];
    [self.scrollView addSubview:self.categoriesView];

    self.regret = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"HGCreateLocationViewController.button.regret", nil) style:UIBarButtonItemStylePlain block:nil];
    self.navigationItem.leftBarButtonItem = self.regret;

    self.save = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"HGCreateLocationViewController.button.save", nil) style:UIBarButtonItemStylePlain block:nil];
    self.navigationItem.rightBarButtonItem = self.save;
}

- (void)checkForExistingLocation {

    if (self.viewModel.existingLocation) {

        self.pickImage.hidden = true;

        self.name.text = self.viewModel.existingLocation.name;
        self.road.text = self.viewModel.existingLocation.addressRoad;
        self.roadNumber.text = self.viewModel.existingLocation.addressRoadNumber;
        self.postalCode.text = self.viewModel.existingLocation.addressPostalCode;
        self.telephone.text = self.viewModel.existingLocation.telephone;
        self.website.text = self.viewModel.existingLocation.homePage;

        self.switchView.halalSwitch.on = [self.viewModel.existingLocation.nonHalal boolValue];
        self.switchView.alcoholSwitch.on = [self.viewModel.existingLocation.alcohol boolValue];
        self.switchView.porkSwitch.on = [self.viewModel.existingLocation.pork boolValue];
        self.viewModel.categories = [[NSMutableArray alloc] initWithArray:self.viewModel.existingLocation.categories];
        [self.categoriesView setCountLabelText];
    }

}


- (void)setupViewModel {

    [self.viewModel loadAddressesNearPositionOnCompletion:nil];

    RAC(self.viewModel, name) = RACObserve(self, name.text);
    RAC(self.viewModel, road) = RACObserve(self, road.text);
    RAC(self.viewModel, roadNumber) = RACObserve(self, roadNumber.text);
    RAC(self.viewModel, postalCode) = RACObserve(self, postalCode.text);
    RAC(self.viewModel, city) = RACObserve(self, city.text);
    RAC(self.viewModel, website) = RACObserve(self, website.text);


    @weakify(self)
    [self.pickImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithBlock:^(id weakSender) {
        [self getPicturesWithDelegate:self viewModel:self.viewModel];
    }]];

    [[self.road rac_signalForControlEvents:UIControlEventEditingDidEnd] subscribeNext:^(id x) {
        @strongify(self)
        Postnummer *postnummer = [self.viewModel postalCodeForRoad];
        if (postnummer) {
            [self.postalCode insertText:postnummer.nr];
            [self.city insertText:postnummer.navn];
        }
    }];

    [[self.postalCode rac_signalForControlEvents:UIControlEventEditingDidEnd] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel cityNameForPostalCode:^(Postnummer *postNummer) {
            if (postNummer) {
                [self.city insertText:postNummer.navn];
            }
        }];
    }];


    [[RACObserve(self.viewModel, progress) skip:1] subscribeNext:^(NSNumber *progress) {
        if (progress.intValue == 1) {
            [SVProgressHUD showWithStatus:NSLocalizedString(@"HGCreateLocationViewController.hud.saving", nil) maskType:SVProgressHUDMaskTypeBlack];
        } else if (progress.intValue > 1 && progress.intValue < 100) {
            [SVProgressHUD showWithStatus:[self percentageString:progress.floatValue] maskType:SVProgressHUDMaskTypeBlack];
        } else if (progress.intValue == 100) {
            [SVProgressHUD dismiss];
            [UIAlertController showAlertInViewController:self withTitle:NSLocalizedString(@"HGCreateLocationViewController.alert.title.action", nil) message:NSLocalizedString(@"HGCreateLocationViewController.alert.message.location.saved", nil) cancelButtonTitle:NSLocalizedString(@"HGCreateLocationViewController.alert.cancel.done", nil) destructiveButtonTitle:nil otherButtonTitles:@[NSLocalizedString(@"HGCreateLocationViewController.alert.add.review", nil)] tapBlock:^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex) {
                if (UIAlertControllerBlocksCancelButtonIndex == buttonIndex) {
                    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                } else if (UIAlertControllerBlocksFirstOtherButtonIndex == buttonIndex) {
                    [self createReviewForLocation:self.viewModel.createdLocation viewModel:self.viewModel pushToStack:true];
                }
            }];
        }
    }];

    [[RACObserve(self.viewModel, error) throttle:0.5] subscribeNext:^(NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"HGCreateLocationViewController.hud.error", nil)];
        }
    }];

    [[self.categoriesView.choose rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)

        HGCategoriesViewController *viewController = [HGCategoriesViewController controllerWithViewModel:self.viewModel];
        MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:viewController];
        formSheet.presentedFSViewController.view.clipsToBounds = false;

        CGRect screenRect = [[UIScreen mainScreen] bounds];
        formSheet.presentedFormSheetSize = CGSizeMake(CGRectGetWidth(screenRect) * 0.8, CGRectGetHeight(screenRect) * 0.8);
        formSheet.transitionStyle = MZFormSheetTransitionStyleBounce;
        formSheet.cornerRadius = 8.0;
        formSheet.shouldDismissOnBackgroundViewTap = true;
        formSheet.didDismissCompletionHandler = ^(UIViewController *presentedFSViewController) {
            [self.categoriesView setCountLabelText];
        };
        [self mz_presentFormSheetController:formSheet animated:YES completionHandler:nil];
    }];

    RAC(self.pickImage, hidden) = [[RACObserve(self.viewModel, images) ignore:nil] map:^id(NSArray *value) {
        return @([value count]);
    }];
}

- (void)setupIQKeyboardReturnKeyHandler {
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
}

- (void)setupNavigationBar {
    @weakify(self)
    [self.regret setBlock:^(id weakSender) {
        @strongify(self)
        [self.presentingViewController dismissViewControllerAnimated:true completion:nil];
    }];


    [self.save setBlock:^(id weakSender) {
        @strongify(self)
        [self.viewModel saveLocation];
    }];

    RAC(self.save, enabled) = [RACSignal combineLatest:@[self.name.rac_textSignal, self.road.rac_textSignal, self.roadNumber.rac_textSignal, self.postalCode.rac_textSignal, self.city.rac_textSignal]
                                                reduce:^(NSString *name, NSString *road, NSString *roadNumber, NSString *postalCode, NSString *city) {
                                                    return @((name.length > 0) && (road.length > 0) && (roadNumber.length > 0) && (postalCode.length > 0) && (city.length > 0));
                                                }];
}

- (void)setupCollectionView {

    self.images.delegate = self;
    self.images.dataSource = self;

    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;

    self.images.backgroundColor = [UIColor clearColor];
    [self.images registerClass:[HGNewLocationPictureCell class] forCellWithReuseIdentifier:@"HGNewLocationPictureCell"];

}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel.images count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HGNewLocationPictureCell *cell = (HGNewLocationPictureCell *) [self.images dequeueReusableCellWithReuseIdentifier:@"HGNewLocationPictureCell" forIndexPath:indexPath];
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


#pragma mark - AutoComplete

- (NSString *)textField:(HTAutocompleteTextField *)textField completionForPrefix:(NSString *)prefix ignoreCase:(BOOL)ignoreCase {

    NSArray *suggestions;

    if (textField == self.road) {
        suggestions = [self.viewModel streetNameForPrefix:prefix];
    } else if (textField == self.roadNumber) {
        suggestions = [self.viewModel streetNumbersForRoad];
    }

    NSString *suggestion = [suggestions linq_firstOrNil];

    if (suggestion && [suggestion length] > [prefix length]) {
        return [suggestion substringFromIndex:[prefix length]];
    } else {
        return @"";
    }

}

#pragma mark - Navigation

- (void)HGImagePickerControllerDidCancel:(HGImagePickerController *)controller {
    [controller.presentingViewController dismissViewControllerAnimated:true completion:nil];
}

- (void)HGImagePickerControllerDidConfirm:(HGImagePickerController *)controller pictures:(NSArray *)pictures {
    [controller.presentingViewController dismissViewControllerAnimated:true completion:^{
        self.viewModel.images = pictures;
        [self.images reloadData];
    }];
}

- (void)updateViewConstraints {

    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [self.images mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(8);
        make.top.equalTo(self.scrollView).offset(8);
        make.width.equalTo(@(104));
        make.bottom.equalTo(self.website.mas_bottom);
    }];

    [self.pickImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(8);
        make.top.equalTo(self.scrollView).offset(8);
        make.width.equalTo(@(104));
        make.height.equalTo(@(104));
    }];

    [self.name mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(8);
        make.left.equalTo(self.scrollView).offset(120);
        make.right.equalTo(self.scrollView).offset(-8);
    }];

    [self.road mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name.mas_bottom).offset(8);
        make.left.equalTo(self.scrollView).offset(120);
        make.right.equalTo(self.roadNumber.mas_left).offset(-8);
        make.width.greaterThanOrEqualTo(@(130));
    }];

    [self.roadNumber mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name.mas_bottom).offset(8);
        make.left.equalTo(self.road.mas_right).offset(8);
        make.right.equalTo(self.view).offset(-8);
    }];

    [self.postalCode mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.road.mas_bottom).offset(8);
        make.left.equalTo(self.scrollView).offset(120);
        make.right.equalTo(self.view).offset(-8);
    }];

    [self.city mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.postalCode.mas_bottom).offset(8);
        make.left.equalTo(self.scrollView).offset(120);
        make.right.equalTo(self.view).offset(-8);
    }];

    [self.telephone mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.city.mas_bottom).offset(8);
        make.left.equalTo(self.scrollView).offset(120);
        make.right.equalTo(self.view).offset(-8);
    }];

    [self.website mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.telephone.mas_bottom).offset(8);
        make.left.equalTo(self.scrollView).offset(120);
        make.right.equalTo(self.view).offset(-8);
    }];


    [self.switchView mas_updateConstraints:^(MASConstraintMaker *make) {

        if (self.viewModel.locationType != LocationTypeDining) {
            make.top.equalTo(self.view.mas_bottom);
        } else {
            make.top.equalTo(self.website.mas_bottom).offset(8);
            make.left.equalTo(self.scrollView);
            make.right.equalTo(self.scrollView);
        }
    }];

    [self.categoriesView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.viewModel.locationType != LocationTypeDining) {
            make.top.equalTo(self.website.mas_bottom).offset(8);
            make.left.equalTo(self.scrollView);
            make.right.equalTo(self.scrollView);
            make.width.equalTo(self.scrollView);
        } else {
            make.top.equalTo(self.switchView.mas_bottom).offset(8);
            make.left.equalTo(self.scrollView);
            make.right.equalTo(self.scrollView);
            make.width.equalTo(self.scrollView);
        }
    }];

    [super updateViewConstraints];
}

- (void)dealloc {
    self.returnKeyHandler = nil;
}

@end
