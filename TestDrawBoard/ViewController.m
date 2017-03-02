//
//  ViewController.m
//  TestDrawBoard
//
//  Created by yuelixing on 2017/2/20.
//  Copyright © 2017年 YueLiXing. All rights reserved.
//

#import "ViewController.h"

#import "LxDrawView.h"
#import "UIView+AddSubView.h"
#import <ReplayKit/ReplayKit.h>

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, RPScreenRecorderDelegate, RPPreviewViewControllerDelegate>

@property (nonatomic, retain) UIWebView * webView;
@property (nonatomic, retain) LxDrawView * drawView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
    
    UIButton * imageButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [imageButton setTitle:@"Image" forState:UIControlStateNormal];
    [imageButton addTarget:self action:@selector(selectImage) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * button0 = [UIButton buttonWithType:UIButtonTypeSystem];
    button0.tag = 0;
    [button0 setTitle:@"划线" forState:UIControlStateNormal];
    [button0 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    button1.tag = 1;
    [button1 setTitle:@"矩形" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    button2.tag = 2;
    [button2 setTitle:@"椭圆" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * button3 = [UIButton buttonWithType:UIButtonTypeSystem];
    button3.tag = 3;
    [button3 setTitle:@"橡皮" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * button4 = [UIButton buttonWithType:UIButtonTypeSystem];
    button4.tag = 4;
    [button4 setTitle:@"清除" forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * button5 = [UIButton buttonWithType:UIButtonTypeSystem];
    button5.tag = 5;
    [button5 setTitle:@"粗细" forState:UIControlStateNormal];
    [button5 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * button8 = [UIButton buttonWithType:UIButtonTypeSystem];
    button8.tag = 8;
    [button8 setTitle:@"颜色" forState:UIControlStateNormal];
    [button8 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * button81 = [UIButton buttonWithType:UIButtonTypeSystem];
    button81.tag = 81;
    [button81 setTitle:@"不透明" forState:UIControlStateNormal];
    [button81 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * button6 = [UIButton buttonWithType:UIButtonTypeSystem];
    button6.tag = 6;
    [button6 setTitle:@"撤销" forState:UIControlStateNormal];
    [button6 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * button7 = [UIButton buttonWithType:UIButtonTypeSystem];
    button7.tag = 7;
    [button7 setTitle:@"恢复" forState:UIControlStateNormal];
    [button7 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(40, 20, AppWidth-40, 40)];
    [scrollView addSubviewFromArray:@[imageButton, button0, button1, button2, button3, button4, button5, button8, button81, button6, button7]];
    [self.view addSubview:scrollView];
    
    [self.view addSubview:self.drawView];
    
    CGFloat left = 2;
    for (UIButton * tempButton in scrollView.subviews) {
        tempButton.frame = CGRectMake(left, 0, 50, 40);
        [tempButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        tempButton.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        left += 50+2;
    }
    scrollView.contentSize = CGSizeMake(left, 40);
    
    UIButton * recorderButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [recorderButton setTitle:@"录制" forState:UIControlStateNormal];
    [recorderButton setTitle:@"结束" forState:UIControlStateSelected];
    [recorderButton addTarget:self action:@selector(recorderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    recorderButton.frame = CGRectMake(0, 20, 40, 40);
    [self.view addSubview:recorderButton];
    
    [RPScreenRecorder sharedRecorder].delegate = self;
}

- (void)recorderButtonClick:(UIButton *)button {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        NSLog(@"系统版本过低，不支持");
    }
    button.selected = !button.selected;
    if (button.selected) { // 开始录制
        [[RPScreenRecorder sharedRecorder] startRecordingWithMicrophoneEnabled:YES handler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"录制出现错误");
            } else {
                NSLog(@"开始录制");
            }
        }];
    } else {
        [[RPScreenRecorder sharedRecorder] stopRecordingWithHandler:^(RPPreviewViewController * _Nullable previewViewController, NSError * _Nullable error) {
            previewViewController.previewControllerDelegate = self;
            [self presentViewController:previewViewController animated:YES completion:nil];
            NSLog(@"%@", error);
        }];
    }
}

// MARK: - RPScreenRecorderDelegate,
- (void)screenRecorder:(RPScreenRecorder *)screenRecorder didStopRecordingWithError:(NSError *)error previewViewController:(nullable RPPreviewViewController *)previewViewController {
    NSLogCMD
}

- (void)screenRecorderDidChangeAvailability:(RPScreenRecorder *)screenRecorder {
    NSLogCMD
}

// MARK: - RPPreviewViewControllerDelegate
- (void)previewControllerDidFinish:(RPPreviewViewController *)previewController {
    [previewController dismissViewControllerAnimated:YES completion:nil];
}

/* @abstract Called when the view controller is finished and returns a set of activity types that the user has completed on the recording. The built in activity types are listed in UIActivity.h. */
- (void)previewController:(RPPreviewViewController *)previewController didFinishWithActivityTypes:(NSSet <NSString *> *)activityTypes {
    [previewController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"%@", activityTypes);
}


- (void)buttonClick:(UIButton *)button {
    NSLog(@"%ld", button.tag);
    if (button.tag == 0) {
        [self changeTo:self.drawView.brushLine];
    } else if (button.tag == 1) {
        [self changeTo:self.drawView.brushRect];
    } else if (button.tag == 2) {
        [self changeTo:self.drawView.brushEllipse];
    } else if (button.tag == 3) {
        [self changeTo:self.drawView.brushEraser];
    } else if (button.tag == 4) {
        [self.drawView cleanAll];
    } else if (button.tag == 5) {
        CGFloat width = arc4random()%1000/100;
        if (width < 1) {
            width += 1;
        }
        [button setTitle:[NSString stringWithFormat:@"粗细%.0lf", width] forState:UIControlStateNormal];
        if (self.drawView.currentBrush.shapeType != LxShapeEraser) {
            self.drawView.lindWidth = width;
        }
    } else if (button.tag == 6) {
        if ([self.drawView canUndo]) {
            [self.drawView undo];
            NSLog(@"撤销");
        } else {
            NSLog(@"无法撤销");
        }
    } else if (button.tag == 7) {
        if ([self.drawView canRedo]) {
            [self.drawView redo];
            NSLog(@"恢复");
        } else {
            NSLog(@"无法恢复");
        }
    } else if (button.tag == 8) {
        if (self.drawView.currentBrush.shapeType != LxShapeEraser) {
            CGFloat red = arc4random_uniform(255) / 255.0;
            CGFloat green = arc4random_uniform(255) / 255.0;
            CGFloat blue = arc4random_uniform(255) / 255.0;
            UIColor * color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
            button.backgroundColor = color;
            self.drawView.currentBrush.color = color;
        }
    } else if (button.tag == 81) {
        if (self.drawView.currentBrush.shapeType != LxShapeEraser) {
            CGFloat red, green, blue, alpha;
            [self.drawView.currentBrush.color getRed:&red green:&green blue:&blue alpha:&alpha];
            UIColor * color;
            if (alpha > 0.5) {
                color = [self.drawView.currentBrush.color colorWithAlphaComponent:1.0];
            } else {
                color = [self.drawView.currentBrush.color colorWithAlphaComponent:0.2];
            }
            NSLog(@"%@ %lf", color, alpha);
            self.drawView.currentBrush.color = color;
        }
    }
}

- (void)changeTo:(LxBrush *)brush {
    if (self.drawView.currentBrush == brush) {
        self.drawView.currentBrush = self.drawView.brushDefault;
    } else {
        self.drawView.currentBrush = brush;
    }
}


- (void)selectImage {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    CGSize size = image.size;
    
    CGRect targetRect;
//    if (size.width < self.drawView.width && size.height < self.drawView.height) {
        targetRect.size = size;
        targetRect.origin.x = (self.drawView.width-size.width)/2.0;
        targetRect.origin.y = (self.drawView.height-size.height)/2.0;
//    } else {
//        CGFloat scal = 0;
//        scal = MIN(size.width/self.drawView.width, size.width/self.drawView.width);
//    }
    [self.drawView drawimage:image InRect:targetRect];
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"%@", info);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - get

- (LxDrawView *)drawView {
    if (!_drawView) {
        _drawView = [[LxDrawView alloc] initWithFrame:CGRectMake(0, 60, AppWidth, AppHeight-60)];
    }
    return _drawView;
}


- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, AppWidth, AppHeight-20)];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    }
    return _webView;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

@end
