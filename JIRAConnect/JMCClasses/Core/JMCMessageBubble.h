/**
   Copyright 2011 Atlassian Software

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
**/
//
//  Created by nick on 7/05/11.
//
//  To change this template use File | Settings | File Templates.
//


#import <Foundation/Foundation.h>


@interface JMCMessageBubble : UITableViewCell {
    
    @private
    UIImageView *bubble;
    UILabel *label;
    UILabel *detailLabel;
    float detailLabelHeight;
}

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UILabel *detailLabel;

- (id)initWithReuseIdentifier:(NSString *)cellIdentifierComment detailSize:(CGSize)detailSize;

- (void)setText:(NSString *)string leftAligned:(BOOL)leftAligned withFont:(UIFont *)font size:(CGSize)constSize;

@end