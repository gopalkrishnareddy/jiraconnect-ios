JIRAConnect for iOS
===================

JIRAConnect is an iOS library that can be embedded into any iOS App to provide following extra functionality:

* **Real Time Crash Reporting** have users or testers submit crash reports directly to your JIRA instance
* **User or Tester Feedback** views for allowing users or testers to create a bug report within your app.
* **2-way Communication with Users** thank your users or testers for providing feedback on your App!

![Report Issue Screen](https://bytebucket.org/atlassian/jiraconnect-ios/wiki/small_report-issue.png) ![Crash Report Dialog](https://bytebucket.org/atlassian/jiraconnect-ios/wiki/small_crash-report.png) ![2-Way Communications](https://bytebucket.org/atlassian/jiraconnect-ios/wiki/small_replies-view.png)

Getting Started
===============

To install JIRAConnect into your current project:
-------------------------------------------------

1. `hg clone ssh://hg@bitbucket.org/atlassian/jiraconnect-ios`
1. Open your project in XCode, right click on your Classes group, and select **'Add Files to YourProjectName'**
1. Browse to the **jiraconnect-ios** clone directory, and add the entire JIRAConnect/JCOClasses directory to your project.
1. Select the project (top most) element in the file/groups tree
1. Click **'Build Phases'** --> Expand **'Link Binary with Libraries'** --> **+**
1. add the following frameworks:
    * CFNetwork
    * SystemConfiguration
    * MobileCoreServices
    * CoreGraphics
    * AVFoundation
    * CoreLocation
    * libz1.2.3
1. Add the `CrashReporter.framework` to your project's frameworks: **+** --> **'Add Other'**
1. Browse to jiraconnect-ios then **JIRAConnect/JCOClasses/Libraries/** --> **CrashReporter.framework**
1. Click **'Open'**
1. Try compiling your App, and ensure there are no errors.

To use JIRAConnect in your App:
-------------------------------
1. Import the JCO.h header file into your ApplicationDelegate

        #import "JCO.h"

1. Configure the [JCO instance] at the *end* of the ApplicationDelegate.m like so:


    `- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions`
method, add the following line:

        [[JCO instance] configureJiraConnect:@"http://connect.onjira.com" customDataSource:nil];

1. Replace the string @"http://connect.onjira.com" with the location of the JIRA instance you wish to connect to.

1. The JIRA URL you configured above, will need to have:
    * the jconnect-plugin installed
    * a project named either the same as
        * the XCode Project,
        * or the value returned by your [id&lt;JCOCustomDataSource&gt; project] method. This can be the project key in JIRA, or the project's name.

1. Provide a trigger mechanism to allow users invoke the Submit Feedback view. This typically goes on the 'About' or 'Info' view.
The UIViewController returned by JCO viewController is designed to be presented modally.
If your info ViewController is in a UINavigationController stack, then you can use the following snippet to show both the feedback view, and the history view.

<pre>
#import "JCO.h"

- (void)viewDidLoad
{
    self.navigationItem.rightBarButtonItem =
    [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                   target:self
                                                   action:@selector(showFeedback)] autorelease];
    self.navigationItem.leftBarButtonItem =
    [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize
                                                   target:self
                                                   action:@selector(showPastFeedback)] autorelease];
}

-(void) showFeedback
{
    [self presentModalViewController:[[JCO instance] viewController] animated:YES];
}

-(void) showPastFeedback
{
    [self presentModalViewController:[[JCO instance] issuesViewController] animated:YES];
}
</pre>

Issue tracking
==============

Use http://connect.onjira.com/browse/CONNECT to raise any issue with the JIRA Mobile Connect library for testing.
Also - install and configure the [JIRA Mobile Connect Plugin](https://bitbucket.org/atlassian/jiraconnect-jiraplugin) in your own running JIRA instance.



Third party Package - License - Copyright / Creator
===================================================

asi-http-request	BSD		Copyright &copy; 2007-2011, [All-Seeing Interactive](http://allseeing-i.com/ASIHTTPRequest/)

json-framework      BSD     Copyright &copy; 2009 [Stig Brautaset.]( http://code.google.com/p/json-framework/)

plcrashreporter     MIT     Copyright (c) 2008-2009 [Plausible Labs Cooperative, Inc.]( http://code.google.com/p/plcrashreporter/)

crash-reporter              Copyright &copy; 2009 Andreas Linde & Kent Sutherland.

UIImageCategories           Created by [Trevor Harmon.](http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/)

