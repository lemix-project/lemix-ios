//
//  net_http.m
//  zwt-ios
//
//  Created by 王炜光 on 2018/8/22.
//  Copyright © 2018年 LemonIT.CN. All rights reserved.
//

#import "net_http.h"
#import "CommunicationInfo.h"
#import <AFNetworking.h>
#import <AFNetworkReachabilityManager.h>
#import <Lemage.h>
@implementation net_http
- (void)syncRequest:(CommunicationInfo *)info{

    AFHTTPSessionManager * manager =[AFHTTPSessionManager manager];
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block id responseData;
    __block id failedError;
    __block id statusCode;
    __block id allHeaderFields;
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableURLRequest *req = [[AFHTTPRequestSerializer serializer] requestWithMethod: info.params[@"method"] URLString: info.params[@"url"] parameters: @{} error: nil];
    
    NSDictionary *headerDic = info.params[@"header"];
    for (NSString *key in headerDic.allKeys) {
        [req setValue: headerDic[key] forHTTPHeaderField: key];
    }
    NSString *bodyStr = info.params[@"body"];
    
    [req setHTTPBody: [bodyStr dataUsingEncoding: NSUTF8StringEncoding]];
    NSURLSessionTask *task = [manager dataTaskWithRequest: req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error) {
            failedError = error;
        }else{
            responseData = responseObject;
        }
        statusCode = [response valueForKey:@"statusCode"];
        allHeaderFields = [response valueForKey:@"allHeaderFields"];
    
        NSLog(@"%@",responseObject);
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        dispatch_semaphore_signal(semaphore);
    }];
    [task resume];
    
    
    ///////////////////

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
 

    NSString *callJSString;
    if (failedError) {
        callJSString = [net_http dicChangeStr:@{@"success":@NO,@"statusCode":statusCode?statusCode:@404,@"error":[net_http returnResponseStr:failedError]}];
    }else{

        callJSString = [net_http dicChangeStr:@{@"success":@YES,@"body":[net_http returnObject:responseData],@"header":allHeaderFields,@"statusCode":statusCode}];
    }
    
    if (info.completionHandler) {
        info.completionHandler(callJSString);
    }
    
    
    
}
- (void)asyncRequest:(CommunicationInfo *)info{
    AFHTTPSessionManager * manager =[AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableURLRequest *req = [[AFHTTPRequestSerializer serializer] requestWithMethod: info.params[@"method"] URLString: info.params[@"url"] parameters: @{} error: nil];
    
    NSDictionary *headerDic = info.params[@"header"];
    for (NSString *key in headerDic.allKeys) {
        [manager.requestSerializer setValue:headerDic[key] forHTTPHeaderField:key];
    }
    NSString *bodyStr = info.params[@"body"];
    
    [req setHTTPBody: [bodyStr dataUsingEncoding: NSUTF8StringEncoding]];
    NSURLSessionTask *task = [manager dataTaskWithRequest: req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"请求失败了！");
            NSString *callJSString = [NSString stringWithFormat:@"__load_callback('%@','%@','%@')",info.params[@"failed"],[net_http returnResponseStr:error],[response valueForKey:@"statusCode"]];
            [info.controller.webView evaluateJavaScript:callJSString completionHandler:^(id resultObject, NSError * _Nullable error) {
                if (!error){
                    NSLog(@"OC调 JS成功");
                }else{
                    NSLog(@"OC调 JS 失败");
                }
            }];
        }else{
            NSLog(@"请求成功了！");
            NSString *callJSString = [NSString stringWithFormat:@"__load_callback('%@',%@,%@,%@)",info.params[@"success"],[net_http returnResponseStr:responseObject],[net_http dicChangeStr:[response valueForKey:@"allHeaderFields"]],[response valueForKey:@"statusCode"]];
            [info.controller.webView evaluateJavaScript:callJSString completionHandler:^(id resultObject, NSError * _Nullable error) {
                if (!error){
                    NSLog(@"OC调 JS成功");
                }else{
                    NSLog(@"OC调 JS 失败");
                }
            }];
        }
        
    }];
    [task resume];
    
    
  
    
}

- (void)uploadFile:(CommunicationInfo *)info{
    
    
//    [Lemage loadImageDataByLemageUrl:info.params[@"fileKey"] complete:^(NSData * _Nonnull imageData) {
//        
//        //1。创建管理者对象
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        //2.上传文件
//        NSDictionary *dict = info.params[@"body"];
//        
//        NSDictionary *headerDic = info.params[@"header"];
//        for (NSString *key in headerDic.allKeys) {
//            [manager.requestSerializer setValue:headerDic[key] forHTTPHeaderField:key];
//        }
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        [manager POST:info.params[@"url"] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//            //上传文件参数
//
//            [formData appendPartWithFileData:imageData name:@"file" fileName:info.params[@"fileKey"] mimeType:@"image/png"];
//            
//        } progress:^(NSProgress * _Nonnull uploadProgress) {
//            
//            //打印下上传进度
//            NSLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            //请求成功
//            
//            NSLog(@"请求成功：%@",responseObject);
//            NSString *callJSString = [NSString stringWithFormat:@"__load_callback('%@',%@)",info.params[@"success"],[net_http returnResponseStr:responseObject]];
//            [info.controller.webView evaluateJavaScript:callJSString completionHandler:^(id resultObject, NSError * _Nullable error) {
//                if (!error){
//                    NSLog(@"OC调 JS成功");
//                }else{
//                    NSLog(@"OC调 JS 失败");
//                }
//            }];
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            //请求失败
//            NSLog(@"请求失败：%@",error);
//            NSString *callJSString = [NSString stringWithFormat:@"__load_callback('%@','%@')",info.params[@"failed"],[net_http returnResponseStr:error]];
//            [info.controller.webView evaluateJavaScript:callJSString completionHandler:^(id resultObject, NSError * _Nullable error) {
//                if (!error){
//                    NSLog(@"OC调 JS成功");
//                }else{
//                    NSLog(@"OC调 JS 失败");
//                }
//            }];
//        }];
//        
//       
//    }];
    
    
    
    
}

- (void)downloadFile:(CommunicationInfo *)info{
    //1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *headerDic = info.params[@"header"];
    for (NSString *key in headerDic.allKeys) {
        [manager.requestSerializer setValue:headerDic[key] forHTTPHeaderField:key];
    }
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //2.确定请求的URL地址
    NSURL *url = [NSURL URLWithString:info.params[@"url"]];
    //3.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //4.下载任务
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //打印下下载进度
        NSLog(@"%lf",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //下载地址
        NSLog(@"默认下载地址:%@",targetPath);
        //设置下载路径，通过沙盒获取缓存地址，最后返回NSURL对象
//        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *filePath = [path stringByAppendingPathComponent:url.lastPathComponent];
        [NSURL fileURLWithPath:path];
        return [NSURL fileURLWithPath:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
        }
        //下载完成调用的方法
        NSLog(@"下载完成：");
        NSLog(@"%@--%@",response,filePath);
        
        if (error) {
            NSLog(@"请求失败了！");
            NSString *callJSString = [NSString stringWithFormat:@"__load_callback('%@','%@','%@')",info.params[@"failed"],[net_http returnResponseStr:error],[response valueForKey:@"statusCode"]];
            [info.controller.webView evaluateJavaScript:callJSString completionHandler:^(id resultObject, NSError * _Nullable error) {
                if (!error){
                    NSLog(@"OC调 JS成功");
                }else{
                    NSLog(@"OC调 JS 失败");
                }
            }];
        }else{
            NSLog(@"请求成功了！");
            NSString *callJSString = [NSString stringWithFormat:@"__load_callback('%@',\"%@\",%@,%@)",info.params[@"success"],filePath,[net_http dicChangeStr:[response valueForKey:@"allHeaderFields"]],[response valueForKey:@"statusCode"]];
            [info.controller.webView evaluateJavaScript:callJSString completionHandler:^(id resultObject, NSError * _Nullable error) {
                if (!error){
                    NSLog(@"OC调 JS成功");
                }else{
                    NSLog(@"OC调 JS 失败");
                }
            }];
        }
        
    }];
    //开始启动任务
    [task resume];
    
}

+ (NSString *)returnResponseStr:(id)response{
    NSString *resposeStr;
    NSData *jsonData;
    NSObject *responseObject;
    if (((NSError *)response).userInfo) {
        responseObject = response;
        NSDictionary *tempDic = ((NSError *)responseObject).userInfo;
        return [NSString stringWithFormat:@"\"%@\"",tempDic[@"NSLocalizedDescription"]];
    }else{
        resposeStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        
        jsonData = [resposeStr dataUsingEncoding:NSUTF8StringEncoding];
        
        responseObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
    }
    
    
    
    if (responseObject) {
        resposeStr = [NSString stringWithFormat:@"JSON.stringify(%@)",resposeStr];
    }else{
         resposeStr = [NSString stringWithFormat:@"\"%@\"",resposeStr];
    }
    return resposeStr;
}

+(id)returnObject:(id)object{
    NSString *resposeStr;
    NSData *jsonData;
    NSObject *responseObject;
    if (((NSError *)object).userInfo) {
        responseObject = object;
        NSDictionary *tempDic = ((NSError *)responseObject).userInfo;
        return [NSString stringWithFormat:@"\"%@\"",tempDic[@"NSLocalizedDescription"]];
    }else{
        resposeStr = [[NSString alloc] initWithData:object encoding:NSUTF8StringEncoding];
        
        jsonData = [resposeStr dataUsingEncoding:NSUTF8StringEncoding];
        
        responseObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
    }
    
    
    
    if (responseObject) {
        return responseObject;
    }else{
        resposeStr = resposeStr;
    }
    return resposeStr;
}

+ (NSString *)dicChangeStr:(NSDictionary *)dic{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
    NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return str;
}
@end
