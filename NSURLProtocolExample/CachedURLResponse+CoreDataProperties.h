//
//  CachedURLResponse+CoreDataProperties.h
//  NSURLProtocolExample
//
//  Created by Linxi on 16/7/11.
//  Copyright © 2016年 Rocir Santiago. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CachedURLResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface CachedURLResponse (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *timestamp;
@property (nullable, nonatomic, retain) NSData *data;
@property (nullable, nonatomic, retain) NSString *encoding;
@property (nullable, nonatomic, retain) NSString *mimeType;
@property (nullable, nonatomic, retain) NSString *url;

@end

NS_ASSUME_NONNULL_END
