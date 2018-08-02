//
//  DetailViewController.h
//  PadcastsApp
//
//  Created by Dzmitry Tarelkin on 7/24/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemObject.h"
//#import "CollectionViewControllerMaster.h"

@interface DetailViewController : UIViewController
-(void)itemWasSelected:(ItemObject *)item;

@end
