//
//  ViewController.m
//  ios-uikit-uidocument
//
//  Created by OkuderaYuki on 2017/11/07.
//  Copyright © 2017年 OkuderaYuki. All rights reserved.
//

#import "ViewController.h"
#import "CloudDocument.h"

@interface ViewController ()
@property (nonatomic) CloudDocument *cloudDocument;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testMethod];
}

/**
 1. iCloud上にsample.txtを生成し、@"1234567890\nsample message." を書き込む
 2. sample.txtを開いて、コンソールにテキストを出力する
 */
- (void)testMethod {
    
    NSURL *cloudFileURL = [self cloudFileURL:@"sample.txt"];
    
    // UIDocumentのサブクラスのインスタンスを生成
    self.cloudDocument = [[CloudDocument alloc] initWithFileURL:cloudFileURL];
    
//    // iCloudのファイルを削除する
//    [self removeDocument:self.cloudDocument.fileURL];
//    //  (iCloudのファイルが削除されたことをテスト)
//    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:cloudFileURL.path];
//    if (exists) {
//        NSLog(@"対象のテキストファイルが既に存在する");
//    } else {
//        NSLog(@"対象のテキストファイルが存在しない");
//    }
    
//    // ファイル移動する
//    // 移動後のファイルURLを生成
//    NSURL *destFileURL = [self cloudFileURL:@"sample2.txt"];
//    //  (iCloudのファイルが移動したことをテスト)
//    [self moveDocument:cloudFileURL destination:destFileURL];
//    BOOL moved = [[NSFileManager defaultManager] fileExistsAtPath:destFileURL.path];
//    if (moved) {
//        NSLog(@"移動済み");
//    } else {
//        NSLog(@"移動なし");
//    }
    
    // @"1234567890\nsample message." を書き込んで保存する
    [self saveDocument:self.cloudDocument text:@"1234567890\nsample message." overwriting:YES];
    // sample.txtを開いて、コンソールにテキストを出力する
    [self openDocument:self.cloudDocument];
}

#pragma mark - iCloud ファイルアクセス

/**
 iCloudのファイルURLを取得する

 @param textFileName ファイル名 ex) foo.txt
 @return ファイルURL
 */
- (NSURL *)cloudFileURL:(NSString *)textFileName {
    
    NSURL *containerUrl = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    NSURL *cloudDocumentsURL = [containerUrl URLByAppendingPathComponent:@"Documents" isDirectory:YES];
    NSURL *cloudFileURL = [cloudDocumentsURL URLByAppendingPathComponent:textFileName];
    return cloudFileURL;
}

/**
 ドキュメントを開く

 @param document (CloudDocument *)
 */
- (void)openDocument:(CloudDocument *)document {
    [document openWithCompletionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"ドキュメントオープン成功");
            [document closeWithCompletionHandler:nil];
        }
    }];
}

/**
 ドキュメントを保存する

 @param document (CloudDocument *)
 @param text 書き込むテキスト
 @param overwriting BOOL YES: 上書き保存, NO: 新規保存
 @warning overwritingがYESの場合、「上書き保存」をする。追記ではない。
 */
- (void)saveDocument:(CloudDocument *)document text:(NSString *)text overwriting:(BOOL)overwriting {
    
    // テキストをエンコードしたデータ
    document.data = [text dataUsingEncoding:NSUTF8StringEncoding];
    
    UIDocumentSaveOperation saveOperation = UIDocumentSaveForCreating;
    // overwritingがYESの場合、UIDocumentSaveForOverwritingを設定
    if (overwriting) {
        saveOperation = UIDocumentSaveForOverwriting;
    }
    
    [document saveToURL:document.fileURL forSaveOperation:saveOperation completionHandler:^(BOOL success) {
        NSLog(@"ドキュメント保存成功");
        [document closeWithCompletionHandler:nil];
    }];
}

/**
 ドキュメントを削除する

 @param cloudFileURL 削除するドキュメントのURL
 @return YES: 削除成功 もしくは 存在しない, NO: 削除失敗
 */
- (BOOL)removeDocument:(NSURL *)cloudFileURL {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:cloudFileURL.path]) {
        return [fileManager removeItemAtURL:cloudFileURL error:nil];
    }
    
    // 存在しない場合もYESを返却
    return YES;
}

/**
 ドキュメントを移動する

 @param srcFileURL 移動元のドキュメントのURL
 @param destFileURL 移動先のドキュメントのURL
 @return YES: 移動成功, NO: 移動失敗 もしくは 存在しない
 */
- (BOOL)moveDocument:(NSURL *)srcFileURL destination:(NSURL *)destFileURL {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:srcFileURL.path]) {
        return [fileManager moveItemAtURL:srcFileURL toURL:destFileURL error:nil];
    }
    
    // 存在しない場合はNOを返却
    return NO;
}

@end
