//
//  DGFileInfoViewController.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/10.
//  Copyright © 2019 ripper. All rights reserved.
//

#import "DGFileInfoViewController.h"

static NSString *kCellID = @"cell";
static NSString *kCellTitle = @"title";
static NSString *kCellValue = @"value";

@interface DGFileInfoViewController ()

@property (nonatomic, strong) NSArray <NSArray *>*dataArray;

@end

@implementation DGFileInfoViewController

- (instancetype)initWithFile:(DGFBFile *)file {
    NSAssert(!file.isDirectory, @"不支持文件夹类型");
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self->_file = file;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.file.displayName;
    // For set lineBreakMode
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = self.title;
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    self.navigationItem.titleView = titleLabel;

    self.dataArray = @[
                       @[
                           @{kCellTitle:@"Name", kCellValue:self.file.displayName},
                           @{kCellTitle:@"Path", kCellValue:self.file.fileURL.path},
                           @{kCellTitle:@"Readable", kCellValue:[NSFileManager.defaultManager isReadableFileAtPath:self.file.fileURL.path]?@"YES":@"NO"},
                           @{kCellTitle:@"Writable", kCellValue:[NSFileManager.defaultManager isWritableFileAtPath:self.file.fileURL.path]?@"YES":@"NO"},
                           @{kCellTitle:@"Executable", kCellValue:[NSFileManager.defaultManager isExecutableFileAtPath:self.file.fileURL.path]?@"YES":@"NO"},
                           @{kCellTitle:@"Deletable", kCellValue:[NSFileManager.defaultManager isDeletableFileAtPath:self.file.fileURL.path]?@"YES":@"NO"},
                           ],
                       @[
                           @{kCellTitle:@"fileSize", kCellValue:[self sizeStringWithSize:self.file.fileAttributes.fileSize]},
                           @{kCellTitle:@"fileModificationDate", kCellValue:[self dateStringWithDate:self.file.fileAttributes.fileModificationDate]},
                           @{kCellTitle:@"fileCreationDate", kCellValue:[self dateStringWithDate:self.file.fileAttributes.fileCreationDate]},
                           @{kCellTitle:@"fileType", kCellValue:self.file.fileAttributes.fileType?:@"null"},
                           @{kCellTitle:@"filePosixPermissions", kCellValue:@(self.file.fileAttributes.filePosixPermissions)},
                           @{kCellTitle:@"fileOwnerAccountName", kCellValue:self.file.fileAttributes.fileOwnerAccountName?:@"null"},
                           @{kCellTitle:@"fileGroupOwnerAccountName", kCellValue:self.file.fileAttributes.fileGroupOwnerAccountName?:@"null"},
                           @{kCellTitle:@"fileSystemNumber", kCellValue:@(self.file.fileAttributes.fileSystemNumber)},
                           @{kCellTitle:@"fileSystemFileNumber", kCellValue:@(self.file.fileAttributes.fileSystemFileNumber)},
                           @{kCellTitle:@"fileExtensionHidden", kCellValue:self.file.fileAttributes.fileExtensionHidden?@"YES":@"NO"},
                           @{kCellTitle:@"fileHFSCreatorCode", kCellValue:@(self.file.fileAttributes.fileHFSCreatorCode)},
                           @{kCellTitle:@"fileHFSTypeCode", kCellValue:@(self.file.fileAttributes.fileHFSTypeCode)},
                           @{kCellTitle:@"fileIsImmutable", kCellValue:self.file.fileAttributes.fileIsImmutable?@"YES":@"NO"},
                           @{kCellTitle:@"fileIsAppendOnly", kCellValue:self.file.fileAttributes.fileIsAppendOnly?@"YES":@"NO"},
                           @{kCellTitle:@"fileOwnerAccountID", kCellValue:self.file.fileAttributes.fileOwnerAccountID?:@"null"},
                           @{kCellTitle:@"fileGroupOwnerAccountID", kCellValue:self.file.fileAttributes.fileGroupOwnerAccountID?:@"null"},
                           ],
                       ];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.file.fileURL.path]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 80)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"❌ File or directory do not exist!";
        self.tableView.tableHeaderView = label;
    }else {
        self.tableView.tableHeaderView = nil;
    }
}

- (NSString *)sizeStringWithSize:(long long)size {
    NSString *sizeStr;
    long long bytes = size;
    double kbs = bytes/1024.0;
    double mbs = kbs/1024.0;
    double gbs = mbs/1024.0;
    if (gbs > 1) {
        sizeStr = [NSString stringWithFormat:@"%lld Bytes (%f GB)", bytes, gbs];
    }else if (mbs > 1) {
        sizeStr = [NSString stringWithFormat:@"%lld Bytes (%f MB)", bytes, mbs];
    }else if (kbs > 1) {
        sizeStr = [NSString stringWithFormat:@"%lld Bytes (%f KB)", bytes, mbs];
    }else{
        sizeStr = [NSString stringWithFormat:@"%lld Bytes", bytes];
    }
    return sizeStr;
}

- (NSString *)dateStringWithDate:(NSDate *)date {
    if (!date) return @"null";
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy年MM月dd日 HH:mm:ss";
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.numberOfLines = 0;
    }
    NSDictionary *data = self.dataArray[indexPath.section][indexPath.row];
    cell.textLabel.text = data[kCellTitle];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", data[kCellValue]];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"general";
    }else{
        return @"attributes";
    }
}

@end
