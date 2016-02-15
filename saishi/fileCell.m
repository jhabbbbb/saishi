//
//  fileCell.m
//  saishi
//
//  Created by JinHongxu on 16/2/15.
//  Copyright © 2016年 JinHongxu. All rights reserved.
//

#import "fileCell.h"

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
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:self.fileURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        self.filePath = (NSString *)filePath;
        NSLog(@"File downloaded to: %@", filePath);
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
        self.fileURL = [dict objectForKey:@"url"];
        
    }
    failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
