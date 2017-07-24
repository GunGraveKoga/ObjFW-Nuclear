#import <ObjFW/ObjFW.h>
#import "NKApplication.h"
#import "NKApplication+OFApplicationDelegate.h"

static Class _nkAppDelegateInitial = Nil;

static BOOL _isInitialized = NO;

@interface NKApplication()

@end


@implementation NKApplication

@synthesize delegate = _delegate;

- (instancetype)init {

	if (_isInitialized) {
		OF_INVALID_INIT_METHOD
	}

	self = [super init];
	_delegate = [[_nkAppDelegateInitial alloc] init];

	_isInitialized = YES;

	return self;

}

- (void)dealloc {

	[_delegate release];

	[super dealloc];
}

@end


@implementation NKApplication (OFApplicationDelegate)

- (void)applicationDidFinishLaunching {

	void *pool = objc_autoreleasePoolPush();

	[_delegate applicationDidFinishLaunching];

	objc_autoreleasePoolPop(pool);
}

- (void)applicationWillTerminate {

	if ([_delegate respondsToSelector:@selector(applicationWillTerminate)]) {
		[_delegate applicationWillTerminate];
	}
}

- (void)applicationDidReceiveSIGINT {
	if ([_delegate respondsToSelector:@selector(applicationDidReceiveSIGINT)]) {
		[_delegate applicationDidReceiveSIGINT];
	}
}

@end

int nk_application_main(int *argc, char **argv[], Class cls) {

	if ([cls isSubclassOfClass: [NKApplication class]]) {
		fprintf(stderr, "FATAL ERROR:\n  Class %s is a subclass of "
		    "class NKApplication, but class\n  %s was specified as "
		    "application delegate!\n  Most likely, you wanted to "
		    "subclass OFObject instead or specified\n  the wrong class "
		    "with NK_APPLICATION_DELEGATE().\n",
		    class_getName(cls), class_getName(cls));
		exit(1);
	}

	_nkAppDelegateInitial = cls;

	return of_application_main(argc, argv, [NKApplication class]);

}