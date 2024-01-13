//
//  UIImage+WHLCompress.m
//  CrudeOilThrough
//
//  Created by Apple on 2017/9/11.
//  Copyright © 2017年 wanglz. All rights reserved.
//

#import "UIImage+WHLCompress.h"
#import "UIImage+WHLProperty.h"

#define MAX_IMAGEPIX      1024.0 // max pix 200.0px
#define MAX_IMAGEDATA_LEN 1000.0 * 200 // max data length 5K

//100KB --> Image 的 size -->清晰度

@implementation UIImage (WHLCompress)

- (UIImage *)whl_fixOrientation {
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;

    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;

    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;

        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;

        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }

    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;

        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }

    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage);
            break;

        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
            break;
    }

    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (NSData *)whl_compressedImageWitnLength:(NSInteger)maxLength
{
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(self, compression);
    while (data.length > maxLength && compression > 0) {
        compression -= 0.1;
        data = UIImageJPEGRepresentation(self, compression);
    }
    return data;
}

- (UIImage *)whl_compressedImage
{
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;

    if (width <= MAX_IMAGEPIX && height <= MAX_IMAGEPIX) {
        // no need to compress.
        return self;
    }

    if (width == 0 || height == 0) {
        // void zero exception
        return self;
    }

    UIImage *newImage = nil;
    CGFloat widthFactor = MAX_IMAGEPIX / width;
    CGFloat heightFactor = MAX_IMAGEPIX / height;
    CGFloat scaleFactor = 0.0;

    if (widthFactor > heightFactor) scaleFactor = heightFactor;  // scale to fit height
    else scaleFactor = widthFactor;                              // scale to fit width

    CGFloat scaledWidth = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    CGSize targetSize = CGSizeMake(scaledWidth, scaledHeight);

    UIGraphicsBeginImageContext(targetSize); // this will crop

    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;

    [self drawInRect:thumbnailRect];

    newImage = UIGraphicsGetImageFromCurrentImageContext();

    //pop the context to get back to the default
    UIGraphicsEndImageContext();

    return newImage;
}

- (NSData *)whl_compressedData:(CGFloat)compressionQuality
{
    assert(compressionQuality <= 1.0 && compressionQuality >= 0);

    return UIImageJPEGRepresentation(self, compressionQuality);
}

- (CGFloat)whl_compressionQuality
{
    NSData *data = UIImageJPEGRepresentation(self, 1.0);
    return 1.0 / (data.length / MAX_IMAGEDATA_LEN);
    //    if (dataLength > MAX_IMAGEDATA_LEN) {
    //        return 1.0 - MAX_IMAGEDATA_LEN / dataLength;
    //    }
    //    else {
    //        return 1.0;
    //    }
}

/// 裁剪出指定rect的图片(限定在自己的size之内) 内部已考虑到retina图片,rect不必为retina图片进行x2处理
/// @param rect 指定的矩形区域,坐标系为图片坐标系,原点在图片的左上角
- (UIImage *)whl_cropImageWithRect:(CGRect)cropRect {
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    cropRect = CGRectIntersection(bounds, cropRect);//限制在自己的尺寸里面
    CGRect drawRect = CGRectMake(-cropRect.origin.x, -cropRect.origin.y, self.size.width * self.scale, self.size.height * self.scale);
    UIGraphicsBeginImageContext(cropRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, CGRectMake(0, 0, cropRect.size.width, cropRect.size.height));
    [self drawInRect:drawRect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 压缩 图片 大小
- (NSData *)whl_compressedData
{
    CGFloat quality = [self whl_compressionQuality];
    NSInteger lastLnegth = 0;
    NSData *data = nil;
    while (!data || data.length > MAX_IMAGEDATA_LEN) {
        data = [self whl_compressedData:MAX(quality, 0)];
        if (data.length < lastLnegth + 100 || data.length > lastLnegth - 100) { //已经 不能在压缩了
            break;
        }
        lastLnegth = data.length;
        quality = (quality > 0.2 ? quality - 0.1 : quality / 2);
    }
    return data;
}

#pragma mark - 修改图片的边长 最大的
- (UIImage *)whl_changeImageWithPix:(CGFloat)pix
{
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if (width == 0 || height == 0 || (MAX(width, height) < pix + 10 && MAX(width, height) > pix - 10)) {
        return self;
    }
    UIImage *newImage = nil;
    CGFloat scaleFactor = pix / MAX(width, height);
    CGFloat scaledWidth = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;

    CGSize targetSize = CGSizeMake(scaledWidth, scaledHeight);
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [self drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    //pop the context to get back to the default
    UIGraphicsEndImageContext();

    return newImage;
}

#pragma mark - 在右下角 加上 文字水印（nil  时间水印）
- (UIImage *)whl_aterMarkImageContent:(NSString *)conStr
{
    // 1. 获得图像上下文
    UIGraphicsBeginImageContext(self.size);
    // 2. 加载图像， 把图像画在特定区域
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    // 3. 设置水印文字
    NSString *word;
    if (conStr.length) {
        word = conStr;
    } else {
        NSDate *senddate = [NSDate date];

        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];

        [dateformatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];

        NSString *locationString = [dateformatter stringFromDate:senddate];
        word = locationString;
    }
    // 颜色  (ios7中设置颜色的方法)
    //ios7之后可用
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentRight;
    NSDictionary *dic = @{
            NSFontAttributeName: [UIFont systemFontOfSize:self.size.height / 50],

            NSParagraphStyleAttributeName: style,

            NSBaselineOffsetAttributeName: [NSNumber numberWithInt:NSLineBreakByWordWrapping],

            NSBackgroundColorAttributeName: [UIColor whiteColor],
            NSForegroundColorAttributeName: (conStr.length ? [UIColor blackColor] : [UIColor redColor]),
    };
    //     画 文字 (rect是相对于图像上得位置)
    //     4. 从图像上下文中获得当前绘制的结果 生产图像
    [word   drawInRect:CGRectMake(0, self.size.height - self.size.height / 40, self.size.width, self.size.height / 40)
        withAttributes:dic];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    // 5. 关闭上下文图像
    UIGraphicsEndImageContext();
    result.isWatermarkForTime = YES;
    return result;
}

#pragma mark - 将 UIColor转化我 UIImage
+ (UIImage *)whl_renderImageWithColor:(UIColor *)color inSize:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

//等比例压缩
- (UIImage *)whl_imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if (CGSizeEqualToSize(imageSize, size) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor;
        } else {
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }

    UIGraphicsBeginImageContext(size);

    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();

    if (newImage == nil) {
        NSLog(@"🔥scale image fail");
    }

    UIGraphicsEndImageContext();

    return newImage;
}

- (UIImage *)whl_imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if (CGSizeEqualToSize(imageSize, size) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor;
        } else {
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;

    [sourceImage drawInRect:thumbnailRect];

    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if (newImage == nil) {
        NSLog(@"scale image fail");
    }

    UIGraphicsEndImageContext();
    return newImage;
}

/// 获取图片压缩后的二进制数据,如果图片大小超过bytes时,会对图片进行等比例缩小尺寸处理    会自动进行png检测,从而保持alpha通道
/// @param bytes  二进制数据的大小上限,0代表不限制
/// @param compressionQuality  压缩后图片质量,取值为0...1,值越小,图片质量越差,压缩比越高,二进制大小越小
- (NSData *)whl_imageDataThatFitBytes:(NSUInteger)bytes compressionQuality:(CGFloat)compressionQuality {
    BOOL isPng = self.whl_isPngImage;
    NSData *data;
    if (isPng) {
        data = [self imageDataOfPngThatFitBytes:bytes];
    } else {
        data = [self imageDataOfJpgThatFitBytes:bytes withCompressionQuality:compressionQuality];
    }
    return data;
}

- (NSData *)imageDataOfPngThatFitBytes:(NSUInteger)bytes {
    NSData *data = UIImagePNGRepresentation(self);
    NSUInteger len = data.length;
    if (bytes != 0 && len > bytes) {
        //可以简单认为压缩后的大小与像素点数量成正比
        CGFloat factor = 0.9 * sqrt(1.0 * bytes / len);//由于只是近似计算,因此再乘上0.9系数,让压缩后的值再小点
        CGSize size = self.size;
        size.width *= factor;
        size.height *= factor;
        UIImage *image = [self whl_imageWithCanvasSize:size];
        data = [image imageDataOfPngThatFitBytes:bytes];
    }
    return data;
}

- (NSData *)imageDataOfJpgThatFitBytes:(NSUInteger)bytes withCompressionQuality:(CGFloat)compressionQuality {
    NSData *data = UIImageJPEGRepresentation(self, compressionQuality);
    NSUInteger len = data.length;
    if (bytes != 0 && len > bytes) {
        //可以简单认为压缩后的大小与像素点数量成正比
        CGFloat factor = 0.9 * sqrt(1.0 * bytes / len);//由于只是近似计算,因此再乘上0.9系数,让压缩后的值再小点
        CGSize size = self.size;
        size.width *= factor;
        size.height *= factor;
        UIImage *image = [self whl_imageWithCanvasSize:size];
        data = [image imageDataOfJpgThatFitBytes:bytes withCompressionQuality:compressionQuality];
    }
    return data;
}

@end

@implementation UIImage (WHLImageSize)

- (CGSize)sizeWithMaxRelativeSize:(CGSize)size isMax:(BOOL)isMax {
    CGSize imageSize = self.size;
    CGSize resultSize = CGSizeZero;
    if (size.width == 0 && size.height != 0) {
        resultSize.height = size.height;
        resultSize.width = imageSize.width / imageSize.height * resultSize.height;
        return resultSize;
    } else if (size.width != 0 && size.height == 0) {
        resultSize.width = size.width;
        resultSize.height = resultSize.width * imageSize.height / imageSize.width;
        return resultSize;
    } else if (size.width == 0 && size.height == 0) {
        return self.size;
    }
    if ((imageSize.width / imageSize.height >= size.width / size.height && isMax) || (imageSize.width / imageSize.height < size.width / size.height && !isMax)) {
        resultSize.height = size.height;
        resultSize.width = imageSize.width / imageSize.height * resultSize.height;
        return resultSize;
    } else {
        resultSize.width = size.width;
        resultSize.height = resultSize.width * imageSize.height / imageSize.width;
        return resultSize;
    }
    return resultSize;
}

/// 返回最大相对尺寸。x/y 为0时，尺寸不受约束
/// @param size 尺寸
- (CGSize)whl_sizeWithMaxRelativeSize:(CGSize)size {
    CGSize resize = [self sizeWithMaxRelativeSize:size isMax:YES];
    return resize;
}

/// 返回最小相对尺寸。x/y 为0时，尺寸不受约束
/// @param size 尺寸
- (CGSize)whl_sizeWithMinRelativeSize:(CGSize)size {
    CGSize resize = [self sizeWithMaxRelativeSize:size isMax:NO];
    return resize;
}

/// 将图片缩放到指定的CGSize大小
/// @param size 要缩放到的尺寸
/// @param scale 比例
- (UIImage *)whl_imageWithCanvasSize:(CGSize)size scale:(CGFloat)scale {
    size.width *= scale;
    size.height *= scale;
    UIImage *scaledImage = [self whl_imageWithCanvasSize:size];
    return scaledImage;
}

- (UIImage *)whl_imageWithCanvasSize:(CGSize)size {
    UIImage *image = [self copy];
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

/// 矫正图片 （相机拍照之后的图片可能需要矫正一下再使用）
- (UIImage *)whl_fixOrientation {
    UIImage *image = [self copy];
    if (image.imageOrientation == UIImageOrientationUp) {
        return image;
    }
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0, 0, image.size.height, image.size.width), image.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
            break;
    }
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

/// 返回图片在内存里的像素点所占的内存大小,单位为字节(Byte) 1kb = 1024btye
- (NSUInteger)whl_lengthOfRawData {
    CGDataProviderRef providerRef = CGImageGetDataProvider(self.CGImage);
    CFDataRef dataRef = CGDataProviderCopyData(providerRef);
    CFIndex len = CFDataGetLength(dataRef);
    CFRelease(dataRef);
    return (NSUInteger)len;
}

@end
