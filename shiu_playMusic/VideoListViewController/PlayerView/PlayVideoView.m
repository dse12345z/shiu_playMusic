//
//  PlayVideoView.m
//  LEOPlayerVideoDemo
//
//  Created by huangwenchen on 15/10/10.
//  Copyright © 2015年 huangwenchen. All rights reserved.
//

#import "PlayVideoView.h"

@implementation PlayVideoView

+ (Class)layerClass {
    // 包裝一個 AVPlayerLayer 使用。
    return [AVPlayerLayer class];
}

- (AVPlayer *)player {
    // 初始化 player。
    return [(AVPlayerLayer *)[self layer] player];
}


- (void)setPlayer:(AVPlayer *)player {
    // 將 AVPlayer 放到 UiView 。
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}


- (AVPlayerLayer *)playerLayer {
    // 回傳自己的 layer。
    return (AVPlayerLayer *)self.layer;
}
@end
