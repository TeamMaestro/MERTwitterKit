//
//  MERTwitterKitUserViewModel.h
//  MERTwitterKit
//
//  Created by William Towe on 3/31/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import "RVMViewModel.h"
#import <UIKit/UIImage.h>

@class TwitterKitUser;

@interface MERTwitterKitUserViewModel : RVMViewModel

@property (readonly,nonatomic) NSString *name;
@property (readonly,nonatomic) NSString *screenName;
@property (readonly,strong,nonatomic) UIImage *profileImage;

+ (instancetype)viewModelWithUser:(TwitterKitUser *)user;

@end
