//
//  CloudDocument.m
//  ios-uikit-uidocument
//
//  Created by OkuderaYuki on 2017/11/07.
//  Copyright © 2017年 OkuderaYuki. All rights reserved.
//

#import "CloudDocument.h"

@implementation CloudDocument

// 読み込み時に呼ばれる
- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError **)outError {
    NSLog(@"content type:%@", typeName);
    self.data = contents;
    
    NSString *text = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    NSLog(@"読み込んだテキスト: %@", text);
    return YES;
}

// 書き込み時に呼ばれる
- (id)contentsForType:(NSString *)typeName error:(NSError **)outError {
    NSLog(@"contentsForType:%@ ", typeName);
    
    NSString *text = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    NSLog(@"書き込むテキスト: %@", text);
    return self.data;
}
@end
