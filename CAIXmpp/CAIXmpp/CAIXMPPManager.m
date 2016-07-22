//
//  CAIXMPPManager.m
//  CAIXmpp
//
//  Created by liyufeng on 16/3/18.
//  Copyright © 2016年 liyufeng. All rights reserved.
//

#import "CAIXMPPManager.h"
#import "XMPPJID.h"
#import "CAIXmppStreamDelegate.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"


@interface CAIXMPPManager()<XMPPStreamDelegate>

@property (nonatomic, strong)CAIXmppStreamDelegate * delegate;

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
        [self roster];
        [self message];
    }
    return self;
}

- (void)setUpStream{
    self.delegate = [[CAIXmppStreamDelegate alloc]init];
    self.xmppStream = [[XMPPStream alloc]init];
    [self.xmppStream addDelegate:self.delegate delegateQueue:dispatch_get_main_queue()];
}

- (void)roster{
    self.xmppRosterCoreDataStorage=[[XMPPRosterCoreDataStorage alloc]init];
    self.xmppRoster=[[XMPPRoster alloc]initWithRosterStorage:self.xmppRosterCoreDataStorage];
    [self.xmppRoster activate:self.xmppStream];
}

- (void)message{
    self.xmppMessageArchivingCoreDataStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    self.xmppMessageArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:self.xmppMessageArchivingCoreDataStorage];
    [self.xmppMessageArchiving activate:self.xmppStream];
}

-(void) xmppConnect
{
    //1.创建JID
    [self.xmppStream disconnect];
    XMPPJID *jid = [XMPPJID jidWithUser:@"test" domain:@"flagcaicai.imwork.net" resource:@"iPhone"];
    //2.把JID添加到xmppSteam中
    [self.xmppStream setMyJID:jid];
    self.delegate.password = @"flygirl791008";
    //连接服务器
    NSError *error = nil;
    [self.xmppStream connectWithTimeout:10 error:&error];
    if (error) {
        NSLog(@"连接出错：%@",[error localizedDescription]);
    }
}

- (void)regist{
    XMPPJID *jid = [XMPPJID jidWithUser:@"test2" domain:@"flagcaicai.imwork.net" resource:@"iPhone"];
    //2.把JID添加到xmppSteam中
    [self.xmppStream setMyJID:jid];
    self.delegate.isRegist = YES;
    //连接服务器
    NSError *error = nil;
    [self.xmppStream connectWithTimeout:10 error:&error];
    if (error) {
        NSLog(@"连接出错：%@",[error localizedDescription]);
    }
}


- (void)sendMessage:(NSString *) messageString toUser:(NSString *) user {
    DDXMLElement *body = [DDXMLElement elementWithName:@"body"];
    [body setStringValue:messageString];
    DDXMLElement *message = [DDXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    NSString *to = [NSString stringWithFormat:@"%@@example.com", user];
    [message addAttributeWithName:@"to" stringValue:to];
    [message addChild:body];
    [self.xmppStream sendElement:message];
}


@end
