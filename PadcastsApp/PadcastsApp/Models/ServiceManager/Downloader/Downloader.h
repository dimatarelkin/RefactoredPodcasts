//
//  Downloader.h
//  PadcastsApp
//
//  Created by Dzmitry Tarelkin on 7/26/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ServiceManager.h"

@protocol ContentDownloadingDelegate
-(void)contentDownloadingWasfinishedWithData:(NSData*)data;
@end

@interface Downloader : NSObject <DownloadManagerProtocol>
+(Downloader*)sharedDownloader;
@property (strong, nonatomic) id<ContentDownloadingDelegate> delegate;
@end
