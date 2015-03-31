//
// Created by Privat on 12/01/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <objc/runtime.h>
#import <ALActionBlocks/UIGestureRecognizer+ALActionBlocks.h>
#import "UIViewController+Extension.h"
#import "UIImage+Transformation.h"
#import "HGOnboarding.h"
#import "UILabel+Extensions.h"
#import <EXTScope.h>

@implementation UIViewController (Extension)


- (NSString *)percentageString:(float)progress {
    NSString *localised = NSLocalizedString(@"percentageComplete", nil);
    NSString *text = [NSString stringWithFormat:@"%i%% %@", (int) progress, localised];
    return text;
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets {

    [self.parentViewController dismissViewControllerAnimated:true completion:nil];

    NSMutableArray *temp = [NSMutableArray new];
    for (ALAsset *asset in assets) {
        ALAssetRepresentation *representation = asset.defaultRepresentation;
        UIImage *image = [UIImage imageWithCGImage:representation.fullResolutionImage scale:1.0f orientation:(UIImageOrientation) representation.orientation];
        [temp addObject:image];
    }

    self.images = temp;

    [self finishedPickingImages];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    [self.parentViewController dismissViewControllerAnimated:true completion:nil];

    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.images = @[image];

    [self finishedPickingImages];
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(ALAsset *)asset {
    // Allow 5 assets to be picked
    return (picker.selectedAssets.count < 5);
}

- (void)finishedPickingImages {

}

- (void)dismissHintView:(NSString *)hintKey {

    [[HGOnboarding instance] setOnBoardingShown:hintKey];
    [UIView animateWithDuration:0.5 animations:^{
        self.hintView.alpha = 0;
    }                completion:^(BOOL finished) {
        [self.hintView removeFromSuperview];
        [self hintWasDismissedByUser:hintKey];
    }];
}

- (void)hintWasDismissedByUser:(NSString *)hintKey {

}

- (void)displayHintForView:(UIView *)viewWithHint withHintKey:(NSString *)hintKey preferedPositionOfText:(HintPosition)position {

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.hintView = [[UIView alloc] initWithFrame:screenRect];
    self.hintView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    self.hintView.autoresizingMask = 0;
    self.hintView.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self.hintView];


    CGRect bounds = self.hintView.bounds;
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;

    const float radius = 25;
    CGRect absolutePosition = [viewWithHint convertRect:viewWithHint.bounds toView:nil];
    CGRect circleRect = CGRectInset(CGRectMake(CGRectGetMidX(absolutePosition), CGRectGetMidY(absolutePosition), 0, 0), -radius, -radius);

    //Draw ma
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:circleRect];
    [path appendPath:[UIBezierPath bezierPathWithRect:bounds]];
    maskLayer.path = path.CGPath;
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    self.hintView.layer.mask = maskLayer;

    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    hintLabel.textColor = [UIColor whiteColor];
    hintLabel.text = NSLocalizedString(hintKey, nil);
    hintLabel.numberOfLines = 0;
    //TODO align text start according with element

    float maxWidth = CGRectGetWidth(screenRect) - 20;
    float paddingToOtherElements = 18;
    CGSize size = [hintLabel getSizeForText:hintLabel.text maxWidth:maxWidth];
    switch (position) {
        case HintPositionAbove: {
            float preferredY = CGRectGetMinY(absolutePosition) - size.height - paddingToOtherElements;
            if (preferredY < 0) { //View is above visible screen, move it below viewWithHint
                hintLabel.frame = CGRectMake(10, CGRectGetMinY(absolutePosition) + CGRectGetHeight(absolutePosition) + paddingToOtherElements, maxWidth, ceilf(size.height));
            } else {
                hintLabel.frame = CGRectMake(10, preferredY, maxWidth, ceilf(size.height));
            }
            break;
        };
        case HintPositionLeft: { //TODO
        };
        case HintPositionRight: { //TODO
        };
        case HintPositionBelow: {
            float preferredY = absolutePosition.origin.y + absolutePosition.size.height + size.height + paddingToOtherElements;
            if (preferredY > screenRect.size.height) { //View is below visible screen, move it above viewWithHint
                hintLabel.frame = CGRectMake(10, absolutePosition.origin.y - size.height - paddingToOtherElements, maxWidth, ceilf(size.height));
            } else {
                hintLabel.frame = CGRectMake(10, preferredY, maxWidth, ceilf(size.height));
            }
            break;
        };
    }

    [self.hintView addSubview:hintLabel];

    [UIView animateWithDuration:0.7 animations:^{
        self.hintView.alpha = 1;
    }];

    @weakify(self)
    @weakify(hintKey)
    [self.hintView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithBlock:^(id weakSender) {
        @strongify(self)
        @strongify(hintKey)
        [self dismissHintView:hintKey];
    }]];
}

- (UIView *)hintView {
    return objc_getAssociatedObject(self, @selector(hintView));
}

- (void)setHintView:(UIView *)hintView {
    objc_setAssociatedObject(self, @selector(hintView), hintView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end