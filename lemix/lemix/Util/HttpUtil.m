//
//  HttpUtil.m
//  zwt-ios
//
//  Created by 王炜光 on 2018/9/4.
//  Copyright © 2018年 LemonIT.CN. All rights reserved.
//

#import "HttpUtil.h"
#import "AFNetworking.h"
#import "SSZipArchive.h"
#import "AimViewControllerInfo.h"
#import "UiNavigation.h"
#import "BaseViewController.h"
@interface HttpUtil ()<SSZipArchiveDelegate>
@property NSString *fileURL;
@end
@implementation HttpUtil

- (void)getDataWithURL:(NSString *)url
            parameters:(NSDictionary *)parameters
               success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable responseObject))success
               failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        success(task,responseObject);
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error); //这里打印错误信息
        failure(task,error);
    }];
}

- (void)postDataWithURL:(NSString *)url
             parameters:(NSDictionary *)parameters
                success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error);
    }];
}

- (void)uploadFileWithURL:(NSString *)url
               parameters:(NSDictionary *)parameters
                 fileData:(NSData *)fileData
                     name:(NSString *)name
                 fileName:(NSString *)fileName
                 mimeType:(NSString *)mimeType
                 progress:(nullable void(^)(NSProgress * _Nullable progress))progress
                  success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                  failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //上传文件参数
        
        [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功
        success(task,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error);
    }];
}
- (void)downloadFileWithURL:(NSString *)url
                 saveToPath:(NSString *)path
          completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler{
    //远程地址
    NSURL *URL = [NSURL URLWithString:url];
    //默认配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSString *tempPath = path;
    
    NSURLSessionDownloadTask * downloadTask= [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        //在此之前先删除本地文件夹里面相同的文件夹
        NSFileManager *fileManager = [NSFileManager defaultManager];//创建文件管理器
        
        //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
        if (tempPath) {
            return [NSURL fileURLWithPath:tempPath];
        }
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        
        
        NSArray *contents = [fileManager contentsOfDirectoryAtPath:cachesPath error:NULL];
        NSEnumerator *e = [contents objectEnumerator];
        NSString *filename;
        NSString *extension = @"zip";
        while ((filename = [e nextObject])) {
            
            if ([[filename pathExtension] isEqualToString:extension]) {
                
                [fileManager removeItemAtPath:[cachesPath stringByAppendingPathComponent:filename] error:NULL];
                
            }
        }
        NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        //设置下载完成操作
        completionHandler(response,filePath,error);
    }];
    [downloadTask resume];
}

#pragma mark 解压
- (NSString *)releaseZipFilesWithUnzipFileAtPath:(NSString *)zipPath Destination:(NSString *)unzipPath{
    NSError *error;
    if (unzipPath.length == 0) {
        unzipPath = [self getUnzipFilePath:zipPath];
    }
    [self createFile:unzipPath];
    if ([SSZipArchive unzipFileAtPath:zipPath toDestination:unzipPath overwrite:YES password:nil error:&error delegate:self]) {
        _fileURL = unzipPath;
        NSLog(@"success");
        return unzipPath;
    }else{
        NSLog(@"%@",error);
        return @"解压失败";
    }
    
}

- (void)createFile:(NSString *)filePath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    BOOL isDir = NO;
    
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    
    if (!existed) {
        // 在Document目录下创建一个archiver目录
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }else{
        
    }
    
}

- (NSDictionary *)showAllFileName:(NSString *)filePath{
    
    NSMutableDictionary *fileNameAndPathDic = [[NSMutableDictionary alloc] init];
    //读取下载后json文件
    NSString *jsonPath = [NSString stringWithFormat:@"%@/config/config.json",filePath];
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath options:NSDataReadingMappedIfSafe error:nil];
    NSMutableDictionary *configDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    //递归路径
    NSString *path=[NSString stringWithFormat:@"%@/pages",filePath]; // 要列出来的目录
    NSFileManager *myFileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *myDirectoryEnumerator = [myFileManager enumeratorAtPath:path];
    //列举目录内容，可以遍历子目录
    while ((path = [myDirectoryEnumerator nextObject]) != nil) {
        
        if ([[path pathExtension] isEqualToString:@"html"]) {
            
            [fileNameAndPathDic setObject:[NSString stringWithFormat:@"%@/pages/%@",filePath,path] forKey: [NSString stringWithFormat:@"%@.%@",configDic[@"identifier"],[[path stringByReplacingOccurrencesOfString:@"/" withString:@"."]stringByReplacingOccurrencesOfString:@".index.html" withString:@""]]];
        }
    }
    
    return @{configDic[@"identifier"]:fileNameAndPathDic,@"config":configDic};
    
}

- (void)deleteMixModuleCache:(NSString *)filePath mixModuleIdentifier:(NSString *)identifier{
    //递归路径
    NSString *path=[NSString stringWithFormat:@"%@",filePath]; // 要列出来的目录
    NSFileManager *myFileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *myDirectoryEnumerator = [myFileManager enumeratorAtPath:path];
    //列举目录内容，可以遍历子目录
    while ((path = [myDirectoryEnumerator nextObject]) != nil) {
        
        if ([[[path componentsSeparatedByString:@"/"] lastObject] containsString:identifier]) {
            [myFileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",filePath,path] error:nil];
            break;
        }
    }
}


- (NSString *)getUnzipFilePath:(NSString *)zipPath{
    NSArray *fileNameArr = [[[zipPath componentsSeparatedByString:@"/"] lastObject] componentsSeparatedByString:@"."];
    NSString *unzipPath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileNameArr[0]];//如果没有这个文件夹就创建一个
    [self createFile:unzipPath];
    return unzipPath;
}


- (void)StartupMixModule:(LemixEngineConfig *)config mixModuleInfo:(MixModuleInfo *)moduleInfo engineName:(NSString *)engineName startUpMixModuleParameter:(StartUpMixModuleParameter*)mixModuleParameter{
    NSString *mixModelLocalPath = [NSString stringWithFormat:@"%@/%@/MixModules/%@-%@.zip",config.workspacePath,engineName,moduleInfo.mixModuleIdentifier,moduleInfo.packageTime];
    NSURL *mixModuleURL = [NSURL URLWithString:moduleInfo.mixModuleURL];
    if ([@[@"http",@"https"] containsObject:mixModuleURL.scheme]) {
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        // fileExistsAtPath 判断一个文件或目录是否有效
        BOOL existed = [fileManager fileExistsAtPath:mixModelLocalPath];
        if (!existed) {
            
            [self downloadFileWithURL:moduleInfo.mixModuleURL saveToPath:mixModelLocalPath completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                
                [self jumpProgremActionMixModuleConfig:config engineName:engineName mixModuleInfo:moduleInfo zipAtPath:[filePath path] startUpMixModuleParameter:mixModuleParameter];
            }];
        }else{
            //存在当前目录
            
            [self jumpProgremActionMixModuleConfig:config engineName:engineName mixModuleInfo:moduleInfo zipAtPath:mixModelLocalPath startUpMixModuleParameter:mixModuleParameter];
        }
    }else{
        //zip包解压
        //界面跳转
        
        //存在当前目录
        
        [self jumpProgremActionMixModuleConfig:config engineName:engineName mixModuleInfo:moduleInfo zipAtPath:moduleInfo.mixModuleURL startUpMixModuleParameter:mixModuleParameter];
    }
}

- (void)jumpProgremActionMixModuleConfig:(LemixEngineConfig *)config engineName:(NSString *)engineName mixModuleInfo:(MixModuleInfo *)moduleInfo zipAtPath:(NSString *)zipAtPath startUpMixModuleParameter:(StartUpMixModuleParameter*)mixModuleParameter{
    
    NSString *unZipPath = [NSString stringWithFormat:@"%@/%@/MixModules/%@-%@",config.tempPath,engineName,moduleInfo.mixModuleIdentifier,moduleInfo.packageTime];
    [self deleteMixModuleCache:[NSString stringWithFormat:@"%@/%@/MixModules",config.tempPath,engineName] mixModuleIdentifier:moduleInfo.mixModuleIdentifier];
    unZipPath = [self releaseZipFilesWithUnzipFileAtPath:zipAtPath Destination:unZipPath];
    if (unZipPath.length > 4) {
        
        NSDictionary *webProgramDic = [self showAllFileName:unZipPath];
        AimViewControllerInfo *aimViewControllerInfo  = [[AimViewControllerInfo alloc] init];
        aimViewControllerInfo.aim = mixModuleParameter.startPage? mixModuleParameter.startPage:webProgramDic[@"config"][@"entrance"];
        aimViewControllerInfo.type = @"ext";
        aimViewControllerInfo.json = mixModuleParameter.json;
        aimViewControllerInfo.webProgram = webProgramDic;
        //        aimViewControllerInfo.webOnShow = mixModuleParameter.webOnShow;
        aimViewControllerInfo.webOnShow = ^(WKWebView *webView) {
            //加载完毕
            UIView *tagView = [[UIApplication sharedApplication].keyWindow viewWithTag:22222];
            [UIView animateWithDuration:0.5 animations:^{
                tagView.alpha = 0;
            } completion:^(BOOL finished) {
                [tagView removeFromSuperview];
            }];
            NSLog(@"等待也删除");
            mixModuleParameter.webOnShow(webView);
        };
        [UiNavigation pushOrPresent:2 baseViewController:(BaseViewController *)config.waitingPage aimInfo:aimViewControllerInfo defaultStyle:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableArray *vcArr = [NSMutableArray arrayWithArray:config.waitingPage.navigationController.viewControllers];
            [vcArr removeObjectAtIndex:0];
            config.waitingPage.navigationController.viewControllers = vcArr;
        });
    }else{
        NSLog(@"解压失败");
        return ;
    }
}



- (void)jumpProgremAction:(NSDictionary *)webProgramDic waitingPage:(UIViewController *)waitingPage{
    AimViewControllerInfo *aimViewControllerInfo  = [[AimViewControllerInfo alloc] init];
    aimViewControllerInfo.aim = webProgramDic[@"config"][@"entrance"];
    aimViewControllerInfo.type = @"ext";
    aimViewControllerInfo.webProgram = webProgramDic;
    [UiNavigation pushOrPresent:2 baseViewController:(BaseViewController *)waitingPage aimInfo:aimViewControllerInfo defaultStyle:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray *vcArr = [NSMutableArray arrayWithArray:waitingPage.navigationController.viewControllers];
        [vcArr removeObjectAtIndex:0];
        waitingPage.navigationController.viewControllers = vcArr;
    });
}

@end
