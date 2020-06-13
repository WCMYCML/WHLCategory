//
//  NSString+WHLAES128.m
//  CrudeOilThrough
//
//  Created by 浩霖 on 2018/5/16.
//  Copyright © 2018年 wanglz. All rights reserved.
//

#import "NSString+WHLAES128.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation NSString (WHLAES128)

///AES128加密 已经base64处理了
- (NSString *)whl_aes128_encryptWithAESWithAESkey:(NSString *)aseKey {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *AESData = [self whl_AES128operation:kCCEncrypt
                                           data:data
                                            key:aseKey
                                             iv:NULL];
    NSString *baseStr = [AESData base64EncodedStringWithOptions:0];
    return baseStr;
}

///AES128解密 已经base64处理了
- (NSString *)whl_aes128_decryptWithAESWithAESkey:(NSString *)aesKey {
    NSData *baseData = [[NSData alloc]initWithBase64EncodedString:self options:0];
    NSData *AESData = [self whl_AES128operation:kCCDecrypt
                                           data:baseData
                                            key:aesKey
                                             iv:NULL];
    NSString *decStr = [[NSString alloc] initWithData:AESData encoding:NSUTF8StringEncoding];
    return decStr;
}

/**
 *  AES加解密算法
 *
 *  @param operation kCCEncrypt（加密）kCCDecrypt（解密）
 *  @param data      待操作Data数据
 *  @param key       key
 *  @param iv        向量
 *
 */
- (NSData *)whl_AES128operation:(CCOperation)operation data:(NSData *)data key:(NSString *)key iv:(NSString *)iv {
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

    // IV
    char ivPtr[kCCBlockSizeAES128 + 1];
    bzero(ivPtr, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];

    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;

    CCCryptorStatus cryptorStatus = CCCrypt(operation, kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode,
                                            keyPtr, kCCKeySizeAES128,
                                            NULL, //若选择非ECB模式，请输入密钥偏移量，否则默认为1234567890123456 否则就设为NULL
                                            [data bytes], [data length],
                                            buffer, bufferSize,
                                            &numBytesEncrypted);

    if (cryptorStatus == kCCSuccess) {
        NSLog(@"Success");
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    } else {
        NSLog(@"Error");
    }

    free(buffer);
    return nil;
}

@end
