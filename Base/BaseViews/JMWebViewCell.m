//
//  JMWebViewCell.m
//  JMBaseProject
//
//  Created by Liuny on 2018/11/1.
//  Copyright © 2018 liuny. All rights reserved.
//

#import "JMWebViewCell.h"
#import <WebKit/WebKit.h>

@interface JMWebViewCell ()<UIWebViewDelegate>
@property (nonatomic, assign) CGFloat height;
@end

@implementation JMWebViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _webview = [[UIWebView alloc] init];
        _webview.delegate = self;
        _webview.scrollView.bounces = NO;
        [self.contentView addSubview:_webview];
        
        [_webview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(0);
            make.right.equalTo(self.contentView.mas_right).offset(0);
            make.top.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setHtml:(NSString *)html {
    _html = html;
    
    if(self.html.length == 0){
        return;
    }
    
    //设置图片显示宽度
    NSString *str = [NSString stringWithFormat:@"<html><head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'><style>*{ width: 100%%; margin: 0; padding: 0 3; box-sizing: border-box;} img{ width: 100%%;}</style></head><body>%@</body></html>", self.html];
    
    [self.webview loadHTMLString:str baseURL:nil];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    // 获取内容高度
    CGFloat height =  [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"] intValue];
    
    // 防止死循环
    if (height != self.height) {
        
        self.height = height;
        JMLog(@"%f",height);
        if (self.height > 0) {
            
            if (self.finishLoad) {
                self.finishLoad(height);
            }
        }
    }
    
    //重写contentSize,防止左右滑动
    CGSize size = webView.scrollView.contentSize;
    size.width = webView.scrollView.frame.size.width;
    webView.scrollView.contentSize = size;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    __block CGFloat webViewHeight;
    self.height = webView.frame.size.height;
    //获取内容实际高度（像素）@"document.getElementById(\"content\").offsetHeight;"
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable result,NSError * _Nullable error) {
        // 此处js字符串采用scrollHeight而不是offsetHeight是因为后者并获取不到高度，看参考资料说是对于加载html字符串的情况下使用后者可以，但如果是和我一样直接加载原站内容使用前者更合适
        //获取页面高度，并重置webview的frame
        webViewHeight = [result doubleValue];
        NSLog(@"%f",webViewHeight);
        // 防止死循环
        if (webViewHeight != self.height) {
            
            self.height = webViewHeight;
            NSLog(@"%f",webViewHeight);
            if (self.height > 0) {
                
                if (self.finishLoad) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self->_finishLoad(webViewHeight);
                    });
                }
            }
            
        }
    }];
    
    JMLog(@"结束加载");
}
@end
