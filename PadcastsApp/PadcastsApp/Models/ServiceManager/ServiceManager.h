//
//  ServiceManager.h
//  PadcastsApp
//
//  Created by Dzmitry Tarelkin on 7/24/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Parser.h"
#import "ItemObject.h"

typedef enum {
    ImageQualityHigh = 1000,
    ImageQualityMedium = 500,
    ImageQualityLow = 250
} ImageQuality;


//delegate
@protocol ServiceDownloadDelegate <NSObject>
-(void)downloadingWasFinished:(NSArray*)result;
@end

//coreData offline mode
@protocol CoreDataHandlingProtocol <NSObject>
-(void)saveItemIntoCoreData:(ItemObject*)item;
-(void)deleteItemFromCoredata:(ItemObject*)item;
-(void)saveDataItemsIntoCoreData:(NSArray<ItemObject*>*)items;
-(NSArray<ItemObject*>*)fetchAllItemsFromCoreData;
-(ItemObject*)fetchItemfromCoredata:(NSString*)guid;
-(void)updateDataAndSetLocalLinks:(ItemObject*)item;
@end

//sandBox
@protocol SandBoxHanlderProtocol <NSObject>
-(void)saveContent:(NSObject*)content IntoSandBoxForItem:(ItemObject*)item;
- (void)saveDataWithImage:(NSData*)data IntoSandBoxForItem:(ItemObject *)item;
-(UIImage*)fetchImageFromSandBoxForItem:(ItemObject*)item;  //returns image
-(ItemObject*)fetchContentfromSandBox:(ItemObject*)item;    //returns audio or video content
@end

//downloading
@protocol DownloadManagerProtocol
-(void)downloadImageForItem:(ItemObject*)item withImageQuality:(ImageQuality)quality
        withCompletionBlock:(void(^)(NSData*data)) completion;
- (void)cancelTasksThatDontNeedToBeDone:(ItemObject*)task;
-(void)downloadContentForItem:(ItemObject*)item;
-(void)downloadXMLWithURL:(NSURL*)url withCompletionHandler:(void(^)(NSData* data)) completion;
@end


@interface ServiceManager : NSObject <ParserDelegate, CoreDataHandlingProtocol, SandBoxHanlderProtocol, DownloadManagerProtocol>
//parser
+(ServiceManager*)sharedManager;
-(void)downloadAndParseFileFromURL:(NSURL*)url withType:(SourceType)sourceType;
@property (weak, nonatomic) id<ServiceDownloadDelegate> delegate;


@end
