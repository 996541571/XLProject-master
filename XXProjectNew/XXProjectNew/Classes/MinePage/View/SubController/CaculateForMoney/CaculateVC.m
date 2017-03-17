//
//  CaculateVC.m
//  XXProjectNew
//
//  Created by apple on 2016/10/16.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "CaculateVC.h"
#import "CaculateCell.h"
@interface CaculateVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

@end

@implementation CaculateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.collectionView registerNib:[UINib nibWithNibName:@"CaculateCell" bundle:nil] forCellWithReuseIdentifier:@"caculate"];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.collectionViewLayout = layout;
    
    
    [self setupUI];
    
    
}

-(void)setupUI{
    
    
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}
- (UICollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    CaculateCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"caculate" forIndexPath:indexPath];
    
    
//    cell.backgroundColor = [UIColor redColor];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(screenWidth - 40, 280);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
