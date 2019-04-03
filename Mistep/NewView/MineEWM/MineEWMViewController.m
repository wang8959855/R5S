//
//  MineEWMViewController.m
//  Wukong
//
//  Created by apple on 2018/5/17.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "MineEWMViewController.h"

@interface MineEWMViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *rwmImage;

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;


@end

@implementation MineEWMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *data = [NSString stringWithFormat:@"https://www.lantianfangzhou.com/download/downloadApp.html?r5s=%@",USERID];
    [self composeImg:[self encodeQRImageWithContent:data size:CGSizeMake(215, 215)]];
    self.iconImage.image = [UIImage imageNamed:@"AppIcon"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//生成二维码
- (UIImage *)encodeQRImageWithContent:(NSString *)content size:(CGSize)size {
    UIImage *codeImage = nil;
    
    NSData *stringData = [content dataUsingEncoding: NSUTF8StringEncoding];
    //生成
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    UIColor *onColor = [UIColor blackColor];
    UIColor *offColor = [UIColor whiteColor];
    
    //上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage",qrFilter.outputImage,
                             @"inputColor0",[CIColor colorWithCGColor:onColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:offColor.CGColor],
                             nil];
    
    CIImage *qrImage = colorFilter.outputImage;
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;
}




- (void)composeImg:(UIImage *)image {
//    UIImage *img = [UIImage imageNamed:@"0.png"];
    CGImageRef imgRef = image.CGImage;
    CGFloat w = CGImageGetWidth(imgRef);
    CGFloat h = CGImageGetHeight(imgRef);
    
    //给二维码加logo
    
    //以1.png的图大小为画布创建上下文
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
    [image drawInRect:CGRectMake(0, 0, w, h)];//再把小图放在上下文中
//    [img2 drawInRect:CGRectMake(w/2-20, h/2-20, 40, 40)];
    
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();//从当前上下文中获得最终图片
    
    
    UIGraphicsEndImageContext();//关闭上下文
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [path stringByAppendingPathComponent:@"share.png"];
    [UIImagePNGRepresentation(resultImg) writeToFile:filePath atomically:YES];//保存图片到沙盒
    
    //    CGImageRelease(imgRef);
    //    CGImageRelease(imgRef1);
    
    
    self.rwmImage.image = resultImg;
}

//返回
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
