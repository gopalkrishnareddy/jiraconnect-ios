
#import "JCODemoViewController.h"
#import "JCO.h"

@implementation JCODemoViewController

@synthesize triggerButtonCrash, triggerButtonFeedback, triggerButtonNotifications;


- (IBAction) triggerFeedback {
	UIViewController* controller = [[JCO instance] viewController];
	[self presentModalViewController:controller animated:YES];
}

- (IBAction) triggerCrash
{
	NSLog(@"Triggering crash!");
	/* Trigger a crash */
	CFRelease(NULL);
}

- (NSDictionary *)customFieldsFor:(NSString *)issueTitle {
    NSArray *objects = [NSArray arrayWithObjects:@"custom field value.", nil];
    NSArray *keys = [NSArray arrayWithObjects:@"customer", nil];
    return [NSDictionary dictionaryWithObjects:objects
                                       forKeys:keys];
}

- (NSDictionary *)payloadFor:(NSString *)issueTitle {
    return [NSDictionary dictionaryWithObject:@"store any custom information here." forKey:@"customer"];
}


- (IBAction) triggerDisplayNotifications {
    NSLog(@"Trigger notifications");
    [[JCO instance] displayNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    self.triggerButtonCrash, self.triggerButtonFeedback, self.triggerButtonNotifications = nil;
    [super dealloc];
}

@end
