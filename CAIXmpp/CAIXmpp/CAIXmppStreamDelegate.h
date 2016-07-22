//
//  CAIXmppStreamDelegate.h
//  CAIXmpp
//
//  Created by liyufeng on 16/4/19.
//  Copyright © 2016年 liyufeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPStream.h"

@interface CAIXmppStreamDelegate : NSObject <NSObject,XMPPStreamDelegate>

@property (nonatomic, assign)BOOL isRegist;//是不是注册
@property (nonatomic, strong)NSString * password;//登陆或是注册用的密码

@end
