//
//  JCSetup.h
//  JiraConnect
//
//  Created by Nicholas Pellow on 21/09/10.
//  Copyright 2010 Nick Pellow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CrashReportSender.h"

@interface JCSetup : NSObject <CrashReportSenderDelegate> {

}

+ (JCSetup*) instance;

- (void) configureJiraConnect:(NSURL*) withUrl;
- (void) sendPing;

@end