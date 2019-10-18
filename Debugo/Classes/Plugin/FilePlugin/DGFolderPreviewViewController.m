//
//  DGFolderPreviewViewController.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGFolderPreviewViewController.h"
#import "DGFileParser.h"
#import "DGPreviewManager.h"
#import "DGFileInfoViewController.h"
#import "DGCommon.h"

@interface DGFolderPreviewViewController ()<UITableViewDataSource, UITableViewDelegate, UIViewControllerPreviewingDelegate, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate>

@property (nonatomic, strong) DGFile *file;
@property (nonatomic, strong) DGFilePreviewConfiguration *configuration;

// Data
@property (nonatomic, strong) NSArray <DGFile *>*files;
@property (nonatomic, strong) NSMutableArray <NSMutableArray <DGFile *>*>*sections;

// Search controller
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSArray <DGFile *>*filteredFiles;

// Count Label
@property (nonatomic, weak) UILabel *countLabel;

@end

@implementation DGFolderPreviewViewController

#pragma mark - Lifecycle

- (instancetype)initWithFile:(DGFile *)file configuration:(DGFilePreviewConfiguration *)configuration {
    if (file.type != DGFileTypeDirectory) return nil;
    if (self = [super init]) {
        self.file = file;
        self.configuration = configuration;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.definesPresentationContext = YES;

    // navigationItem
    dg_weakify(self)
    UIBarButtonItem *item1  = [[DGShareBarButtonItem alloc] initWithViewController:self shareFilePathsWhenClickedBlock:^NSArray<NSString *> * _Nonnull(DGShareBarButtonItem * _Nonnull item) {
        dg_strongify(self)
        return @[self.file.fileURL.path];
    }];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [btn addTarget:self action:@selector(clickShowDirectoryInfoBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:btn];
    if ([self.file.filePath isEqualToString:DGPathFetcher.sandboxDirectory]) {
        // 沙盒根目录有系统文件，不允许分享
        self.navigationItem.rightBarButtonItem = item2;
    }else {
        self.navigationItem.rightBarButtonItems = @[item1, item2];
    }
    
    // Set search controller
    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = self.searchController;
        self.navigationItem.hidesSearchBarWhenScrolling = NO;
        // [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    }else {
        self.tableView.tableHeaderView = self.searchController.searchBar;
    }
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.delegate = self;

    // items count
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    countLabel.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableFooterView = countLabel;
    self.countLabel = countLabel;
    
    // Set tableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Register for 3D touch
    [self registerFor3DTouch];
    
    [self prepareData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Make sure navigation bar is visible
    if (self.navigationController.isNavigationBarHidden) {
        self.navigationController.navigationBarHidden = NO;
    }
}

#pragma mark - Data

- (void)prepareData {
    if (!self.file.fileURL) return;
    
    dg_weakify(self)
    self.files = [DGFileParser filesForDirectory:self.file.fileURL configuration:self.configuration errorHandler:^(NSError *error) {
        dg_strongify(self)
        if (!error) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:OKAction];
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }];
    [self indexFiles];
    self.countLabel.text = [NSString stringWithFormat:@"%zd 项", self.files.count];
}

- (void)indexFiles {
    [self.sections removeAllObjects];
    
    NSArray *sortedObjects = [self.files sortedArrayUsingComparator:^NSComparisonResult(DGFile *  _Nonnull obj1, DGFile *  _Nonnull obj2) {
        return [obj1.displayName compare:obj2.displayName];
    }];
    
    [self.sections addObject:sortedObjects.mutableCopy];
}

- (DGFile *)fileForIndexPath:(NSIndexPath *)indexPath {
    DGFile *file = nil;
    if (self.searchController.isActive) {
        file = [self.filteredFiles objectAtIndex:indexPath.row];
    }else{
        file = [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    return file;
}

- (void)filterContentForSearchText:(NSString *)searchText {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(DGFile *  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject.displayName.lowercaseString containsString:searchText.lowercaseString];
    }];
    self.filteredFiles = [self.files filteredArrayUsingPredicate:predicate];
    [self.tableView reloadData];
    self.countLabel.text = [NSString stringWithFormat:@"%zd 项", self.filteredFiles.count];
}

#pragma mark - event

- (void)clickShowDirectoryInfoBtn:(UIButton *)sender {
    DGFileInfoViewController *fileInfoVC = [[DGFileInfoViewController alloc] initWithFile:self.file];
    [self.navigationController pushViewController:fileInfoVC animated:YES];
}

#pragma mark - setter

- (void)setFile:(DGFile *)file {
    _file = file;
    self.title = file.displayName;
}

#pragma mark - getter

- (NSMutableArray<NSMutableArray<DGFile *> *> *)sections {
    if (!_sections) {
        _sections = [NSMutableArray array];
    }
    return _sections;
}

- (UISearchController *)searchController {
    if (!_searchController) {
        UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
        searchController.searchBar.placeholder = @"搜索";
        searchController.dimsBackgroundDuringPresentation = NO;
        _searchController = searchController;
    }
    return _searchController;
}

#pragma mark - UITableViewDataSource UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.searchController.isActive) {
        return 1;
    }
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.isActive) {
        return self.filteredFiles.count;
    }
    return [self.sections objectAtIndex:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    DGFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[DGFileTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    [cell refreshWithFile:[self fileForIndexPath:indexPath]];
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    DGFile *selectedFile = [self fileForIndexPath:indexPath];
    DGFileInfoViewController *fileInfoVC = [[DGFileInfoViewController alloc] initWithFile:selectedFile];
    [self.navigationController pushViewController:fileInfoVC animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    DGFile *selectedFile = [self fileForIndexPath:indexPath];
    DGLog(@"\n%@", selectedFile.fileURL.path);
    UIViewController *nextViewController = nil;
    if (selectedFile.isDirectory) {
        DGFolderPreviewViewController *fileListViewController = [[DGFolderPreviewViewController alloc] initWithFile:selectedFile configuration:self.configuration];
        nextViewController = fileListViewController;
    }else{
        if (self.configuration.didSelectFileBlock) {
            self.configuration.didSelectFileBlock(selectedFile);
        }else{
            UIViewController *filePreview = [DGPreviewManager previewViewControllerForFile:selectedFile configuration:self.configuration];
            nextViewController = filePreview;
        }
    }
    
    if (nextViewController) {
        if (self.searchController.isActive) {
            self.searchController.active = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:nextViewController animated:YES];
            });
        }else {
            [self.navigationController pushViewController:nextViewController animated:YES];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.searchController.isActive) {
        return nil;
    }
    
    if ([self.sections objectAtIndex:section].count > 0) {
        return nil;
    }else{
        return nil;
    }
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (self.searchController.isActive) {
        return nil;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (self.searchController.isActive) {
        return 0;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        DGFile *selectedFile = [self fileForIndexPath:indexPath];
        dg_weakify(self)
        [selectedFile deleteWithErrorHandler:^(NSError *error) {
            dg_strongify(self)
            if (!error) return;
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:OKAction];
                [self presentViewController:alertController animated:YES completion:nil];
            });
        }];
        
        [self prepareData];
        NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:indexPath.section];
        [tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return !self.configuration.forbidEditing;
}

#pragma mark - UIViewControllerPreviewingDelegate

- (void)registerFor3DTouch {
    if (@available(iOS 9.0, *)) {
        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
            [self registerForPreviewingWithDelegate:self sourceView:self.tableView];
        }
    }
}

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    if (@available(iOS 9.0, *)) {
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
        if (indexPath) {
            DGFile *selectedFile = [self fileForIndexPath:indexPath];
            if (selectedFile.isDirectory == NO) {
                previewingContext.sourceRect = [self.tableView rectForRowAtIndexPath:indexPath];
                return [DGPreviewManager previewViewControllerForFile:selectedFile configuration:self.configuration];
            }
        }
    }
    return nil;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self.navigationController pushViewController:viewControllerToCommit animated:YES];
}

#pragma mark - UISearchControllerDelegate
- (void)willPresentSearchController:(UISearchController *)searchController {
}

- (void)willDismissSearchController:(UISearchController *)searchController {
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterContentForSearchText:searchBar.text];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self filterContentForSearchText:searchController.searchBar.text];
}

@end
