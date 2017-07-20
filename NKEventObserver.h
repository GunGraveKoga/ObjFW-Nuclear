#import <ObjFW/OFObject.h>
#import "NKEventDispatcher.h"
#import "NKWindow.h"
#import "NKEvent.h"

@class OFDate;

@interface NKEventObserver: OFObject {
	OF_KINDOF(NKEventDispatcher) *_dispatcher;
}
@property int prop_cc;
+ (instancetype)observer;
- (void)observe;
- (void)observeForTimeInterval:(of_time_interval_t)timeInterval;
- (void)observeUntilDate:(OFDate *)date;
@end