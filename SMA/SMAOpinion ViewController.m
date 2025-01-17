//
//  SMAOpinion ViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/12.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAOpinion ViewController.h"
#import <MessageUI/MessageUI.h>

@interface SMAOpinion_ViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation SMAOpinion_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI{
    self.title = SMALocalizedString(@"me_set_feedback");
    _detailsView.delegate = self;
    _detailsView.text = SMALocalizedString(@"me_set_feedback_input");
    _detailsView.textColor = [SmaColor colorWithHexString:@"#808080" alpha:0.5];
    _contentField.delegate = self;
    _contentField.placeholder = SMALocalizedString(@"me_set_feedback_input");
    [_submitBut setTitle:SMALocalizedString(@"me_set_feeback_submit") forState:UIControlStateNormal];
    _problemLab.text = SMALocalizedString(@"me_set_feedback_problem");
    _contentLab.text = SMALocalizedString(@"me_set_feedback_relation");
}

- (IBAction)selector:(id)sender{
    if ([_detailsView.text isEqualToString:@""] || [_detailsView.text isEqualToString:SMALocalizedString(@"me_set_feedback_input")]) {
        [MBProgressHUD showError:SMALocalizedString(@"me_set_feeback_contact")];
        return;
    }
    if ([_contentField.text isEqualToString:@""]) {
        [MBProgressHUD showError:SMALocalizedString(@"me_set_feedback_content")];
        return;
    }
    
#if EVOLVEO
//    [MBProgressHUD showSuccess:SMALocalizedString(@"me_set_feeback_subing")];
    NSString *thtStr = [NSString stringWithFormat:@"EVOLVEO Fit--%@",SMALocalizedString(@"me_set_feedback")];
    [self sendEmailToGoal:@"servis@evolveo.com" titMes:thtStr];
#else
    [MBProgressHUD showSuccess:SMALocalizedString(@"me_set_feeback_subing")];
    SmaAnalysisWebServiceTool *webservice = [[SmaAnalysisWebServiceTool alloc] init];
    [webservice acloudFeedbackContact:_contentField.text content:_detailsView.text callBack:^(BOOL isSuccess, NSError *error) {
        if (isSuccess) {
            [MBProgressHUD showSuccess:SMALocalizedString(@"me_set_feeback_subSucc")];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else{
            [MBProgressHUD showError:[NSString stringWithFormat:@"%ld %@",(long)error.code,SMALocalizedString(@"me_set_feeback_subFail")]];
        }
    }];
#endif
}

- (void)sendEmailToGoal:(NSString *)goalMes titMes:(NSString *)tit{
    if ([MFMailComposeViewController canSendMail]) { // 用户已设置邮件账户
        
    }else{
        NSLog(@"无邮件帐户,请设置邮件帐户来发送电子邮件");
        [MBProgressHUD showError:SMALocalizedString(@"me_set_feeback_email")];
        return;
    }
    if ([MFMessageComposeViewController canSendText] == YES) {
        MFMailComposeViewController *_mailComposer = [[MFMailComposeViewController alloc]init];
        _mailComposer.mailComposeDelegate = self;
//        [_mailComposer setSubject:@""];
        NSArray *arr = @[goalMes];
        //收件人
        [_mailComposer setToRecipients:arr];
        // 设置邮件主题
        [_mailComposer setSubject:tit];
        
        // 设置密抄送
//        [_mailComposer setBccRecipients:@[]];
        // 设置抄送人
//        [_mailComposer setCcRecipients:@[@"1229436624@qq.com"]];
        // 如使用HTML格式，则为以下代码
        //    [_mailComposer setMessageBody:@"<html><body><p>Hello</p><p>World！</p></body></html>" isHTML:YES];
        /*
         //添加附件
         UIImage *image = [UIImage imageNamed:@"image"];
         NSData *imageData = UIImagePNGRepresentation(image);
         [_mailComposer addAttachmentData:imageData mimeType:@"" fileName:@"custom.png"];
         NSString *file = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"pdf"];
         NSData *pdf = [NSData dataWithContentsOfFile:file];
         [_mailComposer addAttachmentData:pdf mimeType:@"" fileName:@"7天精通IOS"];
         */
        
        [_mailComposer setMessageBody:_detailsView.text isHTML:NO];
        [self presentViewController:_mailComposer animated:YES completion:^{

        }];
    }else{
         [MBProgressHUD showError:SMALocalizedString(@"me_set_feeback_deviceErr")];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *realTextViewText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //如果有高亮
    if (selectedRange&&pos) {
        return YES;
    }
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [textView resignFirstResponder];
    }
    else{
        _wordsNum.text = [NSString stringWithFormat:@"%lu/400",400 - realTextViewText.length];
    }
    if (realTextViewText.length > 400) {
        NSInteger length = text.length + 400 - realTextViewText.length;
        NSRange rg = {0,MAX(length,0)};
        if (rg.length > 0) {
            NSString *s = [text substringWithRange:rg];
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *realTextViewText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *pos = [textField positionFromPosition:selectedRange.start offset:0];
    if ([string isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [textField resignFirstResponder];
    }
    //如果有高亮
    if (selectedRange&&pos) {
        return YES;
    }
    if (realTextViewText.length > 100) {
        NSInteger length = string.length + 100 - realTextViewText.length;
        NSRange rg = {0,MAX(length,0)};
        if (rg.length>0) {
            NSString *s = [string substringWithRange:rg];
            [textField setText:[textField.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
    if ([string isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:SMALocalizedString(@"me_set_feedback_input")]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text = SMALocalizedString(@"me_set_feedback_input");
        textView.textColor = [SmaColor colorWithHexString:@"#808080" alpha:0.5];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [self dismissViewControllerAnimated:YES completion:^{
        switch (result) {
            case MFMailComposeResultSent:
                [MBProgressHUD showSuccess:SMALocalizedString(@"me_set_feeback_subSucc")];
                break;
            case MFMailComposeResultFailed:
                [MBProgressHUD showSuccess:SMALocalizedString(@"me_set_feeback_subFail")];
                break;
            default:
                break;
        }
    }];
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
