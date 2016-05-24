//
//  ViewController.m
//  ApplePayDemo
//
//  Created by DBL on 16/2/19.
//  Copyright © 2016年 DBL. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(60, 100, 200, 50);
    btn.center = self.view.center;
    [btn setTitle:@"Apple Pay" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goPay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

#pragma mark --- 支付状态
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion{

    BOOL asynSuccessful = FALSE;
    if (asynSuccessful) {
        completion(PKPaymentAuthorizationStatusSuccess);
        NSLog(@"支付成功");
    }else{
    
        completion(PKPaymentAuthorizationStatusFailure);
        NSLog(@"支付失败");
    }
    
}

#pragma mark ---开始支付
- (void)goPay{

    if ([PKPaymentAuthorizationViewController canMakePayments]) {
        
        NSLog(@"支持支付");
        
        PKPaymentRequest * request = [[PKPaymentRequest alloc]init];
        
        PKPaymentSummaryItem * widget1 = [PKPaymentSummaryItem summaryItemWithLabel:@"奶粉" amount:[NSDecimalNumber decimalNumberWithString:@"1.00"]];
        
        PKPaymentSummaryItem * widget2 = [PKPaymentSummaryItem summaryItemWithLabel:@"苹果" amount:[NSDecimalNumber decimalNumberWithString:@"2.00"]];
        
        PKPaymentSummaryItem * widget3 = [PKPaymentSummaryItem summaryItemWithLabel:@"苹果" amount:[NSDecimalNumber decimalNumberWithString:@"3.00"]];
        PKPaymentSummaryItem * wifget4 = [PKPaymentSummaryItem summaryItemWithLabel:@"总金额：" amount:[NSDecimalNumber decimalNumberWithString:@"3.99"] type:PKPaymentSummaryItemTypeFinal];
        
        request.paymentSummaryItems = @[widget1,widget2,widget3,wifget4];
        request.countryCode = @"CN";
        request.currencyCode = @"GQE";
        request.supportedNetworks = @[PKPaymentNetworkChinaUnionPay,PKPaymentNetworkMasterCard,PKPaymentNetworkVisa];
        request.merchantIdentifier = @"merchant.DBL";
        
        /*
         PKMerchantCapabilityCredit NS_ENUM_AVAILABLE_IOS(9_0)   = 1UL << 2,   // 支持信用卡
         PKMerchantCapabilityDebit  NS_ENUM_AVAILABLE_IOS(9_0)   = 1UL << 3    // 支持借记卡
         */
        request.merchantCapabilities = PKMerchantCapabilityCredit;
        
        //增加邮箱及地址信息
        request.requiredBillingAddressFields = PKAddressFieldEmail | PKAddressFieldPostalAddress;
        
        
        PKPaymentAuthorizationViewController * payment = [[PKPaymentAuthorizationViewController alloc]initWithPaymentRequest:request];
        payment.delegate = self;
        
        [self presentViewController:payment animated:YES completion:^{
            
        }];
        
        if (!payment) {
            
            NSLog(@"出问题了");
        }
        
        [self presentViewController:payment animated:YES completion:nil];
        
    }else{
    
        NSLog(@"不支持applePay");
    }
}

#pragma mark---支付完成
- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    
    [controller dismissViewControllerAnimated:TRUE completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
