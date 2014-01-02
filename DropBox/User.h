//
//  User.h
//  DropBox
//
//  Created by Viktor Chibotaru on 1/2/14.
//  Copyright (c) 2014 Viktor Chibotaru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Quota;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * displayName;
@property (nonatomic, retain) NSString * referralLink;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) Quota *quotaInfo;

@end
