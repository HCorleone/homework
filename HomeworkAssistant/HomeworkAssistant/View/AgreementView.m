//
//  AgreementView.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2019/1/2.
//  Copyright © 2019 无敌帅枫. All rights reserved.
//

#import "AgreementView.h"

@interface AgreementView()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *whiteView;

@end

@implementation AgreementView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 大背景
        UIView *bgView = [[UIView alloc]init];
        //    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
        [self addSubview:bgView];
        bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        bgView.userInteractionEnabled = YES;
        self.bgView = bgView;
        
        //白色框
        UIView *whiteView = [[UIView alloc]init];
        whiteView.backgroundColor = whitecolor;
        whiteView.layer.cornerRadius = 4;
        [bgView addSubview:whiteView];
        [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(0.84 * SCREEN_WIDTH, 0.84 * SCREEN_WIDTH * 1.34));
            make.center.mas_equalTo(bgView);
        }];
        whiteView.userInteractionEnabled = YES;
        self.whiteView = whiteView;
        
        UITextView *agreement = [[UITextView alloc] init];
        [whiteView addSubview:agreement];
        [agreement mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(whiteView);
            make.top.mas_equalTo(whiteView);
            make.width.mas_equalTo(0.75 * SCREEN_WIDTH);
            make.bottom.mas_equalTo(whiteView).offset(-0.16 * SCREEN_WIDTH);
        }];
        agreement.showsVerticalScrollIndicator = NO;
        agreement.editable = NO;
        agreement.font = [UIFont systemFontOfSize:14];
        agreement.text = @"特别提示：\n\t在您下载、安装、使用作业答案下载器APP产品时（包括提供给您的更新或升级版本之前），请您务必审慎阅读本协议的全部条款，在充分理解各条款（特别是免除或限制公司责任及对您权利限制条款）内容后安装并使用。\n\t作业答案下载器是成都阅享时光科技有限公司（以下简称“公司”）的产品，公司有权根据业务需要对本协议进行不定时调整，如果您不同意调整后的本协议，您应当停止使用作业答案下载器。如调整本协议后，您继续使用作业答案下载器，将视为您同意遵守调整后的协议。若您下载、安装、使用作业答案下载器，则意味着您将自愿遵守本协议及作业答案下载器公布的有关规则，并完全服从于作业答案下载器的统一管理。\n\t一、协议效力\n\t1、本协议是由您与成都阅享时光科技有限公司就使用作业答案下载器APP产品签署的协议。\n\t2、本协议自您点击同意并下载、安装或使用作业答案下载器之日生效。\n\t3、本协议同时还包括您使用作业答案下载器期间使用该APP中某一特定服务而另行签署的单独协议、公司公布的有关规则等内容，该单独协议及有关规则作为本协议不可分割的部分，您应当予以全部遵守。\n\t二、用户行为规范\n\t1、您必须通过合法渠道下载、安装并使用作业答案下载器。\n\t2、除非另有约定，您同意仅为您个人非商业性质的目的使用作业答案下载器。\n\t3、您应妥善保管自己的账号、密码，不得转让、出售或分享给他人使用。当用户账号未经授权被使用时，您应立即通知公司，否则未经授权的使用行为均视为您本人行为。\n\t4、公司有权随时对作业答案下载器提供的服务内容等进行调整，包括但不限于增加、删除、修改作业答案下载器服务内容。\n\t5、您必须保证您注册、登录并使用的账号符合中国相关法律法规规定。公司有权对您注册、登录并使用的账号名称、头像和简介等注册信息进行审核。\n\t6、如果您以虚假信息骗取账号名称注册或您的账号、头像等注册信息存在违法和不良信息的，公司有权采取通知改正、暂停使用、注销登记等措施限制该账号使用。\n\t三、服务内容\n\t1、作业答案下载器的具体服务内容由公司根据实际业务情况提供，以APP公开提供的内容为准。\n\t2、公司提供的服务内容暂为免费服务。后续如有收费内容，公司将会在您使用前给予明确提示并提供相关规则。若您确认，则在向公司支付相关费用后有权使用该收费服务内容。\n\t3、您因使用作业答案下载器所产生的通讯流量费用、上网费用等应自行承担。\n\t4、基于网络服务的特殊性，您同意公司有权随时变更、中断或终止部分或全部服务内容。如该服务内容系公司免费提供，公司有权不通知您，也无需对您或任何第三方承担任何责任。\n\t四、免责声明\n\t1、作业答案下载器是提供信息分享、传送及获取的平台，您必须依我国法律法规规定使用自己注册帐号，并对自己注册号下的一切行为负责，包括您所传送的任何内容以及由此产生的任何结果。\n\t2、公司不担保您经由作业答案下载器获取的任何信息、内容或服务一定能满足您的要求和期望。您理解并同意使用作业答案下载器时由于非公司过错所导致的一切风险和损失由您自行承担，公司对您不承担任何责任。\n\t3、您应严格确保注册账号符合我国法律法规规定，不得未经授权使用任何第三方的信息等相关资料注册，并不得提供虚假注册信息，否则公司有权注销您的账号及相关数据，并不承担任何法律责任。\n\t4、您应对自己的注册账户全部信息承担保密义务，并依法发布信息，若违法发布信息或因账户信息泄露导致被他人违法发布信息被处罚或侵犯第三方合法权益的，您应自行承担全部责任，公司对此不承担责任。若公司因您自行发布或者因账号信息泄露而产生的被处罚或对第三方赔偿的情况下，公司有权向您追偿全部经济损失（包括但不限于被处罚的金额、对第三方赔偿的金额、因您的行为给公司造成的经济损失、向您追偿而产生的律师费、鉴定费、取证费等）。\n\t5、您需对作业答案下载器提供的全部内容进行审慎判断，并自行承担因使用该内容而引起的所有风险，包括因对内容的准确性、完整性或实用性的信赖而产生的风险（包括但不限于直接或间接损失如数据损失、经营损失、罚款等）。不论该风险或责任是侵权或其他原因而产生，公司对该风险或责任均不承担任何赔偿责任。若您为使用作业答案下载器的产品或服务而向公司支付了费用，则公司就彼此间因协议而产生的违约责任以您支付的全部费用为最高限额。即使依您使用本APP的根本目的无法实现，经协商解决后仍未实现的亦以全部费用为最高限额。如您免费使用，公司将免责，不承担任何责任。\n\t6、公司按照作业答案下载器现有状况向您提供信息，公司对APP内信息不承诺任何明示或默示的保证或担保，包括但不限于基于特定目的而使用APP，不侵权，以及公司或公司员工口头或书面的承诺，除非公司在书面承诺中明确表明排除适用本协议中约定。\n\t7、任何因政府管制、第三方如电信部门的通讯线路故障、技术问题、网络或电脑故障、系统不稳定性影响网络正常使用导致的用户资料泄露、丢失、被盗用或被篡改等，公司免责，对您的损失不承担责任。\n\t8、作业答案下载器与其他互联网产品一样，受包括但不限于用户原因、网络服务质量、社会环境等因素的差异影响，可能受到各种安全问题的侵扰，您应加强信息安全及使用者资料的保护意识，如因计算机系统、黑客攻击、病毒侵入或发作等产生用户资料泄露、丢失、被盗用或被篡改、受到其他损失或骚扰等，公司免责，对您的损失及风险不承担责任。\n\t9、由于您将注册账号相关信息故意或过失告知他人或与他人共享注册帐户，由此导致的任何个人信息的泄漏或造成用户资料泄露、丢失、被盗用或被篡改的，公司免责，不承担任何责任。\n\t10、根据法律规定或相关政府机构要求提供您的个人信息的，公司免责，不承担任何责任。\n\t11、其他非公司故意或重大过失原因导致的个人信息泄漏或造成用户资料泄露、丢失、被盗用或被篡改的，公司免责，不承担任何责任。\n\t12、因不可抗力或公司不能控制的原因导致任何后果的情况，公司免责，不承担任何责任，但公司会采取必要措施减少损失或影响。\n\t五、知识产权\n\t1、公司在作业答案下载器中自行提供的任何文字、图片、图形、版面设计、商业标识、有关数据等内容或服务的著作权、商标权、专利权、商业秘密等知识产权均归属于公司所有。\n\t2、对于您及其他用户上传到作业答案下载器上的任何内容，公司享有有限管理权和形式审核权，其知识产权归相应权利人所有。\n\t3、作业答案下载器的内容全部由您及其他用户上传，您应确保上传的内容不存在侵犯任何第三方的知识产权或其他合法权利。若您发现用户上传的内容有侵犯您或第三方权利时，请及时联系公司并提供相应证明材料，公司将及时删除该内容。\n\t4、您上传的内容若被发现有侵犯第三方知识产权或者其他权利，第三方提出异议的时候，公司有权暂时删除相关的内容，待争议双方以和解、调解、仲裁、诉讼等方式解决争议后，公司根据确认的权属依据可依权利方申请以恢复或彻底删除相关内容。\n\t5、对于您上传到作业答案下载器的任何公开内容，您同意公司具有免费、永久、不可撤销、非独家的使用权。\n\t6、您在作业答案下载器获得的信息仅用于个人学习之目的使用，在没有得到权利人许可的情况下，您不得以复制、发送、传播等手段自行或提供给第三方用于商业目的使用，否则公司及权利人将追究您及相关当事人的法律责任。\n\t7、未经公司事先允许，禁止任何单位或个人使用任何设备或程序等形式非法地全部或部分监控、复制、抓取、引用、反向工程、反射编译等形式使用作业答案下载器所包含的内容（包括但不限于文字、图片、图形、音频或视频等）信息。否则，公司有权依法追究其法律责任。\n\t六、用户个人信息保护\n\t1、您同意公司按照本协议及我国个人信息保护的相关法律规定收集、使用、储存、分享和保护您的个人信息。\n\t2、公司对于收集到的有关您账号的相关信息将依法采取保密措施，不进行非法披露、出售、篡改或毁损。\n\t3、公司不会将您的注册信息提供给第三方，也不会用于其他非本协议约定之目的或用途，除非是以下情形：经您事先同意，向第三方披露；根据法律相关规定，或其他行政司法机构的要求，向相关机构披露；其他根据法律、法规或者政策应进行的披露。\n\t七、协议修改\n\t1、公司有权随时修改本协议的任何条款，届时将会直接在作业答案下载器上公布修改之后的协议内容，该公布视为公司已通知您修改本协议内容。\n\t2、您若不同意公司对本协议的修改，应当停止使用作业答案下载器。如您继续使用，则视为您接受公司对本协议所做的修改。\n\t八、其他规定\n\t1、本协议的签订、生效、履行、争议的解决均适用于中华人民共和国法律。\n\t2、本协议签订地为中华人民共和国北京市昌平区。\n\t3、本协议构成您与公司之间约定事项的完整协议，除本协议约定外，未赋予双方其他权利与义务。\n\t4、您与公司因本协议发生任何争议，应协商解决；协商不成时，任何一方均可向本协议签订地有管辖权的人民法院提起诉讼。\n\t5、本协议中任何条款部分或者全部无效，本协议的其他条款仍应有效并具有法律约束力。";
        
        //分割线
        UIView *grayline = [[UIView alloc] init];
        grayline.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.12];
        [whiteView addSubview:grayline];
        [grayline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(whiteView);
            make.size.mas_equalTo(CGSizeMake(0.84 * SCREEN_WIDTH, 0.5));
            make.bottom.mas_equalTo(whiteView).offset(-0.16 * SCREEN_WIDTH + 0.5);
        }];
        
        //同意按钮
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [whiteView addSubview:confirmBtn];
        [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(whiteView);
            make.size.mas_equalTo(CGSizeMake(0.78 * SCREEN_WIDTH, 0.78 * SCREEN_WIDTH * 0.144));
            make.bottom.mas_equalTo(whiteView).offset(-0.03 * SCREEN_WIDTH);
        }];
        confirmBtn.userInteractionEnabled = YES;
        confirmBtn.layer.cornerRadius = 0.78 * SCREEN_WIDTH * 0.144/2;
        confirmBtn.layer.masksToBounds = YES;
        confirmBtn.backgroundColor = [UIColor colorWithHexString:@"#4BB7FA"];
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [confirmBtn setTitleColor:whitecolor forState:UIControlStateNormal];
        [confirmBtn setTitle:@"我已阅读并同意此用户协议" forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        
//        UITapGestureRecognizer *confirmGesture = [[UITapGestureRecognizer alloc] init];
//        [confirmGesture addTarget:self action:@selector(confirm)];
//        [self.bgView addGestureRecognizer:confirmGesture];
    }
    return self;
}

- (void)confirm {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstInstalled"];
    self.hidden = YES;
    [self removeFromSuperview];
    
}

@end
