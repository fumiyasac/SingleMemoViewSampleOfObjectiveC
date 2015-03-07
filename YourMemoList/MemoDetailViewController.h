//
//  MemoDetailViewController.h
//  YourMemoList
//
//  Created by 酒井文也 on 2015/03/06.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemoDetailViewController : UIViewController

//一覧から引き継いだ値
@property (nonatomic ,strong) NSString *receiveTarget;
@property (nonatomic ,strong) NSString *receiveMemoId;

//テキストフィールド
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITextField *detailTextField;

//追加・変更・削除用ボタン
@property (strong, nonatomic) IBOutlet UIButton *AddButton;
@property (strong, nonatomic) IBOutlet UIButton *EditButton;
@property (strong, nonatomic) IBOutlet UIButton *DeleteButton;

//ボタンアクション
- (IBAction)addButtonClicked:(UIButton *)sender;

- (IBAction)editButtonClicked:(UIButton *)sender;

- (IBAction)deleteButtonClicked:(UIButton *)sender;

@end
