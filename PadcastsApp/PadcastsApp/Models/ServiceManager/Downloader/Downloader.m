//
//  Downloader.m
//  PadcastsApp
//
//  Created by Dzmitry Tarelkin on 7/26/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import "Downloader.h"
#import "SandBoxManager.h"


@interface Downloader() <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate>
@property (strong, nonatomic) NSMutableDictionary* operations;
@property (strong, nonatomic) ItemObject* currentItemForContent;
@end

@implementation Downloader


+(Downloader*)sharedDownloader {
    static Downloader* downloader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloader = [[Downloader alloc] init];
        downloader.operations = [NSMutableDictionary dictionary];
    });
    return downloader;
}

/********* Previous *********
-(void)downloadImageForItem:(ItemObject*)item withImageQuality:(ImageQuality)quality
        withCompletionBlock:(void(^)(NSData*data)) completion {
   
    NSURL *url;
    if (item.sourceType == MP3SourceType) {
        url = [NSURL URLWithString: [NSString stringWithFormat:@"%@",item.image.webLink]];
    } else {
        url = [NSURL URLWithString: [NSString stringWithFormat:@"%@w=%d",item.image.webLink,quality]];
    }

    dispatch_queue_t queue;
    if (quality == ImageQualityHigh) {
     queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    } else {
     queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
  
    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation* weakOperation = operation;
    
    [operation addExecutionBlock:^{
        if (weakOperation.isCancelled == NO) {
            dispatch_async(queue, ^{
                NSData* data = [NSData dataWithContentsOfURL:url];
                  [[SandBoxManager sharedSandBoxManager] saveDataWithImage:data IntoSandBoxForItem:item];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(data);
                });
            });
        }
    }];
    
    [operation setName:item.guiD];
    [self.operations setObject:operation forKey:operation.name];
    [operation start];

}
*/

-(void)downloadImageForItem:(ItemObject*)item withImageQuality:(ImageQuality)quality
        withCompletionBlock:(void(^)(NSData*data)) completion {
    
    NSURL *url;
    if (item.sourceType == MP3SourceType) {
        url = [NSURL URLWithString: [NSString stringWithFormat:@"%@",item.image.webLink]];
    } else {
        url = [NSURL URLWithString: [NSString stringWithFormat:@"%@w=%d",item.image.webLink,quality]];
    }
    
    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    [operation addExecutionBlock:^{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData* data = [NSData dataWithContentsOfURL:url];
                [[SandBoxManager sharedSandBoxManager] saveDataWithImage:data IntoSandBoxForItem:item];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(data);
                });
            });
    }];
    
    [operation setName:item.guiD];
    [self.operations setObject:operation forKey:operation.name];
    [operation start];
}


-(void)downloadXMLFileFormURL:(NSString *)stringUrl withCompletionBlock:(void (^)(NSData *))completionBlock {
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSData *data = [NSData dataWithContentsOfURL:location];
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(data);
            });
        } else {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
        [session invalidateAndCancel];
    }];
    [task resume];
}


- (void)cancelTasksThatDontNeedToBeDone:(ItemObject*)task {
    
    [self.operations enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isEqual: [self.operations objectForKey:task.guiD]]) {
            [[self.operations objectForKey:key] cancel];
            [self.operations removeObjectForKey:key];
            obj = nil;
            NSLog(@"Operation is cancelled");
        }
    }];
}





#warning download the video


-(void)downloadContentForItem:(ItemObject*)item {
    NSURL *url = [NSURL URLWithString:item.content.webLink];

    NSURLSessionConfiguration *config =
    [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:item.content.webLink];
    [config setDiscretionary:YES];
    [config setSessionSendsLaunchEvents:YES];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    NSURLSessionDownloadTask* downloadTask = [session downloadTaskWithURL:url];
    
    [downloadTask resume];
}



//-(void)URLSession
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    if (totalBytesExpectedToWrite > 0) {
        float progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite * 100;
        NSLog(@"Progress %@ : %f", [downloadTask description], progress);
    }
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask* )downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSLog(@"location : %@", location.absoluteString);
    NSData *data = [NSData dataWithContentsOfFile:location.relativePath];
    [[NSFileManager defaultManager] removeItemAtPath:location.absoluteString error:nil];
    
    [self.delegate contentDownloadingWasfinishedWithData:data];
    self.delegate = nil;
    [session invalidateAndCancel];
}


@end
