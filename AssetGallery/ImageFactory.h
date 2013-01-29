//
//  ImageFactory.h
//  AssetGallery
//
//  Created by Brant Merryman on 1/27/13.
//  Copyright (c) 2013 ChristyBrantCo. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
    Make images for testing.
 */

@interface ImageFactory : NSObject

+ (UIImage *)imageWithSize:(CGSize)sz color:(UIColor *)color text:(NSString *)text;

+ (UIColor *)colorForInteger:(NSInteger)i;

@end
