//
//  ServiceManager.m
//  PadcastsApp
//
//  Created by Dzmitry Tarelkin on 7/24/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import "ServiceManager.h"
#import "CoreDataManager.h"
#import "SandBoxManager.h"
#import "Downloader.h"


@interface ServiceManager()
@property (strong, nonatomic) Parser          * parser;
@property (strong, nonatomic) CoreDataManager * coreDataManger;
@property (strong, nonatomic) SandBoxManager  * sandBoxManager;
@property (strong, nonatomic) Downloader      * downloadManager;
@end



@implementation ServiceManager


+(ServiceManager*)sharedManager {
    static ServiceManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ServiceManager alloc] init];
    });
    return manager;
}

#pragma mark - XMLParser + ParserDelegate

-(void)downloadAndParseFileFromURL:(NSURL*)url withType:(SourceType)sourceType {
    self.parser = [[Parser alloc] init];
    self.parser.delegate = self;
    [self.parser  beginDownloadingWithURL:url andSourceType:sourceType];

}

- (void)downloadingWasFinishedWithResult:(NSArray *)result {
    //inform the delegate(tableView)
    [self.delegate downloadingWasFinished:result];
}



#pragma mark - CoreData offline mode
-(void)saveDataItemsIntoCoreData:(NSArray<ItemObject*>*)items {
    [[CoreDataManager sharedManager] saveDataItemsIntoCoreData:items];
}

- (void)deleteItemFromCoredata:(ItemObject *)item {
    [[CoreDataManager sharedManager] deleteItemFromCoredata:item];
}

- (NSArray<ItemObject *> *)fetchAllItemsFromCoreData {
    return [[CoreDataManager sharedManager] fetchAllItemsFromCoreData];
}


- (ItemObject *)fetchItemfromCoredata:(NSString*)guid {
    return [[CoreDataManager sharedManager] fetchItemfromCoredata:guid];
}

- (void)saveItemIntoCoreData:(ItemObject *)item {
    [[CoreDataManager sharedManager] saveItemIntoCoreData:item];
}

- (void)updateDataAndSetLocalLinks:(ItemObject *)item {
    [[CoreDataManager sharedManager] updateDataAndSetLocalLinks:item];
}




#pragma mark - SandBox Handler
- (UIImage *)fetchImageFromSandBoxForItem:(ItemObject *)item {
    return  [[SandBoxManager sharedSandBoxManager] fetchImageFromSandBoxForItem:item];
}

- (void)saveContent:(NSData *)contentData IntoSandBoxForItem:(ItemObject *)item{
    [[SandBoxManager sharedSandBoxManager] saveContent:contentData IntoSandBoxForItem:item];
}

- (void)saveDataWithImage:(NSData*)data IntoSandBoxForItem:(ItemObject *)item{
    [[SandBoxManager sharedSandBoxManager] saveDataWithImage:data IntoSandBoxForItem:item];
}




#pragma mark - DownloadManager

-(void)downloadImageForItem:(ItemObject*)item withImageQuality:(ImageQuality)quality
        withCompletionBlock:(void(^)(NSData*data)) completion {
    
    [[Downloader sharedDownloader] downloadImageForItem:item
                                        withImageQuality:quality
                                     withCompletionBlock:completion];
}

- (void)cancelTasksThatDontNeedToBeDone:(ItemObject*)task {
    [[Downloader sharedDownloader]cancelTasksThatDontNeedToBeDone:task];
}

-(void)downloadXMLFileFormURL:(NSString *)stringUrl withCompletionBlock:(void (^)(NSData *))completionBlock {
    [[Downloader sharedDownloader] downloadXMLFileFormURL:stringUrl withCompletionBlock:completionBlock];
}

-(void)downloadContentForItem:(ItemObject*)item {
    [[Downloader sharedDownloader] downloadContentForItem:item];
}

@end
