//
//  NSString+WHLAES128.h
//  CrudeOilThrough
//
//  Created by 浩霖 on 2018/5/16.
//  Copyright © 2018年 wanglz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WHLAES128)

/**
 加密方法
 */
- (NSString*)whl_aes128_encryptWithAESWithAESkey:(NSString *)aseKey;

/**
 解密方法
 */
- (NSString*)whl_aes128_decryptWithAESWithAESkey:(NSString *)aesKey;



@end
