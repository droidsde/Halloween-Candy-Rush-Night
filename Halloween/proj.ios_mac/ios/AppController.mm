/****************************************************************************
 Copyright (c) 2010 cocos2d-x.org
 
 http://www.cocos2d-x.org
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/

#import "AppController.h"
#import "platform/ios/CCEAGLView-ios.h"
#import "cocos2d.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "BannerViewController.h"

@implementation AppController{
    BannerViewController *_bannerViewController;
}

#pragma mark -
#pragma mark Application lifecycle

// cocos2d application instance
static AppDelegate s_sharedApplication;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    cocos2d::Application *app = cocos2d::Application::getInstance();
    app->initGLContextAttrs();
    cocos2d::GLViewImpl::convertAttrs();
    
    // Override point for customization after application launch.
    
    // Add the view controller's view to the window and display.
    window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    
    // Init the CCEAGLView
    CCEAGLView *eaglView = [CCEAGLView viewWithFrame: [window bounds]
                                         pixelFormat: (NSString*)cocos2d::GLViewImpl::_pixelFormat
                                         depthFormat: cocos2d::GLViewImpl::_depthFormat
                                  preserveBackbuffer: NO
                                          sharegroup: nil
                                       multiSampling: NO
                                     numberOfSamples: 0 ];
    
    // Use RootViewController manage CCEAGLView
    viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
    viewController.wantsFullScreenLayout = YES;
    viewController.view = eaglView;
    
    bannerAd = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    bannerAd.adUnitID = @"ca-app-pub-2034843604618027/1432404796";
    bannerAd.rootViewController = viewController;
    [bannerAd setDelegate:self];//设置代理
    [viewController.view addSubview:bannerAd];
    GADRequest* request = [GADRequest request];
    [bannerAd loadRequest:request];
    //设置广告显示在屏幕的顶部中心位置（横屏情况下）
    //CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    //[bannerAd setCenter:CGPointMake(0, bannerAd.center.y)];
    
    // Set RootViewController to window
    if ( [[UIDevice currentDevice].systemVersion floatValue] < 6.0)
    {
        // warning: addSubView doesn't work on iOS6
        [window addSubview: viewController.view];
    }
    else
    {
        // use this method on ios6
        [window setRootViewController:viewController];
    }
    
    [window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setStatusBarHidden:true];
    
    // IMPORTANT: Setting the GLView should be done after creating the RootViewController
    cocos2d::GLView *glview = cocos2d::GLViewImpl::createWithEAGLView(eaglView);
    cocos2d::Director::getInstance()->setOpenGLView(glview);
    
    app->run();
    
    return YES;
}

/*
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
 
 cocos2d::Application *app = cocos2d::Application::getInstance();
 app->initGLContextAttrs();
 cocos2d::GLViewImpl::convertAttrs();
 
 // Override point for customization after application launch.
 
 // Add the view controller's view to the window and display.
 window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
 
 // Init the CCEAGLView
 CCEAGLView *eaglView = [CCEAGLView viewWithFrame: [window bounds]
 pixelFormat: (NSString*)cocos2d::GLViewImpl::_pixelFormat
 depthFormat: cocos2d::GLViewImpl::_depthFormat
 preserveBackbuffer: NO
 sharegroup: nil
 multiSampling: NO
 numberOfSamples: 0 ];
 
 // Use RootViewController manage EAGLView
 viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
 viewController.wantsFullScreenLayout = YES;
 viewController.view = eaglView;
 
 _bannerViewController = [[BannerViewController alloc] initWithContentViewController:viewController];
 
 // Set RootViewController to window
 if ( [[UIDevice currentDevice].systemVersion floatValue] < 6.0)
 {
 // warning: addSubView doesn't work on iOS6
 [window addSubview: _bannerViewController.view];
 }
 else
 {
 // use this method on ios6
 [window setRootViewController:_bannerViewController];
 }
 
 
 [window makeKeyAndVisible];
 
 [[UIApplication sharedApplication] setStatusBarHidden:true];
 
 // IMPORTANT: Setting the GLView should be done after creating the RootViewController
 cocos2d::GLView *glview = cocos2d::GLViewImpl::createWithEAGLView(eaglView);
 cocos2d::Director::getInstance()->setOpenGLView(glview);
 
 app->run();
 
 return YES;
 }
 
 */
- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    //We don't need to call this method any more. It will interupt user defined game pause&resume logic
    /* cocos2d::Director::getInstance()->pause(); */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    //We don't need to call this method any more. It will interupt user defined game pause&resume logic
    /* cocos2d::Director::getInstance()->resume(); */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    cocos2d::Application::getInstance()->applicationDidEnterBackground();
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    cocos2d::Application::getInstance()->applicationWillEnterForeground();
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

- (void) hideAdmobBanner{
    [_bannerViewController hideBanner];
}

- (void) showAdmobBanner{
    [_bannerViewController showBanner];
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}

//实现GADBannerView的代理函数
- (void)adViewDidReceiveAd:(GADBannerView *)view {
    NSLog(@"Received admob banner ad");
}

-(void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    [view setHidden:YES];
    NSLog(@"Failed to receive ad %@", [error localizedDescription]);
}

@end