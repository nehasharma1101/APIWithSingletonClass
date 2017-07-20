

#import "CommonManager.h"
#import "BaseUrls.h"

@implementation CommonManager
+ (CommonManager*)sharedManager
{
    static CommonManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}
-(void)postOrGetFormData:(NSString *)UrlString strParameters:(NSString *)strParam postPar:(id )postParaDict method:(NSString *)methodType setHeader:(BOOL)header successHandler:(void(^)(id response))successHandler failureHandler:(void(^)(id response))failureHandler{
    
    NSData *postData = [strParam dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:UrlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:postData];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                id responseData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                if ([responseData isKindOfClass:[NSDictionary class]] && [responseData objectForKey:@"error"]) {
                    failureHandler(responseData);
                    return;
                }
                successHandler(responseData);
            }else{
                failureHandler(error);
            }
        });
    }];
    [postDataTask resume];
}

-(void)postOrGetData:(NSString *)UrlString postPar:(id )postParaDict method:(NSString *)methodType isForrmData:(BOOL)formData setHeader:(BOOL)header  successHandler:(void(^)(id response))successHandler failureHandler:(void(^)(id response))failureHandler imageDownloader:(BOOL)imageDownloader{
    NSURL *url = [NSURL URLWithString:UrlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:methodType];
    if (header) {
        [request setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"] forHTTPHeaderField:@"access_token"];
    }
    if (formData)
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    else
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if ([methodType isEqualToString:@"POST"] || [methodType isEqualToString:@"PUT"])
    {
        if (formData)
            [request setHTTPBody:[[NSString stringWithFormat:@"%@",postParaDict ] dataUsingEncoding:NSUTF8StringEncoding]];
        else
        {
            if (postParaDict != nil)
            {
                NSData *jsonData;
                if (imageDownloader) {
                    jsonData =[postParaDict dataUsingEncoding:NSUTF8StringEncoding];
                }else
                    jsonData =[NSJSONSerialization dataWithJSONObject:postParaDict options:0 error:nil];
                
                [request setHTTPBody:jsonData];
            }
        }
    }
    request.timeoutInterval=59;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                id responseData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                if ([responseData isKindOfClass:[NSDictionary class]] && [responseData objectForKey:@"error"]) {
                    failureHandler(responseData);
                    return;
                }
                successHandler(responseData);
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                failureHandler(connectionError);
            });
            
        }
    }];
}
@end
