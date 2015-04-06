//
//  CreateLocationViewController.m
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ALActionBlocks/UIControl+ALActionBlocks.h>
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "CreateLocationViewController.h"
#import "CategoriesViewController.h"
#import "CreateLocationViewModel.h"
#import "MZFormSheetSegue.h"
#import "IQUIView+Hierarchy.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "HGOnboarding.h"
#import "UIViewController+Extension.h"
#import "JSBadgeView.h"
#import "CreateReviewViewController.h"
#import "NSTimer+Block.h"
#import "SevenSwitch.h"
#import "OpeningsHoursViewController.h"
#import <ALActionBlocks/UIBarButtonItem+ALActionBlocks.h>

@implementation CreateLocationViewController {
    IQKeyboardReturnKeyHandler *returnKeyHandler;
    NSUInteger index; //Index of show picture
    NSTimer *timer; //Used for imageslideshow
    JSBadgeView *badgeView;
}

@synthesize viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupIQKeyboardReturnKeyHandler];

    [self setupEvents];

    [self setupUI];

    [self setupLocationType];


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

- (void)setupLocationType {

    if (self.viewModel.locationType != LocationTypeDining) {
        [self.diningSwitches removeFromSuperview];
        self.categoriesView.frame = CGRectMake(self.categoriesView.x, self.website.y + self.website.height + 8, self.categoriesView.width, self.categoriesView.height);
    }

    if (self.viewModel.locationType == LocationTypeMosque) {
        [self.reset removeFromSuperview];
        self.categoriesCount.text = @"";
        self.categoriesText.text = NSLocalizedString(@"language", nil);
    }
}

- (void)setupUI {

    @throw @"not yet localized";
    self.porkSwitch.offLabel.text = self.alcoholSwitch.offLabel.text = self.halalSwitch.offLabel.text = NSLocalizedString(@"no", nil);
    self.porkSwitch.onLabel.text = self.alcoholSwitch.onLabel.text = self.halalSwitch.onLabel.text = NSLocalizedString(@"yes", nil);
    self.porkSwitch.onTintColor = self.alcoholSwitch.onTintColor = self.halalSwitch.onTintColor = [UIColor redColor];
    self.porkSwitch.inactiveColor = self.alcoholSwitch.inactiveColor = self.halalSwitch.inactiveColor = [UIColor greenColor];

    self.road.autocompleteDataSource = self;
    self.roadNumber.autocompleteDataSource = self;
}

- (void)setupEvents {

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

    [[self.porkSwitch rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        @strongify(self)
        self.porkImage.image = [UIImage imageNamed:self.porkSwitch.on ? @"PigTrue" : @"PigFalse"];
    }];

    [[self.alcoholSwitch rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        @strongify(self)
        self.alcoholImage.image = [UIImage imageNamed:self.alcoholSwitch.on ? @"AlcoholTrue" : @"AlcoholFalse"];
    }];


    [[self.halalSwitch rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        @strongify(self)
        self.halalImage.image = [UIImage imageNamed:self.halalSwitch.on ? @"NonHalalTrue" : @"NonHalalFalse"];
    }];

    [[self.reset rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel.categories removeAllObjects];
        [self setUILabels];
    }];

    [self.regret setBlock:^(id weakSender) {
        @strongify(self)
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }];

    [[RACSignal combineLatest:@[self.name.rac_textSignal, self.road.rac_textSignal, self.roadNumber.rac_textSignal, self.postalCode.rac_textSignal, self.city.rac_textSignal]
                       reduce:^(NSString *name, NSString *road, NSString *roadNumber, NSString *postalCode, NSString *city) {
                           return @((name.length > 0) && (road.length > 0) && (roadNumber.length > 0) && (postalCode.length > 0) && (city.length > 0));
                       }] subscribeNext:^(NSNumber *enabled) {
        @strongify(self)
        self.save.enabled = enabled.boolValue;
    }];

    [self.save setBlock:^(id weakSender) {
        //@strongify(self)
//        [self.viewModel saveEntity:self.name.text road:self.road.text roadNumber:self.roadNumber.text postalCode:self.postalCode.text city:self.city.text telephone:self.telephone.text website:self.website.text pork:self.porkSwitch.on alcohol:self.alcoholSwitch.on nonHalal:self.halalSwitch.on images:self.images];
    }];

    [[RACObserve(self.viewModel, createdLocation) skip:1] subscribeNext:^(Location *location) {
        if (!self.viewModel.error && location.objectId) {
            [self performSegueWithIdentifier:@"OpeningHours" sender:self];
        }
    }];

    [[RACObserve(self.viewModel, progress) skip:1] subscribeNext:^(NSNumber *progress) {
        if (progress.intValue != 0 && progress.intValue != 100) {
            if ([SVProgressHUD isVisible]){
                [SVProgressHUD setStatus:[self percentageString:progress.floatValue]];
            } else{
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

#pragma mark UIUpdates

- (void)setUILabels {

    switch (self.viewModel.locationType) {
        case LocationTypeDining: {
            int count = (int) [self.viewModel.categories count];
            self.categoriesCount.text = [NSString stringWithFormat:@"%i", count];
            break;
        };
        case LocationTypeShop: {
            int count = (int) [self.viewModel.shopCategories count];
            self.categoriesCount.text = [NSString stringWithFormat:@"%i", count];
            break;
        };
        case LocationTypeMosque: {
            self.categoriesCount.text = NSLocalizedString(LanguageString(self.viewModel.language), nil);
            break;
        };
    }
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

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {

    if (textField == self.name) {
        [self.road becomeFirstResponder];
        return false;
    } else if (textField == self.road) {
        [self.roadNumber becomeFirstResponder];
        return false;
    } else if (textField == self.roadNumber) {
        [self.postalCode becomeFirstResponder];
        return false;
    } else if (textField == self.postalCode) {
        [self.city becomeFirstResponder];
        return false;
    } else if (textField == self.telephone) {
        [self.website becomeFirstResponder];
        return false;
    } else {
        return true;
    }
}

#pragma mark - Navigation

/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"chooseCategories"]) {
        CategoriesViewController *destination = (CategoriesViewController *) segue.destinationViewController;
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
        OpeningsHoursViewController *viewController = (OpeningsHoursViewController *) segue.destinationViewController;
        viewController.viewModel = self.viewModel;
    }
}*/

- (void)dealloc {
    returnKeyHandler = nil;
    [timer invalidate];
}

@end
