//
//  AppDelegate.m
//  AssetGallery
//
//  Created by Brant Merryman on 1/27/13.
//  Copyright (c) 2013 ChristyBrantCo. All rights reserved.
//

#import "AppDelegate.h"
#import "ImageFactory.h"
#import "AssetGalleryViewController.h"

#define TEST_GALLERY_SIZE 50

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = [AssetGalleryViewController assetGalleryViewController];
    
#if 0
    NSMutableArray * ma = [NSMutableArray arrayWithCapacity:TEST_GALLERY_SIZE];
    

    for (int i = 0;i<TEST_GALLERY_SIZE;++i) {
        [ma addObject: [ImageFactory imageWithSize:CGSizeMake(320, 480) color:[ImageFactory colorForInteger:i % 10] text:[NSString stringWithFormat:@"%d", i]]];
    }
    
    [AssetGalleryViewController assetGalleryViewController].assets = [NSArray arrayWithArray:ma];
#else
    
    NSString * assetFolderPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Assets"];
    
    NSDirectoryEnumerator * de = [[NSFileManager defaultManager] enumeratorAtPath:assetFolderPath ];
    NSArray * assets = [de allObjects];
    NSMutableArray * ma = [NSMutableArray arrayWithCapacity:assets.count];
    for (NSString * fileName in assets) {
        
        [ma addObject: [UIImage imageWithData:[NSData dataWithContentsOfFile: [assetFolderPath stringByAppendingPathComponent:fileName] ]] ];
    }

    
    [AssetGalleryViewController assetGalleryViewController].assets = [ma copy];
    
#endif
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
