//
//  fileCell.m
//  saishi
//
//  Created by JinHongxu on 16/2/15.
//  Copyright © 2016年 JinHongxu. All rights reserved.
//

#import "fileCell.h"

@interface fileCell()

@end

@implementation fileCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//下载文件
- (IBAction)downloadFile:(id)sender {
    [self download];
}

//下载文件
- (void)download
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:self.fileURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        //NSLog(@"%@", documentsDirectoryURL);
        
        //保存文件名
        self.fileName = [response suggestedFilename];
        
        //返回文件路径
        return [documentsDirectoryURL URLByAppendingPathComponent:self.fileName];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        //下载完成后改变下载按钮状态
        [self.downloadButton setBackgroundImage:[UIImage imageNamed:@"10"]  forState:UIControlStateNormal];
        [self.downloadButton setEnabled:NO];
        
        //记录文件的路径，用于打开文件
        self.filePath = [filePath absoluteString];
        
        //记录这个文件名对应的文件已下载
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:self.fileName forKey:[self.fileID stringByAppendingString:@"fileName"]];
        [userDefaults synchronize];
        
        //表示这个cell的文件已下载
        self.fileIsDownloaded = YES;
        
    }];
    [downloadTask resume];

}

//为fileid获取fileURL
- (void)getFileURL
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{@"fileid": self.fileID};
    
    [manager POST:@"http://121.42.157.180/qgfdyjnds/index.php/Api/get_file_url" parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        //NSLog(@"%@", dict);
        
        //获得fileURL
        self.fileURL = [[NSString alloc] initWithFormat:@"http://121.42.157.180/qgfdyjnds/%@", [dict objectForKey:@"url"]];
        
    }
    failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


@end
