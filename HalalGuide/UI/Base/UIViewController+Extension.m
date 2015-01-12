//
// Created by Privat on 12/01/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <objc/runtime.h>
#import "UIViewController+Extension.h"
#import "FrontPageViewModel.h"
#import "NSObject+MethodExchange.h"


@implementation UIViewController (Extension)

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

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(ALAsset *)asset
{
    // Allow 10 assets to be picked
    return (picker.selectedAssets.count < 5);
}

- (void)finishedPickingImages {

}

- (NSArray *)images {
    return objc_getAssociatedObject(self, @selector(images));
}

- (void)setImages:(NSArray *)images {
    objc_setAssociatedObject(self, @selector(images), images, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end