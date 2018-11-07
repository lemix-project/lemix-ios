//
//  HttpUtil.h
//  zwt-ios
//
//  Created by 王炜光 on 2018/9/4.
//  Copyright © 2018年 LemonIT.CN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MixModuleInfo.h"
#import "LemixEngineConfig.h"
#import "StartUpMixModuleParameter.h"
@interface HttpUtil : NSObject

/**
 get网络请求

 @param url 请求url
 @param parameters 请求参数
 @param success 请求成功回调函数
 @param failure 请求失败回调函数
 */
- (void)getDataWithURL:(NSString *)url
            parameters:(NSDictionary *)parameters
               success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable responseObject))success
               failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure;

/**
 post网络请求

 @param url 请求的url
 @param parameters 请求参数
 @param success 请求成功回调函数
 @param failure 请求失败回调函数
 */
- (void)postDataWithURL:(NSString *)url
             parameters:(NSDictionary *)parameters
                success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure;

/**
 上传文件网路请求

 @param url 请求的url
 @param parameters 请求参数
 @param fileData 将要上传文件data
 @param name 接名称
 @param fileName 文件名称
 @param mimeType 文件类型
 @param progress 等待回调函数
 @param success 请求成功回调函数
 @param failure 请求失败回调函数
 */
- (void)uploadFileWithURL:(NSString *)url
               parameters:(NSDictionary *)parameters
                 fileData:(NSData *)fileData
                     name:(NSString *)name
                 fileName:(NSString *)fileName
                 mimeType:(NSString *)mimeType
                 progress:(nullable void(^)(NSProgress * _Nullable progress))progress
                  success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                  failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure;

/**
 下载文件网络请求

 @param url 请求的url
 @param path 将要下载的路径
 @param completionHandler 下载后路径或者失败原因
 */
- (void)downloadFileWithURL:(NSString *)url
                 saveToPath:(NSString *)path
          completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;

/**
 解压zip到指定路径

 @param zipPath zip所在路径
 @param unzipPath zip解压到的路径
 @return 返回成功路径或者失败
 */
- (NSString *)releaseZipFilesWithUnzipFileAtPath:(NSString *)zipPath Destination:(NSString *)unzipPath;

/**
 解压后文件里所有存在.index.html的文件夹名

 @param filePath 当前路径
 @return 文件夹名字典
 */
- (NSDictionary *)showAllFileName:(NSString *)filePath;

- (NSString *)getUnzipFilePath:(NSString *)zipPath;

- (void)createFile:(NSString *)filePath;

- (void)StartupMixModule:(LemixEngineConfig *)config mixModuleInfo:(MixModuleInfo *)moduleInfo engineName:(NSString *)engineName startUpMixModuleParameter:(StartUpMixModuleParameter*)mixModuleParameter;

- (void)deleteMixModuleCache:(NSString *)filePath mixModuleIdentifier:(NSString *)identifier;
@end
