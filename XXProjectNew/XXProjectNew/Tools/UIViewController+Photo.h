//
//  UIViewController+Photo.h
//  XXProjectNew
//
//  Created by apple on 11/29/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Photo)
-(void)changePortait;
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker;
-(void)popToNewWebPage : (NSString*)str;

@end
