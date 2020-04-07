//
//  JMWebViewCell.h
//  JMBaseProject
//
//  Created by Liuny on 2018/11/1.
//  Copyright © 2018 liuny. All rights reserved.
//

#import <UIKit/UIKit.h>


/*使用示例
 JMWebViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"webCell"];
 cell.html = @"<p><img title=\"1536741004370031110.jpg\" alt=\"147955907918292395.jpg\" src=\"http://www.hyiwl.com/haiyitong//ueditor/jsp/upload/image/20180912/1536741004370031110.jpg\"/></p>";
 JMWeak(self);
 cell.finishLoad = ^(CGFloat height) {
 weakself.webViewHeight = height;
 [self.tableView reloadData];
 };
 return cell;
 */

NS_ASSUME_NONNULL_BEGIN

@interface JMWebViewCell : UITableViewCell
@property (nonatomic, copy) void (^finishLoad)(CGFloat height);
@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, strong) NSString *html;
@end

NS_ASSUME_NONNULL_END
