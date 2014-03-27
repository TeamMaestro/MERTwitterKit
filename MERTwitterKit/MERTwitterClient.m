//
//  MERTwitterClient.m
//  MERTwitterKit
//
//  Created by William Towe on 3/27/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import "MERTwitterClient.h"

#import <Accounts/Accounts.h>

@interface MERTwitterClient ()
@property (strong,nonatomic) ACAccountStore *accountStore;
@end

@implementation MERTwitterClient

- (id)init {
    if (!(self = [super init]))
        return nil;
    
    [self setAccountStore:[[ACAccountStore alloc] init]];
    
    return self;
}

@end
