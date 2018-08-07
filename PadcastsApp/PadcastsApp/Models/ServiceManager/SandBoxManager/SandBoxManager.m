//
//  SandBoxManager.m
//  PadcastsApp
//
//  Created by Dzmitry Tarelkin on 7/26/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import "SandBoxManager.h"


@interface SandBoxManager()
@property (strong, nonatomic) NSFileManager* fileManager;
@property (strong,nonatomic) NSString * directory;

@property (assign, nonatomic) int counter;
@end

@implementation SandBoxManager

static NSString * const kImagesDirectory = @"Images";
static NSString * const kContentDirectory = @"Content";


+(SandBoxManager*)sharedSandBoxManager {
    static SandBoxManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SandBoxManager alloc] init];
        manager.counter = 0;
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _fileManager = [NSFileManager defaultManager];
        _directory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        [self createDirectoryWithPath:[NSString stringWithFormat:@"/%@", kImagesDirectory]];
        [self createDirectoryWithPath:[NSString stringWithFormat:@"/%@", kContentDirectory]];
    }
    return self;
}


-(void)createDirectoryWithPath:(NSString*)path {
    NSString *destinationPath = [self.directory stringByAppendingPathComponent:path];
    [self.fileManager createDirectoryAtPath:destinationPath withIntermediateDirectories:YES attributes:nil error:nil];
}


- (void)saveDataWithImage:(NSData*)data IntoSandBoxForItem:(ItemObject *)item {
    NSString* path = [self localFilePathForWebURL:item.image.webLink atDirectory:kImagesDirectory];
    NSString *destinationPath = [self.directory stringByAppendingString:path];
    item.image.localLink = destinationPath;
    [self.fileManager createFileAtPath:destinationPath contents:data attributes:nil];
    
}


- (NSString *)localFilePathForWebURL:(NSString *)webStringUrl atDirectory:(NSString *)directory  {
    NSString *localPath = [NSString stringWithFormat:@"/%@/%@", directory, [self getFilenameFromStringURL:webStringUrl]];
//    NSLog(@"local path = %@", localPath);
    return localPath;
}


- (NSString *)getFilenameFromStringURL:(NSString *)stringUrl {
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSString *fileTitle = url.lastPathComponent;
    return fileTitle;
}


- (UIImage *)fetchImageFromSandBoxForItem:(ItemObject *)item {
    
    if ([self.fileManager fileExistsAtPath:item.image.localLink]) {
//        NSLog(@"local path = %@", item.image.localLink);
        NSData *data = [NSData dataWithContentsOfFile:item.image.localLink];
        return [UIImage imageWithData:data];
    } else {
        NSLog(@"file don't exists");
        return nil;
    }
}


#pragma mark - Content Saving

- (void)saveContent:(NSData *)contentData IntoSandBoxForItem:(ItemObject *)item {
    NSString * path = [self localFilePathForWebURL:item.content.webLink atDirectory:kContentDirectory];
    NSString * destinationPath = [self.directory stringByAppendingString:path];
    item.content.localLink = destinationPath;
    NSLog(@"video location %@", destinationPath);
    [self.fileManager createFileAtPath:destinationPath contents:contentData attributes:nil];
}






@end
