//
//  MusicsListViewController.m
//  shiu_playMusic
//
//  Created by allen_hsu on 2015/10/15.
//  Copyright © 2015年 allen_hsu. All rights reserved.
//

#import "MusicsListViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface MusicsListViewController ()
@property (weak, nonatomic) IBOutlet UIView *playvideoView;
@property (weak, nonatomic) IBOutlet UITableView *musicsInfoTableView;
@property (strong) AVPlayer *player;
@property (strong) AVPlayerLayer *avPlayerLayer;
@property (strong) AVPlayerItem *currentItem;

@end

@implementation MusicsListViewController
- (IBAction)turnScreenButtonAction:(id)sender {   
   [self playVideo:@"Movie"];

}
#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self playVideo:@"like"];
}
- (void)replaceCurrentItemWithPlayerItem:(nullable AVPlayerItem *)item {
    NSLog(@"123");
}
#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"MusicsListViewControllerCell";
    MusicsListViewControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    //cell.temp=self.infoArray[indexPath.row];
    return cell;
}


#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // tableView: cellForRowAtIndexPath:方法中有兩個得重用cell的方法
    [self.musicsInfoTableView registerClass:[MusicsListViewControllerCell class] forCellReuseIdentifier:@"MusicsListViewControllerCell"];
   // 完全透明的navigationBar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //取消navigationBar下邊的線
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    
    //    //總時間
    //    NSUInteger dTotalSeconds = CMTimeGetSeconds(self.player.currentItem.asset.duration);
    //    NSLog(@"12214124 = %lu", (unsigned long)dTotalSeconds);
    //
    //    //時間加快
    //    CMTime currentTime = _player.currentTime;
    //    CMTime timeToAdd   = CMTimeMakeWithSeconds(5, 1);
    //    //得到時間
    //    CMTime resultTime  = CMTimeSubtract(currentTime, timeToAdd);
    //    //播放
    //    [_player seekToTime:resultTime];
    
    
    
    //@property 因為是屬性所以都用點給值   method 就是用中括號給值 ＋-   -實例方法 ＋類方法
}
-(void)playVideo:(NSString*)StrFileName{
    self.player =nil;
    //[self.dispalyMovieView removeFromSuperview];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0], paths];
    
    //獲得Resource的路徑
    NSString *path = [[NSBundle mainBundle] pathForResource:StrFileName ofType:@"m4v"];
    
    NSURL *fileURL = [NSURL fileURLWithPath:path];
   self.player = [[AVPlayer alloc] initWithPlayerItem:[[AVPlayerItem alloc] initWithURL:fileURL]];
    
   
    
    self.avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    self.avPlayerLayer.frame = CGRectMake(0, 0, self.playvideoView.frame.size.width, self.playvideoView.frame.size.height);
    self.avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.playvideoView.layer addSublayer:_avPlayerLayer];
    [self.player play];
    

}
@end
