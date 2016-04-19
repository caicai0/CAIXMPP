#import <Foundation/Foundation.h>
#import "NSXMLElement+XMPP.h"

@class XMPPResultSet;


@interface NSXMLElement (XEP_0059)

- (BOOL)isResultSet;
- (BOOL)hasResultSet;
- (XMPPResultSet *)resultSet;

@end
