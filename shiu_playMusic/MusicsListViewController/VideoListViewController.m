//
//  MusicsListViewController.m
//  shiu_playMusic
//
//  Created by allen_hsu on 2015/10/15.
//  Copyright © 2015年 allen_hsu. All rights reserved.
//

#import "VideoListViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface VideoListViewController ()



@property (weak, nonatomic) IBOutlet PlayVideoView *playvideoView;

@property (weak, nonatomic) IBOutlet UITableView *musicsInfoTableView;

@property (weak, nonatomic) IBOutlet UIButton *playMusicButton;
@property (weak, nonatomic) IBOutlet UIButton *videoRateButton;
@property (weak, nonatomic) IBOutlet UIButton *fullScreenButton;

@property (weak, nonatomic) IBOutlet UILabel *currentlyTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

@property (weak, nonatomic) IBOutlet UISlider *currentlyMusicSlider;

@end

@implementation VideoListViewController

#pragma mark - IBAction

- (IBAction)videoRateButtonAction:(id)sender {
    
}
- (IBAction)playMusicButtonAction:(id)sender {
    
}
- (IBAction)fullScreenButtonAction:(id)sender {
    if ([UIDevice currentDevice].orientation != UIDeviceOrientationPortrait) {
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    }else{
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    }
    
}
#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self.playvideoView.player play];
}
- (void)replaceCurrentItemWithPlayerItem:(nullable AVPlayerItem *)item {
}
#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"VideoListViewCell";
    VideoListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    //cell.temp=self.infoArray[indexPath.row];
    return cell;
}


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // tableView: cellForRowAtIndexPath:方法中有兩個得重用cell的方法
    [self.musicsInfoTableView registerClass:[VideoListViewCell class] forCellReuseIdentifier:@"VideoListViewCell"];
   // 完全透明的navigationBar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //取消navigationBar下邊的線
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.playvideoView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;

    [self playVideoFuntion:@"like"];
    [self.tabBarController.tabBar setHidden:YES];
    
}
-(void)playVideoFuntion:(NSString*)strFileName{
   
    //[self.dispalyMovieView removeFromSuperview];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0], paths];
    
    //獲得Resource的路徑
    NSString *path = [[NSBundle mainBundle] pathForResource:strFileName ofType:@"m4v"];
    
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    self.playvideoView.player = [[AVPlayer alloc] initWithPlayerItem:[[AVPlayerItem alloc] initWithURL:fileURL]];;
    self.playvideoView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    NSUInteger TotalSeconds = CMTimeGetSeconds(self.playvideoView.player.currentItem.asset.duration);
    
    self.totalTimeLabel.text=[self formatStringForDuration:TotalSeconds];
   [self.playvideoView.player play];
    

}
- (NSString*)formatStringForDuration:(NSUInteger)duration
{
    NSInteger minutes = floor(duration/60);
    NSInteger seconds = round(duration - minutes * 60);
    return [NSString stringWithFormat:@"%d:%02d", minutes, seconds];
}

@end
//    //總時間
 //   NSUInteger dTotalSeconds = CMTimeGetSeconds(self.player.currentItem.asset.duration);
   //  NSLog(@"12214124 = %lu", (unsigned long)dTotalSeconds);
//
//    //時間加快
//    CMTime currentTime = _player.currentTime;
//    CMTime timeToAdd   = CMTimeMakeWithSeconds(5, 1);
//    //得到時間
//    CMTime resultTime  = CMTimeSubtract(currentTime, timeToAdd);
//    //播放
//    [_player seekToTime:resultTime];

//播放暫停
//[self.playvideoView.player pause];
//播放加速
//[self.playvideoView.player setRate:2.0];


//@property 因為是屬性所以都用點給值   method 就是用中括號給值 ＋-   -實例方法 ＋類方法
