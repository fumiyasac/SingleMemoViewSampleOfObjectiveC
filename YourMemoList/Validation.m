//
//  Validation.m
//  YourMemoList
//
//  Created by 酒井文也 on 2015/03/06.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import "Validation.h"

@implementation Validation

/* ----------
バリデーションのパターンをクラスメソッドで記述
① どの画面からでも使いまわせるようにする
② 最低限空っぽのデータが作られないようにしている
※データのバリデーションはしっかりと（例.数字だけのチェック等が必要な場合はここに）
---------- */

+(BOOL)checkExistString:(NSString *)checkString {
    
    //空か否かのチェック
    BOOL ret;
    if([checkString isEqualToString:@""]){
        ret = false;
    } else {
        ret = true;
    }
    return ret;
}

@end
