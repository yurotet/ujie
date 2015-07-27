//
//  MTAddCarViewController.m
//  miutour
//
//  Created by Ge on 13/7/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTAddCarViewController.h"

@interface MTAddCarViewController()

@property (nonatomic,assign)BOOL naviHidden;

@end

@implementation MTAddCarViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Uncomment to override the CDVCommandDelegateImpl used
        // _commandDelegate = [[MainCommandDelegate alloc] initWithViewController:self];
        // Uncomment to override the CDVCommandQueue used
        // _commandQueue = [[MainCommandQueue alloc] initWithViewController:self];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Uncomment to override the CDVCommandDelegateImpl used
        // _commandDelegate = [[MainCommandDelegate alloc] initWithViewController:self];
        // Uncomment to override the CDVCommandQueue used
        // _commandQueue = [[MainCommandQueue alloc] initWithViewController:self];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    // View defaults to full size.  If you want to customize the view's size, or its subviews (e.g. webView),
    // you can do so here.
    
    [super viewWillAppear:animated];
    
    //    tmpFrame.size.height -= 64;
    self.webView.backgroundColor = [UIColor colorWithBackgroundColorMark:14];
    self.webView.scrollView.scrollEnabled = NO;
    _naviHidden = self.navigationController.navigationBar.hidden;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = _naviHidden;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CGRect tmpFrame = self.webView.frame;
    tmpFrame.origin.y -= 64;
    self.webView.frame = tmpFrame;
    self.view.backgroundColor = [UIColor colorWithBackgroundColorMark:14];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    //    [self.view addHUDActivityViewForLoadingWithHintsText:@"正在加载..."];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    //    [self.view removeHUDActivityView];
}

-(void)efNavleftButtonClick:(id)sender
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
    else
    {
        [super efNavleftButtonClick:sender];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

/* Comment out the block below to over-ride */

/*
 - (UIWebView*) newCordovaViewWithFrame:(CGRect)bounds
 {
 return[super newCordovaViewWithFrame:bounds];
 }
 */

#pragma mark UIWebDelegate implementation

- (void)webViewDidFinishLoad:(UIWebView*)theWebView
{
    // Black base color for background matches the native apps
    [self.view removeHUDActivityView];
    
    self.title = [theWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    //    theWebView.scrollView.scrollEnabled = NO;
    return [super webViewDidFinishLoad:theWebView];
}

/* Comment out the block below to over-ride */

/*
 
 - (void) webViewDidStartLoad:(UIWebView*)theWebView
 {
 return [super webViewDidStartLoad:theWebView];
 }
 
 - (void) webView:(UIWebView*)theWebView didFailLoadWithError:(NSError*)error
 {
 return [super webView:theWebView didFailLoadWithError:error];
 }
 
 - (BOOL) webView:(UIWebView*)theWebView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
 {
 return [super webView:theWebView shouldStartLoadWithRequest:request navigationType:navigationType];
 }
 */

@end

@implementation MTAddCarCommandDelegate

/* To override the methods, uncomment the line in the init function(s)
 in MTAddCarPWViewController.m
 */

#pragma mark CDVCommandDelegate implementation

- (id)getCommandInstance:(NSString*)className
{
    return [super getCommandInstance:className];
}

- (NSString*)pathForResource:(NSString*)resourcepath
{
    return [super pathForResource:resourcepath];
}

@end

@implementation MTAddCarCommandQueue

/* To override, uncomment the line in the init function(s)
 in MTAddCarPWViewController.m
 */
- (BOOL)execute:(CDVInvokedUrlCommand*)command
{
    return [super execute:command];
}

@end
