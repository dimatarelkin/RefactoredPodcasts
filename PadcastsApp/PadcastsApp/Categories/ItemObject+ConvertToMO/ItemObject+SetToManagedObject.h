//
//  ItemObject+SetToManagedObject.h
//  PadcastsApp
//
//  Created by Dzmitry Tarelkin on 8/2/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import "ItemObject.h"

@interface ItemObject (SetToManagedObject)
- (instancetype)initWithManagedObject:(ItemMO*)manageObject;
- (void)configureManagedObject:(ItemMO*)manageObject;
@end
