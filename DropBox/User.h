//
//  User.h
//  DropBox
//
//  Created by Viktor Chibotaru on 12/31/13.
//  Copyright (c) 2013 Viktor Chibotaru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class File, Quota;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * displayName;
@property (nonatomic, retain) NSString * referralLink;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSSet *files;
@property (nonatomic, retain) Quota *quotaInfo;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addFilesObject:(File *)value;
- (void)removeFilesObject:(File *)value;
- (void)addFiles:(NSSet *)values;
- (void)removeFiles:(NSSet *)values;

@end
