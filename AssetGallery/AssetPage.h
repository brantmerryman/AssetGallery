//
//  AssetPage.h
//  AssetGallery
//
//  Created by Brant Merryman on 1/27/13.
//  Copyright (c) 2013 ChristyBrantCo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetView.h"


@interface AssetPage : UIView {
 
    IBOutlet AssetView * v0;
    IBOutlet AssetView * v1;
    IBOutlet AssetView * v2;
    IBOutlet AssetView * v3;
    
    AssetView * singleImageView;
    CGRect oldSingleImageBounds;
}

+ (AssetPage *)assetPage;

- (void)fourViewMode;

@property (readwrite) AssetView * v0;
@property (readwrite) AssetView * v1;
@property (readwrite) AssetView * v2;
@property (readwrite) AssetView * v3;

@property (readwrite) AssetView * singleImageView;
@property (readwrite) CGRect oldSingleImageBounds;

@end
