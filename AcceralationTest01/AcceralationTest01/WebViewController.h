//
//  WebViewController.h
//  AcceralationTest01
//
//  Created by 天野 裕介 on 12/07/07.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>

- (void)kick:(NSString *)url;

@end
