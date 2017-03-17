//
//  ContactsViewModel.m
//  XXProjectNew
//
//  Created by apple on 2017/1/5.
//  Copyright © 2017年 xianglin. All rights reserved.
//

#import "ContactsViewModel.h"
#import "ContactsModel.h"
static ContactsViewModel *_model;
@implementation ContactsViewModel
+(instancetype)shareModel{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _model = [ContactsViewModel new];
        
    });
    
    return _model;
}
-(void)getContactsDataWithBlock:(void (^)(NSArray *))block
{
    NSMutableArray *contacts = [NSMutableArray arrayWithCapacity:0];
    
    NSDictionary *dict = [[XLPlist sharePlist]getPlistDicByAppendPlistRoute:proactiveLogin];
    [NetRequest requetWithParams:@[@{@"partyId":dict[@"nodeManagerPartyId"]}] requestName:@"UserRelationService.queryContact" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        NSLog(@"%@",responseDicionary);
        if ([responseDicionary[@"resultStatus"] integerValue] == 1000) {
            for (NSDictionary *dict in responseDicionary[@"result"]) {
                ContactsModel *model = [[ContactsModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [contacts addObject:model];
            }
            block([self setUpTableSectionWithContacts:contacts]);
        }
    }];
    
    
}
-(NSArray *)setUpTableSectionWithContacts:(NSArray *)contacts
{
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    NSUInteger sectionNum = [[collation sectionTitles] count];
    NSMutableArray *sectionArr = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger index = 0; index < sectionNum; index ++) {
        [sectionArr addObject:[NSMutableArray array]];
    }
    for (ContactsModel *model in contacts) {
        NSUInteger sectionIndex = [collation sectionForObject:model collationStringSelector:@selector(nikerName)];
        [sectionArr[sectionIndex] addObject:model];
    }
    for (NSUInteger index = 0; index <sectionNum; index++) {
        NSMutableArray *personForSec = sectionArr[index];
        NSArray *sortedPerson = [collation sortedArrayFromArray:personForSec collationStringSelector:@selector(nikerName)];
        sectionArr[index] = sortedPerson;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    self.sectionTitles = [NSMutableArray new];
    
    [sectionArr enumerateObjectsUsingBlock:^(NSArray *arr, NSUInteger idx, BOOL *stop) {
        if (arr.count == 0) {
            [temp addObject:arr];
        } else {
            [self.sectionTitles addObject:[collation sectionTitles][idx]];
        }
    }];
    [sectionArr removeObjectsInArray:temp];
    return  sectionArr;
}
@end























