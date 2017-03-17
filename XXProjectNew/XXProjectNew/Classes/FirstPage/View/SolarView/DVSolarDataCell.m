//
//  DVSolarDataCell.m
//  XXProjectNew
//
//  Created by apple on 16/11/11.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "DVSolarDataCell.h"
#import "UICountingLabel.h"
#import "SolarSubView.h"
#import "JTNumberScrollAnimatedView.h"
#import "ADTickerLabel.h"
#define viewHight (viewWid/(520.0/202))
#define viewWid  ((screenWidth-3*spaceWid)/2)
#define spaceWid 5
@interface  DVSolarDataCell()
@property(nonatomic,strong)NSMutableArray* dataLabel_arr;

@end
@implementation DVSolarDataCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//懒加载

-(NSMutableArray*)dataLabel_arr{
    
    
    if (!_dataLabel_arr) {
        
        _dataLabel_arr = [NSMutableArray array];
    }
    
    return _dataLabel_arr;
}




//重用cell走的方法

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    [self initializeForCell];
    
    return self;
    
}



-(void)initializeForCell{
    
    [self setupUI];
    
    [self setupSeparate_Line];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
}
-(void)setupUI{
    
    
    
    NSArray* dis_arr = @[@"累计发电",@"累计创造效益",@"减少伐木",@"减少排放"];
    NSArray* dis_btnIconArr = @[@"electricity",@"createProfit",@"cutting",@"letout"];
    NSArray* array = @[@"度",@"元",@"颗",@"吨"];

    for (int i = 0; i < 4; i ++) {
        
        SolarSubView* solarView = [SolarSubView new];
        
        [self.dataLabel_arr addObject:solarView.numView];
        
        
        UIImage* iconImg = [UIImage imageNamed:dis_btnIconArr[i]];
        
        
        //        [solarView.des_btn setImage:[iconImg TransformtoSize:CGSizeMake(15, 15)] forState:UIControlStateNormal];
        
        
        solarView.imageView.image = iconImg;
        
        
        
        [solarView.des_btn setTitle:dis_arr[i] forState:UIControlStateNormal];

//        [self.dataLabel_arr addObject:solarView.numLabel];
        
//        [self.dataLabel_arr addObject:solarView.num_label];
        
        
        solarView.unit_label.text = array[i];
        
        
        
        
        UIImage* backgrundImg = [UIImage imageNamed:[NSString stringWithFormat:@"%@_backgroud",dis_btnIconArr[i]]];
        
        solarView.backgroudImgView.image = backgrundImg;
        
        
        solarView.backgroundColor = [UIColor lightGrayColor];
        
        [self.contentView addSubview:solarView];
        
        
        CGFloat row = i/2;
        
        CGFloat col = i%2;
        
//        CGFloat viewWid = (screenWidth-3*spaceWid)/2;
        
        solarView.frame = CGRectMake(col*viewWid + spaceWid*(col+1), viewHight*row +spaceWid*row+ 50 + 10, viewWid, viewHight);
        
        
    }
    

    
    
    
    

    UIButton* btn = [UIButton new];
    
    
    [btn setBackgroundImage:[UIImage imageNamed:@"rain"] forState:UIControlStateNormal];

    
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    
    
    [self.contentView addSubview:btn];
    
    
    [btn setTitleColor:RGB(44, 44, 44, 1) forState:UIControlStateNormal];
    
    [btn setTitle:@"安装光伏的乡亲们共同创造的收益" forState:UIControlStateNormal];
    
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(screenWidth, 50));
        
    }];

    
    
    
    
}

-(void)setupSeparate_Line{
    
    self.separate_line = [UIView  new];
    
    [self addSubview:_separate_line];
    
    _separate_line.backgroundColor = [UIColor lightGrayColor];
    
    self.separate_line.hidden = true;
    
    
    
    [self.separate_line mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.equalTo(@0.5);
        
        make.bottom.equalTo(self.contentView);
        
        make.width.equalTo(self.contentView);
        
        
        
    }];
    
//    self.separate_line.frame = CGRectMake(0,viewHight*2+10, screenWidth, 2);
    
}



-(void)setDataModel:(NSDictionary *)dataModel{
    
    _dataModel = dataModel;
    
    //累计发电：etotal，累计收益：income，减少伐木：totalplant，减少排放：co2
    
    NSString* etotal = [dataModel objectForKey:@"etotal"];
    
    NSString* income =  [dataModel objectForKey:@"income"];
    
    NSString* totalplant =  [dataModel objectForKey:@"totalPlant"];
    
    NSString* co2 = [dataModel objectForKey:@"co2"];
    
    
    NSMutableArray<NSString*>* arr = [NSMutableArray array];
    
    
    [self dealWithData:etotal andArr:arr];
    [self dealWithData:income andArr:arr];
    [self dealWithData:totalplant andArr:arr];
    [self dealWithData:co2 andArr:arr];
    
    
    
    int i = 0;
    
//     for (ADTickerLabel * ad  in self.dataLabel_arr) {
    for (JTNumberScrollAnimatedView* ha  in self.dataLabel_arr) {
//         for (UICountingLabel * l  in self.dataLabel_arr) {
        
//        l.format = [NSString stringWithFormat:@"%@",arr[i]];
        
//        l.text = [NSString stringWithFormat:@"%@%@",l.text,array[i]];
        
//        l.format = @"%.2f";
        
//        NSString* num = arr[i];
    
//        [l countFrom:0 to:num.floatValue withDuration:2];
         
//         ad.text = (NSString*)num;
         
//         ad.text = @"0.00";
        
//         ad.text = [NSString stringWithFormat:@"%.2f",num.floatValue];
        
        NSNumber * num = [NSNumber numberWithFloat:arr[i].floatValue];
        
        NSString* str = [NSString stringWithFormat:@"%@",num];
        
        NSLog(@"%td",str.length);
        
        NSInteger wid  = 10 * str.length;
        
#warning 最大位数为7 , 超过7则显示不正常
        
        if(str.length <8){
            
            ha.frame = CGRectMake(10, 30, wid, 20);
            
        }else{
            
            ha.frame = CGRectMake(10, 30, 70, 20);
        }
        
        

        
        
//
        if (num.floatValue == 0) {
        
            ha.frame = CGRectMake(10, 30, 40, 20);

            
//            num =@0.01;
            
        }
        
        
        
        
        [ha setValue:num];
        
        [ha startAnimation];
        
        
        
        
        
        //富文本设置
        
//        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:l.text];
//        
//        
//        [AttributedStr addAttribute:NSFontAttributeName
//         
//                              value:[UIFont systemFontOfSize:12.0]
//         
//                              range:NSMakeRange(l.text.length - 1, 1)];
        
        
        
        //富文本生效
        
//        l.attributedText = AttributedStr;
        
        
        
        
        
        
        i++;
        
    }
   
    
}

-(void)dealWithData:(NSString*)name andArr:(NSMutableArray*)arr{
    
    
    if ( !name ) {
        
        name = @"0.00";
        
    }
    
    
        [arr addObject:name];


    
}


@end
