//
//  JCComment.m
//  JiraConnect
//
//  Created by Shihab Hamid on 17/03/11.
//  Copyright 2011 Atlassian. All rights reserved.
//

#import "JCComment.h"


@implementation JCComment

@synthesize author = _author;
@synthesize body = _body;

- (void) dealloc {
	[_author release];
    [_body release];
	[super dealloc];
}

- (id) initWithAuthor:(NSString*)p_author body:(NSString*)p_body {
	if ((self = [super init])) {
		self.author = p_author;
        self.body = p_body;
	}
	return self;
}


@end
