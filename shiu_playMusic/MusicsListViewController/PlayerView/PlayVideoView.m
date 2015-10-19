//
//  PlayVideoView.m
//  LEOPlayerVideoDemo
//
//  Created by huangwenchen on 15/10/10.
//  Copyright © 2015年 huangwenchen. All rights reserved.
//

#import "PlayVideoView.h"
@implementation PlayVideoView
//需要一个 AVLayer 类的包装类。该类是一个 CALayer 子类，用于对媒体的可视内容进行管理。创建包装类的代码如下：
+(Class)layerClass{
    return [AVPlayerLayer class];
}
//然后为需要一个方法，实例化一个 AVPlayer 对象（我们在头文件中定义的）。如下列代码所示
- (AVPlayer*)player {
    return [(AVPlayerLayer *)[self layer] player];
}
//在 setPlayer 方法中，如下列代码所示，有一个 AVPlayer 参数，用于将一个 AVPlayer 实例添加到 UIView。这个 UIView 子类，将用在主 View Controller 中。
- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}
//回傳自己的layer
- (AVPlayerLayer *)playerLayer{
    return (AVPlayerLayer *)self.layer;
}
@end
