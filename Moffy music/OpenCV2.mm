//
//  OpenCV2.m
//  Moffy music
//
//  Created by Koki Kurokawa on 2021/07/10.
//
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import "OpenCV2.h"

@implementation OpenCV2

//RGB→Gray
+ (UIImage*)rgb2gray:(UIImage*)image {
   cv::Mat img_Mat;
   UIImageToMat(image, img_Mat);
   cv::cvtColor(img_Mat, img_Mat, cv::COLOR_BGR2GRAY);
   return MatToUIImage(img_Mat);
}

@end
