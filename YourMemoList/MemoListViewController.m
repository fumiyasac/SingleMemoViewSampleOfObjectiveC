//
//  MemoListViewController.m
//  YourMemoList
//
//  Created by 酒井文也 on 2015/03/06.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import "AppDelegate.h"
#import "MemoListViewController.h"
#import "MemoDetailViewController.h"
#import "MemoTableViewCell.h"

//CoreDataクラスのインポート
#import <CoreData/CoreData.h>

@interface MemoListViewController () {
    
    //CoreData取得データ格納用メンバ変数
    int fetchCount;
    NSMutableArray *fetchDataArray;
}

@end

@implementation MemoListViewController

//テーブルビューが表示される前に実行される
- (void)viewWillAppear:(BOOL)animated {
    
    //リロードをかけてコアデータを読み込む
    fetchCount = 0;
    [self selectRecordAndCountToCoreData];
    [self.memoListTable reloadData];
}

- (void)viewDidLoad {
    
    //delegateとdataSourceの設定
    self.memoListTable.delegate = self;
    self.memoListTable.dataSource = self;
    
    //テーブルセルのxibファイルを読み込む
    UINib *nib = [UINib nibWithNibName:@"MemoTableViewCell" bundle:nil];
    [self.memoListTable registerNib:nib forCellReuseIdentifier:@"ListCell"];
    
    [super viewDidLoad];
    
    //新規追加時のボタンを押した際に呼ばれるメソッドを設定
    [self.addListButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
}

//ロード時に呼び出されて、セクション内のセル数を返す
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return fetchCount;
}

//ロード時に呼び出されて、セクション内のセル数を返す
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//ロード時に呼び出されて、セルの内容を返す ※任意
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //MemoTableViewCellクラスのセルレイアウトを呼び出して、Identifierを’ListCell’という名前で設定
    MemoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell" forIndexPath:indexPath];
    
    //キャッシュのcellがあれば再利用して、なければ生成
    if (cell == nil) {
        cell = [[MemoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ListCell"];
    }
    
    //セル1個分の配列を作成する
    NSArray *dic = [fetchDataArray objectAtIndex:indexPath.row];
    
    //セルの中に値を入れる
    cell.cellTitle.text  = [NSString stringWithFormat:@"%@",dic[1]];
    cell.cellDetail.text = [NSString stringWithFormat:@"%@",dic[2]];
    
    //クリック時のハイライトをオフにする
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //アクセサリタイプの指定
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //セルを返す
    return cell;
}

//セルをタップした時に呼び出される
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //配列からIDを抽出する
    NSArray *dic = [fetchDataArray objectAtIndex:indexPath.row];
    NSString *targetMemoId = dic[0];
    
    //詳細画面遷移へ
    MemoDetailViewController *memoDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"MemoDetail"];
    
    //値を引き渡す
    memoDetail.receiveTarget = @"編集";
    memoDetail.receiveMemoId = targetMemoId;
    [self presentViewController:memoDetail animated:YES completion:nil];
}

//セルの高さを返す ※任意
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130.0;
}

//追加ボタンが押された際の処理
-(void)buttonTapped:(UIButton *)addListButton {
    
    //詳細画面遷移へ
    MemoDetailViewController *memoDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"MemoDetail"];
    
    //値を引き渡す
    memoDetail.receiveTarget = @"追加";
    [self presentViewController:memoDetail animated:YES completion:nil];
}

//CoreDataからデータを取得する
- (void)selectRecordAndCountToCoreData {
    
    //NSManagedObjectContextのインスタンスを作成する
    NSManagedObjectContext *managedObjectContext = [[AppDelegate new] managedObjectContext];
    
    //NSFetchRequestのインスタンス作成
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    //検索対象のエンティティを作成する
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Memo" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    //検索条件を指定
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"memo_id > 0"];
    [request setPredicate:predicate];
    
    //"memo_id"でソートをかける
    NSSortDescriptor *sortDescriptorMemoId = [[NSSortDescriptor alloc] initWithKey:@"memo_id" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptorMemoId, nil];
    [request setSortDescriptors:sortDescriptors];
    
    //データ取得実行
    NSError *error;
    NSArray *objects = [managedObjectContext executeFetchRequest:request error:&error];
    
    //メンバ変数に値を格納する
    fetchCount = (int)objects.count;
    
    //配列に詰め替え
    NSMutableArray *theList = [NSMutableArray array];
    
    for (int i = 0; i < objects.count; i++) {
        
        //データをオブジェクト→文字列に変換して取得
        NSManagedObject *object = [objects objectAtIndex:i];
        NSString *memo_id = [object valueForKey:@"memo_id"];
        NSString *title   = [object valueForKey:@"title"];
        NSString *detail  = [object valueForKey:@"detail"];
        
        //配列に格納する
        [theList addObject:@[memo_id,title,detail]];
    }
    
    //順番に並んだ配列をメンバ変数に追加する
    fetchDataArray = theList;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
