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

@property (nonatomic, weak) IBOutlet PlayVideoView *playVideoView;
@property (nonatomic, weak) IBOutlet UITableView *videoInfoTableView;
@property (nonatomic, weak) IBOutlet UIButton *playVideoButton;
@property (nonatomic, weak) IBOutlet UIButton *videoRateButton;
@property (nonatomic, weak) IBOutlet UIButton *fullScreenButton;
@property (nonatomic, weak) IBOutlet UILabel *currentlyTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalTimeLabel;
@property (nonatomic, weak) IBOutlet UIView *controlButtonView;
@property (nonatomic, weak) IBOutlet UISlider *currentVideoSlider;

@property (strong, nonatomic) NSArray *videos;
@property (assign, nonatomic) BOOL isPlayingVideos;
@property (assign, nonatomic) int playIndex;

@end

@implementation VideoListViewController

#pragma mark - IBAction

- (IBAction)currentVideoSliderAction:(id)sender {
    CMTime newTime = CMTimeMakeWithSeconds(self.currentVideoSlider.value, self.currentVideoSlider.maximumValue);
    [self.playVideoView.player seekToTime:newTime];
}

- (IBAction)videoRateButtonAction:(id)sender {
    self.playVideoView.player.rate = 2.0;
}

- (IBAction)playMusicButtonAction:(id)sender {
    if (self.isPlayingVideos) {
        [self.playVideoButton setTitle:@"play" forState:UIControlStateNormal];
        [self.playVideoView.player pause];
    }
    else {
        [self.playVideoButton setTitle:@"pause" forState:UIControlStateNormal];
        [self.playVideoView.player play];
    }
    self.isPlayingVideos = !self.isPlayingVideos;
}

- (IBAction)fullScreenButtonAction:(id)sender {
    self.tabBarController.tabBar.hidden = !self.tabBarController.tabBar.hidden;

    //強制旋轉螢幕
    NSNumber *value;
    if ([UIDevice currentDevice].orientation != UIDeviceOrientationPortrait) {
        value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    }
    else {
        value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    }
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

#pragma mark * GestureAction

- (IBAction)tapGestureRecognizerAction:(id)sender {
    self.controlButtonView.hidden = !self.controlButtonView.hidden;
    self.playVideoButton.hidden = !self.playVideoButton.hidden;
    self.navigationController.navigationBar.hidden = !self.navigationController.navigationBar.hidden;
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.playIndex = (int)indexPath.row;
    [self playVideoConfigure];

}

#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"VideoListViewCell";
    VideoListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.videoImageView.image = [self movieImage:self.videos[self.playIndex]];
    return cell;
}

#pragma mark - private instance method

#pragma mark * init

- (void)playVideoConfigure {
    NSString *path = [[NSBundle mainBundle] pathForResource:self.videos[self.playIndex] ofType:@"m4v"];
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:fileURL];
    self.playVideoView.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    self.playVideoView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //顯示總時間
    int totalSeconds = CMTimeGetSeconds(self.playVideoView.player.currentItem.asset.duration);
    self.totalTimeLabel.text = [self formatTime:totalSeconds];
    //設定currentVideoSlider 的長度
    self.currentVideoSlider.maximumValue = totalSeconds;
    __weak typeof(self) weakSelf = self;
    [self.playVideoView.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 2) queue:dispatch_get_main_queue() usingBlock: ^(CMTime time) {
         int currentTime = CMTimeGetSeconds(weakSelf.playVideoView.player.currentTime);
         [weakSelf.currentVideoSlider setValue:currentTime];
         weakSelf.currentlyTimeLabel.text = [weakSelf formatTime:currentTime];
     }];
    [self.playVideoView.player play];
}

- (void)navigationBarConfigure {
    // 完全透明的navigationBar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    // 取消navigationBar下邊的線
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    // 設定navigationBar 右鍵配置
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(nextVideoButtonAction:)];
    // 設定navigationBar 右鍵配置
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(periousVideoButtonAction:)];
}
- (void)valueConfigure{
    self.videos = @[@"like", @"Movie", @"我能給的"];
    self.playIndex = 0;
}

#pragma mark * misc

- (NSString *)formatTime:(int)num {
    // 秒轉分鐘
    int sec = num % 60;
    int min = num / 60;
    return [NSString stringWithFormat:@"%02d:%02d", min, sec];
}

- (UIImage *)movieImage:(NSString *)fileName {
    // 取得影片畫面
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"m4v"];
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    // 選擇要擷取圖片的時間範圍
    CMTime time = CMTimeMake(10, 10);
    CGImageRef imgRef = [imageGenerator copyCGImageAtTime:time actualTime:nil error:nil];
    return [[UIImage alloc] initWithCGImage:imgRef];
}

#pragma mark * play feature

- (void)nextVideoButtonAction:(id)sender {
    // 下一首
    self.playIndex++;
    [self playVideoConfigure];
}

- (void)periousVideoButtonAction:(id)sender {
    // 上一首
    self.playIndex--;
    [self playVideoConfigure];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // tableView: cellForRowAtIndexPath:方法中有兩個得重用cell的方法
    [self.videoInfoTableView registerClass:[VideoListViewCell class] forCellReuseIdentifier:@"VideoListViewCell"];
    [self navigationBarConfigure];
    [self valueConfigure];
    [self playVideoConfigure];
}

@end