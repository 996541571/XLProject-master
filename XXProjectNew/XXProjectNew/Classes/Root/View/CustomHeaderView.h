//
//  CellHeaderView.h
//  XXProjectNew
//
//  Created by apple on 16/9/6.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomHeaderView : UIView
{
    UIImageView*headImg;
    UILabel*label;
    UIImageView*arrowImgView;
    UILabel*moreLabel;
    UILabel*seperateLabel;
    UIButton*headerBtn;
    UILabel*dataLabel;
}
@property(nonatomic,copy)void (^headerClickBlock)(int tag);
- (instancetype)initWithFrame:(CGRect)frame labelNameStr:(NSString*)labelName imageNameStr:(NSString*)imagenameStr section:(NSInteger)section dataValue:(NSString*)dataValue;
@end
