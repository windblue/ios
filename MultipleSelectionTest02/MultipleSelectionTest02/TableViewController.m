//
//  TableViewController.m
//  MultipleSelectionTest02
//
//  Created by 天野 裕介 on 12/08/13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController {
//セクションや各行のデータを入れる変数
NSMutableArray *tableData;

//編集ボタン
UIBarButtonItem *editButton;

//完了ボタン
UIBarButtonItem *doneButton;
}

static NSString *TITLE = @"複数選択と削除";
static NSString *KEY_SECTION = @"section";
static NSString *KEY_ROW = @"row";

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
        //ナビゲーションコントロールを表示する
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        //ナビゲーションバーにタイトルを設定
        self.navigationItem.title = TITLE;
        
        //完了ボタンを初期化
        editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                   target:self
                                                                   action:@selector(didTapEditButton)
                      ];
        
        //完了ボタンを初期化
        doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                   target:self
                                                                   action:@selector(didTapDoneButton)
                      ];
        //まずは触れないようにしておく
        doneButton.enabled = NO;
        
        //ナビゲーションバーに編集ボタンと完了ボタンを配置
        self.navigationItem.rightBarButtonItem = editButton;
        self.navigationItem.leftBarButtonItem = doneButton;
        
        
        //セクション毎に情報をまとめ、変数に格納
        NSMutableDictionary *section1 = [NSMutableDictionary dictionary];
        [section1 setObject:@"あ行" forKey:KEY_SECTION];
        [section1 setObject:[NSMutableArray arrayWithObjects:@"あ", @"い", @"う", @"え", @"お", nil] forKey:KEY_ROW];
        
        NSMutableDictionary *section2 = [NSMutableDictionary dictionary];
        [section2 setObject:@"か行" forKey:KEY_SECTION];
        [section2 setObject:[NSMutableArray arrayWithObjects:@"か", @"き", @"く", @"け", @"こ", nil] forKey:KEY_ROW];
        
        NSMutableDictionary *section3 = [NSMutableDictionary dictionary];
        [section3 setObject:@"さ行" forKey:KEY_SECTION];
        [section3 setObject:[NSMutableArray arrayWithObjects:@"さ", @"し", @"す", @"せ", @"そ", nil] forKey:KEY_ROW];
        
        //一つ目、二つ目のセクション毎の情報を、順に配列に格納
        tableData = [NSMutableArray arrayWithObjects:section1, section2, section3, nil];
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        //編集モード時のみ、複数選択できるようにしておく
        self.tableView.allowsMultipleSelectionDuringEditing = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didTapEditButton
{
    //編集モードにする
    [self.tableView setEditing:YES animated:YES];
    
    //完了ボタンを使用可能にする
    doneButton.enabled = YES;
}

- (void)didTapDoneButton
{
    //完了ボタンを使用不可にする
    doneButton.enabled = NO;
    
    //複数削除ロジックここから
    
    //「選択したセルたちのindexPath」が配列のかたちで取得できる
    NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
    
    //選択されたセルが含まれるセクション番号一覧を取得(値の重複はさせない)
    NSMutableSet *selectedUniqueSections = [NSMutableSet set];
    for (NSIndexPath *tempIndexPath in indexPaths) {
        [selectedUniqueSections addObject:[NSNumber numberWithInteger:tempIndexPath.section]];
    }
    
    //各セクション番号と、それに紐づく行番号たちをdictionary形式で取得
    NSMutableDictionary *selectedSectionAndRows = [NSMutableDictionary dictionary];
    for (NSNumber *selectedSection in selectedUniqueSections) {
        NSMutableArray *selectedRows = [NSMutableArray array];
        
        for (NSIndexPath *indexPath in indexPaths) {
            if (indexPath.section == [selectedSection intValue]) {
                NSArray *tableDataRow = [[tableData objectAtIndex:indexPath.section] objectForKey:KEY_ROW];
                NSString *selectedRowValue = [tableDataRow objectAtIndex:indexPath.row];
                [selectedRows addObject:selectedRowValue];
            }
        }
        [selectedSectionAndRows setObject:selectedRows forKey:selectedSection];
    }
    
    //各セクション毎に、その中の行を一括で削除する
    for (NSNumber *section in selectedSectionAndRows) {
        NSInteger sectionInteger = [section intValue];
        NSArray *selectedRow = [selectedSectionAndRows objectForKey:section];
        [[[tableData objectAtIndex:sectionInteger] objectForKey:KEY_ROW] removeObjectsInArray:selectedRow];
    }
    
    //UITableViewの表示からも削除する
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    //セクション中の行が0になった場合、削除する
    NSMutableIndexSet *zeroRowSections = [NSMutableIndexSet indexSet];
    for (NSInteger i = 0; i < [tableData count]; i++) {
        if ([[[tableData objectAtIndex:i] objectForKey:KEY_ROW] count] == 0) {
            [zeroRowSections addIndex:i];
        }
    }
    
    //行数がゼロのセクションがあれば、そこのデータを一括削除し、表示をリロードする
    if ([zeroRowSections count] > 0) {
        [tableData removeObjectsAtIndexes:zeroRowSections];
        [self.tableView reloadData];
    }
    
    //複数削除ロジックここまで
    
    //編集モードを解除
    [self.tableView setEditing:NO animated:NO];
    
}

#pragma mark - Table view data source

//テーブル中のセクション(行をまとめる見出し的なもの)の数を返却する
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [tableData count];
}

//あるセクションの中にいくつ行があるかを返却する
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //対象となるセクションと行のセットを取得
    NSDictionary *target = [tableData objectAtIndex:section];
    
    //上記で取得したオブジェクトから、行を格納した配列を取得
    NSArray *targetRows = [target objectForKey:KEY_ROW];
    
    //行がいくつあるのかを計算して返却します
    return [targetRows count];
}

//indexPathで指定されたセルの中身を作成します。
//indexPathはセクションと行がセットの変数です。
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //対象となるセクションと行のセットを取得
    NSDictionary *target = [tableData objectAtIndex:indexPath.section];
    
    //上記で取得したオブジェクトから、行を格納した配を取得
    NSArray *targetRows = [target objectForKey:KEY_ROW];
    
    //どの行を表示するのかを取得
    NSString *rowString = [targetRows objectAtIndex:indexPath.row];
    
    //テキストに文字を設定
    cell.textLabel.text = rowString;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //対象となるセクションと行のセットを取得
    NSDictionary *target = [tableData objectAtIndex:section];
    
    //上記で取得したオブジェクトから、セクションの文字列を取得
    return [target objectForKey:KEY_SECTION];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
