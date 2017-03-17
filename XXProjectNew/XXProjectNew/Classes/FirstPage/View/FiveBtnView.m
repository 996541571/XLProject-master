//
//  FiveBtnView.m
//  XXProjectNew
//
//  Created by apple on 16/9/6.
//  Copyright © 2016年 xianglin. All rights reserved.
//
//#define xPlaceHolder (screenWidth-16*2-152/3*5)/4
#define btnWidth 152/3
#define btnHeight 161/3
#import "FiveBtnView.h"

@implementation FiveBtnView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (instancetype)initWithFrame:(CGRect)frame withArr:(NSMutableArray*)transferArr
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSDictionary * proactiveLoginDic = [[XLPlist sharePlist]getPlistDicByAppendPlistRoute:proactiveLogin];
        NSNumber * partyID = [proactiveLoginDic objectForKey:@"nodePartyId"];
        
        NSString * partyIDStr = [NSString stringWithFormat:@"%@",partyID];

        //初始化可变数组对象的长度，如果后面代码继续添加数组超过长度0以后NSMutableArray的长度会自动扩充，0是自己可以设置的颗粒度
        
        _fiveBtnArr = [NSMutableArray arrayWithCapacity:0];
        
        NSMutableArray * picArr = [NSMutableArray arrayWithCapacity:0];
        
        _businessStatusArr = [NSMutableArray arrayWithCapacity:0];

        _urlArr = [NSMutableArray arrayWithCapacity:0];
        
        _labNameArr = [NSMutableArray arrayWithCapacity:0];
        
        
        
        self.backgroundColor=[UIColor clearColor];
        
        
        //遍历传进来的数组
            for (NSDictionary*dic in transferArr) {
                
                //有h5网址并且不为空
                if ([dic objectForKey:@"h5url"]&&(![[dic objectForKey:@"h5url"] isEqualToString:@""])) {
                //网址添加到数组
                    [_fiveBtnArr addObject:dic];
                    
                }
                
            }
        
        
//        float xPlaceHolder =(screenWidth-16*2-152/3*_fiveBtnArr.count)/(_fiveBtnArr.count-1);
        
        float xPlaceHolder = (screenWidth  - btnWidth*_fiveBtnArr.count)/(_fiveBtnArr.count+1);

//                NSLog(@"----%@",[[_fiveBtnArr[0] objectForKey:@"businessType"]class]);

        
                for (NSDictionary*dic in _fiveBtnArr ) {
            
                    if ([[dic objectForKey:@"businessType"] isEqualToString:@"BANK"]) {
                        [picArr addObject:@"BANK"];
                        [_labNameArr addObject:@"银行业务"];

                        [_urlArr addObject:[NSString stringWithFormat:@"%@?nodePartyId=%@",[dic objectForKey:@"h5url"],partyIDStr]];


                    }else if ([[dic objectForKey:@"businessType"] isEqualToString:@"LOAN"]) {
                        [picArr addObject:@"grain"];
                        [_labNameArr addObject:@"我的谷雨"];
                        [_urlArr addObject:[dic objectForKey:@"h5url"]];
                        
                        
                    }else if ([[dic objectForKey:@"businessType"] isEqualToString:@"ESHOP"]) {
                        [picArr addObject:@"XLShopping"];
                        [_labNameArr addObject:@"乡邻购"];
                        [_urlArr addObject:[dic objectForKey:@"h5url"]];
                        
                        
                    }else if ([[dic objectForKey:@"businessType"] isEqualToString:@"LIVE"]) {
                        [picArr addObject:@"payment"];
                        [_labNameArr addObject:@"水电煤"];
                        [_urlArr addObject:[dic objectForKey:@"h5url"]];
                        
                        
                    }else if ([[dic objectForKey:@"businessType"] isEqualToString:@"MOBILERECHARGE"]) {
                        
                        [picArr addObject:@"phoneCharge"];
                        [_labNameArr addObject:@"手机充值"];
                        [_urlArr addObject:[dic objectForKey:@"h5url"]];
                        
                        
                    }else if ([[dic objectForKey:@"businessType"] isEqualToString:@"SOLAR"]){
                        
                        
                        [picArr addObject:@"solar"];
                        [_urlArr addObject:[dic objectForKey:@"h5url"]];
                        [_labNameArr addObject:@"我的光伏"];
                        
                        
                        
                    }else if ([[dic objectForKey:@"businessType"] isEqualToString:@"OTHER"]){
                        
                        
                        [picArr addObject:@"otherBusiness"];
                        [_labNameArr addObject:@"其他业务"];
                        [_urlArr addObject:[dic objectForKey:@"h5url"]];
                        
                        
                        
                    }


                }
        //处理UI
        //如果是4s
        if (screenWidth==320&&screenHeight==480) {
            
            for (int i=0; i<_fiveBtnArr.count; i++) {
                UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
                
                //计算frame
                //宽 = 左右边距 + 图标宽*数量+图标之间的间隙(数量+1)
                btn.frame=CGRectMake(xPlaceHolder+(btnWidth+xPlaceHolder)*i, 5, btnWidth, btnHeight);
                //            btn.backgroundColor=[UIColor redColor];
                [btn setBackgroundImage:[UIImage imageNamed:picArr[i]] forState:UIControlStateNormal];
                btn.tag=2500+i;
                [btn addTarget:self action:@selector(fiveBtnPress:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btn];
                UILabel*label=[[UILabel alloc]init];
                label.text=_labNameArr[i];
                
                label.bounds=CGRectMake(0, 0, 70, 14);
                label.font=[UIFont systemFontOfSize:12.0];
                label.textAlignment=NSTextAlignmentCenter;
                CGPoint btnPoint=btn.center;
                
                label.center=CGPointMake(btnPoint.x, btnPoint.y+30);
                label.textColor=RGB(102, 102, 102, 1);
                [self addSubview:label];
                
            }
            

         //其他机型
        }else{
            
            for (int i=0; i<_fiveBtnArr.count; i++) {
                
                UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame=CGRectMake(xPlaceHolder+(btnWidth+xPlaceHolder)*i, 17, btnWidth, btnHeight);
                //            btn.backgroundColor=[UIColor redColor];
                [btn setBackgroundImage:[UIImage imageNamed:picArr[i]] forState:UIControlStateNormal];
                btn.tag=2500+i;
                
                //添加点击事件响应(作为block传给控制器去处理)
                [btn addTarget:self action:@selector(fiveBtnPress:) forControlEvents:UIControlEventTouchUpInside];
               
                [self addSubview:btn];
                
                UILabel*label=[[UILabel alloc]init];
                label.text=_labNameArr[i];
                
                label.bounds=CGRectMake(0, 0, 70, 14);
                label.font=[UIFont systemFontOfSize:12.0];
                label.textAlignment=NSTextAlignmentCenter;
                CGPoint btnPoint=btn.center;
                
                label.center=CGPointMake(btnPoint.x, btnPoint.y+30);
                label.textColor=RGB(102, 102, 102, 1);
                [self addSubview:label];
                
            }
        }
        

            
            


       
    }
    return self;
}



-(void)fiveBtnPress:(UIButton*)sender
{
    self.fiveBtnBlock(_urlArr[sender.tag-2500],_labNameArr[sender.tag-2500]);
    
}


@end
