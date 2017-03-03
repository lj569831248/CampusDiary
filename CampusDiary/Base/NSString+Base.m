//
//  NSString+Base.m
//  Inker
//
//  Created by Jon on 2016/12/15.
//  Copyright © 2016年 Droi. All rights reserved.
//

#import "NSString+Base.h"
#import <CommonCrypto/CommonDigest.h>
#define FileHashDefaultChunkSizeForReadingData 1024*8

static NSString *const kPhoneNumberRegex = @"^1+[3578]+\\d{9}";
static NSString *const kPasswordRegex = @"^[\\w.]{6,16}$";
static NSString *const kUserNameRegex = @"^[a-zA-Z\u4E00-\u9FA5]{1,20}";
static NSString *const kIdCardRegex = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
static NSString *const kURLRegex = @"^[0-9A-Za-z]{1,50}";
static NSString *const kVerificationCodeRegex =  @"^[0-9]{4}$";
static NSString *const kEmailRegex =  @"^[a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){1,63}[a-z0-9]+$";
@implementation NSString (Base)


#pragma mark 颜色相关

+ (NSString *)ColorToHex:(UIColor *)color{
    
    const CGFloat *cs=CGColorGetComponents(color.CGColor);
    NSString *r = [NSString stringWithFormat:@"%@",[self  ToHex:cs[0]*255]];
    NSString *g = [NSString stringWithFormat:@"%@",[self  ToHex:cs[1]*255]];
    NSString *b = [NSString stringWithFormat:@"%@",[self  ToHex:cs[2]*255]];
    return [NSString stringWithFormat:@"#%@%@%@",r,g,b];
}

//十进制转十六进制
+ (NSString *)ToHex:(int)tmpid
{
    NSString *endtmp=@"";
    NSString *nLetterValue;
    NSString *nStrat;
    int ttmpig=tmpid%16;
    int tmp=tmpid/16;
    switch (ttmpig)
    {
        case 10:
            nLetterValue =@"A";break;
        case 11:
            nLetterValue =@"B";break;
        case 12:
            nLetterValue =@"C";break;
        case 13:
            nLetterValue =@"D";break;
        case 14:
            nLetterValue =@"E";break;
        case 15:
            nLetterValue =@"F";break;
        default:nLetterValue=[[NSString alloc]initWithFormat:@"%i",ttmpig];
            
    }
    switch (tmp)
    {
        case 10:
            nStrat =@"A";break;
        case 11:
            nStrat =@"B";break;
        case 12:
            nStrat =@"C";break;
        case 13:
            nStrat =@"D";break;
        case 14:
            nStrat =@"E";break;
        case 15:
            nStrat =@"F";break;
        default:nStrat=[[NSString alloc]initWithFormat:@"%i",tmp];
            
    }
    endtmp=[[NSString alloc]initWithFormat:@"%@%@",nStrat,nLetterValue];
    return endtmp;
}



+ (NSString *)base64EncodedWithString:(NSString *)orginString{
    
    NSData *orginData = [orginString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *base64EndcodeData = [orginData base64EncodedDataWithOptions:0];
    NSString *base64EncodeString = [[NSString alloc] initWithData:base64EndcodeData encoding:NSUTF8StringEncoding];
    return base64EncodeString;
}

+ (NSString *)base64DecodedWithString:(NSString *)encodeString{
    
    NSData *encodeData = [[NSData alloc] initWithBase64EncodedString:encodeString options:0];
    NSString *base64DecodedString = [[NSString alloc] initWithData:encodeData encoding:NSUTF8StringEncoding];
    return base64DecodedString;
}

#pragma mark MD5相关

+ (NSString *)md5WithString:(NSString *)string
{
    const char *md5String = string.UTF8String;
    int length = (int)strlen(md5String);
    unsigned char bytes[CC_MD5_DIGEST_LENGTH];
    CC_MD5(md5String, length, bytes);
    return [self stringWithSting:string FromBytes:bytes length:CC_MD5_DIGEST_LENGTH];
}

+ (NSString *)stringWithSting:(NSString *)string FromBytes:(unsigned char *)bytes length:(int)length
{
    NSMutableString *mutableString = @"".mutableCopy;
    for (int i = 0; i < length; i++)
        [mutableString appendFormat:@"%02x", bytes[i]];
    return [NSString stringWithString:mutableString];
}

+(NSString*)getFileMD5WithPath:(NSString*)path
{
    return (__bridge_transfer NSString *)FileMD5HashCreateWithPath((__bridge CFStringRef)path, FileHashDefaultChunkSizeForReadingData);
}

CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath,size_t chunkSizeForReadingData) {
    // Declare needed variables
    CFStringRef result = NULL;
    CFReadStreamRef readStream = NULL;
    // Get the file URL
    CFURLRef fileURL =
    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                  (CFStringRef)filePath,
                                  kCFURLPOSIXPathStyle,
                                  (Boolean)false);
    if (!fileURL) goto done;
    // Create and open the read stream
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                            (CFURLRef)fileURL);
    if (!readStream) goto done;
    bool didSucceed = (bool)CFReadStreamOpen(readStream);
    if (!didSucceed) goto done;
    // Initialize the hash object
    CC_MD5_CTX hashObject;
    CC_MD5_Init(&hashObject);
    // Make sure chunkSizeForReadingData is valid
    if (!chunkSizeForReadingData) {
        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
    }
    // Feed the data to the hash object
    bool hasMoreData = true;
    while (hasMoreData) {
        uint8_t buffer[chunkSizeForReadingData];
        CFIndex readBytesCount = CFReadStreamRead(readStream,(UInt8 *)buffer,(CFIndex)sizeof(buffer));
        if (readBytesCount == -1) break;
        if (readBytesCount == 0) {
            hasMoreData = false;
            continue;
        }
        CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
    }
    // Check if the read operation succeeded
    didSucceed = !hasMoreData;
    // Compute the hash digest
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &hashObject);
    // Abort if the read operation failed
    if (!didSucceed) goto done;
    // Compute the string result
    char hash[2 * sizeof(digest) + 1];
    for (size_t i = 0; i < sizeof(digest); ++i) {
        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
    }
    result = CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hash,kCFStringEncodingUTF8);
    
done:
    if (readStream) {
        CFReadStreamClose(readStream);
        CFRelease(readStream);
    }
    if (fileURL) {
        CFRelease(fileURL);
    }
    return result;
}

#pragma mark 正则相关

+ (BOOL)checkMatch:(NSString *)string regex:(NSString *)regex{
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}

+ (BOOL)checkTelNumber:(NSString *) telNumber
{
    return [self checkMatch:telNumber regex:kPhoneNumberRegex];
}

+ (BOOL)checkPassword:(NSString *) password
{
    return [self checkMatch:password regex:kPasswordRegex];
    
}

+ (BOOL)checkUserName : (NSString *) userName
{
    return [self checkMatch:userName regex:kUserNameRegex];
}

+ (BOOL)checkIdCard: (NSString *) idCard
{
    return [self checkMatch:idCard regex:kIdCardRegex];
}

+ (BOOL)checkURL : (NSString *) url
{
    return [self checkMatch:url regex:kURLRegex];
}

+ (BOOL)checkEmail:(NSString *)email{
    
    return [self checkMatch:email regex:kEmailRegex];
}

// 验证码
+ (BOOL)checkVerificationCode:(NSString *)verificationCode{
    
    return [self checkMatch:verificationCode regex:kVerificationCodeRegex];
}

- (BOOL)isMatchRegex:(NSString *)regex{
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

// 正则匹配手机号
- (BOOL)isTelNumber{
    return [self isMatchRegex:kPhoneNumberRegex];
}
// 正则匹配用户密码6-18位数字或字母组合
- (BOOL)isPassword{
    
   return [self isMatchRegex:kPasswordRegex];
}
//  正则匹配用户姓名,20位的中文或英文
- (BOOL)isUserName{
    
   return [self isMatchRegex:kUserNameRegex];
}
// 正则匹配用户身份证号
- (BOOL)isIdCard{
    
    return [self isMatchRegex:kIdCardRegex];
}
// 正则匹配URL
- (BOOL)isURL{
    
   return [self isMatchRegex:kURLRegex];
}

- (BOOL)isVerificationCode{
    
    return [self isMatchRegex:kVerificationCodeRegex];
}

- (BOOL)isEmail{
    return [self isMatchRegex:kEmailRegex];
}


+ (NSString *)dictToJsonStr:(NSDictionary *)dict
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    if (error != nil) {
        NSLog(@"Dictionary to Json error : %@",error);
        return nil;
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    [mutStr replaceOccurrencesOfString:@" "
                            withString:@""
                               options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    [mutStr replaceOccurrencesOfString:@"\n"
                            withString:@""
                               options:NSLiteralSearch range:range2];
    return mutStr;
}

@end
