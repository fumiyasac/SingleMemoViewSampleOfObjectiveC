//
//  Memo.h
//  YourMemoList
//
//  Created by 酒井文也 on 2015/03/06.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Memo : NSManagedObject

@property (nonatomic, retain) NSNumber * memo_id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * detail;

@end
