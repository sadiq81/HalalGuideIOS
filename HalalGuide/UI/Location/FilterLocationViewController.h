//
//  FilterLocationViewController.h
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterLocationViewController : UIViewController<UINavigationBarDelegate>

@property(strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property(strong, nonatomic) IBOutlet UISlider *distanceSlider;
@property(strong, nonatomic) IBOutlet UISwitch *halalSwitch;
@property(strong, nonatomic) IBOutlet UISwitch *alcoholSwitch;
@property(strong, nonatomic) IBOutlet UISwitch *porkSwitch;
@property (strong, nonatomic) IBOutlet UIView *switchView;
@property(strong, nonatomic) IBOutlet UIButton *choose;
@property(strong, nonatomic) IBOutlet UIButton *reset;
@property (strong, nonatomic) IBOutlet UILabel *categories;

@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UIView *categoryView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *done;
@end
