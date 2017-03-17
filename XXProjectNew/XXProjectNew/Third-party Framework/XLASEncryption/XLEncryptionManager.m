//
//  XLEncryptionManager.m
//  Pods
//
//  Created by chenxiaoqiang on 15/11/11.
//
//

#import "XLEncryptionManager.h"

@implementation XLEncryptionManager

#define     FileHashDefaultChunkSizeForReadingData 1024*8 // 8K

+ (NSString*)getmd5WithString:(NSString *)hashString
{
    return [self getMD5WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding]];
}

+(NSString*)getMD5WithData:(NSData *)hashData{
    unsigned char *digest;
    digest = malloc(CC_MD5_DIGEST_LENGTH);
    
    CC_MD5([hashData bytes], (CC_LONG)[hashData length], digest);
    
    NSData *data = [NSData dataWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
    
    static const char HexEncodeCharsLower[] = "0123456789abcdef";
    char *resultData;
    // malloc result data
    resultData = malloc([data length] * 2 +1);
    // convert imgData(NSData) to char[]
    unsigned char *sourceData = ((unsigned char *)[data bytes]);
    NSUInteger length = [data length];
    for (NSUInteger index = 0; index < length; index++) {
        // set result data
        resultData[index * 2] = HexEncodeCharsLower[(sourceData[index] >> 4)];
        resultData[index * 2 + 1] = HexEncodeCharsLower[(sourceData[index] % 0x10)];
    }
    resultData[[data length] * 2] = 0;
    
    NSString *result = [NSString stringWithCString:resultData encoding:NSASCIIStringEncoding];
    sourceData = nil;
    free(resultData);
    
    return result;
}


+(NSString*)getFileMD5WithPath:(NSString*)path
{
    return (__bridge  NSString *)FileMD5HashCreateWithPath((__bridge CFStringRef)path,FileHashDefaultChunkSizeForReadingData);
}

CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath,
                                      size_t chunkSizeForReadingData) {
    
    // Declare needed variables
    CFStringRef result = NULL;
    CFReadStreamRef readStream = NULL;
    
    // Get the file URL
    CFURLRef fileURL =
    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                  (CFStringRef)filePath,
                                  kCFURLPOSIXPathStyle,
                                  (Boolean)false);
    
    CC_MD5_CTX hashObject;
    bool hasMoreData = true;
    bool didSucceed;
    
    if (!fileURL) goto done;
    
    // Create and open the read stream
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                            (CFURLRef)fileURL);
    if (!readStream) goto done;
    didSucceed = (bool)CFReadStreamOpen(readStream);
    if (!didSucceed) goto done;
    
    // Initialize the hash object
    CC_MD5_Init(&hashObject);
    
    // Make sure chunkSizeForReadingData is valid
    if (!chunkSizeForReadingData) {
        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
    }
    
    // Feed the data to the hash object
    while (hasMoreData) {
        uint8_t buffer[chunkSizeForReadingData];
        CFIndex readBytesCount = CFReadStreamRead(readStream,
                                                  (UInt8 *)buffer,
                                                  (CFIndex)sizeof(buffer));
        if (readBytesCount == -1)break;
        if (readBytesCount == 0) {
            hasMoreData =false;
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
    char hash[2 *sizeof(digest) + 1];
    for (size_t i =0; i < sizeof(digest); ++i) {
        snprintf(hash + (2 * i),3, "%02x", (int)(digest[i]));
    }
    result = CFStringCreateWithCString(kCFAllocatorDefault,
                                       (const char *)hash,
                                       kCFStringEncodingUTF8);
    
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


//AES加密
+ (NSString *)AESEncryptString:(NSString *)str withKey:(NSString *)key
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSData *aesData = [self AESEncryptData:data withKey:key];
    NSString *aesBase64 = [self base64EncryptionWithData:aesData];
    return aesBase64;
}

+ (NSString *)AESDecryptString:(NSString *)str withKey:(NSString *)key
{
    NSData *aesData = [self base64DecryptionWithString:str];
    NSData *data = [self AESDecryptData:aesData withKey:key];
    NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}

+ (NSData *)AESEncryptData:(NSData *)inData withKey:(NSString *)key   //加密
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [inData length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [inData bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}


+ (NSData *)AESDecryptData:(NSData *)inData withKey:(NSString *)key   //解密
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [inData length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [inData bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}

//64编码
+ (NSString *)base64Encryption:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [self base64EncryptionWithData:data];
}

+ (NSString *)base64EncryptionWithData:(NSData *)data
{
    NSString *base64Str = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return base64Str;
}

+ (NSData *)base64DecryptionWithString:(NSString *)base64
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
    return data;
}

//64解码
+ (NSString *)base64Decryption:(NSString *)base64
{
    NSData *data = [self base64DecryptionWithString:base64];
    NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}


+ (NSString*) sha1:(NSString *)inStr
{
    const char *cstr = [inStr cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:inStr.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    NSAssert(data.length < UINT32_MAX, @"data to big");
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

+ (NSString*) sha224:(NSString *)inStr
{
    const char *cstr = [inStr cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:inStr.length];
    
    uint8_t digest[CC_SHA224_DIGEST_LENGTH];
    
    NSAssert(data.length < UINT32_MAX, @"data to big");
    
    CC_SHA224(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA224_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA224_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

+ (NSString*) sha256:(NSString *)inStr
{
    const char *cstr = [inStr cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:inStr.length];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    NSAssert(data.length < UINT32_MAX, @"data to big");
    
    CC_SHA256(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

+ (NSString*) sha384:(NSString *)inStr
{
    const char *cstr = [inStr cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:inStr.length];
    
    uint8_t digest[CC_SHA384_DIGEST_LENGTH];
    
    NSAssert(data.length < UINT32_MAX, @"data to big");
    
    CC_SHA384(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA384_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA384_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

+ (NSString*) sha512:(NSString *)inStr
{
    const char *cstr = [inStr cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:inStr.length];
    
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    
    NSAssert(data.length < UINT32_MAX, @"data to big");
    
    CC_SHA512(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}


+(NSString *) sha512Base64:(NSString *)inStr
{
    NSData *data = [inStr dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    
    NSAssert(data.length < UINT32_MAX, @"data to big");
    
    CC_SHA512(data.bytes, (CC_LONG)data.length, digest);
    
    NSData *sha512Data=[[NSData alloc]initWithBytes:digest length:CC_SHA256_DIGEST_LENGTH * 2];
    
    NSData *base64Sha512Data =[sha512Data base64EncodedDataWithOptions:0];
    
    NSString *output = [[NSString alloc]initWithData:base64Sha512Data encoding:NSUTF8StringEncoding];
    
    return output;
}

@end
