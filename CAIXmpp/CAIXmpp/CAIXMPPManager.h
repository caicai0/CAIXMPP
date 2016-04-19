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

@interface CAIXMPPManager : NSObject

+ (instancetype)manager;

@property (nonatomic, strong)XMPPStream * xmppStream;

@end
