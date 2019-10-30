//
//  DGFileInfoViewController.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/10.
//  Copyright © 2019 ripper. All rights reserved.
//

#import "DGFileInfoViewController.h"
#import "DGCommon.h"

#define kBoolString(bool) bool?@"YES":@"NO"
#define kNullString(obj)  obj?:@"null"

@interface DGFileInfoViewController ()

@property (nonatomic, strong) DGFile *file;
@property (nonatomic, strong) NSArray <DGOrderedDictionary<NSString *, NSString *> *>*dataArray;
@property (nonatomic, assign) long long size;

@end

@implementation DGFileInfoViewController

- (instancetype)initWithFile:(DGFile *)file {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.file = file;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DGLog(@"\n%@", self.file.fileURL.path);
    self.title = self.file.displayName;
    
    if (!self.file.isExist) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 80)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"❌ 文件或文件夹不存在！";
        self.tableView.tableFooterView = label;
        return;
    }
    
    if (self.file.isDirectory) {
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicatorView.color = [UIColor lightGrayColor];
        indicatorView.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
        [indicatorView startAnimating];
        [self.view addSubview:indicatorView];
        dg_weakify(self)
        dg_weakify(indicatorView)
        [self.file calculateSize:^(long long size) {
            dg_strongify(self)
            dg_strongify(indicatorView)
            [indicatorView removeFromSuperview];
            self.size = size;
            [self refresh];
        }];
    }else {
        self.size = [[self.file fileAttributes] fileSize];
        [self refresh];
    }
}

- (void)refresh {
    NSDictionary *fileAttributes = [self.file fileAttributes];
    DGOrderedDictionary *general = [[DGOrderedDictionary alloc] initWithKeysAndObjects:
                                    @"Name", self.file.fileName,
                                    @"Path", self.file.filePath,
                                    @"Readable", kBoolString([NSFileManager.defaultManager isReadableFileAtPath:self.file.fileURL.path]),
                                    @"Writable", kBoolString([NSFileManager.defaultManager isWritableFileAtPath:self.file.fileURL.path]),
                                    @"Executable", kBoolString([NSFileManager.defaultManager isExecutableFileAtPath:self.file.fileURL.path]),
                                    @"Deletable", kBoolString([NSFileManager.defaultManager isDeletableFileAtPath:self.file.fileURL.path]),
                                    nil];
    DGOrderedDictionary *attribute = [[DGOrderedDictionary alloc] initWithKeysAndObjects:
                                      @"fileSize", [NSString stringWithFormat:@"%lld bytes (%@)", self.size, [@(self.size) dg_sizeString]],
                                      @"fileModificationDate", [self dateStringWithDate:fileAttributes.fileModificationDate],
                                      @"fileCreationDate", [self dateStringWithDate:fileAttributes.fileCreationDate],
                                      @"fileType", kNullString(fileAttributes.fileType),
                                      @"filePosixPermissions", @(fileAttributes.filePosixPermissions),
                                      @"fileOwnerAccountName", kNullString(fileAttributes.fileOwnerAccountName),
                                      @"fileGroupOwnerAccountName", kNullString(fileAttributes.fileGroupOwnerAccountName),
                                      @"fileSystemNumber", @(fileAttributes.fileSystemNumber),
                                      @"fileSystemFileNumber", @(fileAttributes.fileSystemFileNumber),
                                      @"fileExtensionHidden", kBoolString(fileAttributes.fileExtensionHidden),
                                      @"fileHFSCreatorCode", @(fileAttributes.fileHFSCreatorCode),
                                      @"fileHFSTypeCode", @(fileAttributes.fileHFSTypeCode),
                                      @"fileIsImmutable", kBoolString(fileAttributes.fileIsImmutable),
                                      @"fileIsAppendOnly", kBoolString(fileAttributes.fileIsAppendOnly),
                                      @"fileOwnerAccountID", kNullString(fileAttributes.fileOwnerAccountID),
                                      @"fileGroupOwnerAccountID", kNullString(fileAttributes.fileGroupOwnerAccountID),
                                      nil];
    self.dataArray = @[general, attribute];
    [self.tableView reloadData];
}


- (NSString *)dateStringWithDate:(NSDate *)date {
    if (!date) return @"null";
    return [date dg_dateStringWithFormat:@"yyyy年MM月dd日 HH:mm:ss"];
}

#pragma mark - event

- (void)clickedCopyBtn:(UIButton *)sender {
    kDGImpactFeedback
    NSIndexPath *indexPath = sender.dg_extStrongObj;
    
    // iOS 模拟器和真机剪切板不互通的问题 https://stackoverflow.com/questions/15188852/copy-and-paste-text-into-ios-simulator
    // Xcode 10 解决了这个问题：模拟器导航栏->Edit->Automatically Sync Pasteboard
    [UIPasteboard generalPasteboard].string = [self.dataArray[indexPath.section] objectAtIndex:indexPath.row];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.numberOfLines = 0;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setImage:[DGBundle imageNamed:@"icon_copy"] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(0, 0, 44, 44)];
        [btn addTarget:self action:@selector(clickedCopyBtn:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = btn;
    }
    DGOrderedDictionary *sectionDic = self.dataArray[indexPath.section];
    cell.textLabel.text = [sectionDic keyAtIndex:indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [sectionDic objectAtIndex:indexPath.row]];
    cell.accessoryView.hidden = ![[sectionDic keyAtIndex:indexPath.row] isEqualToString:@"Path"];
    cell.accessoryView.dg_extStrongObj = indexPath;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }else{
        return @"属性";
    }
}

@end
