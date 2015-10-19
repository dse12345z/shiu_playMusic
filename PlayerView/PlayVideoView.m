//
//  PlayVideoView.m
//  LEOPlayerVideoDemo
//
//  Created by huangwenchen on 15/10/10.
//  Copyright © 2015年 huangwenchen. All rights reserved.
//

#import "PlayVideoView.h"
@implementation PlayVideoView

+(Class)layerClass{
    return [AVPlayerLayer class];
}
- (AVPlayer*)player {
    return [(AVPlayerLayer *)[self layer] player];
}
- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}
- (AVPlayerLayer *)playerLayer{
    return (AVPlayerLayer *)self.layer;
}
@end
