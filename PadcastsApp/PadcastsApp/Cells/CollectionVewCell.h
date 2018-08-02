//
//  CollectionVewCell.h
//  PadcastsApp
//
//  Created by Dzmitry Tarelkin on 7/25/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemObject.h"


@interface CollectionVewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView;
-(void)setDataToLabelsFrom:(ItemObject*)item;

@end
