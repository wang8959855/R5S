//
//  LMSTakePhotoController.m
//  LetMeSpend
//
//  Created by 袁斌 on 16/3/10.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import "LMSTakePhotoController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIView+borderLine.h"
#import "SGImagePickerController/SGCollectionController.h"

#define SCREEN_WIDTH   [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT  [[UIScreen mainScreen] bounds].size.height

@interface LMSTakePhotoController ()<AVCaptureMetadataOutputObjectsDelegate>
{

    //切换前后摄像头
    
    __weak IBOutlet UIButton *_switchBtn;

    //自动
    
    __weak IBOutlet UIButton *_autonBtn;
    

    //拍照
    __weak IBOutlet UIButton *_takePicBtn;
    

    //取消
    __weak IBOutlet UIButton *_cancelBtn;
    
    //重拍
    
//    __weak IBOutlet UIButton *restartBtn;
    
    //使用拍照
    
//    __weak IBOutlet UIButton *_doneBtn;
    
    __weak IBOutlet UIView *_cameraView;
    
    //预览照片
//    __weak IBOutlet UIImageView *_groupImage;
    
}

@property (nonatomic,strong) AVCaptureSession *session;

@property(nonatomic,strong)AVCaptureDeviceInput *videoInput;

@property (nonatomic,strong)AVCaptureStillImageOutput *stillImageOutput;

@property (nonatomic,strong)AVCaptureVideoPreviewLayer *previewLayer;


- (IBAction)takePic:(UIButton *)sender;

- (IBAction)cancel:(UIButton *)sender;




- (IBAction)switchAction:(UIButton *)sender;



@end

@implementation LMSTakePhotoController

- (void)dealloc
{
    self.session = nil;
    self.groups = nil;
    self.assetsLibrary = nil;
    self.photoImageView = nil;
    [self.kcanCelBtn removeFromSuperview];
    self.kcanCelBtn = nil;
    self.videoInput = nil;
    self.stillImageOutput = nil;
    self.previewLayer = nil;
}


-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    [super viewWillAppear:animated];
    if (!self.session) {
        [self initialSession];
    }
    if (self.session) {
        [self.session startRunning];
    }
    [self groups];
}
- (void)viewDidLoad {
    
    [_kcanCelBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [super viewDidLoad];
    self.navigationItem.title = @"预览照片";
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.hidden = YES;
    
    self.photoImageView.layer.cornerRadius = 3;
    
    __weak LMSTakePhotoController *weakSelf = self;
    
    [[CositeaBlueTooth sharedInstance] recieveTakePhotoMessage:^(int number) {
        [weakSelf gainPicture];
    }];
}

#pragma mark session
- (void) initialSession;
{
    //这个方法的执行我放在init方法里了
    self.session = [[AVCaptureSession alloc] init];
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:nil];
    //[self fronCamera]方法会返回一个AVCaptureDevice对象，因为我初始化时是采用前摄像头，所以这么写，具体的实现方法后面会介绍
    [self.session setSessionPreset:AVCaptureSessionPresetPhoto];//
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    //这是输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
    if (self.session) {
        [self.session startRunning];
    }
    [self setUpCameraLayer];
}
- (AVCaptureDevice *)backCamera {
    return [self cameraWithPosition:self.position == TakePhotoPositionFront ?  AVCaptureDevicePositionFront:AVCaptureDevicePositionBack];
}

#pragma mark VideoCapture
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
}

- (void) setUpCameraLayer
{
    if (self.previewLayer == nil) {
        self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        [self.previewLayer setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 65)];
        [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [_cameraView.layer insertSublayer:self.previewLayer below:[[_cameraView.layer sublayers] objectAtIndex:0]];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 切换前后摄像头
- (void)swapFrontAndBackCameras {
    // Assume the session is already running
    
    NSArray *inputs = self.session.inputs;
    for ( AVCaptureDeviceInput *input in inputs ) {
        AVCaptureDevice *device = input.device;
        if ( [device hasMediaType:AVMediaTypeVideo] ) {
            AVCaptureDevicePosition position = device.position;
            AVCaptureDevice *newCamera = nil;
            AVCaptureDeviceInput *newInput = nil;
            
            if (position == AVCaptureDevicePositionFront)
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            else
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
            
            // beginConfiguration ensures that pending changes are not applied immediately
            [self.session beginConfiguration];
            
            [self.session removeInput:input];
            [self.session addInput:newInput];
            
            // Changes take effect once the outermost commitConfiguration is invoked.
            [self.session commitConfiguration];
            break;
        }
    }
}
- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
    self.navigationController.navigationBar.hidden = NO;
    if (self.session) {
        [self.session stopRunning];
    }
}
-(void)viewDidLayoutSubviews
{
    
    [_takePicBtn cornerRadius:CGRectGetHeight(_takePicBtn.frame)/2.0 borderColor:[[UIColor clearColor] CGColor] borderWidth:0];
//    [restartBtn cornerRadius:4 borderColor:[[UIColor clearColor] CGColor] borderWidth:0];
//    [_doneBtn cornerRadius:4 borderColor:[[UIColor clearColor] CGColor] borderWidth:0];
    
    [super viewDidLayoutSubviews];
}
#pragma mark 获取照片
- (void)gainPicture
{
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    if (!videoConnection) {
        return;
    }
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImageWriteToSavedPhotosAlbum([UIImage imageWithData: imageData], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//        if (self.session) {
//            [self.session stopRunning];
//        }
        UIImageView *cacheImageView = [[UIImageView alloc]init];
        cacheImageView.frame = _cameraView.frame;
        UIImage *image = [UIImage imageWithData:imageData];
        cacheImageView.image = image;
        [self.view addSubview:cacheImageView];
        
        [UIView animateWithDuration:0.3 animations:^{
            cacheImageView.frame = CGRectMake(self.photoImageView.frame.origin.x, self.photoImageView.frame.origin.y + _cameraView.frame.size.height, self.photoImageView.size.width, self.photoImageView.size.height);
        } completion:^(BOOL finished) {
            [cacheImageView removeFromSuperview];
        }];
    }];
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
//    if (self.session) {
//        [self.session startRunning];
//    }
    [self groups];
}

- (IBAction)takePic:(UIButton *)sender {
    [self gainPicture];
}

- (IBAction)cancel:(UIButton *)sender {
    __weak LMSTakePhotoController *weakSelf = self;
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didFinishPickingImage:)])
        {
            [weakSelf.delegate didFinishPickingImage:nil];
        }
    }];
}

- (IBAction)autoAction:(UIButton *)sender {
    
}

- (IBAction)switchAction:(UIButton *)sender {
    
    [self swapFrontAndBackCameras];
    sender.selected = !sender.selected;
}




- (IBAction)restartAction:(UIButton *)sender {
    if (self.session) {
        [self.session startRunning];
    }
}

- (IBAction)checkPhoto:(UIButton *)sender
{
    if (_groups.count != 0)
    {
        SGCollectionController *collectionVC = [[SGCollectionController alloc] init];
        collectionVC.maxCount = 4;
        collectionVC.group = _groups[0];
        self.navigationController.navigationBar.hidden = NO;
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = NSLocalizedString(@"返回", nil);
        self.navigationItem.backBarButtonItem = backItem;
        [self.navigationController pushViewController:collectionVC animated:YES];
    }
}

- (NSMutableArray *)groups{
    if (_groups == nil) {
        _groups = [NSMutableArray array];
    }
    [_groups removeAllObjects];
    __weak LMSTakePhotoController *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                if(group){
                    [_groups addObject:group];
                    UIImage *image =[UIImage imageWithCGImage:group.posterImage] ;
                    weakSelf.photoImageView.image = image;
                }
            } failureBlock:^(NSError *error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"访问相册失败" delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
            }];
        });
    
    return _groups;
}

- (ALAssetsLibrary *)assetsLibrary{
    if (_assetsLibrary == nil) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
