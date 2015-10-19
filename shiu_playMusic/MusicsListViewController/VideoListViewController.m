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
{

    BOOL isPlayingVideos;
    int currentValue;
}
@property (nonatomic, weak) IBOutlet PlayVideoView *playVideoView;
@property (nonatomic, weak) IBOutlet UITableView *videoInfoTableView;
@property (nonatomic, weak) IBOutlet UIButton *playVideoButton;
@property (nonatomic, weak) IBOutlet UIButton *videoRateButton;
@property (nonatomic, weak) IBOutlet UIButton *fullScreenButton;
@property (nonatomic, weak) IBOutlet UILabel *currentlyTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalTimeLabel;
@property (nonatomic, weak) IBOutlet UIView *controlButtonView;
@property (nonatomic, weak) IBOutlet UISlider *currentVideoSlider;
@property(nonatomic, strong) NSArray *videos;
@end

@implementation VideoListViewController

#pragma mark - GestureAction

- (IBAction)tapGestureRecognizerAction:(id)sender {
    self.controlButtonView.hidden = !self.controlButtonView.hidden;
    self.playVideoButton.hidden = !self.playVideoButton.hidden;
    self.navigationController.navigationBar.hidden = !self.navigationController.navigationBar.hidden;

}

#pragma mark - IBAction
- (IBAction)currentVideoSliderAction:(id)sender {
    CMTime newTime = CMTimeMakeWithSeconds(self.currentVideoSlider.value, self.currentVideoSlider.maximumValue);
    [self.playVideoView.player seekToTime:newTime];

}

- (IBAction)videoRateButtonAction:(id)sender {

    [self.playVideoView.player setRate:2.0];

}
- (IBAction)playMusicButtonAction:(id)sender {
    if (isPlayingVideos) {
        [self.playVideoButton setTitle:@"play" forState:UIControlStateNormal];
        [self.playVideoView.player pause];
        isPlayingVideos = NO;
    }
    else {
        [self.playVideoButton setTitle:@"pause" forState:UIControlStateNormal];
        [self.playVideoView.player play];
        isPlayingVideos = YES;
    }

}
- (IBAction)fullScreenButtonAction:(id)sender {
    //強制旋轉螢幕
    self.tabBarController.tabBar.hidden = !self.tabBarController.tabBar.hidden;
    if ([UIDevice currentDevice].orientation != UIDeviceOrientationPortrait) {
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    }
    else {
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    }
}
#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    currentValue=(int)indexPath.row;
    [self playVideoFuntion];
    
}
- (void)replaceCurrentItemWithPlayerItem:(nullable AVPlayerItem *)item {
}
#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"VideoListViewCell";
    VideoListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.videoImageView.image = [self getTheMovieImage:[self.videos objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - private instance method
- (void)playVideoFuntion {
    isPlayingVideos = NO;



    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0], paths];

    NSString *path = [[NSBundle mainBundle] pathForResource:[self.videos objectAtIndex:currentValue] ofType:@"m4v"];

    NSURL *fileURL = [NSURL fileURLWithPath:path];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:fileURL];
    self.playVideoView.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    self.playVideoView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;

    //顯示總時間
    int TotalSeconds = CMTimeGetSeconds(self.playVideoView.player.currentItem.asset.duration);
    self.totalTimeLabel.text = [self formatTime:TotalSeconds];
    //設定currentVideoSlider 的長度
    [self.currentVideoSlider setMaximumValue:TotalSeconds];

    [self.playVideoView.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 2) queue:dispatch_get_main_queue() usingBlock: ^(CMTime time) {
         int currentTime = CMTimeGetSeconds(self.playVideoView.player.currentTime);
         [self.currentVideoSlider setValue:currentTime];
         self.currentlyTimeLabel.text = [self formatTime:currentTime];
     }];

    [self.playVideoView.player play];
}
//秒轉分鐘
- (NSString *)formatTime:(int)num {
    int sec = num % 60;
    int min = num / 60;
    return [NSString stringWithFormat:@"%02d:%02d", min, sec];
}
//取得影片畫面
- (UIImage *)getTheMovieImage:(NSString *)fileName {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:fileName ofType:@"m4v"]] options:nil];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    //選擇要擷取圖片的時間範圍
    CMTime time = CMTimeMake(10,10); // time range in which you want
    CGImageRef imgRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL

                                                    error:nil];
    return [[UIImage alloc] initWithCGImage:imgRef];

}
//下一首
- (void)nextVideoButtonAction:(id)sender {
    currentValue++;
    [self playVideoFuntion];
}
//上一首
- (void)periousVideoButtonAction:(id)sender {
    currentValue--;
    [self playVideoFuntion];
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    // tableView: cellForRowAtIndexPath:方法中有兩個得重用cell的方法
    [self.videoInfoTableView registerClass:[VideoListViewCell class] forCellReuseIdentifier:@"VideoListViewCell"];

    // 完全透明的navigationBar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //取消navigationBar下邊的線
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //設定navigationBar 右鍵配置
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward
                                                                   target:self action:@selector(nextVideoButtonAction:)];
    //設定navigationBar 右鍵配置
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemRewind
                                                                  target:self action:@selector(periousVideoButtonAction:)];


   // [self playVideoFuntion:[self.videos objectAtIndex:1]];
    self.videos = @[@"like", @"Movie",@"我能給的"];
    currentValue=0;
    [self playVideoFuntion];

}


@end
//@property 因為是屬性所以都用點給值   method 就是用中括號給值 ＋-   -實例方法 ＋類方法
