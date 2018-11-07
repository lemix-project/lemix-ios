//
//  LemixNavigationController.m
//  lemix
//
//  Created by 王炜光 on 2018/10/12.
//  Copyright © 2018 lemix. All rights reserved.
//

#import "BaseNavigationViewController.h"
#import "PushTransitionUtil.h"
@interface BaseNavigationViewController ()<UINavigationControllerDelegate>

@end

@implementation BaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    tempBtn.frame = CGRectMake(100, 200, 100, 100);
//    [self.view addSubview:tempBtn];
//    [tempBtn addTarget:self action:@selector(presentView:) forControlEvents:UIControlEventTouchUpInside];
//    tempBtn.backgroundColor = [UIColor redColor];
    
    
    
    self.delegate = self;
    self.interactivePopGestureRecognizer.delegate = (id)self.interactivePopGestureRecognizer;
}

- (void)viewDidAppear:(BOOL)animated{
//    self.lemixEngine.moduleInstanceDic[self.instanceKey].moduleLifeCycle.onShow();
}

- (void)presentView:(id)btn{
    
//    [self.lemixEngine.moduleInstanceDic objectForKey:self.instanceKey].mixModuleLifeCycle.onHide();
    [self.lemixEngine.instanceList lastObject].mixModuleLifeCycle.onHide();
    
}

#pragma mark - UINavigationControllerDelegate
// 当控制器显示完毕的时候调用
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //这里是为了防止在跟视图上侧滑出现的bug(具体什么原因也不知道);
    if (navigationController.viewControllers.count == 1) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }else{
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    // 是否需要隐藏式push
    if ([fromVC isKindOfClass:[self.lemixEngine.config.waitingPage class]]) {
        if (operation == UINavigationControllerOperationPush){ // 就是在这里判断是哪种动画类型
            return [PushTransitionUtil new]; // 返回push动画的类
        }else{
            return nil;
        }
    }else{
        return nil;
    }
    
    return nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
