//
//  UIImage+WHLCompress.h
//  CrudeOilThrough
//
//  Created by Apple on 2017/9/11.
//  Copyright © 2017年 wanglz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WHLCompress)

//修改图片上传到后台旋转的问题
- (UIImage *)whl_fixOrientation;

/**
 *  修改图片 尺寸   pix 大小
 *
 *

 */
- (UIImage *)whl_changeImageWithPix:(CGFloat)pix;

- (UIImage *)whl_compressedImage;

/**
 *  给图片加上时间的水印
 *
 *  @param conStr 文字 当为nil的时候就是系统时间
 *
 *  @return UIImage
 */
- (UIImage *)whl_waterMarkImageContent:(NSString *)conStr;

/**
 *   UIColor -->> UIImage    （将UIColor转化为UIimage）
 *
 *  @param color  颜色
 *  @param size 图片尺寸
 *
 *  @return
 */
+ (UIImage *)whl_renderImageWithColor:(UIColor *)color inSize:(CGSize)size;

/// 裁剪出指定rect的图片(限定在自己的size之内) 内部已考虑到retina图片,rect不必为retina图片进行x2处理
/// @param rect 指定的矩形区域,坐标系为图片坐标系,原点在图片的左上角
- (UIImage *)whl_cropImageWithRect:(CGRect)rect;

/// 获取图片压缩后的二进制数据,如果图片大小超过bytes时,会对图片进行等比例缩小尺寸处理    会自动进行png检测,从而保持alpha通道
/// @param bytes  二进制数据的大小上限,0代表不限制
/// @param compressionQuality  压缩后图片质量,取值为0...1,值越小,图片质量越差,压缩比越高,二进制大小越小
- (NSData *)whl_imageDataThatFitBytes:(NSUInteger)bytes compressionQuality:(CGFloat)compressionQuality;

/**
 *  将image 限制在某一个大小范围内（300KB）
 *
 *  @return return value description
 */
- (NSData *)whl_compressedData;

/**
 *  将图片压缩至指定的大小
 *
 *  @param imageLength 以KB为单位 （jepg 都有一个最小的压缩值 保证图片的清晰度 的情况下 进行压缩）
 *
 *  @return
 */
- (NSData *)whl_compressedImageWitnLength:(NSInteger)imageLength;

@end

@interface UIImage (WHLImageSize)

/// 返回最大相对尺寸。x/y 为0时，尺寸不受约束
/// @param size 尺寸
- (CGSize)whl_sizeWithMaxRelativeSize:(CGSize)size;

/// 返回最小相对尺寸。x/y 为0时，尺寸不受约束
/// @param size 尺寸
- (CGSize)whl_sizeWithMinRelativeSize:(CGSize)size;

/// 将图片缩放到指定的CGSize大小
/// @param size 要缩放到的尺寸
/// @param scale 比例
- (UIImage *)whl_imageWithCanvasSize:(CGSize)size scale:(CGFloat)scale;

- (UIImage *)whl_imageWithCanvasSize:(CGSize)size;

/// 矫正图片 （相机拍照之后的图片可能需要矫正一下再使用）
- (UIImage *)whl_fixOrientation;

/// 返回图片在内存里的像素点所占的内存大小,单位为字节(Byte) 1kb = 1024btye
- (NSUInteger)whl_lengthOfRawData;

@end
