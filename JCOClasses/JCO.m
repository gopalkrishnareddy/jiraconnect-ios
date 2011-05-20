//
//  JCO.m
//  JiraConnect
//
//  Created by Nicholas Pellow on 21/09/10.
//

#import "JCO.h"
#import "Core/JCOPing.h"
#import "Core/JCONotifier.h"
#import "JCOCrashSender.h"


@implementation JCO

@synthesize url=_url;

JCOPing * _pinger;
JCONotifier * _notifier;
JCOViewController* _jcController;
UINavigationController *_navController;
JCOCrashSender* _crashSender;
id<JCOCustomDataSource> _customDataSource;

+(JCO*) instance {
	static JCO *singleton = nil;
	
	if (singleton == nil) {
		singleton = [[JCO alloc] init];
	}
	return singleton;
}

- (id)init {
	if ((self = [super init])) {
		_pinger = [[[JCOPing alloc] init] retain];
		UIView* window = [[UIApplication sharedApplication] keyWindow]; // TODO: investigate other ways to present our replies dialog.
		_notifier = [[[JCONotifier alloc] initWithView:window] retain];
		_crashSender = [[[JCOCrashSender alloc] init] retain];
		_jcController = [[[JCOViewController alloc] initWithNibName:@"JCOViewController" bundle:nil] retain];
        _navController = [[[UINavigationController alloc] initWithRootViewController:_jcController] retain];
        _navController.navigationBar.translucent = YES;
    }
	return self;
}


- (void) configureJiraConnect:(NSString*) withUrl customData:(id<JCOCustomDataSource>)customData {

    [CrashReporter enableCrashReporter];
	self.url = [NSURL URLWithString:withUrl];

    _pinger.baseUrl = self.url;
    [_pinger start];
    _jcController.payloadDataSource = customData;

    // TODO: fire this when network becomes active

	[NSTimer scheduledTimerWithTimeInterval:3 target:_crashSender selector:@selector(sendCrashReportsAfterAsking) userInfo:nil repeats:NO];
	
	NSLog(@"JiraConnect is Configured with url: %@", withUrl);	
}


-(UIViewController*) viewController {
	return _navController;
}

/**
* Returns the actual JCOViewController.
* Its best to use viewController
*/
-(JCOViewController*) jcoViewController {

    for (UIViewController * controller in _navController.viewControllers) {
        NSLog(@"controller = %@", controller);
        if (controller == _jcController) {
            return (JCOViewController *)controller;
        }
    }
    return nil;
}

-(void) displayNotifications {
    [_notifier displayNotifications:nil];
}

-(NSDictionary*) getMetaData {
	UIDevice* device = [UIDevice currentDevice];
	NSDictionary* appMetaData = [[NSBundle mainBundle] infoDictionary];
	NSMutableDictionary* info = [[[NSMutableDictionary alloc] initWithCapacity:10] autorelease];
	
	// add device data
	[info setObject:[device uniqueIdentifier] forKey:@"udid"];
	[info setObject:[device name] forKey:@"devName"];
	[info setObject:[device systemName] forKey:@"systemName"];
	[info setObject:[device systemVersion] forKey:@"systemVersion"];
	[info setObject:[device model] forKey:@"model"];
	
	// app application data (we could make these two separate dicts but cbf atm)
	[info setObject:[appMetaData objectForKey:@"CFBundleVersion"] forKey:@"appVersion"];
	[info setObject:[appMetaData objectForKey:@"CFBundleName"] forKey:@"appName"];
	[info setObject:[appMetaData objectForKey:@"CFBundleIdentifier"] forKey:@"appId"];
	
	return info;
}

- (NSString*) getProjectName {
    if ([_customDataSource respondsToSelector:@selector(projectName)]) {
        return [_customDataSource projectName];
    }
    return [[self getMetaData] objectForKey:@"appName"];
}

-(void) dealloc {
	[_url release]; _url = nil;
	[_pinger release]; _pinger = nil;
	[_notifier release]; _notifier = nil;
	[_jcController release]; _jcController = nil;
	[_navController release]; _navController = nil;
	[_crashSender release]; _crashSender = nil;
	[super dealloc];
}


@end
