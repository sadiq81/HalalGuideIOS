//
//  CreateLocationViewController.h
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTAutocompleteTextField.h"

@interface CreateLocationViewController :UIViewController <UINavigationControllerDelegate, HTAutocompleteDataSource, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *pickImage;
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet HTAutocompleteTextField *road;
@property (strong, nonatomic) IBOutlet HTAutocompleteTextField *roadNumber;
@property (strong, nonatomic) IBOutlet UITextField *postalCode;
@property (strong, nonatomic) IBOutlet UITextField *city;
@property (strong, nonatomic) IBOutlet UITextField *telephone;
@property (strong, nonatomic) IBOutlet UITextField *website;
@property (strong, nonatomic) IBOutlet UIView *diningSwitches;
@property (strong, nonatomic) IBOutlet UIImageView *porkImage;
@property (strong, nonatomic) IBOutlet UISwitch *porkSwitch;
@property (strong, nonatomic) IBOutlet UIImageView *alcoholImage;
@property (strong, nonatomic) IBOutlet UISwitch *alcoholSwitch;
@property (strong, nonatomic) IBOutlet UIImageView *halalImage;
@property (strong, nonatomic) IBOutlet UISwitch *halalSwitch;
@property (strong, nonatomic) IBOutlet UIView *categoriesView;
@property (strong, nonatomic) IBOutlet UILabel *categoriesText;
@property (strong, nonatomic) IBOutlet UILabel *categoriesCount;
@property (strong, nonatomic) IBOutlet UIButton *reset;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *regret;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *save;

@property (strong, nonatomic) UIImage *image;
@end
