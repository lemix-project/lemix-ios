//
//  WaitingPage.m
//  lemixExample
//
//  Created by 王炜光 on 2018/10/12.
//  Copyright © 2018 lemix. All rights reserved.
//

#import "WaitingPage.h"
#import "WaitingPageStandard.h"
@interface WaitingPage ()

@end

@implementation WaitingPage
- (instancetype)init{
    if (self = [super init]) {
        _navi = (BaseNavigationViewController *)self.navigationController;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:tempBtn];
    [tempBtn addTarget:self action:@selector(presentView:) forControlEvents:UIControlEventTouchUpInside];
    tempBtn.backgroundColor = [UIColor blueColor];
    
}
- (void)presentView:(id)btn{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onWaiting:(MixModuleInfo *)moduleInfo{
    NSLog(@"%@",moduleInfo);
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
