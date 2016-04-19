//
//  CAIXMPPManager.m
//  CAIXmpp
//
//  Created by liyufeng on 16/3/18.
//  Copyright © 2016年 liyufeng. All rights reserved.
//

#import "CAIXMPPManager.h"
#import "XMPPJID.h"

@interface CAIXMPPManager()<XMPPStreamDelegate>

@end

@implementation CAIXMPPManager

+ (instancetype)manager{
    static CAIXMPPManager * manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CAIXMPPManager alloc]init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpStream];
    }
    return self;
}

- (void)setUpStream{
    self.xmppStream = [[XMPPStream alloc]init];
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

-(void) xmppConnect
{
    //1.创建JID
    XMPPJID *jid = [XMPPJID jidWithUser:@"test" domain:@"flagcaicia.imwork.net" resource:@"iPhone"];
    //2.把JID添加到xmppSteam中
    [self.xmppStream setMyJID:jid];
    //连接服务器
    NSError *error = nil;
    [self.xmppStream connectWithTimeout:10 error:&error];
    if (error) {
        NSLog(@"连接出错：%@",[error localizedDescription]);
    }
}

#pragma mark - XMPPStreamDelegate

- (void)xmppStreamWillConnect:(XMPPStream *)sender{
    NSLog(@"%s,%s",__FILE__,__FUNCTION__);
}


@end
