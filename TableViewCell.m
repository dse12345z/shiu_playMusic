//
//  TableViewCell.m
//  shiu_playMusic
//
//  Created by allen_hsu on 2015/10/15.
//  Copyright © 2015年 allen_hsu. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

#pragma mark - life cycle 決定我的cell用哪一個畫面
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray * arrayOfViews = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        self = arrayOfViews[0];
    }
    
    return self;
}

//-(void)setTemp:(NSDictionary *)temp{
//    _temp = temp;
//    self.controlSexLabel.text=temp[@"controlSex"];
//    self.birthdayLabel.text=temp[@"birthday"];
//    self.nameLabel.text=temp[@"name"];
//}
//-(NSDictionary *)temp{
//    return _temp;
//}

@end
