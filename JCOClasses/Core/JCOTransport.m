//
//  JCOTransport.m
//  JiraConnect
//
//  Created by Nick Pellow on 4/11/10.
//

#import "JCOTransport.h"
#import "JSON.h"
#import "JCO.h"

@implementation JCOTransport

- (void)populateCommonFields:(NSString *)description
                      images:(NSArray *)images
                   voiceData:(NSData *)voiceData
                 payloadData:(NSDictionary *)payloadData
                customFields:(NSDictionary *)customFields
                   upRequest:(ASIFormDataRequest *)upRequest
                      params:(NSMutableDictionary *)params {

    [params setObject:description forKey:@"description"];
    NSDictionary *metaData = [[JCO instance] getMetaData];
    [params addEntriesFromDictionary:metaData];
    NSData *jsonData = [[params JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
    [upRequest setData:jsonData withFileName:@"issue.json" andContentType:@"application/json" forKey:@"issue"];
    if (images != nil) {
        for (int i = 0; i < [images count]; i++) {
            NSData *imgData = UIImagePNGRepresentation([images objectAtIndex:i]);
            NSString *filename = [@"jiraconnect-screenshot" stringByAppendingFormat:@"-%d.png", i];
            NSString *key = [@"screenshot" stringByAppendingFormat:@"-%d", i];
            [upRequest setData:imgData withFileName:filename andContentType:@"image/png" forKey:key];
        }
    }
    if (voiceData != nil) {
        [upRequest setData:voiceData withFileName:@"voice-feedback.caf" andContentType:@"audio/x-caf" forKey:@"recording"];
    }
    if (payloadData != nil) {
        NSData *json = [[payloadData JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
        [upRequest setData:json withFileName:@"payload.txt" andContentType:@"plain/text" forKey:@"payload"];
    }
    if (customFields != nil) {
        NSData *json = [[customFields JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
        [upRequest setData:json withFileName:@"customfields.json" andContentType:@"application/json" forKey:@"customfields"];
    }
}

#pragma mark ASIHTTPRequest

- (void)alert:(NSString *)msg withTitle:(NSString *)title button:(NSString *)button {
    UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:title
                message:msg
                delegate:self
                cancelButtonTitle:button
                otherButtonTitles:nil];
    [alertView2 show];
    [alertView2 release];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    
    NSLog(@"Response for %@ is %@", request.url,  [request responseString]);
    if (request.responseStatusCode < 300) {

        NSString *msg = [NSString stringWithFormat:@"Your feedback has been received. Thank you, for the common good."];
        [self alert:msg withTitle:@"Thank you" button:@"OK"];
        // alert the delegate!
        // TODO: also alert on FAIL...
        [self.delegate transportDidFinish];

    } else {
        [self requestFailed:request];
    }

}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    NSLog(@"request failed: %@", request);
    if ([self.delegate respondsToSelector:@selector(transportDidFinishWithError:)]) {
        NSLog(@"invoking transportDidFinishWithError:");
        [self.delegate transportDidFinishWithError:error];
    }
    NSString *msg = @"";
    if (request.responseStatusCode >= 300) {
        msg = [msg stringByAppendingFormat:@"Response code %d\n", request.responseStatusCode];
    }
    if ([error localizedDescription] != nil) {
        msg = [msg stringByAppendingFormat:@"%@.\n", [error localizedDescription]];
    }
    msg = [msg stringByAppendingString:@"Please try again later."];
    
    NSLog(@"requestFailed: %@ URL: %@, response code: %d", msg, [request url], [request responseStatusCode]);
    [self alert:msg withTitle:@"Error submitting Feedback" button:@"OK"];
}

#pragma mark end

@synthesize delegate = _delegate;

- (void)dealloc {
    self.delegate = nil;
    [super dealloc];
}


@end
