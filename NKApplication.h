#import <ObjFW/OFObject.h>
#import <ObjFW/OFApplication.h>

#define NK_APPLICATION_DELEGATE(cls)					\
	int								\
	main(int argc, char *argv[])					\
	{								\
		return nk_application_main(&argc, &argv, [cls class]);	\
	}

@protocol NKApplicationDelegate <OFApplicationDelegate>

@end

OF_ASSUME_NONNULL_BEGIN

@interface NKApplication: OFObject {
	id<NKApplicationDelegate> _delegate;
}

@property (nonatomic, assign) id<NKApplicationDelegate> delegate;

@end

OF_ASSUME_NONNULL_END

#ifdef __cplusplus
extern "C" {
#endif	

extern int nk_application_main(int *_Nonnull,
    char *_Nonnull *_Nonnull[_Nonnull], Class _Nonnull);

#ifdef __cplusplus
}
#endif