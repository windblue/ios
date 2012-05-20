//
//  WebViewController.m
//  WebViewTest01
//
//  Created by 天野 裕介 on 12/05/20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () {
    UIWebView *webView;
}

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:webView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)kick:(NSString *)url
{
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    //UserAgentをセットします
    NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    [urlRequest setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    
    //urlにアクセスします
    NSHTTPURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest
                                                 returningResponse:&response 
                                                             error:&error];
    //何らかのエラーが出たとき
    if ([response statusCode] >= 400 || error) {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"エラー" 
                                   message:[NSString stringWithFormat:@"HTTP STATUS CODE:%d", [response statusCode]]
                                  delegate:self 
                         cancelButtonTitle:@"確認" otherButtonTitles:nil];
        [alert show];
    }
    //正常なレスポンスのとき
    else {
        [webView loadData:responseData MIMEType:[response MIMEType] 
          textEncodingName:[response textEncodingName] 
                   baseURL:[response URL]];
        [self setView:webView];
    }
}

@end
