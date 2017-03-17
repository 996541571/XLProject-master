//
//  FPBusinessModulView.m
//  XXProjectNew
//
//  Created by apple on 12/8/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import "FPBusinessModulView.h"
#import "BusinessModel.h"

@interface FPBusinessModulView ()
@property(nonatomic,weak)UIImageView* bgimgV;

@end
@implementation FPBusinessModulView


-(UIImageView*)bgimgV{
    
    
    if (!_bgimgV) {
        
        
        UIImageView* temp = [UIImageView new];
        
        [self addSubview:temp];
        
        
        [temp mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(self);
            
        }];

        
        _bgimgV = temp;
        
    }
    
    
    return _bgimgV;
}


-(NSArray*)btn_arr{
    
    
    if (!_btn_arr) {
        
        _btn_arr = @[];
    }
    
    
    return _btn_arr;
}




-(void)setModel_arr:(NSArray<BusinessModel *> *)model_arr{
    
    
    _model_arr = model_arr;
    
    if (self.isNewYear) {
        
        
        self.bgimgV.image = [UIImage imageNamed:@"NY_bg"];
        
    }else{
        
        self.bgimgV.image = nil;
        
    }

    
    
    //先把原来的清空
    
    
    for (DVButton* btn  in self.btn_arr) {
        
        [btn removeFromSuperview];
    }
    
//    self.btn_arr = @[];
    
    
    
    /*
     
     count  :  item 总数
     width_count : 每行最大item数
     Max_HigCount : 最大行数 : (总数-1)/每行限制 + 1  (注意 count 最小为1)
     space_X : 横间距
     space_Y : 竖间距
     
     
     */
    

    
    
    NSInteger count = _model_arr.count;

    CGFloat space_X = (screenWidth  - btnWidth * count)/(count+1);
    
    CGFloat space_Y = 10.0;
    
    NSMutableArray* arr = [NSMutableArray array];
    
    NSMutableArray* btn_arr_temp = [NSMutableArray array];
    
    for (int i = 0 ; i < count ; i++) {
        
        DVButton* btn = [DVButton buttonWithText:model_arr[i].busiName andColor:title_Color andFontSize:12 andSuperview:self];
        
        btn.btnType = BtnTypeDown;
        
        
        
        btn.tag = i;
        
//        [btn addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [arr addObject:btn];
        
        if (self.isNewYear) {
            
            
            //[btn setTitleColor:RGB(255, 65, 65, 1) forState:UIControlStateNormal];
            //ff4141
            
            [btn setTitleColor:[UIColor colorWithHexString:@"ff4141"] forState:UIControlStateNormal];

            
            [btn setImage:[UIImage imageNamed:self.model_arr[i].busiNewYearImageName] forState:UIControlStateNormal];
            
            
        }else{
            
            
            [btn sd_setImageWithURL:[NSURL URLWithString:self.model_arr[i].busiImage] forState:UIControlStateNormal];
            
            
        }
        
        
        
        
        
        
        //注意给标题留出空间
        
        btn.frame=CGRectMake(space_X+(btnWidth+space_X)*(i% count),
                             space_Y+(btnHeight+space_Y)*(i/count),
                             btnWidth,
                             btnHeight);
        
        
        
        
        [btn_arr_temp addObject:btn];
        
    }

    
    
        self.btn_arr = btn_arr_temp.copy;
    
    
    
    
}


@end
