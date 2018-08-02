//
//  Object.h
//  PadcastsApp
//
//  Created by Dzmitry Tarelkin on 7/23/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Content.h"
#import "Image.h"
#import "ItemMO+CoreDataClass.h"
#import "NSDate+ConvertToString.h"


typedef enum {
    MP3SourceType,
    TEDSourceType
} SourceType;

static NSString * const kElementItem        = @"item";
static NSString * const kElementTitle       = @"title";
static NSString * const kElementAuthor      = @"itunes:author";
static NSString * const kElementDescription = @"itunes:summary";
static NSString * const kElementContent     = @"enclosure";
static NSString * const kElementImage       = @"itunes:image";
static NSString * const kElementDuration    = @"itunes:duration";
static NSString * const kElementPubDate     = @"pubDate";
static NSString * const kElementID          = @"guid";
static NSString * const kElementSourceType  = @"sourceType";


@interface ItemObject : NSObject
@property (strong, nonatomic) NSString  *guiD;
@property (strong, nonatomic) NSString  *title;
@property (strong, nonatomic) NSString  *author;
@property (strong, nonatomic) NSString  *details;
@property (strong, nonatomic) Content   *content;
@property (strong, nonatomic) Image     *image;
@property (strong, nonatomic) NSString  *duration;
@property (strong, nonatomic) NSString  *publicationDate;
@property (assign, nonatomic) SourceType sourceType;
@property (assign, nonatomic) BOOL isSaved;


- (instancetype)initWithDictionary:(NSDictionary*)objects andSourceType:(SourceType)sourceType;
@end

#import "ItemObject+SetToManagedObject.h"
