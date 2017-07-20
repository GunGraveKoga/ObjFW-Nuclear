#import <ObjFW/ObjFW.h>
#import "NKEventObserver.h"
#import "NKEventObserver+Private.h"

typedef uint8_t test_cc;


@implementation NKEventObserver
@synthesize prop_cc;
+ (instancetype)observer {
	return [[[self alloc] init] autorelease];
}

- (instancetype)init {
	OF_UNRECOGNIZED_SELECTOR
}

@end