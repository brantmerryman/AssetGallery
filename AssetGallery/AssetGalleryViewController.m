//
//  AssetGalleryViewController.m
//  AssetGallery
//
//  Created by Brant Merryman on 1/27/13.
//  Copyright (c) 2013 ChristyBrantCo. All rights reserved.
//

#import "AssetGalleryViewController.h"
#import "AssetPage.h"

@interface AssetGalleryViewController () {

    BOOL ignoreScroll;
    
    NSUInteger currentPage;
    
    NSMutableArray * assetPages;
}

@property (readonly) NSInteger numberOfPages;

@end

static AssetGalleryViewController * _assetGalleryViewController_ = nil;

@implementation AssetGalleryViewController


@synthesize assets, assetMode;

+(AssetGalleryViewController *)assetGalleryViewController
{
    if (nil == _assetGalleryViewController_) {
        _assetGalleryViewController_ = [[AssetGalleryViewController alloc] initWithNibName:@"AssetGalleryViewController" bundle:nil];
    }
    return _assetGalleryViewController_;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        assetMode = AssetModeFourView;
        currentPage = 0;
        ignoreScroll = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadPages];
}


- (void)loadPages
{
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width * self.numberOfPages, scrollView.frame.size.height)];

    assetPages = [[NSMutableArray alloc] initWithCapacity:3];
    for (int i = 0; i < 3; ++i) {
        AssetPage * ap = [AssetPage assetPage];
        ap.frame = CGRectMake(i * scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height);
        
        ap.v0.image = [self assetForIndex: (i*4)+0];
        ap.v1.image = [self assetForIndex: (i*4)+1];
        ap.v2.image = [self assetForIndex: (i*4)+2];
        ap.v3.image = [self assetForIndex: (i*4)+3];
        
        [scrollView addSubview:ap];
        [assetPages addObject:ap];
    }
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfPages
{
    NSInteger np = self.assets.count;
    
    if (AssetModeFourView == assetMode) {
        np /= 4;
        
        if (self.assets.count % 4) {
            ++np;
        }
    }
    
    return np;
}

- (UIImage *)assetForIndex:(NSInteger)i
{
    UIImage * img = nil;
    if (i >= 0 && i < self.assets.count) {
        
        id the_asset = [self.assets objectAtIndex:i];
        
        if ([the_asset isKindOfClass:[UIImage class]]) {
            img = the_asset;
        } else if ([the_asset isKindOfClass:[NSString class]]) {
            img = [UIImage imageWithData:[NSData dataWithContentsOfFile:the_asset]];
        }
        
    }
    return img;
}

#pragma mark UIScrollViewDelegate Methods

- (void)loadPage:(AssetPage *)ap withAssetIndex:(NSInteger)i
{
    if (AssetModeFourView == self.assetMode) {
        ap.v0.image = [self assetForIndex: (i*4)+0];
        ap.v1.image = [self assetForIndex: (i*4)+1];
        ap.v2.image = [self assetForIndex: (i*4)+2];
        ap.v3.image = [self assetForIndex: (i*4)+3];
    } else if (AssetModeSingleView == self.assetMode) {
        
        
        if (ap.singleImageView) {
            ap.singleImageView.frame = ap.oldSingleImageBounds;
            ap.singleImageView = nil;
        }
        
        NSArray * assetViewsArray = [NSArray arrayWithObjects:ap.v0, ap.v1, ap.v2, ap.v3, nil];
        AssetView * av2Load = [assetViewsArray objectAtIndex: i % 4];


        for (int j = 0; j < 4; ++j) {
            AssetView * av = [assetViewsArray objectAtIndex:j];
            
            NSInteger myIndex = i + ([assetViewsArray indexOfObject:av] - (i % 4));

            av.image = [self assetForIndex: myIndex];
            if (av != av2Load) {
                [av setAlpha:0.0f];
            } else {
                [av setAlpha:1.0f];
            }
        }
        
        ap.oldSingleImageBounds = av2Load.frame;
        ap.singleImageView = av2Load;
        
        CGRect f;
        f.origin.x = ap.v0.frame.origin.x;
        f.origin.y = ap.v0.frame.origin.y;
        f.size.width = ap.frame.size.width - (2 * f.origin.x);
        f.size.height = ap.frame.size.height - (2 * f.origin.y);
        av2Load.frame = f;

    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sv
{
    if (ignoreScroll)
        return;
    
    float fPage = sv.contentOffset.x / sv.frame.size.width;
    
    
    NSInteger iPage = (NSInteger) floorf(fPage + 0.5f);
    
    if (currentPage != iPage) {
        
        NSInteger difference = iPage - currentPage;
        
        NSAssert(-1 == difference || 1 == difference, @"Invalid page change.");
        
        
        
        switch (difference) {
            case -1:
            {
                if (iPage > 0 && iPage < (self.numberOfPages-2)) {
                // take back one and put it on the front.
                    AssetPage * page2Move = [assetPages objectAtIndex:2];
                    [assetPages removeObject:page2Move];
                    [assetPages insertObject:page2Move atIndex:0];
                    CGRect f = page2Move.frame;
                    f.origin.x -= 3.0f * f.size.width;
                    page2Move.frame = f;
                    [self loadPage:page2Move withAssetIndex: iPage-1];
                }
                
            }
                break;
            case 1:
            {
                if (iPage > 1 && iPage < (self.numberOfPages-1)) {
                // take the front one and put it on the back.
                    AssetPage * page2Move = [assetPages objectAtIndex:0];
                    [assetPages removeObject:page2Move];
                    [assetPages addObject:page2Move];
                    CGRect f = page2Move.frame;
                    f.origin.x += 3.0f * f.size.width;
                    page2Move.frame = f;
                    [self loadPage: page2Move withAssetIndex: iPage +1];
                }
            }
                break;
        }
        
        currentPage = iPage;
    }
}




- (void)showSingleImage:(AssetView *)av forPage:(AssetPage *)ap
{
    ap.singleImageView = av;
    ap.oldSingleImageBounds = av.frame;
    
    self.assetMode = AssetModeSingleView;
    
    ignoreScroll = YES;
    

    
    [UIView animateWithDuration:0.25f
                     animations:^{
                         CGRect f;
                         
                         
                         f = av.frame;
                         
                         f.origin.x = ap.v0.frame.origin.x;
                         f.origin.y = ap.v0.frame.origin.y;
                         f.size.width = ap.frame.size.width - (2 * f.origin.x);
                         f.size.height = ap.frame.size.height - (2 * f.origin.y);
                         av.frame = f;
                         
                         for (UIView * v in [NSArray arrayWithObjects:ap.v0, ap.v1, ap.v2, ap.v3, nil]) {
                             
                             if (v != av) {
                                 [v setAlpha:0.0f];
                             }
                         }
                     }
                     completion:^(BOOL fComplete){
                         if (fComplete) {
                             
                             CGRect f;
                             
                             scrollView.contentSize = CGSizeMake(self.numberOfPages * ap.frame.size.width, ap.frame.size.height);
                             
                             currentPage = [self.assets indexOfObject:av.image];
                             
                             [scrollView setContentOffset:CGPointMake(ap.frame.size.width * currentPage, 0)];
                             
                             f = ap.frame;
                             f.origin.x = ap.frame.size.width * currentPage;
                             ap.frame = f;
                             
                             AssetPage * ap0;
                             AssetPage * ap1;
                             AssetPage * ap2;
                             [assetPages removeObject:ap];
                             
                             if (0 == currentPage) {
                                 ap0 = ap;
                                 ap1 = [assetPages objectAtIndex:0];
                                 ap2 = [assetPages objectAtIndex:1];
                                 ap0.frame = CGRectMake(0, 0, ap.frame.size.width, ap.frame.size.height);
                                 ap1.frame = CGRectMake(ap.frame.size.width, 0, ap.frame.size.width, ap.frame.size.height);
                                 ap2.frame = CGRectMake(2.0f * ap.frame.size.width, 0, ap.frame.size.width, ap.frame.size.height);

                                 [self loadPage:ap1 withAssetIndex:1];
                                 [self loadPage:ap2 withAssetIndex:2];
                                 
                             } else if (currentPage == (self.numberOfPages-1) ) {
                                 ap2 = ap;
                                 ap0 = [assetPages objectAtIndex:0];
                                 ap1 = [assetPages objectAtIndex:1];
                                 
                                 
                                 ap0.frame = CGRectMake( (currentPage-2) * ap.frame.size.width , 0, ap.frame.size.width, ap.frame.size.height);
                                 ap1.frame = CGRectMake( (currentPage-1) * ap.frame.size.width, 0, ap.frame.size.width, ap.frame.size.height);
                                 ap2.frame = CGRectMake( (currentPage) * ap.frame.size.width, 0, ap.frame.size.width, ap.frame.size.height);

                                 [self loadPage:ap0 withAssetIndex:currentPage - 2];
                                 [self loadPage:ap1 withAssetIndex:currentPage - 1];
                                 
                             } else {
                                 ap0 = [assetPages objectAtIndex:0];
                                 ap1 = ap;
                                 ap2 = [assetPages objectAtIndex:1];
                                 
                                 
                                 ap0.frame = CGRectMake((currentPage-1) * ap.frame.size.width, 0, ap.frame.size.width, ap.frame.size.height);
                                 ap1.frame = CGRectMake(currentPage * ap.frame.size.width, 0, ap.frame.size.width, ap.frame.size.height);
                                 ap2.frame = CGRectMake((currentPage+1) * ap.frame.size.width, 0, ap.frame.size.width, ap.frame.size.height);
                                 
                                 [self loadPage:ap0 withAssetIndex:currentPage - 1];
                                 [self loadPage:ap2 withAssetIndex:currentPage + 1];
                             }
                             
                             assetPages = [NSMutableArray arrayWithObjects:ap0, ap1, ap2, nil];
                             

                             
                             
                             UIPinchGestureRecognizer * pgr = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
                             [scrollView addGestureRecognizer:pgr];
                         }
                         ignoreScroll = NO;
                     }];

}

- (void)pinchAction:(UIPinchGestureRecognizer *)pgr
{
    
    if (UIGestureRecognizerStateEnded == pgr.state) {
        
        if (pgr.scale < 1.0 && pgr.velocity < 0) {
            
            ignoreScroll = YES;
            
            
            
            AssetPage * ap = nil;
            if (0 == currentPage) {
                ap = [assetPages objectAtIndex:0];
                currentPage = 0;
            } else if (currentPage == (self.numberOfPages - 1)) {
                ap = [assetPages objectAtIndex:2];
                self.assetMode = AssetModeFourView;
                currentPage = self.numberOfPages -1;
            } else {
                ap = [assetPages objectAtIndex:1];
                currentPage /= 4;
            }

            self.assetMode = AssetModeFourView;

            
            [UIView animateWithDuration:0.25f
                             animations:^{
                                 
                                 ap.singleImageView.frame = ap.oldSingleImageBounds;
                                 
                                 for (UIView * v in [NSArray arrayWithObjects:ap.v0, ap.v1, ap.v2, ap.v3, nil]) {
                                     
                                     if (v != ap.singleImageView) {
                                         [v setAlpha:1.0f];
                                     }
                                 }
                                 
                             }
                             completion:^(BOOL fFinished){
                                 if (fFinished) {
                                     ap.singleImageView = nil;
                                     ap.oldSingleImageBounds = CGRectZero;

                                 
                                     scrollView.contentSize = CGSizeMake(self.numberOfPages * ap.frame.size.width, ap.frame.size.height);
                                 
                                     for (int i=0;i<3;++i) {
                                         int cpi = (currentPage-1) + i;
                                         
                                         if (0 == currentPage) {
                                             ++cpi;
                                         } else if (currentPage == (self.numberOfPages - 1)) {
                                             --cpi;
                                         }
                                     
                                         AssetPage * ap_ = [assetPages objectAtIndex:i];
                                         ap_.frame = CGRectMake(cpi * ap_.frame.size.width, 0, ap_.frame.size.width, ap_.frame.size.height);

                                         [ap_ fourViewMode];
                                         [self loadPage:ap_ withAssetIndex:cpi];
                                         
                                         
                                     }
                                     
                                     [scrollView setContentOffset:CGPointMake(currentPage * scrollView.frame.size.width, 0) animated:NO];

                                     ignoreScroll = NO;
                                 }
                             }];
            
            [scrollView removeGestureRecognizer:pgr];
            
        }
    }
    
}

@end
