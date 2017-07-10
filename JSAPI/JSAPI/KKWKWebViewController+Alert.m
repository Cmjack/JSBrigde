//
//  KKWKWebViewController+Alert.m
//  JSAPI
//
//  Created by CaiMing on 2017/7/7.
//  Copyright © 2017年 CaiMing. All rights reserved.
//

#import "KKWKWebViewController+Alert.h"

@implementation KKWKWebViewController (Alert)

#pragma mark -sys alert

- (void)showAlert:(NSDictionary*)param
{
    NSString *message = param[@"message"];
    NSString *title = param[@"title"];
    NSString *buttonName = param[@"buttonName"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:buttonName style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showConfirm:(NSDictionary*)param
{
    NSString *message = param[@"message"];
    NSString *title = param[@"title"];
    NSArray *buttonLabels = param[@"buttonLabels"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    for (NSString *buttonLabel in buttonLabels) {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:buttonLabel
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           NSMutableDictionary *param = @{}.mutableCopy;
                                                           [param setObject:@([buttonLabels indexOfObject:buttonLabel]) forKey:@"buttonIndex"];
                                                           [self callJS:@"showConfirm" param:param];
                                                       }];
        
        [alertController addAction:action];
    }
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showPrompt:(NSDictionary*)param
{
    NSString *message = param[@"message"];
    NSString *title = param[@"title"];
    NSString *placeholder = param[@"placeholder"];
    NSArray *buttonLabels = param[@"buttonLabels"];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    for (NSString *buttonLabel in buttonLabels) {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:buttonLabel
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           NSMutableDictionary *param = @{}.mutableCopy;
                                                           [param setObject:@([buttonLabels indexOfObject:buttonLabel]) forKey:@"buttonIndex"];
                                                           if (alertController.textFields.count>0) {
                                                               
                                                               UITextField *textField = alertController.textFields[0];
                                                               [param setObject:textField.text forKey:@"text"];
                                                           }
                                                           [self callJS:@"showPrompt" param:param];
                                                           
                                                       }];
        
        [alertController addAction:action];
    }
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = placeholder;
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)showActionSheet:(NSDictionary*)param
{
    NSString *message = param[@"message"];
    NSString *title = param[@"title"];
    NSArray *otherButtons = param[@"otherButtons"];
    NSString *cancelButton = param[@"cancelButton"];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (NSString *buttonLabel in otherButtons) {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:buttonLabel
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           // todo
                                                           NSMutableDictionary *param = @{}.mutableCopy;
                                                           [param setObject:@([otherButtons indexOfObject:buttonLabel]) forKey:@"buttonIndex"];
                                                           [self callJS:@"showPrompt" param:param];
                                                           
                                                       }];
        
        [alertController addAction:action];
    }
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelButton
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       // todo
                                                       NSMutableDictionary *param = @{}.mutableCopy;
                                                       [param setObject:@(-1) forKey:@"buttonIndex"];
                                                       [self callJS:@"showActionSheet" param:param];
                                                   }];
    
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
    
}


@end
