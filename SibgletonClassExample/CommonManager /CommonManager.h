

#import <Foundation/Foundation.h>



@protocol NetworkConnectionDelegate <NSObject>

-(void)internetConnected:(BOOL)value;

@end


@interface CommonManager : NSObject<NSURLConnectionDelegate>
{
    BOOL isUpdateNetworkCalled;
    BOOL isNotificationFlagCalled;
    BOOL isnoInternetCalled;
    int countConnected;
    int countDisconnected;
}

@property (weak, nonatomic) id<NetworkConnectionDelegate> networkDelegate;

+ (CommonManager*)sharedManager;


-(void)postOrGetData:(NSString *)UrlString postPar:(id )postParaDict method:(NSString *)methodType isForrmData:(BOOL)formData setHeader:(BOOL)header  successHandler:(void(^)(id response))successHandler failureHandler:(void(^)(id response))failureHandler imageDownloader:(BOOL)imageDownloader;

-(void)postOrGetFormData:(NSString *)UrlString strParameters:(NSString *)strParam postPar:(id )postParaDict method:(NSString *)methodType setHeader:(BOOL)header successHandler:(void(^)(id response))successHandler failureHandler:(void(^)(id response))failureHandler;


@end
