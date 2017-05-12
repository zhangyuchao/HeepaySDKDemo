//
//  WebRequest.m
//  HeePaySDKDemo
//
//  Created by Jiangrx on 6/30/14.
//  Copyright (c) 2014 Jiangrx. All rights reserved.
//

#import "WebRequest.h"
#import "HYHeePayModel.h"
#import <CommonCrypto/CommonDigest.h>
#import "HYBase64.h"

#define  kVersion           @"1" // 表示新接口版本 ，“1”： 表示旧接口版本 。
#define  kPayInitURL        @"https://pay.heepay.com/Phone/SDK/PayInit.aspx"
#define  kQueryURL          @"https://pay.heepay.com/Phone/SDK/PayQuery.aspx"

//#warning 这里填写商户号与商户秘钥
//测试号1
#define  kSignKey           @"87FB9444028A4B14937A1905" // 密钥
#define  kSDKAgentId           @"1664502" // 商户号


//H5ceshihao
#define KH5AgnetId             @"1664502" 
NSString * agentKey = @"87FB9444028A4B14937A1905";

NSString * baseURL = @"https://pay.heepay.com/Payment/Index.aspx";

NSString *queryURL = @"https://query.heepay.com/Payment/Query.aspx";

@interface WebRequest ()<NSXMLParserDelegate>

@property(nonatomic,copy) NSMutableDictionary * returnValue;
@property(nonatomic,copy) NSMutableString * tmpStr;
@property (nonatomic,copy) WebRequestCompleteBlock completeBlock;
@property (nonatomic,copy) NSString * agent_bill_id;
@property (nonatomic,copy) NSString * agent_bill_time;
@property (nonatomic,copy) NSString * agent_id;

@end

@implementation WebRequest


+(WebRequest *)shareInstance
{
    static WebRequest *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WebRequest alloc] init];
    });
    return instance;
}


+ (NSString *)getMetaOptionParam
{
    //1.获取APP 名称、bundleID、运行平台
    NSDictionary * infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString * appName = infoDictionary[@"CFBundleDisplayName"];
    NSString * bundleID = [[NSBundle mainBundle] bundleIdentifier];
    
    //2.转jsonStr
    if([self isNullOrEmpty:appName]){
        appName = @"TestDemo";
    }
    NSArray * appInfos = @[
                           @{
                               @"s":@"IOS",
                               @"n":appName,
                               @"id":bundleID
                               },
                           @{
                               @"s":@"Android",
                               @"n":@"",
                               @"id":@""
                               }
                           ];
    
    NSData * data = [NSJSONSerialization dataWithJSONObject:appInfos options:NSJSONWritingPrettyPrinted error:nil];
    NSString * meta_option = [[NSString alloc] initWithBytes:[data bytes] length:data.length encoding:NSUTF8StringEncoding];
    //3.base64 + gb2312编码。
    NSStringEncoding gb2312 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *metaOptionData = [meta_option dataUsingEncoding:gb2312 allowLossyConversion:YES];
    NSString * base64Str = [metaOptionData base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];
    //4.urlencode 编码
    meta_option = [self encodeURLString:base64Str];
    return meta_option;
}

//判断是否为空
+ (BOOL)isNullOrEmpty:(NSString *)str
{
    if (!str) {
        return YES;
    }
    else if ([str isEqual:[NSNull null]]){
        
        return YES;
    }
    else {
        NSString *trimedString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimedString length] == 0) {
            return YES;
        }
        else {
            return NO;
        }
    }
}

+(NSString *)getSystemTimeString
{
    NSDate * data = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSString * timeString = [formatter stringFromDate:data];
    return timeString;
}

+(NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];
    
    return output;
}

+(NSString*)encodeURLString:(NSString*)unencodedString
{
    NSString *outputStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)unencodedString, NULL, nil, kCFStringEncodingUTF8));
    return outputStr;
}

+ (NSString *)generateSignParams:(NSDictionary *)preSignParams andPreSignKeys:(NSArray *)allKeys
{
    //参与签名的key
    NSMutableString * preSignStr = [NSMutableString string];
    for (NSString * key in allKeys) {
        
        NSString * value = [preSignParams objectForKey:key];
        if ([self isNullOrEmpty:value]) {
            continue;
        }
        [preSignStr appendFormat:@"%@=%@&",key,value];
    }
    [preSignStr appendFormat:@"%@=%@",@"key",kSignKey];
    
    return [self md5: preSignStr];
}

//SDK
+ (void)sendWebRequestToSDKInitWithPaymentFee:(NSString *)fee paymentType:(NSString *)type withCompleteBlock:(WebRequestCompleteBlock)block
{
   

    HYHeePayModel * payModel = [[HYHeePayModel alloc] init];
    payModel.version = kVersion;
    payModel.agent_id = kSDKAgentId;
    payModel.agent_bill_time = [self getSystemTimeString];
    payModel.agent_bill_id = [self getSystemTimeString];
    
    [WebRequest shareInstance].agent_bill_id = payModel.agent_bill_id;
    [WebRequest shareInstance].agent_bill_time = payModel.agent_bill_time; //创单时间。
    [WebRequest shareInstance].agent_id = kSDKAgentId;
    payModel.pay_type = type;
    payModel.pay_amt = fee;
    payModel.user_ip = @"192.168.2.100";
    payModel.notify_url = @"http://www.baidu.com";
    payModel.user_identity = @""; //这个参数可不传，但是如果传了，必须要参与签名，顺序放在user_ip 之后。
    payModel.bank_card_no = @""; //银行4要素 ，快捷支付使用。其他支付可不传
    payModel.bank_user = @"";
    payModel.cert_no = @"";
    payModel.mobile = @"";
    payModel.goods_name = @"iPhone 6s Plus";
    payModel.goods_num = @"1";
    payModel.goods_note = @"国行 白色";
    //此参数穿 商户APP 的url Schemes；
    payModel.remark = @"iPhone6s";
    payModel.return_url = @"www.baidu.com";
    payModel.meta_option = [self getMetaOptionParam];
    
    NSArray * allKeys = @[@"version",@"agent_id",@"agent_bill_id",@"agent_bill_time",@"pay_type",@"pay_amt",@"notify_url",@"user_ip",@"user_identity",@"bank_card_no",@"bank_user",@"cert_no",@"mobile"];
    
    payModel.sign = [self generateSignParams:[payModel dictionaryRepresentation] andPreSignKeys:allKeys];
    NSDictionary * params = [payModel dictionaryRepresentation];
    [[self alloc]  sendRequestWithParamsStr:params completeBlock:block];
    
}

//H5 下单接口
+ (void)sendWebRequestToPaymentIndexWithPaymentFee:(NSString *)fee paymentType:(NSString *)type withCompleteBlock:(WebRequestCompleteBlock)block{
    
    NSString * version = @"1";
    [WebRequest shareInstance].agent_bill_id = [NSString stringWithFormat:@"%ld",time(0)];
    [WebRequest shareInstance].agent_bill_time = [self getSystemTimeString]; //创单时间。
    [WebRequest shareInstance].agent_id = KH5AgnetId;
    
    NSString * is_phone = @"1";
    NSString * is_frame = @"0"; // 1公众号支付，0 Wap支付。
    NSString * pay_type = type;
    
    NSString * pay_amt = fee;
    NSString * notify_url = @"https://www.baidu.com";
    NSString * return_url = @"http://www.hynet.co"; //支付成功之后的跳转地址。
    NSString * user_ip = @"192_168_2_107";
    
    NSString * goods_name = @"iPhone6s"; //（不参加签名）
    NSString * goods_num = @"1";
    NSString * remark = @"AppName"; //（不参加签名）
    
    //预签名串中不加 is_test 参数。
    NSString * preSignStr = [NSString stringWithFormat:@"version=%@&agent_id=%@&agent_bill_id=%@&agent_bill_time=%@&pay_type=%@&pay_amt=%@&notify_url=%@&return_url=%@&user_ip=%@&key=%@",version,KH5AgnetId,[WebRequest shareInstance].agent_bill_id,[WebRequest shareInstance].agent_bill_time,pay_type,pay_amt,notify_url,return_url,user_ip,agentKey];
    
    NSLog(@"preSignStr:: %@",preSignStr);
    NSString * sign = [self md5:preSignStr];//做签名。
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用名称
    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString * bundleID =  [[NSBundle mainBundle] bundleIdentifier];
    ;
    NSString * meta_option =[NSString stringWithFormat:@"\{\"s\":\"IOS\",\"n\":\"%@\",\"id\":\"%@\"}",appCurName,bundleID];
    NSLog(@"%@",meta_option);
    meta_option = [meta_option base64EncodedString]; //base64编码。
    meta_option = [self encodeURLString:meta_option];
    
    NSLog(@"%@",meta_option);
    
    //POST 数据。
    NSString * paramsStr = [NSString stringWithFormat:@"version=%@&agent_id=%@&agent_bill_id=%@&agent_bill_time=%@&pay_type=%@&pay_amt=%@&notify_url=%@&return_url=%@&user_ip=%@&is_phone=%@&is_frame=%@&goods_name=%@&goods_num=%@&remark=%@&sign=%@&meta_option=%@",version,KH5AgnetId,[WebRequest shareInstance].agent_bill_id,[WebRequest shareInstance].agent_bill_time,pay_type,pay_amt,notify_url,return_url,user_ip,is_phone,is_frame,goods_name,goods_num,remark,sign,meta_option];
    NSLog(@"paramsStr:::%@",paramsStr);
    
    //URL 编码
    paramsStr = [self encodeURLString:paramsStr];
    
    NSString * loadURLString = [NSString stringWithFormat:@"%@?%@",baseURL,paramsStr];
    block(@{@"params":loadURLString},NO);
}


- (void)sendRequestWithParamsStr:(NSDictionary *)paramsDic completeBlock:(WebRequestCompleteBlock)block
{
    self.completeBlock = block;

    NSMutableString * paramsStr = [NSMutableString string];
    
    for (NSString *key  in paramsDic.allKeys) {
        NSString * value = [paramsDic objectForKey:key];
        if (value == nil || [value isEqual:[NSNull null]]) {
            continue;
        }
        [paramsStr appendFormat:@"%@=%@&",key,value];
    }
    [paramsStr substringToIndex:paramsStr.length - 1];
    NSStringEncoding gb2312 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString * encodeParams = [paramsStr stringByAddingPercentEscapesUsingEncoding:gb2312];
    
    NSMutableURLRequest * theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kPayInitURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0f];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest addValue: @"application/x-www-form-urlencoded;charset=GB2312" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPBody:[encodeParams dataUsingEncoding:NSUTF8StringEncoding]];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSURLConnection sendAsynchronousRequest:theRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (connectionError) {
                    self.completeBlock(@{
                                @"error":[connectionError localizedDescription]
                            },YES);
                }
                else {
                    NSString * xmlString = [[NSString alloc] initWithBytes:[data bytes] length:data.length encoding:NSUTF8StringEncoding];
                    NSLog(@"xml String ::%@",xmlString);
                    _returnValue = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                   @"agent_bill_id":paramsDic[@"agent_bill_id"],
                                                                                   @"agent_id":kSDKAgentId,
                                                                                   }];
                    NSXMLParser * parser = [[NSXMLParser alloc] initWithData:data];
                    parser.delegate = self;
                    [parser parse];
                }
            });
        }];
    });
}

/*
 version=1&agent_id=1994367&agent_bill_id=1493171644&agent_bill_time=20170426095404&pay_type=30&pay_amt=3&notify_url=https://www.baidu.com&return_url=http://www.hynet.co&user_ip=192_168_2_107&key=3CA4BD84029D4191BEB14A0A
 version=1&agent_id=1994367&agent_bill_id=1493171644&agent_bill_time=20170426095404&return_mode=1&key=3CA4BD84029D4191BEB14A0A
 
 version=1&agent_id=1994367&agent_bill_id=1493171644&agent_bill_time=20170426095404&return_mode=1&remark=AppName&sign_type=MD5&sign=5ED634DB1C48BFC722884A5AD354F0C2
 */
/**
  * 查单接口返回参数
  * agent_id=1994367|agent_bill_id=1493196219|jnet_bill_no=H1704264228977AQ|pay_type=30|result=0|pay_amt=0.00|pay_message=|remark=AppName|sign=e99d8e90f699eebb778f2c8a03f24acb
 */
//H5 查询接口。
+(void)queryPaymentResultwithCompleteBlock:(WebRequestCompleteBlock)block{

    
    NSString * version = @"1";
    NSString *return_mode = @"1";
    NSString *remark = @"AppName";
    NSString *sign_type = @"MD5";
    NSString *key = agentKey;
    NSString *preSignStr = [NSString stringWithFormat:@"version=%@&agent_id=%@&agent_bill_id=%@&agent_bill_time=%@&return_mode=%@&key=%@",version,[WebRequest shareInstance].agent_id,[WebRequest shareInstance].agent_bill_id,[WebRequest shareInstance].agent_bill_time,return_mode,key];
    NSLog(@"presign:: %@",preSignStr);
    
    NSString *sign = [self md5:preSignStr].lowercaseString;//此处的md5签名数据记住改为小写，不然会报签名数据无效的错误，注意
    
    NSString *postStr = [NSString stringWithFormat:@"version=%@&agent_id=%@&agent_bill_id=%@&agent_bill_time=%@&return_mode=%@&remark=%@&sign_type=%@&sign=%@",version,[WebRequest shareInstance].agent_id,[WebRequest shareInstance].agent_bill_id,[WebRequest shareInstance].agent_bill_time,return_mode,remark,sign_type,sign];
    NSLog(@"postStr:::%@",postStr);
    
    NSStringEncoding gb2312 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *postData = [[postStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest * postRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:queryURL]];
    [postRequest setHTTPBody:postData];
    [postRequest setHTTPMethod:@"POST"];
//    [postRequest setValue:@"application/x-www-form-urlencoded;charset=GB2312" forHTTPHeaderField:@"Content-Type"];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSURLConnection sendAsynchronousRequest:postRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (connectionError) {
                    NSLog(@"error:%@",connectionError);
                    block(@{@"error":connectionError},YES);
                }else{
                    
                    NSString *string = [[NSString alloc] initWithData:data encoding:gb2312];
                    NSLog(@"\ndata:%@\nstring:%@",data,string);
                    
                    NSString *xmlstring = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:gb2312];
                    block(@{@"params":xmlstring},NO);
                    NSLog(@"xmlstring:::%@---connectionError:::%@",xmlstring,connectionError);
                }
            });
        }];
    });

}


#pragma mark - NSXMLParserDelegate Methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    _tmpStr = [[NSMutableString alloc] init];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [_tmpStr appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
     if ([elementName isEqualToString:@"token_id"]) {
        [_returnValue setObject:_tmpStr forKey:@"token_id"];
    }
    else if ([elementName isEqualToString:@"error"]) {
        [_returnValue setObject:_tmpStr forKey:@"error"];
    }
    
    _tmpStr = nil;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if(self.completeBlock){
        if (_returnValue[@"error"] != nil) {
            self.completeBlock(self.returnValue.copy,YES);
        }
        else {
            
            self.completeBlock(self.returnValue.copy,NO);
        }
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    if(self.completeBlock){
        self.completeBlock(@{
                                @"error":@"解析失败"
                             },YES);
    }
}


@end

