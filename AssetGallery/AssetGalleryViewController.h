//
//  AssetGalleryViewController.h
//  AssetGallery
//
//  Created by Brant Merryman on 1/27/13.
//  Copyright (c) 2013 ChristyBrantCo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AssetView;
@class AssetPage;

typedef enum {
     AssetModeFourView
    ,AssetModeSingleView
    
} AssetMode;

@interface AssetGalleryViewController : UIViewController <UIScrollViewDelegate> {
 
    NSArray * assets;

    IBOutlet UIScrollView * scrollView;

    AssetMode assetMode;
}

+ (AssetGalleryViewController *)assetGalleryViewController;
- (void)showSingleImage:(AssetView *)av forPage:(AssetPage *)ap;

@property (readwrite) NSArray * assets;
@property (readwrite) AssetMode assetMode;

@end
