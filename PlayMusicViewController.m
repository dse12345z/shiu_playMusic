//
//  PlayMusicViewController.m
//  shiu_playMusic
//
//  Created by allen_hsu on 2015/10/15.
//  Copyright © 2015年 allen_hsu. All rights reserved.
//

#import "PlayMusicViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
@interface PlayMusicViewController ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *avPlayerLayer;
@property (nonatomic, strong) AVPlayerItem *currentItem;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;

@end

@implementation PlayMusicViewController

- (void)viewDidLoad {

    //獲得documentsPath的路徑
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0], paths];

    //獲得Resource的路徑
    NSString *path = [[NSBundle mainBundle] pathForResource:@"like" ofType:@"m4v"];

    NSURL *fileURL = [NSURL fileURLWithPath:path];
    self.player = [[AVPlayer alloc] initWithPlayerItem:[[AVPlayerItem alloc] initWithURL:fileURL]];
    self.avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];

    self.avPlayerLayer.bounds = self.view.bounds;
    self.avPlayerLayer.frame = self.view.frame;

    // self.view.backgroundColor = [UIColor clearColor];
    [self.view.layer addSublayer:_avPlayerLayer];

    [_player play];
    
    //獲得影片圖片
    AVAsset *asset = [AVAsset assetWithURL:fileURL];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    CMTime time = CMTimeMake(1, 1);
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    self.imageview.image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    [super viewDidLoad];
}



@end
