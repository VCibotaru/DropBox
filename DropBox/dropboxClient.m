//
//  dropboxClient.m
//  DropboxFinal
//
//  Created by Viktor Chibotaru on 12/31/13.
//  Copyright (c) 2013 Viktor Chibotaru. All rights reserved.
//

#import "dropboxClient.h"
#import "File.h"

#define LOGIN_URL "https://www.dropbox.com/1/oauth2/authorize"
#define APP_KEY "akzosdvbu3on4dh"
#define RESPONSE_TYPE "token"
#define REDIRECT_URI "akzosdvbu3on4dh://authorize"


@implementation dropboxClient

@synthesize userToken;
@synthesize uid;
@synthesize managedObjectContext;
@synthesize managedObjectModel;
@synthesize objectManager;
@synthesize objectStore;
@synthesize delegate;

- (void) dropBoxLogin
{
    NSString *urlString = [NSString stringWithFormat:@"%s?response_type=%s&client_id=%s&redirect_uri=%s",LOGIN_URL, RESPONSE_TYPE, APP_KEY, REDIRECT_URI];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

-(void) parseOpenURL:(NSURL *) url
{
    NSString *urlString = [url absoluteString];
    urlString = [urlString substringFromIndex:[urlString rangeOfString:@"access_token"].location];
    NSArray *urlComponents = [urlString componentsSeparatedByString:@"&"];
    for (NSString *keyValuePair in urlComponents)
    {
        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
        NSString *key = [pairComponents objectAtIndex:0];
        if ([key isEqualToString:@"access_token"]) {
            userToken = [[NSString alloc] initWithString:[pairComponents objectAtIndex:1]];
            continue;
        }
        if ([key isEqualToString:@"uid"]) {
            uid = [[NSString alloc] initWithString:[pairComponents objectAtIndex:1]];
        }
    }
    [objectManager setAcceptHeaderWithMIMEType:RKMIMETypeJSON];
    [objectManager.HTTPClient setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@", userToken]];
    [delegate didLogin];
}
-(void) setUpRestKit
{
    objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"https://api.dropbox.com"]];
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    objectManager.managedObjectStore = managedObjectStore;
    [managedObjectStore createPersistentStoreCoordinator];
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"dropBoxData.sqlite"];
    NSError *error;
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:@{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES} error:&error];
    NSAssert(persistentStore, @"Failed to add persistent store with error: %@", error);
    [managedObjectStore createManagedObjectContexts];
    managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
}
-(void) updateFiles
{
    RKEntityMapping* fileMapping = [RKEntityMapping mappingForEntityForName:@"File" inManagedObjectStore:objectManager.managedObjectStore];
    [fileMapping addAttributeMappingsFromDictionary:@{
                                                         @"path": @"path",
                                                         @"bytes": @"size",
                                                         @"icon": @"icon",
                                                         @"thumb_exists": @"thumbExists",
                                                         @"rev": @"rev"
                                                         }];
    fileMapping.identificationAttributes = @[@"rev"];
    RKResponseDescriptor *fileDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:fileMapping method:RKRequestMethodGET pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:fileDescriptor];
    [objectManager getObjectsAtPath:@"1/search/dropbox" parameters:@{@"query": @"."}
        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
        {
        }
        failure:^(RKObjectRequestOperation *operation, NSError *error)
        {
            NSLog(@"Hit error: %@", [error localizedDescription]);
                      }];
    [objectManager removeResponseDescriptor:fileDescriptor];
}

@end
