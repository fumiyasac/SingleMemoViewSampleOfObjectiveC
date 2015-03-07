//
//  MemoListViewController.h
//  YourMemoList
//
//  Created by 酒井文也 on 2015/03/06.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemoListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

//メモ一覧テーブルビュー
@property (strong, nonatomic) IBOutlet UITableView *memoListTable;

//新規追加する
@property (strong, nonatomic) IBOutlet UIButton *addListButton;

@end

