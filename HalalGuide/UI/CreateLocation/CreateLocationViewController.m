//
//  CreateLocationViewController.m
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ALActionBlocks/UIControl+ALActionBlocks.h>
#import <ALActionBlocks/UIBarButtonItem+ALActionBlocks.h>
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "CreateLocationViewController.h"
#import "CategoriesViewController.h"
#import "CreateLocationViewModel.h"
#import "MZFormSheetSegue.h"
#import "IQUIView+Hierarchy.h"
#import "Adgangsadresse.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "CreateReviewViewModel.h"
#import "UIView+Extensions.h"
#import "HalalGuideOnboarding.h"
#import "UIViewController+Extension.h"
#import "JSBadgeView.h"
#import <EXTScope.h>
#import <UIAlertController+Blocks/UIAlertController+Blocks.h>

@implementation CreateLocationViewController {
    IQKeyboardReturnKeyHandler *returnKeyHandler;
    NSUInteger index; //Index of show picture
    NSTimer *timer; //Used for imageslideshow
    JSBadgeView *badgeView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[CreateLocationViewModel instance] reset];

    [CreateLocationViewModel instance].categories = [NSMutableArray new];

    [self setupIQKeyboardReturnKeyHandler];

    [self setupEvents];

    [self setupUI];

    [self setupLocationType];

    [self onBoarding];
}

- (void)setupIQKeyboardReturnKeyHandler {
    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
}

- (void)onBoarding {
    if (![[HalalGuideOnboarding instance] wasOnBoardingShow:kCreateLocationPickImageOnBoardingKey]) {
        #warning implement
    }
}

- (void)setupLocationType {

    if ([CreateLocationViewModel instance].locationType != LocationTypeDining) {
        [self.diningSwitches removeFromSuperview];
        self.categoriesView.frame = CGRectMake(self.categoriesView.x, self.website.y + self.website.height + 8, self.categoriesView.width, self.categoriesView.height);
    }

    if ([CreateLocationViewModel instance].locationType == LocationTypeMosque) {
        [self.reset removeFromSuperview];
        self.categoriesCount.text = @"";
        self.categoriesText.text = NSLocalizedString(@"language", nil);
    }
}

- (void)setupUI {

    index = 0;

    self.porkSwitch.offText = self.alcoholSwitch.offText = self.halalSwitch.offText = NSLocalizedString(@"no", nil);
    self.porkSwitch.onText = self.alcoholSwitch.onText = self.halalSwitch.onText = NSLocalizedString(@"yes", nil);
    self.porkSwitch.onTintColor = self.alcoholSwitch.onTintColor = self.halalSwitch.onTintColor = [UIColor redColor];

    self.road.autocompleteDataSource = self;
    self.roadNumber.autocompleteDataSource = self;


}

- (void)setupEvents {

    __weak typeof(self) weakSelf = self;

    [[CreateLocationViewModel instance] loadAddressesNearPositionOnCompletion:nil];

    [self.pickImage handleControlEvents:UIControlEventTouchUpInside withBlock:^(UIButton *weakSender) {
        [[CreateLocationViewModel instance] getPicture:weakSelf];
    }];

    [self.road handleControlEvents:UIControlEventEditingDidEnd withBlock:^(UITextField *weakSender) {
        Postnummer *postnummer = [[CreateLocationViewModel instance] postalCodeFor:weakSender.text];
        if (postnummer) {
            weakSelf.postalCode.text = postnummer.nr;
            weakSelf.city.text = postnummer.navn;
        }
    }];

    [self.postalCode handleControlEvents:UIControlEventEditingDidEnd withBlock:^(UITextField *weakSender) {
        [[CreateLocationViewModel instance] cityNameFor:weakSender.text onCompletion:^(Postnummer *postnummer) {
            if (postnummer) {
                weakSelf.city.text = postnummer.navn;
            }
        }];
    }];

    [self.porkSwitch handleControlEvents:UIControlEventValueChanged withBlock:^(UISwitch *weakSender) {
        weakSelf.porkImage.image = [UIImage imageNamed:weakSender.on ? @"PigTrue" : @"PigFalse"];
    }];

    [self.alcoholSwitch handleControlEvents:UIControlEventValueChanged withBlock:^(UISwitch *weakSender) {
        weakSelf.alcoholImage.image = [UIImage imageNamed:weakSender.on ? @"AlcoholTrue" : @"AlcoholFalse"];
    }];

    [self.halalSwitch handleControlEvents:UIControlEventValueChanged withBlock:^(UISwitch *weakSender) {
        weakSelf.halalImage.image = [UIImage imageNamed:weakSender.on ? @"NonHalalTrue" : @"NonHalalFalse"];
    }];

    [self.reset handleControlEvents:UIControlEventTouchUpInside withBlock:^(UIButton *weakSender) {
        [[CreateLocationViewModel instance].categories removeAllObjects];
        [weakSelf setUILabels];
    }];

    [self.regret setBlock:^(id weakSender) {
        [weakSelf.navigationController popViewControllerAnimated:true];
    }];

    @weakify(self)
    [self.save setBlock:^(id weakSender) {
        @strongify(self)

        if ([self areMandatoryFieldsFilledOut]) {
            [[CreateLocationViewModel instance] saveEntity:self.name.text
                                                      road:self.road.text
                                                roadNumber:self.roadNumber.text
                                                postalCode:self.postalCode.text
                                                      city:self.city.text
                                                 telephone:self.telephone.text
                                                   website:self.website.text
                                                      pork:self.porkSwitch.on
                                                   alcohol:self.alcoholSwitch.on
                                                  nonHalal:self.halalSwitch.on
                                                    images:self.images
                                              onCompletion:^(CreateEntityResult result) {

                                                  [self showDialog:result];

                                              }];
        }
    }];
}

- (void)showDialog:(CreateEntityResult)result {

    __weak typeof(self) weakSelf = self;

    switch (result) {
        case CreateEntityResultAddressDoesNotExist: {
            [UIAlertController showAlertInViewController:self withTitle:NSLocalizedString(@"GPSNotPreciseEnough", nil) message:nil cancelButtonTitle:NSLocalizedString(@"no", nil) destructiveButtonTitle:nil otherButtonTitles:@[NSLocalizedString(@"yes", nil)] tapBlock:^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex) {

                if (controller.firstOtherButtonIndex == buttonIndex) {
                    [[CreateLocationViewModel instance] findAddressByDescription:weakSelf.road.text roadNumber:weakSelf.roadNumber.text postalCode:weakSelf.postalCode.text onCompletion:^{
                        [CreateLocationViewModel instance].suggestionName = weakSelf.name.text;
                        [self performSegueWithIdentifier:@"ChooseGPSPoint" sender:weakSelf];
                    }];
                }
            }];
            break;
        }
        case CreateEntityResultCouldNotCreateEntityInDatabase: {
            [UIAlertController showAlertInViewController:self withTitle:NSLocalizedString(@"couldnotcreateindb", nil) message:nil cancelButtonTitle:NSLocalizedString(@"no", nil) destructiveButtonTitle:nil otherButtonTitles:@[NSLocalizedString(@"yes", nil)] tapBlock:^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex) {
                if (controller.cancelButtonIndex == buttonIndex) {
                    [self.navigationController popViewControllerAnimated:true];
                } else if (controller.firstOtherButtonIndex == buttonIndex) {
                    [[CreateLocationViewModel instance] saveEntity:self.name.text road:self.road.text roadNumber:self.roadNumber.text postalCode:self.postalCode.text city:self.city.text telephone:self.telephone.text website:self.website.text pork:self.porkSwitch.on alcohol:self.alcoholSwitch.on nonHalal:self.halalSwitch.on images:self.images onCompletion:^(CreateEntityResult result) {
                        [self showDialog:result];
                    }];
                }
            }];
            break;
        }
        case CreateEntityResultOk: {
            [self performSegueWithIdentifier:@"OpeningHours" sender:self];
            break;
        }
        case CreateEntityResultError: {
            //Not currently used
            break;
        }
    }
}

#pragma mark Saving

- (bool)areMandatoryFieldsFilledOut {

    bool complete = true;
    for (int i = 100; i < 105; i++) {
        UITextField *textField = (UITextField *) [self.scrollView viewWithTag:i];
        if ([textField.text length] == 0) {
            textField.layer.borderColor = [UIColor redColor].CGColor;
            textField.layer.borderWidth = 3;
            textField.layer.cornerRadius = 5;
            complete = false;
        } else {
            textField.layer.borderColor = [UIColor clearColor].CGColor;
            textField.layer.borderWidth = 0.5f;
            textField.layer.cornerRadius = 5;
        }

    }
    return complete;
}

- (void)finishedPickingImages {
    [super finishedPickingImages];

    [badgeView removeFromSuperview];

    NSUInteger count = [self.images count];
    if (count > 0) {
        badgeView = [[JSBadgeView alloc] initWithParentView:self.pickImage alignment:JSBadgeViewAlignmentTopRight];
        badgeView.badgeText = [NSString stringWithFormat:@"%d", (int) count];
    }
    [self startTimer];
}


#pragma mark - ImagePicker

- (void)startTimer {
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(updatePhoto) userInfo:nil repeats:YES];
    }
}

- (void)updatePhoto {
    index++;
    if (index >= [self.images count]) {
        index = 0;
    }
    [self.pickImage setImage:[self.images objectAtIndex:index] forState:UIControlStateNormal];

}

#pragma mark UIUpdates

- (void)setUILabels {
    if ([CreateLocationViewModel instance].locationType == LocationTypeDining) {
        int count = (int) [[CreateLocationViewModel instance].categories count];
        self.categoriesCount.text = [NSString stringWithFormat:@"%i", count];
    } else if ([CreateLocationViewModel instance].locationType == LocationTypeShop) {
        int count = (int) [[CreateLocationViewModel instance].shopCategories count];
        self.categoriesCount.text = [NSString stringWithFormat:@"%i", count];
    }
    else if ([CreateLocationViewModel instance].locationType == LocationTypeMosque) {
        self.categoriesCount.text = NSLocalizedString(LanguageString([CreateLocationViewModel instance].language), nil);
    }
}

#pragma mark - AutoComplete

- (NSString *)textField:(HTAutocompleteTextField *)textField completionForPrefix:(NSString *)prefix ignoreCase:(BOOL)ignoreCase {

    NSArray *suggestions;

    if (textField == self.road) {
        suggestions = [[CreateLocationViewModel instance] streetNameForPrefix:prefix];
    } else if (textField == self.roadNumber) {
        suggestions = [[CreateLocationViewModel instance] streetNumbersFor:self.road.text];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"chooseCategories"]) {
        CategoriesViewController *destination = (CategoriesViewController *) segue.destinationViewController;
        destination.locationType = [CreateLocationViewModel instance].locationType;
        destination.viewModel = [CreateLocationViewModel instance];

        MZFormSheetSegue *formSheetSegue = (MZFormSheetSegue *) segue;
        MZFormSheetController *formSheet = formSheetSegue.formSheetController;
        formSheet.presentedFormSheetSize = CGSizeMake(self.view.size.width * 0.8, self.view.size.height * 0.8);
        formSheet.transitionStyle = MZFormSheetTransitionStyleBounce;
        formSheet.cornerRadius = 8.0;
        formSheet.shouldDismissOnBackgroundViewTap = YES;
        formSheet.didDismissCompletionHandler = ^(UIViewController *presentedFSViewController) {
            [self setUILabels];
        };
    }
    else if ([segue.identifier isEqualToString:@"CreateReview"]) {
        [CreateReviewViewModel instance].reviewedLocation = [CreateLocationViewModel instance].createdLocation;
    }
}

- (void)dealloc {
    returnKeyHandler = nil;
    [timer invalidate];
}

@end
