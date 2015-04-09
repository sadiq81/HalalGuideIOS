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
#import "HGCategoriesViewController.h"
#import "HGCreateLocationViewModel.h"
#import "MZFormSheetSegue.h"
#import "IQUIView+Hierarchy.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "HGOnboarding.h"
#import "UIViewController+Extension.h"
#import "JSBadgeView.h"
#import "HGCreateReviewViewController.h"
#import "NSTimer+Block.h"
#import "SevenSwitch.h"
#import "HGOpeningsHoursViewController.h"
#import "HGFilterSwitchView.h"
#import "HGCategoriesView.h"
#import "HGCreateSwitchView.h"
#import "UITextField+HGTextFieldStyling.h"
#import <ALActionBlocks/UIBarButtonItem+ALActionBlocks.h>
#import <Masonry/View+MASAdditions.h>

@interface HGCreateLocationViewController () <UINavigationControllerDelegate, HTAutocompleteDataSource, UITextFieldDelegate>

@property(strong, nonatomic) UIScrollView *scrollView;
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

@property(strong, nonatomic) HGCreateLocationViewModel *viewModel;

@end

@implementation HGCreateLocationViewController {
    IQKeyboardReturnKeyHandler *returnKeyHandler;
    NSUInteger index; //Index of show picture
    NSTimer *timer; //Used for imageslideshow
    JSBadgeView *badgeView;
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
    [self setupNavigationBar];
    [self setupViewModel];
    [self setupIQKeyboardReturnKeyHandler];
    [self updateViewConstraints];
}


- (void)setupViews {

    self.view.backgroundColor = [UIColor whiteColor];

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.scrollView];

    self.pickImage = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.pickImage setImage:[UIImage imageNamed:@"HGCreateLocationViewController.button.pick.image"] forState:UIControlStateNormal];
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

- (void)setupViewModel {

    [self.viewModel loadAddressesNearPositionOnCompletion:nil];

    @weakify(self)
    [[self.pickImage rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        //@strongify(self)
        //[self.viewModel getPictures:self];
    }];

    [[self.road rac_signalForControlEvents:UIControlEventEditingDidEnd] subscribeNext:^(id x) {
        @strongify(self)
        Postnummer *postnummer = [self.viewModel postalCodeFor:self.road.text];
        if (postnummer) {
            [self.postalCode insertText:postnummer.nr];
            [self.city insertText:postnummer.navn];
        }
    }];

    [[self.postalCode rac_signalForControlEvents:UIControlEventEditingDidEnd] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel cityNameFor:self.postalCode.text onCompletion:^(Postnummer *postnummer) {
            if (postnummer) {
                [self.city insertText:postnummer.navn];
            }
        }];
    }];


    [[RACObserve(self.viewModel, progress) skip:1] subscribeNext:^(NSNumber *progress) {
        if (progress.intValue != 0 && progress.intValue != 100) {
            if ([SVProgressHUD isVisible]) {
                [SVProgressHUD setStatus:[self percentageString:progress.floatValue]];
            } else {
                [SVProgressHUD showWithStatus:[self percentageString:progress.floatValue] maskType:SVProgressHUDMaskTypeBlack];
            }
        } else if (progress.intValue == 100) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"imagesSaved", nil)];
        } else {
            [SVProgressHUD dismiss];
        }
    }];

    [RACObserve(self.viewModel, saving) subscribeNext:^(NSNumber *saving) {
        if (saving.boolValue) {
            [SVProgressHUD showWithStatus:NSLocalizedString(@"savingToTheCloud", nil) maskType:SVProgressHUDMaskTypeBlack];
        } else {
            [SVProgressHUD dismiss];
        }
    }];

    [[RACObserve(self.viewModel, error) throttle:0.5] subscribeNext:^(NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"error", nil)];
        }
    }];

    [[RACObserve(self.viewModel, createdLocation) skip:1] subscribeNext:^(HGLocation *location) {
        if (!self.viewModel.error && location.objectId) {
            [self performSegueWithIdentifier:@"OpeningHours" sender:self];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self onBoarding];
}

- (void)setupIQKeyboardReturnKeyHandler {
    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
}

- (void)onBoarding {
    if (![[HGOnboarding instance] wasOnBoardingShow:kCreateLocationPickImageOnBoardingKey]) {
        [self displayHintForView:self.pickImage withHintKey:kCreateLocationPickImageOnBoardingKey preferedPositionOfText:HintPositionAbove];
    }
}

- (void)setupNavigationBar {
    @weakify(self)
    [self.regret setBlock:^(id weakSender) {
        @strongify(self)
        [self.presentingViewController dismissViewControllerAnimated:true completion:nil];
    }];


    [self.save setBlock:^(id weakSender) {
        @strongify(self)
//        [self.viewModel saveEntity:self.name.text road:self.road.text roadNumber:self.roadNumber.text postalCode:self.postalCode.text city:self.city.text telephone:self.telephone.text website:self.website.text pork:self.porkSwitch.on alcohol:self.alcoholSwitch.on nonHalal:self.halalSwitch.on images:self.images];
    }];

    RAC(self.save, enabled) = [RACSignal combineLatest:@[self.name.rac_textSignal, self.road.rac_textSignal, self.roadNumber.rac_textSignal, self.postalCode.rac_textSignal, self.city.rac_textSignal]
                                                reduce:^(NSString *name, NSString *road, NSString *roadNumber, NSString *postalCode, NSString *city) {
                                                    return @((name.length > 0) && (road.length > 0) && (roadNumber.length > 0) && (postalCode.length > 0) && (city.length > 0));
                                                }];
}

- (void)finishedPickingImages {
//   [super finishedPickingImages];
//
//    [badgeView removeFromSuperview];
//
//    NSUInteger count = [self.images count];
//    if (count > 0) {
//        badgeView = [[JSBadgeView alloc] initWithParentView:self.pickImage alignment:JSBadgeViewAlignmentTopRight];
//        badgeView.badgeText = [NSString stringWithFormat:@"%d", (int) count];
//    }
//    @weakify(self)
//    timer = [NSTimer scheduledTimerWithTimeInterval:2 repeats:true block:^{
//        @strongify(self)
//        index++;
//        if (index >= [self.images count]) {
//            index = 0;
//        }
//        [self.pickImage setImage:[self.images objectAtIndex:index] forState:UIControlStateNormal];
//    }];
}

#pragma mark - AutoComplete

- (NSString *)textField:(HTAutocompleteTextField *)textField completionForPrefix:(NSString *)prefix ignoreCase:(BOOL)ignoreCase {

    NSArray *suggestions;

    if (textField == self.road) {
        suggestions = [self.viewModel streetNameForPrefix:prefix];
    } else if (textField == self.roadNumber) {
        suggestions = [self.viewModel streetNumbersFor:self.road.text];
    }

    NSString *suggestion = [suggestions linq_firstOrNil];

    if (suggestion && [suggestion length] > [prefix length]) {
        return [suggestion substringFromIndex:[prefix length]];
    } else {
        return @"";
    }

}

#pragma mark - Navigation

/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"chooseCategories"]) {
        HGCategoriesViewController *destination = (HGCategoriesViewController *) segue.destinationViewController;
        destination.locationType = self.viewModel.locationType;
        destination.viewModel = self.viewModel;

        MZFormSheetSegue *formSheetSegue = (MZFormSheetSegue *) segue;
        MZFormSheetController *formSheet = formSheetSegue.formSheetController;
        formSheet.presentedFormSheetSize = CGSizeMake(self.view.size.width * 0.8, self.view.size.height * 0.8);
        formSheet.transitionStyle = MZFormSheetTransitionStyleBounce;
        formSheet.cornerRadius = 8.0;
        formSheet.shouldDismissOnBackgroundViewTap = YES;
        formSheet.didDismissCompletionHandler = ^(UIViewController *presentedFSViewController) {
            [self setUILabels];
        };
    } else if ([segue.identifier isEqualToString:@"OpeningHours"]) {
        HGOpeningsHoursViewController *viewController = (HGOpeningsHoursViewController *) segue.destinationViewController;
        viewController.viewModel = self.viewModel;
    }
}*/

- (void)updateViewConstraints {

    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
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
    returnKeyHandler = nil;
    [timer invalidate];
}

@end
