//
//  CAIXMPPManager.h
//  CAIXmpp
//
//  Created by liyufeng on 16/3/18.
//  Copyright © 2016年 liyufeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPStream.h"
#import "Enum.h"
//好友列表
#import "XMPPRoster.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPMessageArchivingCoreDataStorage.h"

@interface CAIXMPPManager : NSObject

+ (instancetype)manager;

@property (nonatomic, strong)XMPPStream * xmppStream;
@property (nonatomic, strong)XMPPRoster * xmppRoster;
@property (nonatomic, strong)XMPPRosterCoreDataStorage * xmppRosterCoreDataStorage;
@property (nonatomic, strong)XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;
@property (nonatomic, strong)XMPPMessageArchiving * xmppMessageArchiving;

-(void) xmppConnect;
-(void) regist;
- (void)queryRoster;

@end
