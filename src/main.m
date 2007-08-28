
#import <UIKit/UIKit.h>
#import "iRCMobileApp.h"


int main(int argc, const char *argv[]) {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int ret = UIApplicationMain(argc, argv, [iRCMobileApp class]);
	[pool release];
	return ret;
}