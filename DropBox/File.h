//
//  File.h
//  DropBox
//
//  Created by Viktor Chibotaru on 1/1/14.
//  Copyright (c) 2014 Viktor Chibotaru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface File : NSManagedObject

@property (nonatomic, retain) NSString * folderHash;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSNumber * isDir;
@property (nonatomic, retain) NSDate * lastModified;
@property (nonatomic, retain) NSString * localPath;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSString * rev;
@property (nonatomic, retain) NSNumber * savedOnDevice;
@property (nonatomic, retain) NSNumber * size;
@property (nonatomic, retain) NSNumber * thumbExists;
@property (nonatomic, retain) NSNumber * isDel;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) User *user;

@end
