//
//  testViewController.m
//  CAIXmpp
//
//  Created by liyufeng on 16/4/19.
//  Copyright © 2016年 liyufeng. All rights reserved.
//

#import "testViewController.h"
#import "CAIXMPPManager.h"
#import "rosterViewController.h"

@interface testViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSMutableArray * datas;

@end

@implementation testViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datas = [NSMutableArray array];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.datas addObjectsFromArray:@[
                                      @"login",
                                      @"regist",
                                      @"queryRoster"
                                      ]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.textLabel.text = self.datas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * title = self.datas[indexPath.row];
    if ([title isEqualToString:@"login"]) {
        [[CAIXMPPManager manager]xmppConnect];
    }else if ([title isEqualToString:@"regist"]){
        [[CAIXMPPManager manager]regist];
    }else if ([title isEqualToString:@"queryRoster"]){
        rosterViewController * controller = [[rosterViewController alloc]initWithNibName:@"rosterViewController" bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
