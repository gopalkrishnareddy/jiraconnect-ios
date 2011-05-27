#import "AngryNerdsViewController.h"
#import "JCO.h"

@implementation AngryNerdsViewController

@synthesize triggerButtonCrash, triggerButtonFeedback, triggerButtonNotifications;
CLLocation *_currentLocation;

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager = [[[CLLocationManager alloc] init] retain];
        _locationManager.delegate = self;
        [_locationManager startUpdatingLocation];
        NSLog(@"started updating location manager = %@", _locationManager );


    }
}

- (IBAction)triggerFeedback {
    UIViewController *controller = [[JCO instance] viewController];
    [self presentModalViewController:controller animated:YES];
}

- (IBAction)triggerCrash {
    NSLog(@"Triggering crash!");
    /* Trigger a crash. NB: if run from XCode, the sigquit handler wont be called to store crash data. */
    CFRelease(NULL);
}

#pragma mark JCOCustomDataSource

- (NSString *)project {
    return @"AngryNerds";
}

- (NSDictionary *)customFieldsFor:(NSString *)issueTitle {
    NSMutableArray *objects = [NSMutableArray arrayWithObjects:@"custom field value.", nil];
    NSMutableArray *keys = [NSMutableArray arrayWithObjects:@"customer", nil];
    if (_currentLocation != nil) {
        @synchronized (self) {
            NSNumber *lat = [NSNumber numberWithDouble:_currentLocation.coordinate.latitude];
            NSNumber *lng = [NSNumber numberWithDouble:_currentLocation.coordinate.longitude];
            NSString *locationString = [NSString stringWithFormat:@"%f,%f", lat.doubleValue, lng.doubleValue];
            [keys addObject:@"lat"]; [objects addObject:lat];
            [keys addObject:@"lng"]; [objects addObject:lng];
            [keys addObject:@"location"]; [objects addObject:locationString];
        }
    } else {
        // DUMMY just for the demo.... 37.331689, -122.030731
         NSNumber *lat = [NSNumber numberWithDouble:37.331689];
            NSNumber *lng = [NSNumber numberWithDouble:-122.030731];
            NSString *locationString = [NSString stringWithFormat:@"%f,%f", lat.doubleValue, lng.doubleValue];
            [keys addObject:@"lat"]; [objects addObject:lat];
            [keys addObject:@"lng"]; [objects addObject:lng];
            [keys addObject:@"location"]; [objects addObject:locationString];

    }
    return [NSDictionary dictionaryWithObjects:objects forKeys:keys];
}

- (NSDictionary *)payloadFor:(NSString *)issueTitle {
    return [NSDictionary dictionaryWithObject:@"store any custom information here." forKey:@"customer"];
}

#pragma end

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    @synchronized (self) {
        [_currentLocation release];
        _currentLocation = newLocation;
        [_currentLocation retain];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"location did fail... with error: %@", [error localizedDescription]);
}


- (IBAction)triggerDisplayNotifications {
    [[JCO instance] displayNotifications];
}

- (void)dealloc {
    self.triggerButtonCrash, self.triggerButtonFeedback, self.triggerButtonNotifications = nil;
    [_locationManager release];
    [super dealloc];
}

- (void)viewDidUnload {
    [_locationManager release];
    [super viewDidUnload];
}


@end
