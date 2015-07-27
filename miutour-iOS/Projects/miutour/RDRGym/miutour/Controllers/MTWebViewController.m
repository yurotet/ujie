//
//  MTWebViewController.m
//  miutour
//
//  Created by Ge on 7/6/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTWebViewController.h"
@interface MTWebViewController ()

@property (nonatomic,strong)UIActivityIndicatorView *activityIndicator;

@end

@implementation MTWebViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Uncomment to override the CDVCommandDelegateImpl used
        // _commandDelegate = [[MTWebCommandDelegate alloc] initWithViewController:self];
        // Uncomment to override the CDVCommandQueue used
        // _commandQueue = [[MTWebCommandQueue alloc] initWithViewController:self];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Uncomment to override the CDVCommandDelegateImpl used
        // _commandDelegate = [[MTWebCommandDelegate alloc] initWithViewController:self];
        // Uncomment to override the CDVCommandQueue used
        // _commandQueue = [[MTWebCommandQueue alloc] initWithViewController:self];
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
    self.navigationController.navigationBar.hidden = YES;

    //    CGRect tmpFrame = self.view.frame;
    //    tmpFrame.origin.y += 64;
    //    tmpFrame.size.height -= 64;
    //    self.view.frame = tmpFrame;
    //    self.webView.backgroundColor = [UIColor colorWithBackgroundColorMark:14];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the MTWeb view.
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
    self.title = [theWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    //    theWebView.scrollView.scrollEnabled = NO;
    [_activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
    
    return [super webViewDidFinishLoad:theWebView];
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    //创建UIActivityIndicatorView背底半透明View
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    [view setTag:108];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.5];
    [self.view addSubview:view];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [_activityIndicator setCenter:view.center];
    [_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [view addSubview:_activityIndicator];
    
    [_activityIndicator startAnimating];
    return [super webViewDidStartLoad:webView];
}

- (void) webView:(UIWebView*)theWebView didFailLoadWithError:(NSError*)error
{
    [_activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
}

- (BOOL) webView:(UIWebView*)theWebView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    return [super webView:theWebView shouldStartLoadWithRequest:request navigationType:navigationType];
}

@end

@implementation MTWebCommandDelegate

/* To override the methods, uncomment the line in the init function(s)
 in MTWebViewController.m
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

@implementation MTWebCommandQueue

/* To override, uncomment the line in the init function(s)
 in MTWebViewController.m
 */
- (BOOL)execute:(CDVInvokedUrlCommand*)command
{
    return [super execute:command];
}

@end
