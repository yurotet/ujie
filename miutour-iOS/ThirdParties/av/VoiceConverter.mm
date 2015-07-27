//
//  FileListTableView.m
//  WAVtoAMRtoWAV
//
//  Created by Jeans Huang on 12-7-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VoiceConverter.h"
#import "wav.h"
#import "interf_dec.h"
#import "dec_if.h"
#import "interf_enc.h"
#import "amrFileCodec.h"

@implementation VoiceConverter

+ (NSData *)amrToNSData:(NSString *)fileNameString
{
    return DecodeAMRToNSData([fileNameString cStringUsingEncoding:NSASCIIStringEncoding]);
}

+ (int)wavToAmr:(NSString *)fileNameString{
    

    //NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //NSString *path = [NSString stringWithFormat:@"%@/%@",documentDir,fileNameString];
    NSString *path = fileNameString;
    
    // WAVE音频采样频率是8khz 
    // 音频样本单元数 = 8000*0.02 = 160 (由采样频率决定)
    // 声道数 1 : 160
    //        2 : 160*2 = 320
    // bps决定样本(sample)大小
    // bps = 8 --> 8位 unsigned char
    //       16 --> 16位 unsigned short
   

        NSString *savePath = [path stringByReplacingOccurrencesOfString:@"wav" withString:@"amr"];
        
        if (EncodeWAVEFileToAMRFile([path cStringUsingEncoding:NSASCIIStringEncoding], [savePath cStringUsingEncoding:NSASCIIStringEncoding], 1, 8))
            return 0;


    return 1;
}



@end
