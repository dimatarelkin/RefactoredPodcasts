//
//  ItemMO+CoreDataProperties.h
//  PadcastsApp
//
//  Created by Dzmitry Tarelkin on 7/30/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//
//

#import "ItemMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ItemMO (CoreDataProperties)

+ (NSFetchRequest<ItemMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *author;
@property (nullable, nonatomic, copy) NSString *details;
@property (nullable, nonatomic, copy) NSString *duration;
@property (nullable, nonatomic, copy) NSString *guid;
@property (nonatomic) BOOL isSaved;
@property (nullable, nonatomic, copy) NSDate *pubDate;
@property (nonatomic) int64_t sourceType;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *imageLocalLink;
@property (nullable, nonatomic, copy) NSString *imageWebLink;
@property (nullable, nonatomic, copy) NSString *contentLocalLink;
@property (nullable, nonatomic, copy) NSString *contentWebLink;

@end

NS_ASSUME_NONNULL_END
