//
//  WebViewController.m
//  AcceralationTest01
//
//  Created by 天野 裕介 on 12/07/07.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

UIWebView *webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 434)];
    [self.view addSubview:webView];
    
    //UIToolbarの生成
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 414, 320, 46)];
    
    //戻るボタンの生成
    UIBarButtonItem *goBackButton = [[UIBarButtonItem alloc] init];
    goBackButton.title = @"戻る";
    goBackButton.style = UIBarButtonItemStyleBordered;
    goBackButton.target = self;
    goBackButton.action = @selector(goBack);
    
    //進むボタンの生成
    UIBarButtonItem *goFowardButton = [[UIBarButtonItem alloc]init];
    goFowardButton.title = @"進む";
    goFowardButton.style = UIBarButtonItemStyleBordered;
    goFowardButton.target = self;
    goFowardButton.action = @selector(goFoward);
    
    //更新ボタンの生成
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc]init];
    reloadButton.title = @"更新";
    reloadButton.style = UIBarButtonItemStyleBordered;
    reloadButton.target = self;
    reloadButton.action = @selector(reloadWebView);
    
    //ツールバーアイテムをツールバーに追加
    NSArray *elements = [NSArray arrayWithObjects:goBackButton, goFowardButton, reloadButton, nil];
    [toolBar setItems:elements animated:NO];
    
    //ツールバーをビューに追加
    [self.view addSubview:toolBar];
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
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: url]]];
}

- (void)goBack {
    [webView goBack];
    
}

- (void)goFoward {
    [webView goForward];
}

- (void)reloadWebView {
    [webView reload];
}

@end
