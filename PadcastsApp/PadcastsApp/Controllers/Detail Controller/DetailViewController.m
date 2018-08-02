//
//  DetailViewController.m
//  PadcastsApp
//
//  Created by Dzmitry Tarelkin on 7/24/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import "DetailViewController.h"
#import "ServiceManager.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>



@interface DetailViewController ()

@property (assign, nonatomic) SourceType itemType;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UILabel *authorLabel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *detailsLabel;

@property (strong, nonatomic) UIButton *downloadButton;

@property (strong, nonatomic) UIStackView* stackView;
@property (strong, nonatomic) ItemObject* item;
@property (strong, nonatomic) UIImageView* playImgView;

@property (strong, nonatomic) NSLayoutConstraint *changableConstraint;

-(void)playAudio;
-(void)downloadAction:(UIButton*)sender;
@end


static NSString * const kPlaceHolder = @"videoPlaceholder";

CGFloat multiplier = 0.5;

@implementation DetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"DetailController has been shown");
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        self.navigationItem.leftItemsSupplementBackButton = YES;
        self.view.backgroundColor = UIColor.whiteColor;
        [self setupViews];
    }
    return self;
}

-(void)setupViews {
    [self setupScrollView];
    [self setupImageView];
    [self setupDownloadButton];
    [self setupTitleLabel];
    [self setupAuthorLabel];
    [self setupDateLabel];
    [self setupDetailsLabel];
    [self createStackView];
    
    [self setupConstraints];
}


#pragma mark - Views Layouting
-(void)setupScrollView {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = UIColor.clearColor;
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.clipsToBounds = YES;
    [self.view addSubview: self.scrollView];
    
   
}

-(void)setupImageView {
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: kPlaceHolder]];
    self.imageView.layer.contentsGravity = kCAGravityResizeAspect;
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.layer.shadowColor = UIColor.lightGrayColor.CGColor;
    self.imageView.layer.shadowOffset = CGSizeMake(0, 5);
    self.imageView.layer.shadowOpacity = 0.8;
    self.imageView.layer.backgroundColor = UIColor.blackColor.CGColor;
    [self.imageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(tapGestureHandle:)];
    [self.imageView addGestureRecognizer:tap];
    [self.scrollView addSubview:self.imageView];
}



-(void)setupTitleLabel {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    UIFont* gillSans = [UIFont fontWithName:@"GillSans-Bold" size:26];
    self.titleLabel.font = gillSans;
    
    
    
    self.titleLabel.text = @"Title Details I have a simple requirement, I want to have color change effect on UIButton when a user touch on button";
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentNatural;
    self.titleLabel.numberOfLines = 0;
}

-(void)setupAuthorLabel {
    self.authorLabel = [[UILabel alloc] init];
    self.authorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.authorLabel.font = [UIFont fontWithName:@"Bodoni 72" size:20];
    self.authorLabel.text = @"Author";
    self.authorLabel.textAlignment = NSTextAlignmentLeft;
    self.authorLabel.textColor = [UIColor darkGrayColor];
}

-(void)setupDateLabel {
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.dateLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
    self.dateLabel.text = @"Date";
    self.dateLabel.textAlignment = NSTextAlignmentRight;
    self.dateLabel.textColor = [UIColor darkGrayColor];
}

-(void)setupDownloadButton {
    self.downloadButton = [[UIButton alloc] init];
    [self.downloadButton addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
    self.downloadButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.downloadButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.downloadButton.titleLabel.font = [UIFont fontWithName:@"Futura-Bold" size:20];;
    self.downloadButton.backgroundColor = UIColor.whiteColor;
    self.downloadButton.layer.cornerRadius = 10;
    [self.downloadButton setTitle:@"Download" forState:UIControlStateNormal];
    [self.downloadButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];

    self.downloadButton.layer.borderWidth = 1;
    self.downloadButton.layer.borderColor = UIColor.lightGrayColor.CGColor;
}


-(void)setupDetailsLabel {
    self.detailsLabel = [[UILabel alloc] init];
    self.detailsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.detailsLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];//[UIFont fontWithName:@"Bodoni 72" size:17];
    self.detailsLabel.text = @"Details";
    self.detailsLabel.textColor = [UIColor blackColor];
    self.detailsLabel.textAlignment = NSTextAlignmentNatural;
    self.detailsLabel.numberOfLines = 0;
    
}


-(void)createStackView {
    self.stackView = [[UIStackView alloc] initWithArrangedSubviews:
   @[self.authorLabel,self.titleLabel, self.dateLabel, self.downloadButton,self.detailsLabel]];

    [self.stackView setAxis:UILayoutConstraintAxisVertical];
    self.stackView.spacing = 10.f;
    [self.stackView setAlignment:UIStackViewAlignmentFill];
    [self.stackView setDistribution:UIStackViewDistributionFill];
    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.scrollView addSubview:self.stackView];
}


-(void)setupConstraints {
    //scrollView
    [NSLayoutConstraint activateConstraints:
     @[
       [self.scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:0],
       [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:0],
       [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:0],
       [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:0],
       ]];
    
    //changable constraint
    self.changableConstraint = [self.imageView.heightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.heightAnchor multiplier:0.5];
    
    //ImageView
    [NSLayoutConstraint activateConstraints:
     @[
       [self.imageView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor constant:0],
       [self.imageView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:0],
       [self.imageView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:0],
       self.changableConstraint,
       [self.imageView.widthAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.widthAnchor]
       ]];
    
    //StackView
    [NSLayoutConstraint activateConstraints:
     @[
       [self.stackView.topAnchor constraintEqualToAnchor:self.imageView.bottomAnchor constant:20],
       [self.stackView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:20],
       [self.stackView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-20],
       [self.stackView.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor constant:-20]
       ]];
}

#pragma mark - SizeClasses
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    NSLog(@"trait collection did change");
    [NSLayoutConstraint deactivateConstraints:@[self.changableConstraint]];
    
    if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact &&
        self.view.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) {
        
        self.changableConstraint = [self.imageView.heightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.heightAnchor multiplier:1];
    } else {
        self.changableConstraint = [self.imageView.heightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.heightAnchor multiplier:0.5];
    }
    [NSLayoutConstraint activateConstraints:@[self.changableConstraint]];
}



#pragma mark - Delegate
- (void)itemWasSelected:(ItemObject *)item {

    [[ServiceManager sharedManager] downloadImageForItem:item withImageQuality:ImageQualityHigh withCompletionBlock:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            UIImage* img = [UIImage imageWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.imageView setImage:img];
            });
        });
    }];
    
    self.authorLabel.text = item.author;
    self.titleLabel.text = item.title;
    self.dateLabel.text = item.publicationDate;
    self.detailsLabel.text = item.details;
    self.itemType = item.sourceType;
    self.item = item;
    
    if (item.isSaved) {
        [self.downloadButton setTitle:@"Saved" forState:UIControlStateNormal];
    }else {
        [self.downloadButton setTitle:@"Download" forState:UIControlStateNormal];
    }
        
}




-(void)tapGestureHandle:(UITapGestureRecognizer*)tap {
    AVPlayer *player;
    if (self.item.isSaved) {
         player = [AVPlayer playerWithURL:[NSURL URLWithString:self.item.content.webLink]]; //localLink for offLine mode
    } else {
         player = [AVPlayer playerWithURL:[NSURL URLWithString:self.item.content.webLink]];
    }
    
    AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
    
    [self presentViewController:controller animated:YES completion:^{
        controller.player = player;
        [player play];
    }];
    NSLog(@"playing video");
}

-(void)playAudioWithURL:(NSURL*)url {

}



-(void)downloadAction:(UIButton*)button {
    [self changeButton:button forState:UIControlStateHighlighted animated:YES];
    [self changeButton:button forState:UIControlStateNormal animated:YES];
    
    if (_item.isSaved == NO) {
        _item.isSaved = YES;
        [self.downloadButton setTitle:@"Saved" forState:UIControlStateNormal];
        [[ServiceManager sharedManager] saveItemIntoCoreData:_item];

//      [[ServiceManager sharedManager] downloadContentForItem:_item];
    } else {
        [[ServiceManager sharedManager] deleteItemFromCoredata:_item];
        _item.isSaved = NO;
        [self.downloadButton setTitle:@"Download" forState:UIControlStateNormal];
    }
    
    [[ServiceManager sharedManager].delegate reloadChangedDataOfCollectionView];
    
}


- (void)changeButton:(UIButton*)button forState:(UIControlState)state animated:(BOOL)isAnimated {
    
    if (isAnimated) {
        [UIView animateWithDuration:1 animations:^{
            if (state == UIControlStateNormal) {
                button.backgroundColor = UIColor.whiteColor;
            } else {
                button.backgroundColor = UIColor.greenColor;
            }
        }];
    }
}

@end
