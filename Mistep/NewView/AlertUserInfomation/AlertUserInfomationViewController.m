//
//  AlertUserInfomationViewController.m
//  Wukong
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "AlertUserInfomationViewController.h"
#import "AUIMineCell.h"
#import "AUIPhoneCell.h"
#import "AUIHeaderCell.h"
#import "AUIAccountCell.h"
#import "AUISaveCell.h"
#import "ChooseLocationView.h"
#import "UIImage+ForceDecode.h"
#import "AlertNickNameView.h"
#import "AlertPhoneViewController.h"
#import "RegulationViewController.h"
#import "CitiesDataTool.h"

static NSString *AUIHeaderID = @"AUIHeaderID";
static NSString *AUIAccountID = @"AUIAccountID";
static NSString *AUIMineID = @"AUIMineID";
static NSString *AUIPhoneID = @"AUIPhoneID";
static NSString *AUISaveID = @"AUISaveID";

@interface AlertUserInfomationViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,NSURLSessionDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{
    UIView *_backView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//选择器
@property (nonatomic,strong) ChooseLocationView *chooseLocationView;
@property (nonatomic,strong) UIView  *cover;
@property (strong, nonatomic)NSDate *datePickerDate;
@property (strong, nonatomic)UIDatePicker *datePicker;

//修改昵称提示框
@property (nonatomic, strong) AlertNickNameView *nickView;

//联系人
@property (nonatomic, strong) UITextField *rafTel1TF;
@property (nonatomic, strong) UITextField *rafTel2TF;
@property (nonatomic, strong) UITextField *rafTel3TF;
@property (nonatomic, strong) UITextField *GluTF;

    @property (weak, nonatomic) IBOutlet UILabel *titlePage;
    
    
@end

@implementation AlertUserInfomationViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getUserInfo];
    [self performSelector:@selector(reload) withObject:nil afterDelay:2];
}

- (void)reload{
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setSubViews];
    [self.view addSubview:self.cover];
    [[CitiesDataTool sharedManager] requestGetData];
    self.titlePage.text = kLOCAL(@"个人信息");
}

- (void)setSubViews{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelEdit)];
    tap.delegate=self;
    [self.tableView addGestureRecognizer:tap];
}

- (void)cancelEdit{
    [self.view endEditing:YES];
}

#pragma mark - tableView刷新
- (void)reloadTableViewSection:(NSInteger)section row:(NSInteger)row{
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark-手势代理，解决和tableview点击发生的冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (_backView){
        [self hiddenDateBackView];
    }
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//判断如果点击的是tableView的cell，就把手势给关闭了
        return NO;//关闭手势
    }//否则手势存在
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (CGRectContainsPoint(_chooseLocationView.frame, point)){
        return NO;
    }
    return YES;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 2;
    }else if (section == 2){
        return 12;
    }else if (section == 3){
        return 3;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        AUIHeaderCell *cell = [AUIHeaderCell tableView:tableView identfire:AUIHeaderID];
        if ([[[HCHCommonManager getInstance] UserNick] length] != 0) {
            cell.nickName.text = [[HCHCommonManager getInstance] UserNick];
        }
        if (self.selectImage) {
            cell.userHeader.image = self.selectImage;
        }else{
            [cell.userHeader sd_setImageWithURL:[[HCHCommonManager getInstance] UserHeader] placeholderImage:[UIImage imageNamed:@"touxiang_"]];
        }
        [cell.alertNickButton addTarget:self action:@selector(editNickName) forControlEvents:UIControlEventTouchUpInside];
        [cell.selectHeaderButton addTarget:self action:@selector(selectHeader) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else if (indexPath.section == 1){
        //账号信息
        AUIAccountCell *cell = [AUIAccountCell tableView:tableView identfire:AUIAccountID];
        if (indexPath.row == 0) {
            cell.titleLabel.text = kLOCAL(@"更换号码");
            [cell.alertButton setTitle:kLOCAL(@"更换手机号") forState:UIControlStateNormal];
            cell.alertWidth.constant = 85;
            cell.alertRight.constant = 20;
            NSString *numberString = [[[HCHCommonManager getInstance] UserTel] stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
            cell.detailLabel.text = numberString;
            [cell.alertButton addTarget:self action:@selector(alertTelAction) forControlEvents:UIControlEventTouchUpInside];
        }else{
            cell.titleLabel.text = kLOCAL(@"康币");
            [cell.alertButton setTitle:kLOCAL(@"赚取康币") forState:UIControlStateNormal];
            cell.alertWidth.constant = 67;
            cell.alertRight.constant = 29;
            cell.detailLabel.text = [NSString stringWithFormat:@"%@%@",[[HCHCommonManager getInstance] UserPoint],kLOCAL(@"枚")];
            [cell.alertButton addTarget:self action:@selector(makePointAction) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }else if (indexPath.section == 2){
        //我的资料
        AUIMineCell *cell = [AUIMineCell tableView:tableView identfire:AUIMineID];
        if (indexPath.row < 2) {
            cell.arrowButton.hidden = YES;
            cell.detailRight.constant = 10;
        }else{
            cell.arrowButton.hidden = NO;
            cell.detailRight.constant = 25;
        }
        if (indexPath.row == 0) {
            cell.titleLabel.text = kLOCAL(@"姓名");
            cell.detailLabel.text = self.uploadInfoDic[@"userName"];
        }else if (indexPath.row == 1){
            cell.titleLabel.text = kLOCAL(@"性别");
            NSInteger sex = [self.uploadInfoDic[@"sex"] integerValue];
            if (sex == 1) {
                cell.detailLabel.text = kLOCAL(@"男");
            }else{
                cell.detailLabel.text = kLOCAL(@"女");
            }
        }else if (indexPath.row == 2){
            cell.titleLabel.text = kLOCAL(@"生日");
            cell.detailLabel.text = self.uploadInfoDic[@"birthday"];
        }else if (indexPath.row == 3){
            cell.titleLabel.text = kLOCAL(@"所在地");
            cell.detailLabel.text = self.uploadInfoDic[@"address"];
        }else if (indexPath.row == 4){
            cell.titleLabel.text = kLOCAL(@"身高");
            cell.detailLabel.text = [NSString stringWithFormat:@"%@cm",self.uploadInfoDic[@"height"]];
        }else if (indexPath.row == 5){
            cell.titleLabel.text = kLOCAL(@"体重");
            cell.detailLabel.text = [NSString stringWithFormat:@"%@%@",self.uploadInfoDic[@"weight"],kLOCAL(@"公斤")];
        }else if (indexPath.row == 6){
            cell.titleLabel.text = kLOCAL(@"高血压病史");
            BOOL isHypertension = [self.uploadInfoDic[@"is_hypertension"] boolValue];
            if (isHypertension) {
                cell.detailLabel.text = kLOCAL(@"有");
            }else{
                cell.detailLabel.text = kLOCAL(@"无");
            }
        }else if (indexPath.row == 7){
            cell.titleLabel.text = kLOCAL(@"基准高压值");
            cell.detailLabel.text = self.uploadInfoDic[@"SystolicPressure"];
        }else if (indexPath.row == 8){
            cell.titleLabel.text = kLOCAL(@"基准低压值");
            cell.detailLabel.text = self.uploadInfoDic[@"DiastolicPressure"];
        }else if (indexPath.row == 9){
            cell.titleLabel.text = kLOCAL(@"冠心病史");
            BOOL isCHD = [self.uploadInfoDic[@"is_CHD"] boolValue];
            if (isCHD) {
                cell.detailLabel.text = kLOCAL(@"有");
            }else{
                cell.detailLabel.text = kLOCAL(@"无");
            }
        }else if (indexPath.row == 10){
            cell.titleLabel.text = kLOCAL(@"糖尿病史");
            BOOL isdiabetes = [self.uploadInfoDic[@"is_Glu"] boolValue];
            if (isdiabetes) {
                cell.detailLabel.text = kLOCAL(@"有");
            }else{
                cell.detailLabel.text = kLOCAL(@"无");
            }
        }else{
            AUIPhoneCell *cellT = [AUIPhoneCell tableView:tableView identfire:AUIPhoneID];
            cellT.phoneTextField.delegate = self;
            cellT.phoneTextField.text = self.uploadInfoDic[@"Glu"];
            self.GluTF = cellT.phoneTextField;
            cellT.titleLabel.text = kLOCAL(@"餐后血糖值");
            cellT.phoneTextField.keyboardType = UIKeyboardTypeDecimalPad;
            cellT.phoneTextField.placeholder = kLOCAL(@"请输入餐后血糖值");
            return cellT;
        }
        return cell;
    }else if (indexPath.section == 3){
        //紧急联系人
        AUIPhoneCell *cell = [AUIPhoneCell tableView:tableView identfire:AUIPhoneID];
        cell.phoneTextField.delegate = self;
        if (indexPath.row == 0) {
            cell.phoneTextField.text = self.uploadInfoDic[@"rafTel1"];
            self.rafTel1TF = cell.phoneTextField;
        }else if (indexPath.row == 1){
            cell.phoneTextField.text = self.uploadInfoDic[@"rafTel2"];
            self.rafTel2TF = cell.phoneTextField;
        }else{
            cell.phoneTextField.text = self.uploadInfoDic[@"rafTel3"];
            self.rafTel3TF = cell.phoneTextField;
        }
        cell.phoneTextField.placeholder = kLOCAL(@"11位手机号码");
        cell.titleLabel.text = kLOCAL(@"监护人电话");
        
        return cell;
    }else{
        AUISaveCell *cell = [AUISaveCell tableView:tableView identfire:AUISaveID];
        [cell.saveButton addTarget:self action:@selector(saveInfo) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 4) {
        return 100;
    }
    if (indexPath.section == 0) {
        return 150;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 4 || section == 0) {
        return 0.01;
    }
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 4 || section == 0) {
        return nil;
    }
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    header.backgroundColor = [UIColor whiteColor];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth-10, 40)];
    if (section == 1) {
        title.text = kLOCAL(@"账号信息");
    }else if (section == 2){
        title.text = kLOCAL(@"我的资料");
    }else if (section == 3){
        title.text = kLOCAL(@"紧急联系人");
    }
    [header addSubview:title];
    
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    if (indexPath.section == 2 && indexPath.row) {
        switch (indexPath.row) {
            case 1:{//性别
                _PickerViewType = PickerViewSex;
                [self setPickerView];
            }break;
            case 2:{//生日
                _PickerViewType = PickerViewBirthday;
                [self setPickerView];
            }break;
            case 3:{//所在地
                self.cover.hidden = !self.cover.hidden;
                self.chooseLocationView.hidden = self.cover.hidden;
            }break;
            case 4:{//身高
                _PickerViewType = PickerViewHeight;
                [self setPickerView];
            }break;
            case 5:{//体重
                _PickerViewType = PickerViewWeight;
                [self setPickerView];
            }break;
            case 6:{//高血压病史
                _PickerViewType = PickerViewHypertension;
                [self setPickerView];
            }break;
            case 7:{//基准高压值
                _PickerViewType = PickerViewSystolicPressure;
                [self setPickerView];
            }break;
            case 8:{//基准低压值
                _PickerViewType = PickerViewDiastolicPressure;
                [self setPickerView];
            }break;
            case 9:{//冠心病史
                _PickerViewType = PickerViewCHD;
                [self setPickerView];
            }break;
            case 10:{//糖尿病史
                _PickerViewType = PickerViewDiabetes;
                [self setPickerView];
            }break;
            case 11:{//餐后血糖值
//                _PickerViewType = PickerViewPPBS;
//                [self setPickerView];
                
            }break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2 || section == 1) {
        return 10;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 2 || section == 1) {
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
        footer.backgroundColor = kColor(238, 238, 238);
        return footer;
    }
    return nil;
}

#pragma mark - 点击事件
//编辑昵称
- (void)editNickName{
    if (!_nickView) {
        _nickView = [AlertNickNameView alertNickNameView];
    }
    [_nickView.okButton addTarget:self action:@selector(backNickNameAction) forControlEvents:UIControlEventTouchUpInside];
    [_nickView show];
}

//选择头像
- (void)selectHeader{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"请选择获取方式", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"拍摄新的照片",nil),NSLocalizedString(@"从相册获取",nil), nil];
    [self.view endEditing:YES];
    [actionSheet showInView:self.view];
}

//点击确定修改昵称返回
- (void)backNickNameAction{
    if (![_nickView.nickTF.text length]) {
        [self addActityTextInView:_nickView text:kLOCAL(@"请填写昵称") deleyTime:1.5f];
        return;
    }
    [self requestAlertInfoUrl:ALERTNICKNAME parameter:@{@"NickName":[_nickView.nickTF.text copy],@"userId":USERID} filePath:nil];
    [_nickView removeFromSuperview];
    _nickView = nil;
}

- (void)saveInfo{
//    if (![[self.uploadInfoDic allKeys] count]) {
//        [self addActityTextInView:self.view text:@"请至少修改一项" deleyTime:1.5f];
//        return;
//    }
    
    [self.uploadInfoDic setObject:USERID forKey:@"userId"];
    
    if ([self.rafTel1TF.text length] == 0) {
        [self addActityTextInView:self.view text:kLOCAL(@"请填写监护人电话") deleyTime:1.5f];
        return;
    }else if ([self.rafTel1TF.text length] != 11){
        [self addActityTextInView:self.view text:kLOCAL(@"监护人电话格式错误") deleyTime:1.5f];
        return;
    }
    
    if ([self.rafTel2TF.text length] != 0) {
        if ([self.rafTel2TF.text length] != 11) {
            [self addActityTextInView:self.view text:kLOCAL(@"监护人电话格式错误") deleyTime:1.5f];
            return;
        }
    }
    
    if ([self.rafTel3TF.text length] != 0) {
        if ([self.rafTel3TF.text length] != 11) {
            [self addActityTextInView:self.view text:kLOCAL(@"监护人电话格式错误") deleyTime:1.5f];
            return;
        }
    }
    
    [self requestAlertInfoUrl:UPLOADUSERINFO parameter:self.uploadInfoDic filePath:nil];
}

//修改手机号
- (void)alertTelAction{
    AlertPhoneViewController *tel = [[AlertPhoneViewController alloc] init];
    [self.navigationController pushViewController:tel animated:YES];
}

//赚取康币
- (void)makePointAction{
    RegulationViewController *regula = [RegulationViewController new];
    regula.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:regula animated:YES];
}

//返回
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _rafTel1TF) {
        [self.uploadInfoDic setObject:textField.text forKey:@"rafTel1"];
    }else if (textField == _rafTel2TF){
        [self.uploadInfoDic setObject:textField.text forKey:@"rafTel2"];
    }else if (textField == _rafTel3TF){
        [self.uploadInfoDic setObject:textField.text forKey:@"rafTel3"];
    }else{
        //血糖
        [self.uploadInfoDic setObject:textField.text forKey:@"Glu"];
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //        选择头像的Action
    if (buttonIndex == 2) {
        return;
    }
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    if(buttonIndex == 0)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else
        {
            [self showAlertView:NSLocalizedString(@"相机不可用", nil)];
        }
    }
    else if (buttonIndex == 1)
    {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];

}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.selectImage = image;
    [self dismissViewControllerAnimated:YES completion:nil];
    dispatch_queue_t concurrentDiapatchQueue=dispatch_queue_create("com.test.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(concurrentDiapatchQueue, ^
                   {
                       UIImage *locImage = [UIImage decodedImageWithImage:image withSize:CGSizeMake(120, 120)];
                       if( !locImage ){
                           
                       }
                       _imageFilePath = [[HCHCommonManager getInstance] storeHeadImageWithImage:locImage];
                       dispatch_async(dispatch_get_main_queue(), ^{
                           [self requestAlertInfoUrl:UPLOADHEADER parameter:@{@"userId":USERID} filePath:_imageFilePath];
                       });
                       
                   });
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (_PickerViewType == PickerViewHeight){
        return 211;
    }else if (_PickerViewType == PickerViewWeight){
        return 141;
    }else if (_PickerViewType == PickerViewSystolicPressure){
        return 200;
    }else if (_PickerViewType == PickerViewPPBS){
        return 20;
    }else if (_PickerViewType == PickerViewDiastolicPressure){
        return 190;
    }else{
        return 2;
    }
}

#pragma mark - UIPickerViewDelegate
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (_PickerViewType == PickerViewHeight){
        return [NSString stringWithFormat:@"%ld",row + 40];
    }else if (_PickerViewType == PickerViewWeight){
        return [NSString stringWithFormat:@"%ld",row + 30];
    }else if (_PickerViewType == PickerViewSystolicPressure){
        return [NSString stringWithFormat:@"%ld",row + 50];
    }else if (_PickerViewType == PickerViewDiastolicPressure){
        return [NSString stringWithFormat:@"%ld",row + 30];
    }else if (_PickerViewType == PickerViewPPBS){
        return [NSString stringWithFormat:@"%ld",row];
    }else if (_PickerViewType == PickerViewSex){
        if (row == 0) {
            return kLOCAL(@"男");
        }
        return kLOCAL(@"女");
    }else{
        if (row == 0) {
            return kLOCAL(@"有");
        }else{
            return kLOCAL(@"无");
        }
    }
}

#pragma mark - 请求
- (void)requestAlertInfoUrl:(NSString *)url parameter:(NSDictionary *)parameter filePath:(NSString *)filePath{
    NSString *uploadUrl = [NSString stringWithFormat:@"%@/%@",url,TOKEN];
    
    [self addActityIndicatorInView:self.view labelText:NSLocalizedString(@"正在修改", nil) detailLabel:NSLocalizedString(@"正在修改", nil)];
    [self performSelector:@selector(loginTimeOut) withObject:nil afterDelay:60.f];
    
    [[AFAppDotNetAPIClient sharedClient] globalmultiPartUploadWithUrl:uploadUrl fileUrl:filePath params:parameter Block:^(id responseObject, NSError *error) {
         
         [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loginTimeOut) object:nil];
         
         [self removeActityIndicatorFromView:self.view];
         if (error)
         {
             [self addActityTextInView:self.view text:NSLocalizedString(@"网络连接错误", nil) deleyTime:1.5f];
             _imageFilePath = @"";
             _selectImage = nil;
         }
         else
         {
             int code = [[responseObject objectForKey:@"code"] intValue];
             NSString *message = [responseObject objectForKey:@"message"];
             if (code == 0) {
                 if ([message isEqualToString:@"error"]) {
                     [self addActityTextInView:self.view text:NSLocalizedString(@"修改失败", nil) deleyTime:1.5f];
                     return;
                 }else{
                     //设置心率预警
                     [[HCHCommonManager getInstance] setUserBirthdateWith:self.uploadInfoDic[@"birthday"]];
                     [self getHeartRateWithAge];
                     //设置血压配置参数
                     [ADASaveDefaluts setObject:self.uploadInfoDic[@"SystolicPressure"] forKey:BLOODPRESSURELOW];
                     [ADASaveDefaluts setObject:self.uploadInfoDic[@"DiastolicPressure"] forKey:BLOODPRESSUREHIGH];
                     
                     [[NSUserDefaults standardUserDefaults] setObject:self.uploadInfoDic[@"SystolicPressure"] forKey:@"setheight"];
                     [[NSUserDefaults standardUserDefaults] setObject:self.uploadInfoDic[@"DiastolicPressure"] forKey:@"setlow"];
                     [[NSUserDefaults standardUserDefaults] setObject:self.uploadInfoDic[@"Glu"] forKey:@"setspo2"];
                     
                     
                     [self addActityTextInView:self.view text:NSLocalizedString(@"修改成功", nil) deleyTime:1.5f];
                 }
                 
                 if ([url isEqualToString:ALERTNICKNAME]) {
                     [[HCHCommonManager getInstance] setUserNickWith:responseObject[@"data"][@"NickName"]];
                     [self reloadTableViewSection:0 row:0];
                 }else if ([url isEqualToString:UPLOADHEADER]){
                     [[HCHCommonManager getInstance] setUserHeaderWith:responseObject[@"data"][@"imgURL"]];
                     [self reloadTableViewSection:0 row:0];
                     [[NSNotificationCenter defaultCenter] postNotificationName:UserInformationUpDateNotification object:nil];
                 }else{
                     [self getUserInfo];
                 }
             } else {
                 [self addActityTextInView:self.view text:NSLocalizedString(message, nil)  deleyTime:1.5f];
                 _imageFilePath = @"";
                 _selectImage = nil;
             }
         }
     }];
    
}

#pragma mark - 选择器
- (void)setPickerView{
    _backView = [[UIView alloc] initWithFrame:CurrentDeviceBounds];
    _backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_backView];
    
    _animationView  = [[UIView alloc] initWithFrame:CGRectMake(0, CurrentDeviceHeight, CurrentDeviceWidth, 246)];
    [_backView addSubview:_animationView];
    
    if (_PickerViewType == PickerViewBirthday)
    {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 30,CurrentDeviceWidth, 216)];
        NSString* string = @"19000101";
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyyMMdd"];
        NSDate* minDate = [formatter dateFromString:string];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.backgroundColor = [UIColor whiteColor];
        NSDate *maxDate = [NSDate date];
        _datePicker.maximumDate = maxDate;
        _datePicker.minimumDate = minDate;
        [_animationView addSubview:_datePicker];
    }else{
        [self setHeightPickerView];
    }
    UIView *buttonView = [[UIView alloc] init];
    buttonView.backgroundColor = [UIColor whiteColor];
    [_animationView addSubview:buttonView];
    buttonView.sd_layout.leftEqualToView(_backView)
    .rightEqualToView(_backView)
    .heightIs(30)
    .topEqualToView(_animationView);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonView addSubview:button];
    button.frame = CGRectMake(CurrentDeviceWidth-80, 0, 80, 40);
    [button addTarget:self action:@selector(dateSureClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *btnImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    btnImageView.image = [UIImage imageNamed:@"hook"];
    btnImageView.center = button.center;
    [buttonView addSubview:btnImageView];
    
    [UIView animateWithDuration:0.23 animations:^{
        _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _animationView.frame = CGRectMake(0, CurrentDeviceHeight-246,CurrentDeviceWidth, 246);
    }];
}

- (void)setHeightPickerView{
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30,CurrentDeviceWidth, 216)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    if (_PickerViewType == PickerViewHeight){
        [_pickerView selectRow:110 inComponent:0 animated:NO];
    }
    else if (_PickerViewType == PickerViewWeight){
        [_pickerView selectRow:20 inComponent:0 animated:NO];
    }else if (_PickerViewType == PickerViewSystolicPressure){
        //基准高压
        [_pickerView selectRow:100 inComponent:0 animated:NO];
    }else if (_PickerViewType == PickerViewDiastolicPressure){
        //基准低压
        [_pickerView selectRow:100 inComponent:0 animated:NO];
    }else{
        [_pickerView selectRow:0 inComponent:0 animated:NO];
    }
    [_animationView addSubview:_pickerView];
}

// 选择出生日期完毕
- (void)dateSureClick{
    [self hiddenDateBackView];
    NSInteger row = [_pickerView selectedRowInComponent:0];
    if (_PickerViewType == PickerViewBirthday){
        int seconds = [_datePickerDate timeIntervalSince1970];
        [[TimeCallManager getInstance] getYYYYMMDDSecondsSince1970With:seconds];
        _datePickerDate = _datePicker.date;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *birthday = [formatter stringFromDate:_datePickerDate];
        [self.uploadInfoDic setObject:birthday forKey:@"birthday"];
        [self reloadTableViewSection:2 row:2];
    }else if (_PickerViewType == PickerViewSex){
        [self.uploadInfoDic setObject:[NSString stringWithFormat:@"%ld",row+1] forKey:@"sex"];
        [self reloadTableViewSection:2 row:1];
    }else if (_PickerViewType == PickerViewHeight){
        NSString *height = [NSString stringWithFormat:@"%ld",row + 40];
        [self.uploadInfoDic setObject:height forKey:@"height"];
        [self reloadTableViewSection:2 row:4];
    }else if (_PickerViewType == PickerViewWeight){
        NSString *width = [NSString stringWithFormat:@"%ld",row + 30];
        [self.uploadInfoDic setObject:width forKey:@"weight"];
        [self reloadTableViewSection:2 row:5];
    }else if (_PickerViewType == PickerViewCHD){
        if (row == 0) {
            [self.uploadInfoDic setObject:@(true) forKey:@"is_CHD"];
        }else{
            [self.uploadInfoDic setObject:@(false) forKey:@"is_CHD"];
        }
        [self reloadTableViewSection:2 row:9];
    }else if (_PickerViewType == PickerViewHypertension){
        if (row == 0) {
            [self.uploadInfoDic setObject:@(true) forKey:@"is_hypertension"];
        }else{
            [self.uploadInfoDic setObject:@(false) forKey:@"is_hypertension"];
        }
        [self reloadTableViewSection:2 row:6];
    }else if (_PickerViewType == PickerViewDiabetes) {
        if (row == 0) {
            [self.uploadInfoDic setObject:@(true) forKey:@"is_Glu"];
        }else{
            [self.uploadInfoDic setObject:@(false) forKey:@"is_Glu"];
        }
        [self reloadTableViewSection:2 row:10];
    }else if (_PickerViewType == PickerViewPPBS) {
        [self.uploadInfoDic setObject:[NSString stringWithFormat:@"%ld",row] forKey:@"Glu"];
        [self reloadTableViewSection:2 row:11];
    }else if (_PickerViewType == PickerViewSystolicPressure){
        [self.uploadInfoDic setObject:[NSString stringWithFormat:@"%ld",row+50] forKey:@"SystolicPressure"];
        [self reloadTableViewSection:2 row:7];
    }else if (_PickerViewType == PickerViewDiastolicPressure){
        [self.uploadInfoDic setObject:[NSString stringWithFormat:@"%ld",row+30] forKey:@"DiastolicPressure"];
        [self reloadTableViewSection:2 row:8];
    }
}

// 隐藏DatePicker
- (void)hiddenDateBackView
{
    [UIView animateWithDuration:0.23 animations:^{
        _animationView.frame = CGRectMake(0, CurrentDeviceHeight, CurrentDeviceWidth, 246);
    } completion:^(BOOL finished) {
        
        [_backView removeFromSuperview];
        _backView = nil;
        [_datePicker removeFromSuperview];
        _datePicker = nil;
    }];
}
//取消选择出生日期
- (void)dateCancleButtonClick{
    [self hiddenDateBackView];
}

#pragma mark - 选择地址
- (void)tapCover:(UITapGestureRecognizer *)tap{
    if (_chooseLocationView.chooseFinish) {
        _chooseLocationView.chooseFinish();
    }
}

- (ChooseLocationView *)chooseLocationView{
    if (!_chooseLocationView) {
        _chooseLocationView = [[ChooseLocationView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 350, [UIScreen mainScreen].bounds.size.width, 350)];
    }
    return _chooseLocationView;
}

- (UIView *)cover{
    if (!_cover) {
        _cover = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [_cover addSubview:self.chooseLocationView];
        __weak typeof (self) weakSelf = self;
        _chooseLocationView.chooseFinish = ^{
            [UIView animateWithDuration:0.25 animations:^{
                if (weakSelf.chooseLocationView.address && weakSelf.chooseLocationView.address.length != 0) {
                    [weakSelf.uploadInfoDic setObject:weakSelf.chooseLocationView.address forKey:@"address"];
                    weakSelf.view.transform = CGAffineTransformIdentity;
                    [weakSelf reloadTableViewSection:2 row:3];
                }
                weakSelf.cover.hidden = YES;
            }];
        };
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCover:)];
        [_cover addGestureRecognizer:tap];
        tap.delegate = self;
        _cover.hidden = YES;
    }
    return _cover;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载
- (NSMutableDictionary *)uploadInfoDic {
    if (!_uploadInfoDic) {
        _uploadInfoDic = [NSMutableDictionary dictionary];
        HCHCommonManager *hchc = [HCHCommonManager getInstance];
        [_uploadInfoDic setObject:[hchc userBirthdate] forKey:@"birthday"];
        [_uploadInfoDic setObject:[hchc UserGender] forKey:@"sex"];
        [_uploadInfoDic setObject:[hchc UserAcount] forKey:@"userName"];
        [_uploadInfoDic setObject:[hchc UserAddress] forKey:@"address"];
        [_uploadInfoDic setObject:[hchc UserWeight] forKey:@"weight"];
        [_uploadInfoDic setObject:[hchc UserHeight] forKey:@"height"];
        [_uploadInfoDic setObject:[hchc UserIsHypertension] forKey:@"is_hypertension"];
        [_uploadInfoDic setObject:[hchc UserSystolicP] forKey:@"SystolicPressure"];
        [_uploadInfoDic setObject:[hchc UserIsCHD] forKey:@"is_CHD"];
        [_uploadInfoDic setObject:[hchc UserDiastolicP] forKey:@"DiastolicPressure"];
        [_uploadInfoDic setObject:@"" forKey:@"Glu"];
        [_uploadInfoDic setObject:[hchc UserRafTel1] forKey:@"rafTel1"];
        [_uploadInfoDic setObject:[hchc UserRafTel2] forKey:@"rafTel2"];
        [_uploadInfoDic setObject:[hchc UserRafTel3] forKey:@"rafTel3"];
        [_uploadInfoDic setObject:[hchc UserGlu] forKey:@"Glu"];
        [_uploadInfoDic setObject:[hchc UserIsGlu] forKey:@"is_Glu"];
    }
    return _uploadInfoDic;
    
}

//根据年龄获取心率
- (void)getHeartRateWithAge{
    int maxHeart,maxHeartTwo;
    maxHeart = 220 - [[HCHCommonManager getInstance]getAge];
    
    maxHeartTwo = maxHeart * 80 /100;
    [[CositeaBlueTooth sharedInstance] setHeartRateAlarmWithState:YES MaxHeartRate:maxHeartTwo MinHeartRate:40];
}

@end
