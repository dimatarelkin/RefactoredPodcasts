//
//  ItemObject+SetToManagedObject.m
//  PadcastsApp
//
//  Created by Dzmitry Tarelkin on 8/2/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import "ItemObject+SetToManagedObject.h"

@implementation ItemObject (SetToManagedObject)

#pragma mark ManagedObject
- (instancetype)initWithManagedObject:(ItemMO*)manageObject {
    self = [super init];
    if (self) {
        Image* img = [[Image alloc] init];
        Content* content = [[Content alloc] init];
        self.guiD = manageObject.guid;
        self.title = manageObject.title ;
        self.author =  manageObject.author;
        self.details = manageObject.details;
        self.duration = manageObject.duration;
        self.sourceType = (NSInteger)manageObject.sourceType == 0 ? MP3SourceType : TEDSourceType;
        self.publicationDate = [NSDate stringFromDate:manageObject.pubDate];
        
        content.localLink = manageObject.contentLocalLink;
        content.webLink = manageObject.contentWebLink;
        img.localLink = manageObject.imageLocalLink;
        img.webLink = manageObject.imageWebLink;
        self.image = img;
        self.content = content;
        self.isSaved = manageObject.isSaved;
    }
    return self;
}

-(void)configureManagedObject:(ItemMO*)manageObject {
    manageObject.title  = self.title;
    manageObject.author = self.author;
    manageObject.details = self.details;
    manageObject.duration = self.duration;
    manageObject.sourceType = self.sourceType;
    manageObject.pubDate = [NSDate createDateFromString:self.publicationDate];
    manageObject.guid = self.guiD;
    manageObject.isSaved = self.isSaved;
    manageObject.contentLocalLink = self.content.localLink;
    manageObject.contentWebLink = self.content.webLink;
    manageObject.imageLocalLink = self.image.localLink;
    manageObject.imageWebLink = self.image.webLink;
}
@end
