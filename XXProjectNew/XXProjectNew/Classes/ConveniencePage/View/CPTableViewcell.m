//
//  CPTableViewcell.m
//  XXProjectNew
//
//  Created by apple on 12/5/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import "CPTableViewcell.h"
#import "ConveniecePageViewModel.h"
#import "ConveniencePageModel.h"
@interface CPTableViewcell()
@end

@implementation CPTableViewcell

-(UILabel*)title_label{
    
    
    if (!_title_label) {
        
        
        UILabel* temp = [UILabel labelWithText:@"便民服务" andColor:title_Color andFontSize:text_Size andSuperview:self.contentView];
        
        _title_label = temp;
        
    }
    
    
    return _title_label;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    [self setupUI];

    
    return self;
}


-(void)setCell_model:(ConveniencePageModel *)cell_model{
    
    //每次拿到数据都需要更新
    //但可能面临重复创建的问题
    //解决思路是每次创建时把以前的拿到
    
    //清空
    for (DVButton* btn in self.btn_arr) {
        
        [btn removeFromSuperview];
    }
    
    self.btn_arr = nil;
    
    
    
    //创建
    _cell_model = cell_model;
    
   
    [self setUpData];
    
    
    
}

-(void)setupUI{
    
    self.selectionStyle = 0;
    
    [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(20);
        make.left.equalTo(self.contentView).offset(15);
        
    }];
    

    
    
}

-(void)setUpData{
    
    [self setUpBtn];
    
    self.title_label.text = self.cell_model.title;
    
    
    
}


-(void)setUpBtn{
    
    /*
     
     count  :  item 总数
     width_count : 每行最大item数
     Max_HigCount : 最大行数 : (总数-1)/每行限制 + 1  (注意 count 最小为1)
     space_X : 横间距
     space_Y : 竖间距
     
     
     */
    
    NSInteger count = self.cell_model.item_count;
    
    NSInteger Max_WidCount = self.cell_model.Max_WidCount;
    
//    NSInteger Max_HigCount =  count == 0 ? 0: (count-1)/Max_WidCount+1 ;
    
    Max_WidCount = MIN(count, Max_WidCount);
    
    Max_WidCount = 4;
    
    CGFloat space_X = (screenWidth  - btnWidth * Max_WidCount)/(Max_WidCount+1);
    
//    CGFloat space_Y = (CellRowHeight -title_height - Max_HigCount*btnHeight)/2;
    
    CGFloat space_Y = 10.0;
    
    NSMutableArray* arr = [NSMutableArray array];
    
    for (int i = 0 ; i < count ; i++) {
        
//        DVButton* btn = [DVButton buttonWithText:self.cell_model.title_arr[i] andColor:title_Color andFontSize:12 andSuperview:self.contentView];
        
        DVButton* btn = [DVButton buttonWithText:self.cell_model.title_arr[i] andColor:title_Color andFontSize:12 andSuperview:self.contentView andType:BtnTypeDown andCustomimgBounds:CGRectMake(0, 0, 40, 40)];
        
//        btn.btnType = BtnTypeDown;
        
        btn.tag = i;
        
//        btn.bounds.size.height
        
//        [btn setValue:@"30" forKey:@"imageView.bounds.size.height"];
        
        [btn addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [arr addObject:btn];
        
//        [btn setImage:[UIImage imageNamed:self.cell_model.img_arr[i]] forState:UIControlStateNormal];
        
//        [btn sd_setImageWithURL: [NSURL URLWithString: self.cell_model.imgUrl_arr[i]] forState:UIControlStateNormal];
        
        NSString* imgUrl_str = self.cell_model.imgUrl_arr[i];
        
        if (imgUrl_str.length) {
            
            [btn sd_setImageWithURL:[NSURL URLWithString:self.cell_model.imgUrl_arr[i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultImage"]];
        }else{
            
            [btn setImage:[UIImage imageNamed:@"defaultImage"] forState:UIControlStateNormal];

        }
        
        

        //注意给标题留出空间
        
        btn.frame=CGRectMake(space_X+(btnWidth+space_X)*(i% Max_WidCount),
                             space_Y+(btnHeight+space_Y)*(i/ Max_WidCount)+title_height,
                             btnWidth,
                             btnHeight);
        
        
    }
    
    
    self.btn_arr = arr.copy;
    
    
    
    
    
    
    
    UIView* separate_line = [UIView  new];
    
    [self.contentView addSubview:separate_line];
    
    separate_line.backgroundColor = [UIColor lightGrayColor];
    
//    separate_line.hidden = true;
    
    
    
    [separate_line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@0.5);
        
        make.bottom.equalTo(self.contentView);
        
        make.width.mas_equalTo(screenWidth);
        
        
    }];
    
    
    
}


-(void)btnDidClick:(DVButton*)btn{
    
    if (self.block) {
        self.block(btn,self.tag);
    }
    
}


@end
