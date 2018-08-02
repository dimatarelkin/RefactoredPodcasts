//
//  Object.m
//  PadcastsApp
//
//  Created by Dzmitry Tarelkin on 7/23/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import "ItemObject.h"


@implementation ItemObject

- (NSString *)description {
    return [NSString stringWithFormat:@"\n ID - %@\n title - %@\n author - %@\n description - %@\n content - %@\n image - %@\n duration - %@\n publicationDate - %@\n sourceType - %@",
            self.guiD, self.title,
            self.author, self.details,
            self.content.webLink, self.image.webLink,
            self.duration, self.publicationDate,
            self.sourceType == 0 ? @"MP3":@"TED"];
}

- (instancetype)initWithDictionary:(NSDictionary*)objects andSourceType:(SourceType)sourceType{
    self = [super init];
    if (self) {
        self.isSaved = NO;
        self.sourceType = sourceType;
        self.image = [[Image alloc] init];
        self.content = [[Content alloc] init];
        [self setAllObjects:objects];
    }
    return self;
}


-(void)setAllObjects:(NSDictionary*)objects {
    self.guiD            = [objects objectForKey:kElementID];
    self.title           = [objects objectForKey:kElementTitle];
    self.author          = [objects objectForKey:kElementAuthor];
    self.details         = [objects objectForKey:kElementDescription];
    self.content.webLink = [objects objectForKey:kElementContent];
    self.image.webLink   = [objects objectForKey:kElementImage];
    self.duration        = [objects objectForKey:kElementDuration];
    self.publicationDate = [objects objectForKey:kElementPubDate];
    self.publicationDate = [NSDate convertStringWithDateString:self.publicationDate];
}


@end
