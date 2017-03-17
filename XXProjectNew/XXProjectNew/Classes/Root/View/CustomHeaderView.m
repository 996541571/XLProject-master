//
//  CellHeaderView.m
//  XXProjectNew
//
//  Created by apple on 16/9/6.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "CustomHeaderView.h"

@implementation CustomHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame labelNameStr:(NSString*)labelName imageNameStr:(NSString*)imagenameStr section:(NSInteger)section dataValue:(NSString*)dataValue
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGPoint viewPoint=self.center;
        if (!headImg) {
            headImg=[[UIImageView alloc]initWithFrame:CGRectMake(16, viewPoint.y-10, 17, 20)];
            [self addSubview:headImg];
            label=[[UILabel alloc]init];
            [self addSubview:label];
            arrowImgView=[[UIImageView alloc]initWithFrame:CGRectMake(screenWidth-16-8, viewPoint.y-8.5, 8, 15)];
            [self addSubview:arrowImgView];
            moreLabel=[[UILabel alloc]init];
            [self addSubview:moreLabel];
            seperateLabel=[[UILabel alloc]init];
            [self addSubview:seperateLabel];
            headerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [self addSubview:headerBtn];
            dataLabel=[[UILabel alloc]init];
            [self addSubview:dataLabel];
        }
        headImg.image=[UIImage imageNamed:imagenameStr];
        label.text=labelName;
        
        label.frame=CGRectMake(16+17+10, viewPoint.y-9, 66, 18);
        label.font=[UIFont systemFontOfSize:16];
        label.textAlignment=NSTextAlignmentCenter;
        
//        label.textColor=RGB(47, 150, 255, 1);
        label.textColor = title_redColor;
        
        arrowImgView.image=[UIImage imageNamed:@"arrow"];
        moreLabel.text=@"更多";
        
        moreLabel.frame=CGRectMake(screenWidth-16-8-7-30, viewPoint.y-7.5, 30, 15);
        moreLabel.font=[UIFont systemFontOfSize:14];
        moreLabel.textAlignment=NSTextAlignmentCenter;
        
        moreLabel.textColor=RGB(170, 170, 170, 1);
        
        seperateLabel.frame=CGRectMake(0,frame.size.height-1 , screenWidth, 0.5);
//        seperateLabel.backgroundColor = RGB(238,238,238,1.0f);
        
        seperateLabel.backgroundColor = RGB(170, 170, 170, 1);

        
        
        headerBtn.frame=CGRectMake(0, 0, screenWidth, self.frame.size.height);
        [headerBtn addTarget:self action:@selector(headerClick:) forControlEvents:UIControlEventTouchUpInside];
        headerBtn.tag=10000+section;
        
        if (section==1) {
            //数据统计时间label
//            dataLabel.backgroundColor=[UIColor redColor];
            dataLabel.font=[UIFont systemFontOfSize:9];
            dataLabel.textColor=RGB(170, 170, 170, 1);

            
            dataLabel.frame=CGRectMake(16+17+10,label.frame.origin.y+18+2 , 200, 12);
//            dataLabel.text=@"数据统计时间:null";
            dataLabel.backgroundColor = RGB(238,238,238,1.0f);
            dataLabel.text=[NSString stringWithFormat:@"数据统计时间:%@",dataValue];
            dataLabel.backgroundColor=[UIColor clearColor];


            if ([dataValue isEqualToString:@"暂无数据"]) {
                dataLabel.text=dataValue;
                [dataLabel removeFromSuperview];
            }
            
            
            

            
        }



    //DV edited
        
        
        
//        UIView * deviationView = [UIView new];
//        
//        [self addSubview:deviationView];
//        
//        deviationView.backgroundColor = gray_backgound;
//        
//        
//        [deviationView mas_makeConstraints:^(MASConstraintMaker *make) {
//           
//            make.left.right.bottom.equalTo(self);
//            
//            make.height.equalTo(@10);
//            
//        }];
        
        
        
        

        
    }
    return self;
}
-(void)headerClick:(UIButton*)sender
{
    self.headerClickBlock(sender.tag);
}


@end
