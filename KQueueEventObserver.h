#import <ObjFW/OFObject.h>
#import <ObjFW/OFKernelEventObserver.h>

@class OFList;

@interface KQueueEventObserver: OFObject {
	id <OFKernelEventObserverDelegate> _delegate;
	OFList *_readQueue;
	HANDLE _iocp;
}

- (void)observeForTimeInterval:(of_time_interval_t)timeInterval;
- (void)observeUntilData:(OFDate *)date;

@end
