//
//  dropboxClient.h
//  DropboxFinal
//
//  Created by Viktor Chibotaru on 12/31/13.
//  Copyright (c) 2013 Viktor Chibotaru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>

@protocol dropboxSyncProtocol <NSObject>
- (void) didLogin;
- (void) didSyncFileList;
@end

@interface dropboxClient : NSObject

@property (strong, nonatomic) RKObjectManager *objectManager;
@property (strong, nonatomic) RKManagedObjectStore *objectStore;
@property (strong, nonatomic) NSString *userToken;
@property (strong, nonatomic) NSString *uid;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property id<dropboxSyncProtocol> delegate;

-(void) dropBoxLogin;
-(void) parseOpenURL: (NSURL *) url;
-(void) updateFiles;
-(void) setUpRestKit;
@end
