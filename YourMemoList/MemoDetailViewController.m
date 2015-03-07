//
//  MemoDetailViewController.m
//  YourMemoList
//
//  Created by 酒井文也 on 2015/03/06.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import "AppDelegate.h"
#import "MemoDetailViewController.h"

//バリデーションクラスのインポート
#import "Validation.h"

//CoreDataクラスのインポート
#import <CoreData/CoreData.h>

@interface MemoDetailViewController () {
    
    //データ編集時の取得データ配列
    NSMutableArray *fetchDataArray;
    
    //データ追加許可フラグ
    BOOL dataAddFlag;
}
@end

@implementation MemoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //ボタン・テキストフィールドのコントロール
    [self initButtons];
    [self initInputTextFields];
}

//ボタンの初期設定
-(void)initButtons {
    
    if([self.receiveTarget isEqual:@"追加"]){
        
        //ボタンのアルファを設定
        self.AddButton.alpha    = 1;
        self.EditButton.alpha   = 0;
        self.DeleteButton.alpha = 0;
        
        //ボタン誤作動防止の指定をする
        self.AddButton.enabled    = YES;
        self.EditButton.enabled   = NO;
        self.DeleteButton.enabled = NO;
        
    }else if([self.receiveTarget isEqual:@"編集"]){
        
        //ボタンのアルファを設定
        self.AddButton.alpha    = 0;
        self.EditButton.alpha   = 1;
        self.DeleteButton.alpha = 1;
        
        //ボタン誤作動防止の指定をする
        self.AddButton.enabled    = NO;
        self.EditButton.enabled   = YES;
        self.DeleteButton.enabled = YES;

    }
}

//入力エリアの初期設定
-(void)initInputTextFields {
    
    if([self.receiveTarget isEqual:@"追加"]){
        
        //テキストフィールドを空にする
        self.titleTextField.text  = @"";
        self.detailTextField.text = @"";
        
    }else if([self.receiveTarget isEqual:@"編集"]){
        
        //値をCoreDataから取得
        [self selectRecordToCoreDataByMemoId];
        
        //テキストフィールドにレコードからフェッチした値を入れる
        NSArray *dic = [fetchDataArray objectAtIndex:0];
        self.titleTextField.text  = [NSString stringWithFormat:@"%@",dic[1]];
        self.detailTextField.text = [NSString stringWithFormat:@"%@",dic[2]];
    }
}

//memo_idに紐づくデータのみを取得する
-(void)selectRecordToCoreDataByMemoId
{
    //NSManagedObjectContextのインスタンスを作成する
    NSManagedObjectContext *managedObjectContext = [[AppDelegate new] managedObjectContext];
    
    //NSFetchRequestのインスタンス作成
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    //検索対象のエンティティを作成する
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Memo" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    //検索条件を指定
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(memo_id = %@)", self.receiveMemoId];
    [request setPredicate:predicate];
    
    //データ取得実行
    NSError *error;
    NSArray *objects = [managedObjectContext executeFetchRequest:request error:&error];
    
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
    fetchDataArray = theList;
}

//コアデータ（Memo）に1件の新規データを追加する
-(void)addRecordToCoreData {
    
    //NSManagedObjectContextのインスタンス作成
    NSManagedObjectContext *managedObjectContext = [[AppDelegate new] managedObjectContext];
    
    //カウントを取って0だったら1、1より大きければデータの中でmemo_idの最大値に+1をする
    int max_memo_id = 1;
    if([self getMaxMemoId] > 0){
        max_memo_id = (int)[self getMaxMemoId] + 1;
    }
    
    //データ追加用のオブジェクトを作成する
    NSManagedObject *addObject = [NSEntityDescription insertNewObjectForEntityForName:@"Memo" inManagedObjectContext:managedObjectContext];
    
    //オブジェクトにデータを追加する
    [addObject setValue:@(max_memo_id) forKeyPath:@"memo_id"];
    [addObject setValue:self.titleTextField.text forKeyPath:@"title"];
    [addObject setValue:self.detailTextField.text forKeyPath:@"detail"];
    
    //データ保存実行
    NSError *error;
    [managedObjectContext save:&error];
}

//コアデータ（Memo）に1件のデータを更新する
-(void)editRecordToCoreData {
    
    //NSManagedObjectContextのインスタンスを作成する
    NSManagedObjectContext *managedObjectContext = [[AppDelegate new] managedObjectContext];
    
    //NSFetchRequestのインスタンス作成
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    //検索対象のエンティティを作成する
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Memo" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    //検索条件を指定
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(memo_id = %@)", self.receiveMemoId];
    [request setPredicate:predicate];
    
    //データ取得実行
    NSError *error;
    NSArray *objects = [managedObjectContext executeFetchRequest:request error:&error];
    
    //更新用NSManagedObjectを作成
    NSManagedObject *editObject = [objects objectAtIndex:0];
    
    //テキストフィールドの値に変更する
    [editObject setValue:self.titleTextField.text forKey:@"title"];
    [editObject setValue:self.detailTextField.text forKey:@"detail"];
    
    //更新処理を実行する
    [managedObjectContext save:&error];
}

//コアデータ（Memo）に1件のデータを削除する
-(void)deleteRecordToCoreData {
    
    //NSManagedObjectContextのインスタンスを作成する
    NSManagedObjectContext *managedObjectContext = [[AppDelegate new] managedObjectContext];
    
    //NSFetchRequestのインスタンス作成
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    //検索対象のエンティティを作成する
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Memo" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    //検索条件を指定
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(memo_id = %@)", self.receiveMemoId];
    [request setPredicate:predicate];
    
    //データ取得実行
    NSError *error;
    NSArray *objects = [managedObjectContext executeFetchRequest:request error:&error];
    
    //money_idでフェッチして取得したデータをdeleteObjectメソッドで消去
    [managedObjectContext deleteObject:[objects objectAtIndex:0]];
    
    //削除処理を実行する
    [managedObjectContext save:&error];
}

//memo_idの最大値を取得する
/* ----------------
これがないと、このようなことが起こり得る
例）全く同じタイトルのもの or 全く同じ本文のものをが複数ある場合では変更・削除する際に例外が出てしまう
---------------- */
- (NSInteger)getMaxMemoId {
    
    //NSManagedObjectContextのインスタンスを作成する
    NSManagedObjectContext *managedObjectContext = [[AppDelegate new] managedObjectContext];
    
    //NSFetchRequestのインスタンス作成
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    //検索対象のエンティティを作成する
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Memo" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    //NSFetchRequestの中身をディクショナリにして返す
    [request setResultType:NSDictionaryResultType];
    
    //NSExpressionを作成する
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"memo_id"];
    NSExpression *maxExpression = [NSExpression expressionForFunction:@"max:" arguments:@[keyPathExpression]];
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    
    //NSExpressionDescriptionを作る
    [expressionDescription setName:@"maxMemoId"];
    [expressionDescription setExpression:maxExpression];
    [expressionDescription setExpressionResultType:NSInteger64AttributeType];
    [request setPropertiesToFetch:@[expressionDescription]];
    
    //NSFetchRequestにセット
    NSError *error = nil;
    NSArray *obj = [managedObjectContext executeFetchRequest:request error:&error];
    NSInteger maxValue = NSNotFound;
    
    //オブジェクトが取れているかをチェック
    if(obj == nil){
        NSLog(@"error");
    }else if([obj count] > 0){
        maxValue = [obj[0][@"maxMemoId"] integerValue];
    }
    return maxValue;
}

//データのバリデーションを設定する
- (BOOL)dataValidateForPut {
    
    //空チェック結果を返す
    if(![Validation checkExistString:self.titleTextField.text] || ![Validation checkExistString:self.detailTextField.text]){
        dataAddFlag = false;
    }else{
        dataAddFlag = true;
    }
    return dataAddFlag;
}

//背景タップでキーボードを引っ込める
- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}

//新規追加ボタンのアクション
- (IBAction)addButtonClicked:(UIButton *)sender {
    
    //データが正しく入力されている場合
    if([self dataValidateForPut]){
        
        //CoreData内のEntitiyへ該当レコードを新規追加する
        [self addRecordToCoreData];
        
        //前の画面に戻る
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

//編集ボタンのアクション
- (IBAction)editButtonClicked:(UIButton *)sender {
    
    //データが正しく入力されている場合
    if([self dataValidateForPut]){
        
        //CoreData内のEntitiyの該当レコードを編集する
        [self editRecordToCoreData];
        
        //前の画面に戻る
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

//削除ボタンのアクション
- (IBAction)deleteButtonClicked:(UIButton *)sender {
    
    //CoreData内のEntitiyの該当レコードを削除する
    [self deleteRecordToCoreData];
    
    //前の画面に戻る
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
