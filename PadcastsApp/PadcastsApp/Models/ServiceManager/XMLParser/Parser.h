//
//  Parser.h
//  PadcastsApp
//
//  Created by Dzmitry Tarelkin on 7/23/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemObject.h"



@protocol ParserDelegate <NSObject>
-(void)downloadingWasFinishedWithResult:(NSArray*)result;
@end

@interface Parser : NSObject <NSXMLParserDelegate>

@property (weak, nonatomic) id<ParserDelegate> delegate;

@property (strong, nonatomic) NSMutableArray* arrayOfObjects;
@property (strong, nonatomic) NSArray *tags;
-(void)beginDownloadingWithURL:(NSURL*)url andSourceType:(SourceType)sourceType;
@end


