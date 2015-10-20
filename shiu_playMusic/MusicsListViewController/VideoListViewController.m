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
@property (nonatomic, weak) IBOutlet UISlider *videoSlider;

@property (strong, nonatomic) NSArray *videos;
@property (assign, nonatomic) BOOL isPlayingVideos;
@property (assign, nonatomic) BOOL isSliderMoving;
@property (assign, nonatomic) int playIndex;

@end

@implementation VideoListViewController

#pragma mark - IBAction

- (IBAction)videoRateButtonAction:(id)sender {
    // 設定影片播放速率
    self.playVideoView.player.rate = 2.0;
}

- (IBAction)playMusicButtonAction:(id)sender {
    // 播放功能
    [self playVideo];
}

- (IBAction)fullScreenButtonAction:(id)sender {
    self.tabBarController.tabBar.hidden = !self.tabBarController.tabBar.hidden;
    // 強制旋轉螢幕
    NSNumber *value;
    if ([UIDevice currentDevice].orientation != UIDeviceOrientationPortrait) {
        value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    }
    else {
        value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    }
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

#pragma mark * Slider

- (IBAction)videoSliderTouchDown:(id)sender {
    self.isSliderMoving = YES;
}
- (IBAction)videoSliderUpInside:(id)sender {
    self.isSliderMoving = NO;
    CMTime newTime = CMTimeMakeWithSeconds(self.videoSlider.value, self.videoSlider.maximumValue);
    [self.playVideoView.player seekToTime:newTime];
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
    [self removeAllObserver];
    [self playVideoConfigure:self.videos[self.playIndex]];
    self.isPlayingVideos = NO;
    [self playVideo];
}

#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"VideoListViewCell";
    VideoListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.videoImageView.image = [self movieImage:self.videos[indexPath.row]];
    return cell;
}

#pragma mark - private instance method

#pragma mark * init

- (void)playVideoConfigure:(NSString *)fileName {
    // 取得檔案路徑
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"m4v"];
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    // 設定播放項目
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:fileURL];
    self.playVideoView.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    self.playVideoView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    // 使用 KVO 監聽 playerItem 狀態
    [self.playVideoView.player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    // 使用 NSNotificationCenter 監聽 playerItem：如果播放完就直接下一首
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoDidFinishPlayed:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playVideoView.player.currentItem];
}

- (void)navigationBarConfigure {
    // 透明 navigationBar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    // 取消 navigationBar 下邊的線
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    // 設定 navigationBar 右鍵配置
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(nextVideoButtonAction:)];
    // 設定 navigationBar 右鍵配置
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(periousVideoButtonAction:)];
}

- (void)valueConfigure {
    // 初始設定
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
    // 取得影片檔案位置
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"m4v"];
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    // 選擇要擷取圖片的時間範圍，參數 2 為截取影片 2 秒處的畫面，10 為每秒 10禎
    CMTime time = CMTimeMakeWithSeconds(2, 10);
    CGImageRef imgRef = [imageGenerator copyCGImageAtTime:time actualTime:nil error:nil];
    return [[UIImage alloc] initWithCGImage:imgRef];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (self.playVideoView.player == object && [keyPath isEqualToString:@"status"]) {
        if (self.playVideoView.player.status == AVPlayerStatusReadyToPlay) {
            // 顯示總時間
            int totalSeconds = CMTimeGetSeconds(self.playVideoView.player.currentItem.asset.duration);
            self.totalTimeLabel.text = [self formatTime:totalSeconds];
            // 設定 currentVideoSlider 的長度
            self.videoSlider.maximumValue = totalSeconds;
            // 解除 retain cycle
            __weak typeof(self) weakSelf = self;
            // 给播放器增加進度更新
            [self.playVideoView.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 2) queue:dispatch_get_main_queue() usingBlock: ^(CMTime time) {
                 if (!weakSelf.isSliderMoving) {
                     int currentTime = CMTimeGetSeconds(weakSelf.playVideoView.player.currentTime);
                     weakSelf.videoSlider.value = currentTime;
                     weakSelf.currentlyTimeLabel.text = [weakSelf formatTime:currentTime];
                 }

             }];

        }
        else if (self.playVideoView.player.status == AVPlayerStatusFailed) {
            NSLog(@"檔案錯誤");
        }
        else if (self.playVideoView.player.status == AVPlayerStatusUnknown) {

        }
    }
}

- (void)removeAllObserver {
    [self.playVideoView.player removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playVideoView.player.currentItem];
}

#pragma mark * play feature

- (void)videoDidFinishPlayed:(id)sender {
    //播放完畢之後繼續播下一首
    [self nextVideo];
}

- (void)playVideo {
    // 播放功能
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

- (void)nextVideoButtonAction:(id)sender {
    // 下一首
    [self nextVideo];
}

- (void)periousVideoButtonAction:(id)sender {
    // 上一首
    [self periousVideo];
}

- (void)nextVideo {
    self.playIndex++;
    if (self.playIndex >= self.videos.count) {
        self.playIndex = 0;
    }
    [self removeAllObserver];
    [self playVideoConfigure:self.videos[self.playIndex]];
    self.isPlayingVideos = NO;
    [self playVideo];
}

- (void)periousVideo {
    self.playIndex--;
    if (self.playIndex < 0) {
        self.playIndex = (int)self.videos.count - 1;
    }
    [self removeAllObserver];
    [self playVideoConfigure:self.videos[self.playIndex]];
    self.isPlayingVideos = NO;
    [self playVideo];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // tableView cellForRowAtIndexPath 方法中有兩個得重用 cell 的方法
    [self.videoInfoTableView registerClass:[VideoListViewCell class] forCellReuseIdentifier:@"VideoListViewCell"];
    [self navigationBarConfigure];
    [self valueConfigure];
}
@end