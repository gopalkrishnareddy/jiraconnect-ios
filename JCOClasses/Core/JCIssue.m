//
//  JCIssue.m
//  JiraConnect
//
//  Created by Shihab Hamid on 17/03/11.
//  Copyright 2011 Atlassian. All rights reserved.
//

#import "JCIssue.h"
#import "JCComment.h"

@implementation JCIssue

@synthesize key = _key;
@synthesize status = _status;
@synthesize title = _title;
@synthesize description = _description;
@synthesize comments = _comments;

- (void) dealloc {
	[_key release];
    [_status release];
    [_title release];
    [_description release];
    [_comments release];
	[super dealloc];
}

- (id) initWithDictionary:(NSDictionary*)map {
	if ((self = [super init])) {
		self.key = [map objectForKey:@"key"];
        self.status = [map objectForKey:@"status"];
        self.title = [map objectForKey:@"title"];
        self.description = [map objectForKey:@"description"];    
        
        if (!self.key)
        {
            self.key = @"(no issue key)";
        }
        if (!self.status)
        {
            self.status = @"(no status)";
        }
        if (!self.title)
        {
            self.title = @"(no title)";
        }
        if (!self.description)
        {
            self.description = @"(no description)";
        }
        
        NSArray* commentDataArray = [map objectForKey:@"comments"];
        if (commentDataArray)
        {
            NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:[commentDataArray count]];
            for (NSDictionary* data in commentDataArray)
            {
                NSString* author = [data objectForKey:@"username"];
                if (!author)
                {
                    author = @"(no author)";
                }
                NSString* body = [data objectForKey:@"text"];
                if (!body)
                {
                    body = @"(no body)";
                }
                JCComment* comment = [[JCComment alloc] initWithAuthor:author body:body];
                [array addObject:comment];
            }
            self.comments = array;
            [array release];
        }
    }
    
    NSLog(@"self = %@", self);
    
	return self;
}

- (NSString*) asString {
    return [NSString stringWithFormat:@"key: %@, status %@, title: %@, description: %@", _key, _status, _title, _description];
}

@end