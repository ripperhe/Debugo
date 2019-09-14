//
//  DGFileTableViewCell.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/9/14.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGFileTableViewCell.h"

@implementation DGFileTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.detailTextLabel.textColor = [UIColor grayColor];
    }
    return self;
}

- (void)refreshWithFile:(DGFile *)file {
    self.textLabel.text = file.displayName;
    self.detailTextLabel.text = file.simpleInfo;
    self.imageView.image = file.image;
    self.accessoryType = file.isDirectory?UITableViewCellAccessoryDisclosureIndicator:UITableViewCellAccessoryDetailButton;
    self.accessoryView.userInteractionEnabled = !file.isDirectory;
}

@end
