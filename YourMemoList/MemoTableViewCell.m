//
//  MemoTableViewCell.m
//  YourMemoList
//
//  Created by 酒井文也 on 2015/03/06.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import "MemoTableViewCell.h"
#import "DeviseSize.h"

@implementation MemoTableViewCell {
    int labelWidth;
}

- (void)awakeFromNib {
    
    //Initialization code
    NSString *deviceName = [DeviseSize getNowDisplayDevice];
    
    //iPhone4s
    if([deviceName isEqual:@"iPhone4s"]){
        labelWidth = 300;
    //iPhone5またはiPhone5s
    }else if ([deviceName isEqual:@"iPhone5"]){
        labelWidth = 300;
    //iPhone6
    }else if ([deviceName isEqual:@"iPhone6"]){
        labelWidth = 355;
    //iPhone6 plus
    }else if ([deviceName isEqual:@"iPhone6plus"]){
        labelWidth = 394;
    }
    
    //文字長さを変えるラベルのマルチデバイス対応
    self.cellTitle.frame  = CGRectMake(10, 40,  labelWidth, 20);
    self.cellDetail.frame = CGRectMake(10, 100, labelWidth, 20);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
