//
//  CoreDataManager.m
//  PadcastsApp
//
//  Created by Dzmitry Tarelkin on 7/26/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import "CoreDataManager.h"
#import "ItemMO+CoreDataClass.h"

static NSString * const kItemEntity = @"ItemMO";


@interface CoreDataManager ()
- (void)saveContext;
@end


static NSString * const kCoreDataBaseName = @"PadcastsApp";


@implementation CoreDataManager

+(CoreDataManager *)sharedManager {
    static CoreDataManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CoreDataManager alloc] init];
    });
    
    return manager;
}


#pragma mark - Core Data stack
@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:kCoreDataBaseName];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}


#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}


#pragma mark - CoreDataHandlingProtocol Methods
//ADD
- (void)saveItemIntoCoreData:(ItemObject *)item {
    if (![self checkItemIsNew:item]) {
        return;
    }
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kItemEntity inManagedObjectContext:self.persistentContainer.viewContext];
    if (!entityDescription) {
        NSLog(@"could not find entity description");
        return;
    }
    
    ItemMO* manageObject = [[ItemMO alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.persistentContainer.viewContext];
    [item configureManagedObject:manageObject];
    [self saveContext];
}


-(BOOL)checkItemIsNew:(ItemObject*)item {
    NSArray* allCoredataItems = [self fetchAllItemsFromCoreData];
    BOOL result = YES;
    for (ItemObject* obj in allCoredataItems  ) {
        if ([obj.guiD isEqualToString:item.guiD]) {
            return  NO;
        }
    }
    return result;
}

//DELETE
- (void)deleteItemFromCoredata:(ItemObject *)item {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kItemEntity];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"guid == %@",item.guiD];
    [fetchRequest setPredicate:predicate];
    
    ItemMO *manageObject = [[self.persistentContainer.viewContext executeFetchRequest:fetchRequest error:nil] firstObject];
    if ([item.guiD isEqualToString: manageObject.guid]) {
        [self.persistentContainer.viewContext deleteObject:manageObject];
        [self saveContext];
        NSLog(@"Object has been deleted");
    }
}


//UPDATE
-(void)updateDataAndSetLocalLinks:(ItemObject*)item {
    NSFetchRequest *fetchRequest = [ItemMO fetchRequest];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"guid == %@",item.guiD];
    [fetchRequest setPredicate:predicate];

    ItemMO *manageObject = [[self.persistentContainer.viewContext executeFetchRequest:fetchRequest error:nil] firstObject];
    if ([item.guiD isEqualToString: manageObject.guid]) {
        [item configureManagedObject: manageObject];
        NSLog(@"item = %@", [item description]);
        [self saveContext];
        NSLog(@"Object has been updated");
    }
}


//FETCH
- (ItemObject *)fetchItemfromCoredata:(NSString*)guid {
    ItemObject *item = [[ItemObject alloc] init];
    NSArray *items = [self fetchAllItemsFromCoreData];
    
    for (ItemObject* itemObj in items ) {
        if ([guid isEqualToString:item.guiD]) {
            item = itemObj;
        }
    }
    return item;
}

//DELETE ALL
-(void)deleteAllDataFromCoreData {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kItemEntity];
    NSArray* results;
    
    if (!fetchRequest) {
        NSLog(@"error with fetch request");
    } else {
        results = [self.persistentContainer.viewContext executeFetchRequest:fetchRequest error:nil];
        if (results.count == 0) {
            NSLog(@"Context is empty");
        } else {
            for (ItemMO *manageObject in results) {
                //cleaning context
                [manageObject.managedObjectContext deleteObject:manageObject];
            }
            [self saveContext];
            NSLog(@"Context have been cleaned");
        }
    }
}

//FETCH ALL
- (NSArray<ItemObject *> *)fetchAllItemsFromCoreData {
    NSFetchRequest *fetchRequest = [ItemMO fetchRequest];
    NSArray* results;
    NSMutableArray* items = [NSMutableArray array];
    
    if (!fetchRequest) {
        NSLog(@"error with fetch request");
    } else {
        results = [self.persistentContainer.viewContext executeFetchRequest:fetchRequest error:nil];
        
        for (ItemMO *manageObject in results) {
            ItemObject* item = [[ItemObject alloc] initWithManagedObject:manageObject];
            [items addObject:item];
        }
        
        if (items.count == 0) {
            NSLog(@"Context is empty");
        } else {
            NSLog(@"All Tasks have been fetched");
            NSLog(@"fetch %@",[items componentsJoinedByString:@"-"]);
        }
    }
    
    return items;
}

- (void)saveDataItemsIntoCoreData:(NSArray<ItemObject *> *)items {
    for (ItemObject* item in items  ) {
        [self saveItemIntoCoreData:item];
    }
}





@end
