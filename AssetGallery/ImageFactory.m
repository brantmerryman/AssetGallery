//
//  ImageFactory.m
//  AssetGallery
//
//  Created by Brant Merryman on 1/27/13.
//  Copyright (c) 2013 ChristyBrantCo. All rights reserved.
//

#import "ImageFactory.h"

@implementation ImageFactory

+ (UIImage *)imageWithSize:(CGSize)sz color:(UIColor *)color text:(NSString *)text
{
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef imageContext = CGBitmapContextCreate(NULL,
                                                               sz.width,
                                                               sz.height,
                                                               8,
                                                               sz.width*4,
                                                               rgbColorSpace,
                                                               kCGImageAlphaPremultipliedFirst);
    
    CGColorSpaceRelease( rgbColorSpace );
    
    
    CGContextSetFillColorWithColor(imageContext, color.CGColor);
    
    CGContextFillRect(imageContext, CGRectMake(0,0,sz.width,sz.height));
    
    
    UIFont * f = [UIFont boldSystemFontOfSize:20.0f];
    
    CGContextSelectFont(imageContext, [f.fontName UTF8String], 72, kCGEncodingMacRoman);
    CGContextSetTextMatrix(imageContext, CGAffineTransformMakeScale(1, 1));
    CGContextSetStrokeColorWithColor(imageContext, [UIColor blackColor].CGColor);
    CGContextSetFillColorWithColor(imageContext, [UIColor blackColor].CGColor);
    CGContextSetShadowWithColor(imageContext, CGSizeMake(0.5, -0.75), 1.0, [[UIColor lightGrayColor] CGColor]);

    CGContextShowTextAtPoint(imageContext, 100, sz.height - 100, [text UTF8String], text.length);
    

    
    //finally turn the context into a CGImage
    CGImageRef cgImage = CGBitmapContextCreateImage(imageContext);
    
    
    UIImage * img = [UIImage imageWithCGImage:cgImage];
    
    return img;
}

+ (UIColor *)colorForInteger:(NSInteger)i
{
    UIColor * c = nil;
    
    switch (i) {
        case 0:
            c = [UIColor yellowColor];
            break;
        case 1:
            c = [UIColor orangeColor];
            break;
        case 2:
            c = [UIColor greenColor];
            break;
        case 3:
            c = [UIColor redColor];
            break;
        case 4:
            c = [UIColor cyanColor];
            break;
        case 5:
            c = [UIColor magentaColor];
            break;
        case 6:
            c = [UIColor purpleColor];
            break;
        case 7:
            c = [UIColor brownColor];
            break;
        case 8:
            c = [UIColor blueColor];
            break;
        case 9:
            c = [UIColor grayColor];
            break;
        default:
            c = [UIColor blackColor];
            break;
    }

    return c;
}



@end
