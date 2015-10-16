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
@property (weak, nonatomic) IBOutlet UIView *PlayingToolsView;

@property (weak, nonatomic) IBOutlet UIView *dispalyMovieView;
@property (weak, nonatomic) IBOutlet UITableView *musicsInfoTableView;
@property (strong) AVPlayer *player;
@property (strong) AVPlayerLayer *avPlayerLayer;
@property (strong) AVPlayerItem *currentItem;

@end

@implementation MusicsListViewController

#pragma mark - TableView Delegate

- (IBAction)turnScreenButtonAction:(id)sender {
    self.avPlayerLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    //self.avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    PlayMusicViewController *playerViewController = [PlayMusicViewController new];
//    [self presentViewController:playerViewController animated:YES completion:nil];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0], paths];
    
    //獲得Resource的路徑
    NSString *path = [[NSBundle mainBundle] pathForResource:@"like" ofType:@"m4v"];
    
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    self.player = [[AVPlayer alloc] initWithPlayerItem:[[AVPlayerItem alloc] initWithURL:fileURL]];
    self.avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    self.avPlayerLayer.frame = CGRectMake(0, 0, self.dispalyMovieView.frame.size.width, self.dispalyMovieView.frame.size.height);
      self.avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    // self.view.backgroundColor = [UIColor clearColor];
    [self.dispalyMovieView.layer addSublayer:_avPlayerLayer];
    
    [_player play];

    
}
- (void)replaceCurrentItemWithPlayerItem:(nullable AVPlayerItem *)item {
    NSLog(@"123");
}
#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"TableViewCell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    //cell.temp=self.infoArray[indexPath.row];
    return cell;
}


#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // tableView: cellForRowAtIndexPath:方法中有兩個得重用cell的方法
    [self.musicsInfoTableView registerClass:[TableViewCell class] forCellReuseIdentifier:@"TableViewCell"];
    
    
    
    
    
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

    
//    NSArray *names=@[@"Tom",@"Mark",@"Amry",@"Harry",@"Jack"];
//    NSArray *sexs=@[@0,@1,@0,@1,@0];
//    NSArray *birthdays=@[@"1990-09-10",@"1940-01-18",@"1970-05-25",@"2000-07-06",@"1991-10-24"];


//    self.infoArray= [NSMutableArray new];
//    for (int i=0; i<names.count; i++) {
//        NSMutableDictionary *infoDictionary = [NSMutableDictionary new];
//
//        [infoDictionary setObject:birthdays[i] forKey:@"birthday"] ;
//        [infoDictionary setObject:names[i] forKey:@"name"] ;
//        [infoDictionary setObject:([sexs [i] isEqual:@0])? @"boy" : @"girl" forKey:@"controlSex"] ;
//        [self.infoArray addObject:infoDictionary];
//        NSLog(@"%@",[infoDictionary objectForKey:@"name"] );
//
//    }



}

@end
