//
//  UIViewController+Social.m
//  BookReader
//
//  Created by yaming_deng on 20/7/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import "UIViewController+Social.h"
#import "UMSocial.h"
#import "MobClick.h"

@implementation UIViewController (Social)

- (void)openShareActions:(NSString*)msg image:(UIImage*)image {
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:nil
                                      shareText:msg
                                     shareImage:image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite, UMShareToQzone,UMShareToQQ,nil]
                                       delegate:self];
    
    [MobClick event:@"app-share" attributes:nil];
    
}
//实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        NSString* name = [[response.data allKeys] objectAtIndex:0];
        //得到分享到的微博平台名
        LOG(@"share to ; name is %@", name);
        NSDictionary* temp = [self shareArgs];
        //NSDictionary *dict = @{@"sns": name};
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        if (temp) {
            [dict setDictionary:temp];
        }
        [dict setObject:@"sns" forKey:name];
        [MobClick event:@"share-to" attributes:dict];
        [self postShareAction];
    }
}
- (NSDictionary*)shareArgs{
    return nil;
}
-(void)postShareAction{
    
}

@end
