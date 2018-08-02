//
//  ItemMO+CoreDataProperties.m
//  PadcastsApp
//
//  Created by Dzmitry Tarelkin on 7/30/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//
//

#import "ItemMO+CoreDataProperties.h"

@implementation ItemMO (CoreDataProperties)

+ (NSFetchRequest<ItemMO *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ItemMO"];
}

@dynamic author;
@dynamic details;
@dynamic duration;
@dynamic guid;
@dynamic isSaved;
@dynamic pubDate;
@dynamic sourceType;
@dynamic title;
@dynamic imageLocalLink;
@dynamic imageWebLink;
@dynamic contentLocalLink;
@dynamic contentWebLink;

@end
