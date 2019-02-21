//
//  DGDatabasePreviewViewController.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/9.
//  Copyright © 2019 ripper. All rights reserved.
//

#import "DGDatabasePreviewViewController.h"
#import "DGDatabaseOperation.h"
#import "DGDatabaseTableContentViewController.h"
#import "DGDatabaseTableInfoViewController.h"

@interface DGDatabasePreviewViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DGDatabaseOperation *dbOperation;
@property (nonatomic, strong) NSArray <DGDatabaseTableInfo *>*tableArray;
@property (nonatomic, strong) DGDatabaseUIConfig *uiConfig;

@end

@implementation DGDatabasePreviewViewController

- (instancetype)initWithFile:(DGFBFile *)file databaseUIConfig:(nullable DGDatabaseUIConfig *)uiConfig
{
    NSAssert(file.type == DGFBFileTypeDB, @"该预览控制器仅支持数据库类型的文件");
    
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self->_file = file;
        self.dbOperation = [[DGDatabaseOperation alloc] initWithURL:file.fileURL];
        self.uiConfig = uiConfig?:[DGDatabaseUIConfig new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.file.displayName;
    
    // Add share button
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareFile:)];
    self.navigationItem.rightBarButtonItem = shareButton;

    self.tableArray = [self.dbOperation queryAllTableInfo];
}

#pragma mark - share
- (void)shareFile:(UIBarButtonItem *)sender
{
    if (!self.file) {
        return;
    }
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.file.fileURL] applicationActivities:nil];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
        && [activityViewController respondsToSelector:@selector(popoverPresentationController)]) {
        activityViewController.popoverPresentationController.barButtonItem = sender;
    }
    [self presentViewController:activityViewController animated:YES completion:nil];
}

#pragma mark -- UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    cell.textLabel.text = self.tableArray[indexPath.row].name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DGDatabaseTableContentViewController *contentController = [[DGDatabaseTableContentViewController alloc] initWithDatabaseOperation:self.dbOperation table:self.tableArray[indexPath.row] tableUIConfig:[self.uiConfig tableUIConfigForTableName:_tableArray[indexPath.row].name]];
    [self.navigationController pushViewController:contentController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    DGDatabaseTableInfo *tableInfo = [self.tableArray objectAtIndex:indexPath.row];
    DGDatabaseTableInfoViewController *tableInfoVC = [[DGDatabaseTableInfoViewController alloc] initWithTable:tableInfo];
    [self.navigationController pushViewController:tableInfoVC animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"table";
}


@end
