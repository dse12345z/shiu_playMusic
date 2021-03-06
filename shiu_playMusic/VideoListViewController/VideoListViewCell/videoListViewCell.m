//
//  VideoListViewCell.m
//  shiu_playMusic
//
//  Created by allen_hsu on 2015/10/19.
//  Copyright © 2015年 allen_hsu. All rights reserved.
//

#import "VideoListViewCell.h"

@implementation VideoListViewCell

#pragma mark - life cycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    // 決定我的cell用哪一個畫面
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        self = arrayOfViews[0];
    }
    return self;
}
@end
