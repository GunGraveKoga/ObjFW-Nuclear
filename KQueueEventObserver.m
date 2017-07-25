#import <ObjFW/ObjFW.h>
#import "KQueueEventObserver.h"

static OFString * const kKQEventBufferKey = @"kKQEventBufferKey";

@interface KQEventBuffer: OFObject {
	struct {
		DWORD bytes;
		ULONG_PTR key;
		OVERLAPPED *overlap;

	} _iocp_buf;
}

@property(nonatomic, readonly) DWORD *bytes;
@property(nonatomic, readonly) ULONG_PTR *key;
@property(nonatomic, readonly) OVERLAPPED **overlap;

+ (instancetype)sharedBuffer;
- (void)refresh;

@end

@interface KQueueEventObserver()
- (int)kq_wait:(of_time_interval_t)timeout;
- (void)kq_peak:(int)noe;
@end

@implementation KQueueEventObserver

-(instancetype)init {
	self = [super init];

	@try {

		if ((_iocp = CreateIoCompletionPort(INVALID_HANDLE_VALUE, NULL, 0, 0)) == NULL)
			@throw [OFInitializationFailedException exceptionWithClass:[self class]];

	} @catch(id e) {
		[self release];

		@throw e;
	}

	return self;
}

- (void)dealloc {
	if (_iocp != NULL)
		CloseHandle(_iocp);


	[super dealloc];
}

- (void)observeUntilData:(OFDate *)date {

	of_time_interval_t timeInterval = -1;

	if (date != nil)
		timeInterval = [date timeIntervalSinceNow];

	[self observeForTimeInterval:timeInterval];
}

- (void)observeForTimeInterval:(of_time_interval_t)timeInterval {
	int noe = [self kq_wait:timeInterval];

	if (noe < 0)
		@throw [OFObserveFailedException exceptionWithObserver:(OFKernelEventObserver *)self errNo:GetLastError()];

	[self kq_peak:noe];
}

- (int)kq_wait:(of_time_interval_t)timeout {

	DWORD timeout_ms;

	uint64_t milsec = (((long)timeout * (uint64_t)1000) + (uint64_t)(lrint(timeout - (long)timeout)));

	timeout_ms = (DWORD)milsec;

	WINBOOL success;

	if (GetQueuedCompletionStatus(_iocp, LPDWORD lpNumberOfBytesTransferred, PULONG_PTR lpCompletionKey, LPOVERLAPPED *lpOverlapped, DWORD dwMilliseconds))

}

@end


@implementation KQEventBuffer

- (instancetype)init {
	self = [super init];

	[self refresh];

	return self;
}

+ (instancetype)sharedBuffer {
	KQEventBuffer *evbuf = [[OFThread threadDictionary] objectForKey:kKQEventBufferKey];

	if (evbuf == nil) {
		evbuf = [[KQEventBuffer alloc] init];

		[[OFThread threadDictionary] setObject:evbuf forKey:kKQEventBufferKey];

		[evbuf release];
	}

	return evbuf;
}

- (void)refresh {
	memset(&_iocp_buf, 0, sizeof(_iocp_buf));
}

- (DWORD *)bytes {
	return &_iocp_buf.bytes;
}

- (ULONG_PTR *)key {
	return &_iocp_buf.key;
}

- (OVERLAPPED **)overlap {
	return &_iocp_buf.overlap;
}

@end