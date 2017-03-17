//
//  XLEncryptionManager.h
//  Pods
//
//  Created by chenxiaoqiang on 15/11/11.
//
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface XLEncryptionManager : NSObject

//AES加密
+ (NSString *)AESEncryptString:(NSString *)str withKey:(NSString *)key;
+ (NSString *)AESDecryptString:(NSString *)str withKey:(NSString *)key;

+ (NSData *)AESEncryptData:(NSData *)inData withKey:(NSString *)key;
+ (NSData *)AESDecryptData:(NSData *)inData withKey:(NSString *)key;

//base64
+ (NSString *)base64EncryptionWithData:(NSData *)data;
+ (NSData *)base64DecryptionWithString:(NSString *)base64;
+ (NSString *)base64Encryption:(NSString *)string;
+ (NSString *)base64Decryption:(NSString *)base64;

//SHA
+(NSString *) sha1:(NSString *)inStr;
+(NSString *) sha224:(NSString *)inStr;
+(NSString *) sha256:(NSString *)inStr;
+(NSString *) sha384:(NSString *)inStr;
+(NSString *) sha512:(NSString *)inStr;
+(NSString *) sha512Base64:(NSString *)inStr;

//MD5
+ (NSString*)getmd5WithString:(NSString *)hashString;
+ (NSString*)getMD5WithData:(NSData *)hashData;
+(NSString*)getFileMD5WithPath:(NSString*)path;

@end
