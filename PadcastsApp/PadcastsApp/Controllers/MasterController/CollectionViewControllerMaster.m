//
//  CollectionViewControllerMaster.m
//  PadcastsApp
//
//  Created by Dzmitry Tarelkin on 7/25/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import "CollectionViewControllerMaster.h"
#import "CollectionVewCell.h"
#import "ItemObject.h"
#import "ServiceManager.h"



@interface CollectionViewControllerMaster () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ServiceDownloadDelegate>

@property (strong, nonatomic) NSMutableArray *parserData;
@property (strong, nonatomic) NSMutableArray *cachedData;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UISegmentedControl* segmentedControl;
@property (strong, nonatomic) DetailViewController* detail;



@end





@implementation CollectionViewControllerMaster

static NSString * const reuseIdentifier = @"Cell";
static NSString * const kTedURL = @"https://feeds.feedburner.com/tedtalks_video";
static NSString * const kMP3URL = @"http://rss.simplecast.com/podcasts/4669/rss";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"All",@"Saved"]];
    self.segmentedControl.selectedSegmentIndex = 0;
    
    [self.segmentedControl addTarget:self
                              action:@selector(segmentedControlValueDidChange:)
                    forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segmentedControl;
    
    
    self.navigationController.navigationBar.backgroundColor = UIColor.whiteColor;
    self.navigationController.navigationBar.barTintColor = UIColor.whiteColor;
    
    
    self.collectionView.backgroundColor = UIColor.whiteColor;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.allowsSelection = YES;
    
    
    self.dataSource = [NSMutableArray array];
    self.cachedData = [NSMutableArray array];
    self.parserData = [NSMutableArray array];
    
    // Register cell classes
    [self.collectionView registerClass:[CollectionVewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    //detailVC
    self.detail = [[DetailViewController alloc] init];
    
    NSURL* urlMP3 = [NSURL URLWithString:kMP3URL];
    NSURL* urlTED = [NSURL URLWithString:kTedURL];
    
    [ServiceManager sharedManager].delegate = self;
    [[ServiceManager sharedManager] downloadAndParseFileFromURL:urlTED withType:TEDSourceType];
    [[ServiceManager sharedManager] downloadAndParseFileFromURL:urlMP3 withType:MP3SourceType];
    
  
}


#pragma mark - segmentedControl
-(void)segmentedControlValueDidChange:(UISegmentedControl*)control {
    NSLog(@"value changed");
    
    [self.dataSource removeAllObjects];
    [self.cachedData removeAllObjects];
    
    if (control.selectedSegmentIndex == 1) {
        [self.cachedData addObjectsFromArray:
         [[ServiceManager sharedManager] fetchAllItemsFromCoreData]];
        [self.dataSource addObjectsFromArray:self.cachedData];
    } else {
        [self.dataSource addObjectsFromArray:self.parserData];
    }
    
    
    [self.collectionView reloadData];
}

#pragma mark <UICollectionViewDataSource>

//SECTION
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//CELL
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}


//WILL DISPLAY CELL
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(CollectionVewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    //start downloading
    ItemObject* item = [self.dataSource objectAtIndex:indexPath.row];
    if (item.image.localLink) {
        cell.imageView.image = [[ServiceManager sharedManager] fetchImageFromSandBoxForItem:item];
        NSLog(@"from sandbox");
    } else {
        
        [[ServiceManager sharedManager] downloadImageForItem:item
                                            withImageQuality:ImageQualityLow
                                         withCompletionBlock:^(NSData *data) {
                                             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                 UIImage* img = [UIImage imageWithData:data];
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     cell.imageView.image = img;
                                                 });
                                             });
                                         }];
      }
}

//CELL REUSE
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionVewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    ItemObject* item = [self.dataSource objectAtIndex:indexPath.row];
    [cell setDataToLabelsFrom:item];
    
    return cell;
}




- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self.collectionView.collectionViewLayout invalidateLayout];
}

-(void)downloadingWasFinished:(NSArray*)result {
    [self.dataSource removeAllObjects];
    [self.parserData addObjectsFromArray:result];
    [self.dataSource addObjectsFromArray:self.parserData];
    
    [self.collectionView reloadData];
    NSLog(@"count = %lu",(unsigned long)self.dataSource.count);
}



#pragma mark <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}


// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    [self.collectionView cellForItemAtIndexPath:indexPath].backgroundColor = UIColor.whiteColor;
    ItemObject *item = [self.dataSource objectAtIndex:indexPath.row];
    [self.detail itemWasSelected:item];
    [self.splitViewController showDetailViewController:self.detail sender:self];
    
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSLog(@"item at %ld was tapped", (long)indexPath.row);
}


- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return YES;
}



#pragma mark <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake(CGRectGetWidth(collectionView.bounds), 120);
}



- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}



@end
