//
//  ViewController.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/2/20.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "Debugo.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self clickGoToTestLogin];
    }
}

- (void)clickGoToTestLogin {
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LoginViewController *loginVC = [board instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:loginVC animated:YES];
}

@end
