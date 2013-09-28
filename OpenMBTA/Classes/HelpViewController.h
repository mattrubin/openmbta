//
//  HelpViewController.h
//  OpenMBTA
//
//  Created by Daniel Choi on 10/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerUrl.h"

@interface HelpViewController : UIViewController <UIWebViewDelegate> {
    NSString *viewName;
    IBOutlet UIWebView *webView;
    NSURLRequest *request;    
    NSString *transportType;
    
    
        UIView *progressView;
    
    
    
}
@property (strong, nonatomic) UIView *progressView;
@property (nonatomic, copy) NSString *viewName;
@property (nonatomic, copy) NSString *transportType;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURLRequest *request;
- (IBAction)doneButtonPressed:(id)sender;
- (void)showLoadingIndicators;
- (void)hideLoadingIndicators;
- (void)loadWebView;
@end
