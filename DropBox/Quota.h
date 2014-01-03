//
//  Quota.h
//  DropBox
//
//  Created by Viktor Chibotaru on 1/3/14.
//  Copyright (c) 2014 Viktor Chibotaru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Quota : NSManagedObject

@property (nonatomic, retain) NSNumber * normal;
@property (nonatomic, retain) NSNumber * quota;
@property (nonatomic, retain) NSNumber * shared;
@property (nonatomic, retain) User *userInfo;

@end
