//
//  UIViewController+Photo.m
//  XXProjectNew
//
//  Created by apple on 11/29/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import "UIViewController+Photo.h"
#import "MinePageViewModel.h"
#import <objc/runtime.h>

// 自定义 sheetView

#import "MMSheetView.h"


@interface UIViewController()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>


@end

@implementation UIViewController (Photo)
-(void)changePortait{
    
    //身份判断
    
    if ( [MinePageViewModel model].user == visitor ) {
        
        
        return ;
    }
    
    
    
    //"UIActionSheet is deprecated. Use UIAlertController with a preferredStyle of UIAlertControllerStyleActionSheet instead"
    
    
    //MMSheetView
    
    void (^block1)() = ^(){
        
        [self selectProtait_UsingCamera:YES];

    };
    
    void (^block2)() = ^(){
        
        [self selectProtait_UsingCamera:NO];

    };
    
    
    
    NSArray *items =
  @[MMItemMake(@"拍照", MMItemTypeNormal, block1),
    MMItemMake(@"从相册中选取", MMItemTypeNormal, block2)];
    
    MMSheetView* sheetView = [[MMSheetView alloc] initWithTitle:nil items:items];
    
    
    sheetView.type = MMPopupTypeSheet;
    
    [MMPopupWindow sharedWindow].touchWildToHide = YES;
    
    [sheetView show];
    
    
    
    //kvc 修改
    //----------------------
    
    
    //遍历私有属性
    
    
    /*
     
     
    unsigned int count = 0;
    Ivar *property = class_copyIvarList([UIAlertAction class], &count);
    for (int i = 0; i < count; i++) {
        Ivar var = property[i];
        const char *name = ivar_getName(var);
        const char *type = ivar_getTypeEncoding(var);
        NSLog(@"%s =============== %s",name,type);
    }
    
    
     */

    
    /*
    
    UIAlertAction *sureAction=[UIAlertAction actionWithTitle:@"喵帕斯~" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];

    
      [sureAction setValue:title_Color forKey:@"titleTextColor"];
    
    [alertController addAction:sureAction];
     
     
     
     */
    
    
    //KVC 修改私有属性
    
    /*

    
    NSMutableAttributedString *hogan1 = [[NSMutableAttributedString alloc] initWithString:@"选择你的头像"];
    
    NSMutableAttributedString *hogan2 = [[NSMutableAttributedString alloc] initWithString:@"拍照或者从相册中选取一张照片"];
    
    [hogan1 addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} range:NSMakeRange(0, hogan1.length)];
    
    [hogan2 addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} range:NSMakeRange(0, hogan2.length)];
    
    [alertController setValue:hogan1 forKey:@"attributedTitle"];//attributedMessage
    
    
    [alertController setValue:hogan2 forKey:@"attributedDetailMessage"];
     
     */
    
    //----------------------
    
    /*
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:@"提示"];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 2)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 2)];
    
    
    
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }]];

    
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        [self selectProtait_UsingCamera:YES];
        
    }]];
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        [self selectProtait_UsingCamera:NO];
        
    }]];
    
    
    
    
    // 由于它是一个控制器 直接modal出来就好了
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
     */

    
    
}



-(void)selectProtait_UsingCamera:(BOOL)res{
    
    
    //调用系统相册的类
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    
    //
    //设置选取的照片是否可编辑
    pickerController.allowsEditing = YES;
    //设置相册呈现的样式
    
    
    
    //    pickerController.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;//图片分组列表样式
    
    if (res) {
        
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }else{
        
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }
    //照片的选取样式还有以下两种
    //UIImagePickerControllerSourceTypePhotoLibrary,直接全部呈现系统相册
    //UIImagePickerControllerSourceTypeCamera//调取摄像头
    
    //选择完成图片或者点击取消按钮都是通过代理来操作我们所需要的逻辑过程
    
    pickerController.delegate = self;
    
    //使用模态呈现相册
    [self presentViewController:pickerController animated:YES completion:^{
        
    }];
}


-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
//    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    //获取图片后的操作
    
    
    //    self.headView.headimgV.image = image;
    
    
    
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}


-(void)popToNewWebPage : (NSString*)str{
    
//    WKWebVC *web = [[WKWebVC alloc]initWithNibName:@"WKWebVC" bundle:nil];
    WYWebController *web = [WYWebController new];
    web.urlstr = str;
    
    web.hidesBottomBarWhenPushed = YES;
    
    
    if (str.length) {
        
        
        [self.navigationController pushViewController:web animated:YES];
        
    }
    
    
        
        
        
        
    
        
        
        
        
    
    

    
    
}



@end
