#import <ObjFW/ObjFW.h>
#import "NKRunLoop.h"

@interface OFTimer()
@property OF_NULLABLE_PROPERTY (nonatomic, retain, setter=of_setInRunLoop:)
    OFRunLoop *of_inRunLoop;
@end

@implementation NKRunLoop

- (void)runUntilDate: (OFDate *)deadline {
	_stop = false;

	for(;;) {

		void *pool = objc_autoreleasePoolPush();
		OFDate * now = [OFDate date];
		OFDate * nextTimer;

		for(;;) {

			OFTimer *timer;

#ifdef OF_HAVE_THREADS
			[_timersQueueLock lock];

			@try {
#endif			
				of_list_object_t *listObject = [_timersQueue firstObject];

				if (listObject != NULL && 
					[[listObject->object fireDate] compare:now] != OF_ORDERED_DESCENDING) {

					timer = [[listObject->object retain] autorelease];

					[_timersQueue removeListObject:listObject];

					[timer of_setInRunLoop:nil];

				} else 
					break;

#ifdef OF_HAVE_THREADS
			}@finally {
				[_timersQueueLock unlock];
			}
#endif		

			if ([timer isValid])
				[timer fire];
		}

#ifdef OF_HAVE_THREADS
		[_timersQueueLock lock];

		@try {
#endif		
			nextTimer = [[_timersQueue firstObject] fireDate];

#ifdef OF_HAVE_THREADS
		} @finally {
			[_timersQueueLock unlock];
		}
#endif		

		if (nextTimer != nil || deadline != nil) {

		} else {

		}

		if (_stop || (deadline != nil &&
			[deadline compare: now] != OF_ORDERED_DESCENDING)) {

			objc_autoreleasePoolPop(pool);

			break;
		}

		objc_autoreleasePoolPop(pool);
	}
}

@end