//
// Created by Privat on 29/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "HGAdgangsadresse.h"


@implementation HGAdgangsadresse {


}

- (CLLocation *)location {
    NSString *latitude = [self.adgangspunkt.koordinater objectAtIndex:1];
    NSString *longitude = [self.adgangspunkt.koordinater objectAtIndex:0];
    return [[CLLocation alloc] initWithLatitude:latitude.floatValue longitude:longitude.floatValue];
}

- (NSString *)latitude {
    return [self.adgangspunkt.koordinater objectAtIndex:1];
}

- (NSString *)longitude {
    return [self.adgangspunkt.koordinater objectAtIndex:0];
}


@end

@implementation Vejstykke {

}
@end

@implementation Postnummer {

}
@end

@implementation Stormodtageradresser {

}
@end

@implementation Kommune {

}
@end

@implementation Ejerlav {

}
@end

@implementation Historik {

}
@end

@implementation Adgangspunkt {

}
@end

@implementation DDKN {

}
@end

@implementation Sogn {

}
@end

@implementation Region {

}
@end

@implementation Retskreds {

}
@end

@implementation Politikreds {

}
@end

@implementation Opstillingskreds {

}
@end

@implementation SimpleAddress {

}

- (instancetype)initWithName:(NSString *)name numbers:(NSMutableArray *)numbers postalCode:(Postnummer *)postnummer {
    self = [super init];
    if (self) {
        self.name = name;
        self.numbers = numbers;
        self.postnummer = postnummer;
    }

    return self;
}

@end