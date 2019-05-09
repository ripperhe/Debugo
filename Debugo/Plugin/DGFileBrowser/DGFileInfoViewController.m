//
//  DGFileInfoViewController.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/10.
//  Copyright © 2019 ripper. All rights reserved.
//

#import "DGFileInfoViewController.h"
#import "DGBase.h"

static NSString *kCellID = @"cell";
static NSString *kCellTitle = @"title";
static NSString *kCellValue = @"value";

@interface DGFileInfoViewController ()

@property (nonatomic, strong) NSArray <NSArray *>*dataArray;

@end

@implementation DGFileInfoViewController

- (instancetype)initWithFile:(DGFBFile *)file {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self->_file = file;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.file.displayName;

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
                           @{kCellTitle:@"fileSize", kCellValue:[NSString stringWithFormat:@"%lld bytes (%@)", self.file.fileAttributes.fileSize, [@(self.file.fileAttributes.fileSize) dg_sizeString]]},
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
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    }
}

- (NSString *)dateStringWithDate:(NSDate *)date {
    if (!date) return @"null";
    return [date dg_dateStringWithFormat:@"yyyy年MM月dd日 HH:mm:ss"];
}

#pragma mark - event

- (void)clickedCopyBtn:(UIButton *)sender {
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
        [feedBackGenertor impactOccurred];
    }
    NSIndexPath *indexPath = sender.dg_strongExtObj;
    
    // iOS 模拟器和真机剪切板不互通的问题 https://stackoverflow.com/questions/15188852/copy-and-paste-text-into-ios-simulator
    // Xcode 10 解决了这个问题：模拟器导航栏->Edit->Automatically Sync Pasteboard
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.dataArray[indexPath.section][indexPath.row][kCellValue];
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
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setImage:[DGBundle imageNamed:@"copy"] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(0, 0, 44, 44)];
        [btn addTarget:self action:@selector(clickedCopyBtn:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = btn;
    }
    NSDictionary *data = self.dataArray[indexPath.section][indexPath.row];
    cell.textLabel.text = data[kCellTitle];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", data[kCellValue]];
    cell.accessoryView.hidden = ![data[kCellTitle] isEqualToString:@"Path"];
    cell.accessoryView.dg_strongExtObj = indexPath;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"general";
    }else{
        return @"attributes";
    }
}

@end
