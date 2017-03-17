//
//  UIWebView+HideURL.m
//  XXProjectNew
//
//  Created by apple on 2016/10/13.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "UIWebView+HideURL.h"

@implementation UIWebView (HideURL)
-(void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame
{
    UIAlertView* customAlert = [[UIAlertView alloc] initWithTitle:@""
                                                          message:message
                                                         delegate:nil
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
    
    [customAlert show];
}
@end
