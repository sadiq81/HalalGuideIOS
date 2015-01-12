//
// Created by Privat on 12/01/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#define EXCHANGE_METHOD(a,b) [[self class]exchangeMethod:@selector(a) withNewMethod:@selector(b)]

@interface NSObject (MethodExchange)
+(void)exchangeMethod:(SEL)origSel withNewMethod:(SEL)newSel;
@end