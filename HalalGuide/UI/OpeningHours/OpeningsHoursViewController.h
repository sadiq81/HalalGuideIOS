//
// Created by Privat on 21/01/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface OpeningsHoursViewController : UIViewController  {
}
@property (weak, nonatomic) IBOutlet UIButton *rightBarButton;
@property(weak, nonatomic) IBOutlet UIButton *chooseButton;

@property (weak, nonatomic) IBOutlet UIVisualEffectView *datePickerView;

@property (weak, nonatomic) IBOutlet UIDatePicker *openPicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *closePicker;
@property (weak, nonatomic) IBOutlet UIButton *next;
@property (weak, nonatomic) IBOutlet UIButton *previous;
@property (weak, nonatomic) IBOutlet UIButton *closed;
@property (weak, nonatomic) IBOutlet UIButton *finished;
@property (weak, nonatomic) IBOutlet UILabel *day;

@end