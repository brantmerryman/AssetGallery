//
//  AssetView.m
//  AssetGallery
//
//  Created by Brant Merryman on 1/27/13.
//  Copyright (c) 2013 ChristyBrantCo. All rights reserved.
//

#import "AssetView.h"
#import "AssetPage.h"
#import "AssetGalleryViewController.h"

@implementation AssetView

- (void)awakeFromNib
{
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (void)tapAction:(UITapGestureRecognizer *)tgr
{
    if (AssetModeFourView == [AssetGalleryViewController assetGalleryViewController].assetMode) {
        if ([self.superview isKindOfClass:[AssetPage class]]) {
            AssetPage * ap = (AssetPage *) self.superview;
            [[AssetGalleryViewController assetGalleryViewController] showSingleImage:self forPage:ap];
            
        }
    }
}

@end
