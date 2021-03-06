//
// Created by Privat on 10/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class HGCreateLocationViewModel;


@interface HGCoordinatePickerViewController : UIViewController<MKMapViewDelegate>{
    
}
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *approve;
@property CLLocationCoordinate2D tempCoordinate;
@property BOOL dismissByApproval;
@property (strong, nonatomic) HGCreateLocationViewModel *viewModel;

@end