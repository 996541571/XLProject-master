//
//  NLCollectionViewCell.h
//  XXProjectNew
//
//  Created by apple on 11/25/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString* NLTableViewReusedID = @"tableViewcell";
@class NLTableView;
@interface NLCollectionViewCell : UICollectionViewCell
@property(nonatomic,weak)NLTableView* tableView;
@end
