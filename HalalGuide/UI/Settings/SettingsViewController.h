//
// Created by Privat on 20/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface SettingsViewController : UITableViewController{
    
}

@property (strong, nonatomic) IBOutlet UIButton *clearCache;
@property (strong, nonatomic) IBOutlet UIButton *restorePurchases;
@property (strong, nonatomic) IBOutlet UIButton *resetFilter;

@property (weak, nonatomic) IBOutlet UITableViewCell *clear;
@property (weak, nonatomic) IBOutlet UITableViewCell *support;
@property (weak, nonatomic) IBOutlet UITableViewCell *reset;

@end