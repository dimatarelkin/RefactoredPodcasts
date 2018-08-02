//
//  CoreDataManager.h
//  PadcastsApp
//
//  Created by Dzmitry Tarelkin on 7/26/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ServiceManager.h"

@interface CoreDataManager : NSObject <CoreDataHandlingProtocol>
@property (readonly, strong) NSPersistentContainer *persistentContainer;
+(CoreDataManager*)sharedManager;
@end
