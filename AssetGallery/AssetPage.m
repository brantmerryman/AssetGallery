//
//  AssetPage.m
//  AssetGallery
//
//  Created by Brant Merryman on 1/27/13.
//  Copyright (c) 2013 ChristyBrantCo. All rights reserved.
//

#import "AssetPage.h"
#import "AssetGalleryViewController.h"

@implementation AssetPage

@synthesize v0,v1,v2,v3;
@synthesize oldSingleImageBounds;
@synthesize singleImageView;

+ (AssetPage *)assetPage
{
    AssetPage * ap = nil;
    NSArray * objects = [[NSBundle mainBundle] loadNibNamed:@"AssetPage" owner:nil options:nil];
    
    for (id myObj in objects) {
        if ([myObj isKindOfClass:[AssetPage class]]) {
            ap = myObj;
        }
    }
    
    if (nil == ap) {
        NSLog(@"** Warning: Could not load AssetPage");
    }
    
    return ap;
}

- (void)fourViewMode
{
    self.singleImageView.frame = self.oldSingleImageBounds;
    self.oldSingleImageBounds = CGRectZero;
    self.singleImageView = nil;
    [v0 setAlpha:1.0f];
    [v1 setAlpha:1.0f];
    [v2 setAlpha:1.0f];
    [v3 setAlpha:1.0f];
}



@end


