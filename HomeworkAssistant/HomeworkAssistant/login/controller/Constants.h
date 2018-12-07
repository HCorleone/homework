//
//  Constants.h
//  YoudaoDict
//
//  Created by wumw on 12-2-3.
//  Copyright (c) 2012年 Netease Youdao . All rights reserved.
//

#ifndef YoudaoDict_Constants_h
#define YoudaoDict_Constants_h

#define DebugLog debugLog
#ifdef DEBUG
#define debugLog(fmt, ...) do {                                            \
NSString* file = [NSString stringWithFormat:@"%s", __FILE__]; \
NSLog((@"%@(%d) " fmt), [file lastPathComponent], __LINE__, ##__VA_ARGS__); \
} while(0)

#define debugMethod() do {                                            \
NSString* file = [NSString stringWithFormat:@"%s", __FILE__]; \
NSLog((@"%@(%d) method:%s"), [file lastPathComponent], __LINE__, __PRETTY_FUNCTION__); \
} while(0)
#else
#define debugLog(...)
#define debugMethod()
#endif


// 这个版本号只是引导界面的版本号，不必要和程序版本号保持一致
//#define VERSION_CODE @"5.2.0"
#define VERSION_CODE @"6.3.0"
//首页版本号，若版本更新后对首页资源有变化，则增加这个值
#define INDEX_VERSION @"4.2.0"

#define DAILY_SENTENSE_BLOCK_NAME @"b0"
#define ENGLISH_NEWS_BLOCK_NAME @"b1"
#define IMAGE_CACHE_FOLDER @"image_cache"
#define COMMON_PARAM_STRING_FORMAT @"&client=mobile&keyfrom=%s&imei=%@&model=%@&deviceid=%@&mid=%@&username=%@&vendor=%@&userid=%@"
#define COMMON_PARAM_RET_JS_FORMAT @"g_commonParam = \"%@\";"


#ifdef DICT_NORMAL
#define APP_PUSH_ID @"1"
#else
#define APP_PUSH_ID @"2"
#endif


// 声明一个单例方法
#define DECLARE_SHARED_INSTANCE(className)  \
+ (className *)sharedInstance;

// 实现一个单例方法
#define IMPLEMENT_SHARED_INSTANCE(className)  \
+ (className *)sharedInstance { \
static className *sharedInstance = nil; \
@synchronized(self) { \
if (!sharedInstance) { \
sharedInstance = [[self alloc] init]; \
} \
} \
return sharedInstance; \
}

#define IS_EMPTY_STRING(str) ((str) == nil || [(str) isEmpty])

// push 以及首页 内容服务相关服务器设置
#define INFOLINE_URL_FORMAT_TEST @"http://dict.youdao.com/infoline?mode=preview&client=mobile&apiversion=3.0&lastId=%@&style=%@"
#define INFOLINE_URL_FORMAT @"http://dict.youdao.com/infoline?mode=publish&client=mobile&apiversion=3.0&lastId=%@&style=%@"

#define NEW_INDEX_PROXY_URL_FORMAT_TEST @"http://dict.youdao.com/infoline?mode=preview&date=%@&update=%@%@&apiversion=3.0&duplicate=true"
#define NEW_INDEX_PROXY_URL_FORMAT_VIDEO_TEST @"http://qt002x.corp.youdao.com:34567/infoline?mode=publish&date=%@&update=%@%@&apiversion=3.0&duplicate=true"
#define NEW_INDEX_PROXY_URL_FORMAT @"http://dict.youdao.com/infoline?mode=publish&date=%@&update=%@%@&apiversion=3.0&duplicate=true"

#ifdef DEBUG
#define DICT_PUSH_SETTING_SERVER    @"http://tb037x.corp.youdao.com:18080/"
#define REQUEST_LOG_SERVER          @"http://tb037x.corp.youdao.com:18080/"
#define INDEX_CONTENT_SERVER        @"http://dict.youdao.com/dp/"
#define XUETANG_CONTENT_SERVER      @"http://xue.corp.youdao.com/"


#define DICT_4_0_INDEX_CONTENT_SERVER_FORMAT @"http://dict.youdao.com/infoline?id=%@&client=push&mode=preview"
//    #define DICT_APPADS_SERVER @"http://qt002x.corp.youdao.com:8025/appwall?src=youdao%@"
#define DICT_APPADS_SERVER @"http://dict.youdao.com/appapi/360applist?src=youdao%@"

//#define DICT_MOBILE_RESOURCE_MANAGER_LIST_URL @"http://qt002x.corp.youdao.com:13131/files/list?product=dict&platform=iphone&version=%@&abtest=%@"
//#define DICT_MOBILE_RESOURCE_MANAGER_GET_URL @"http://qt002x.corp.youdao.com:13131/files/get?version=%@"
#define DICT_MOBILE_RESOURCE_MANAGER_LIST_URL @"http://dict.youdao.com/files/list?product=dict&platform=iphone&version=%@&abtest=%@"
#define DICT_MOBILE_RESOURCE_MANAGER_GET_URL @"http://dict.youdao.com/files/get?version=%@"

#else

#define DICT_PUSH_SETTING_SERVER    @"http://iospush.youdao.com/"
#define REQUEST_LOG_SERVER          @"http://iospush.youdao.com/"
#define INDEX_CONTENT_SERVER        @"http://dict.youdao.com/dp/"
#define XUETANG_CONTENT_SERVER      @"http://xue.youdao.com/"

#define DICT_4_0_INDEX_CONTENT_SERVER_FORMAT @"http://dict.youdao.com/infoline?id=%@&client=push"
#define DICT_APPADS_SERVER @"http://dict.youdao.com/appapi/360applist?src=youdao%@"


#define DICT_MOBILE_RESOURCE_MANAGER_LIST_URL @"http://dict.youdao.com/files/list?product=dict&platform=iphone&version=%@&abtest=%@"
#define DICT_MOBILE_RESOURCE_MANAGER_GET_URL @"http://dict.youdao.com/files/get?version=%@"

#endif

#define PUSH_SETTING_SERVER_FORMAT DICT_PUSH_SETTING_SERVER"api?method=storeToken&token=%@&pushType=%@&startPushTime=%d&endPushTime=%d&version=" KEYFROM"&app=" APP_PUSH_ID
#define REQUEST_LOG_URL_FORMAT REQUEST_LOG_SERVER"log?category=IOS_PUSH&url=%@%@&ispush=false"
#define REQUEST_LOG_URL_FROM_PUSH_FORMAT REQUEST_LOG_SERVER"log?category=IOS_PUSH&url=%@%@&ispush=true"

//  学堂每日一句接口
#define DAILY_SENTENCE_URL_FORMAT XUETANG_CONTENT_SERVER"back.s?method=tinyEnglishData&type=sentence&date=%@&id=%@"

#define LOG_SERVER @"http://dict.youdao.com/appapi/log?"

// 关闭引导界面的通知
#define kNotifyCloseIntroduction @"notifyCloseIntroduction"
#define kIntroductionVersion @"introductionVersion"

#define kIndexContainerDidAppear @"notifyIndexContainerDidAppear"

//启动页广告展示结束的通知
#define kLaunchingBootAdsShowingFinished @"kLaunchingBootAdsShowingFinished"

// 首页样式（信息流，看天下）版本号
#define kIndexVersion @"indexVersion"

#define kReceiveNotification @"kReceiveNotification"

//退出SimpleWebView
#define kSimpleWebViewDidDisappear @"kSimpleWebViewDidDisappear"

#define kScrollToTop @"kScrollToTop"

// schemeURL
// 目前只有云笔记的分享在用
#define APP_SCHEME_URL_NAME @"yddict"

// 播放mp3成功的通知
#define kPlayMp3Sucess @"kPlayMp3Sucess"

// 加载广告成功的通知
#define kLoadAdsSucess @"kLoadAdsSucess"

// 播放mp3 失败的通知
#define kPlayMp3Fail @"kPlayMp3Fail"

#define kGetDailySucess @"kGetDailySucess"

#define kDownloadImageSucess @"kDownloadImageSucess"

// 程序即将进入后台的通知
#define kDidEnterBackground @"kWillEnterBackGround"

// 程序即将进入前台的通知
#define kWillEnterForeground @"kWillEnterForeGround"

#define kSimpleWebviewDismiss @"kSimpleWebviewDismiss"

#define kGetHomepageContentSucess @"kGetHomepageContentSucess"

#define kGetPushDailySucess @"kGetPushDailySucess"

#define kGetLatestContentSucess @"kGetLatestContentSucess"

#define kIndexAdsUpdate @"kIndexAdsUpdate"

#define kResetShakeCount @"kResetShakeCount"

#define kAdYoudao   @"kAdYoudao"
#define kAdDomob    @"kAdDomob"
#define kAdInmobi   @"kAdInmobi"

// 最近一次剪切板查词的单词的key
#define DEFAULTS_KEY_FOR_LAST_PASTEBOARD_SEARCH @"kLastQueryFromPastBoard"

// 每日一句推送是否打开的key
#define DEFAULTS_KEY_FOR_PUSH_DAILY @"kPushDaily"

// 双语热闻是否打开的key
#define DEFAULTS_KEY_FOR_PUSH_NEWS @"kPushNews"

// 版本更新是否打开的key
#define DEFAULTS_KEY_FOR_PUSH_VERSIONS @"kPushVersions"

// 推送开始时间设置的key
#define DEFAULTS_KEY_FOR_PUSH_TIME_START @"kPushTimeStart"

// 推送结束时间设置的key
#define DEFAULTS_KEY_FOR_PUSH_TIME_END @"kPushTimeEnd"

// Device Token Key
#define DEFAULTS_KEY_FOR_DEVICE_TOKEN @"kPushDeviceToken"

// UNUSED
#define DEFAULTS_KEY_FOR_POST_PUSH_SETTING @"kPostPushSetting"

// 首页显示每日一句的权重
#define DEFAULTS_KEY_FOR_DAILT_WEIGHT @"kDailyWeight"

// 首页显示双语热闻的权重
#define DEFAULTS_KEY_FOR_NEWS_WEIGHT @"kNewsWeight"

// 首页显示推荐的权重
#define DEFAULTS_KEY_FOR_RECOMMENDATION_WEIGHT @"kRecommendationWeight"

// 是否显示 Feeds 的key
#define DEFAULTS_KEY_FOR_SHOW_FEEDS @"kShowFeeds"

// 是否显示系统推荐的key
#define DEFAULTS_KEY_FOR_SHOW_RECOMANDATION @"kShowRecomandation"

#define DEFAULTS_KEY_FOR_UPDATE_SHARER @"kUpdateSharer"

// ClientEventLogger上次更新的日期
#define DEFAULTS_KEY_FOR_LAST_UPDATE_DATE @"kLastUpdateDate"

// ClientEventLogger上次发送daily log的日期
#define DEFAULTS_KEY_FOR_LAST_POST_DAILY_LOG_DATE @"DEFAULTS_KEY_FOR_LAST_POST_DAILY_LOG_DATE"

#define kAdReappearKey  @"AdReappear"   // 广告关闭后再次出现的间隔
#define kAdRefreshKey   @"AdRefresh"    // 广告刷新的间隔
#define kDictAdReappearKey  @"DictAdReappear"   // 查词结果页广告关闭后再次出现的间隔

//彩蛋进入查词界面originY改变，退出查词恢复原值
#define DEFAULTS_EVENT_FOR_CHANGEEASTEREGGY @"kChangeEasterEggY"
#define DEFAULTS_EVENT_FOR_RESTOREEASTEREGGY @"kRestoreEasterEggY"

#define PUSH_TYPE_DAILY @"push_daily"
#define PUSH_TYPE_NEWS  @"push_news"
#define PUSH_TYPE_UPDATE @"push_update"

#define YD_NEWS_CELL_HEIGHT (85)//(78)//(87)
#define SENTENCE_MARGIN_LEFT (10)
#define SENTENCE_MARGIN_RIGHT (40)
#define SENTENCE_HEIGHT (20)

#define COLOR(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]


#define kRowDefaultHeight   44


#pragma mark -
#pragma mark 离线词典ID

#ifdef DICT_NORMAL
#define kUkPronunciationDictID @"yddict.voiceUK"
#else
#define kUkPronunciationDictID @"yddict.pro.voiceUK"
#endif

#ifdef DICT_NORMAL
#define kUsPronunciationDictID @"yddict.voiceUS"
#else
#define kUsPronunciationDictID @"yddict.pro.voiceUS"
#endif

#pragma mark -
#pragma mark DEFINE NOTIFICATIONS

#define YDDictVoiceUkViewedNotification @"dictVoiceUkViewed"
#define YDDictVoiceUsViewedNotification @"dictVoiceUsViewed"
#define YDNewItemViewed                 @"newItemViewed"

// NPS提交成功的通知
#define kNPSSuccessNotification             @"NPSSuccess"
// NPS提交失败的通知
#define kNPSFailureNotification             @"NPSFailure"
// feedback提交成功的通知
#define kFeedbackSuccessNotification        @"FeedbackSuccess"
// feedback提交失败的通知
#define kFeedbackFailureNotification        @"FeedbackFailure"
// 检查更新成功的通知
#define kCheckForUpdatesSuccessNotification @"FeedbackSuccess"
// 检查更新失败的通知
#define kCheckForUpdatesFailureNotification @"FeedbackFailure"




#pragma mark - 普通版和增强版不同的常量

#ifdef DICT_NORMAL
#pragma mark 普通版

#define APP_ID      @"326251330"

#else
#pragma mark 增强版

#define APP_ID      @"353115739"

#endif

// 在设置里面新功能标记为new，3.6的新功能为本地翻译LocalTrans
#define NEW_FEATURE_BADGE_VALUE @"LocalTrans"


#pragma mark - URL

// REVIEW_URL结尾的APP_ID会执行字符串替换，并非写错。
#define REVIEW_URL  @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=APP_ID"
#define APP_STORE_URL @"http://itunes.apple.com/app/idAPP_ID?mt=8"
#define HOME_URL    @"http://dict.youdao.com/"
#define DICT_WEIBO_URL  @"http://weibo.com/youdaocidian"

// 海量发音接口
#define GLOBAL_PRONOUNCE_CHECK_URL @"http://dict.youdao.com/mvoice?word=%@%@"
#define GLOBAL_PRONOUNCE_GET_URL @"http://dict.youdao.com/mvoice?method=getInfo&word=%@%@"
#define GLOBAL_PRONOUNCE_URL @"http://dict.youdao.com/mvoice?method=getVoice&id=%@"
#define GLOBAL_PRONOUNCE_VOTE_URL @"http://dict.youdao.com/mvoice?method=updateVote&word=%@&lang=%@&id=%@&type=%@%@"

// 看天下详情页接口
#ifdef DEBUG

//#define DICT_PINGLUN_SERVER @"http://zx.corp.youdao.com/pinglun/"
//#define DICT_PINGLUN_SERVER @"http://nc021x.corp.youdao.com:40709/pinglun/"
#define DICT_PINGLUN_SERVER @"http://dict.youdao.com/pinglun/"
#else
#define DICT_PINGLUN_SERVER @"http://dict.youdao.com/pinglun/"
#endif
#define DICT_PINGLUN_LIKE_URL DICT_PINGLUN_SERVER"act/update?product=%@&item=%@&floor=%@&act=%@&remove=%@" // 赞和踩操作
#define DICT_PINGLUN_QUERY_COMMENT_NUM DICT_PINGLUN_SERVER"act/info?product=%@&item=%@&floor=%@"

#define DICT_PINGLUN_ADD_COMMENT DICT_PINGLUN_SERVER"add?product=%@&item=%@&content=%@&reply=%@&notice=%@&keyfrom=%@&app=%@&callback=%@"
#define DICT_PINGLUN_ADD_COMMENT_NO_CONTENT DICT_PINGLUN_SERVER"add?product=%@&item=%@&reply=%@&notice=%@&keyfrom=%@&app=%@&callback=%@"

#define DICT_PINGLUN_LOAD_COMMENT DICT_PINGLUN_SERVER"list?product=%@&item=%@&startFloor=%@&len=%@&reverse=%@&safe=%@"

#define DICT_PINGLUN_HOT_COMMENT DICT_PINGLUN_SERVER"hot?product=%@&item=%@&len=%@&safe=%@"

#pragma mark - Keys of UserDefaults

#define CURRENT_VERSION_KEY @"kCurrentVersion"


#pragma mark - Keys in Dictionary

// 错误信息的key
#define kErrorInfo  @"errorInfo"

// appUpdateInfo的xml文件中的标签
#define kLatestVersion              @"latestversion"
#define kDownloadUrl                @"downloadurl"
#define kReleaseNote                @"release_note"
#define kEventCountToRate           @"event_count_to_rate"

// 网易应用和推荐应用的相关信息
#define kAppName            @"AppName"
#define kAppImgName         @"AppImgName"
#define kAppURLSchema       @"AppURLSchema"
#define kAppURL             @"AppURL"
#define kAppDes             @"AppDes"


#pragma mark - Added For 3.4

// 广告缩放常量
#define kYoudaoAdWidth  300.0f
#define kYoudaoAdHeight 38
#define kDomobAdWidth   320.0f
#define kInmobiAdWidth  320.0f
#define kInmobiAdHeight 50

#define kDomobAdScale   kYoudaoAdWidth / kDomobAdWidth
#define kInmobiAdScale  kYoudaoAdWidth / kInmobiAdWidth

#define kAdBottomEdgeHeight 8

#define kPageControlHeight  23

#define kAdCloseButtonWidth     23
#define kAdCloseButtonHeight    23
#define kAdCloseButtonEdge      10

// database schemas
#define SQL_CREATE_HISTORY_DB @"CREATE TABLE IF NOT EXISTS HISTORY (WORD TEXT PRIMARY KEY, DATE TEXT, TIME TEXT, RESULT TEXT)"

// 各语种的查词历史，主键word+language
#define SQL_CREATE_LANG_HISTORY_TABLE @"CREATE TABLE IF NOT EXISTS HISTORYWITHLANG (WORD TEXT, LANG TEXT, DATE TEXT, TIME TEXT, RESULT TEXT , jsonDefinition BLOB, PRIMARY KEY(WORD, LANG))"

#define SQL_CREATE_WIKIHISTORY_TABLE @"CREATE TABLE IF NOT EXISTS WIKIHISTORY (WORD TEXT PRIMARY KEY, DATE TEXT, TIME TEXT, RESULT BLOB)"

#define SQL_UPDATE_HISTORY @"UPDATE HISTORY SET DATE = '%@' , TIME = '%@', RESULT = '%@', jsonDefinition = ? WHERE WORD = '%@'"
#define SQL_UPDATE_HISTORY2 @"UPDATE HISTORY SET DATE = ? , TIME = ? WHERE WORD = ?"
#define SQL_UPDATE_HISTORYWITHLANG @"UPDATE HISTORY SET DATE = ? , TIME = ? WHERE WORD = ? AND LANG = ?"
#define SQL_S_SELECT_HISTORY_FORMAT @"SELECT * FROM HISTORY WHERE WORD = '%@'"

#define SQL_S_INSERT_HISTORY_FORMAY @"INSERT INTO HISTORY VALUES ('%@', '%@', '%@', '%@', ?)"

#define SQL_CREATE_WORDBOOK_DB      @"CREATE TABLE IF NOT EXISTS WORDBOOK (WORD TEXT, DATE TEXT, TIME TEXT, INTP TEXT, TS TEXT, OP TEXT, USERNAME TEXT, PRIMARY KEY(WORD,USERNAME))"
#define SQL_CREATE_USERINFO_DB      @"CREATE TABLE IF NOT EXISTS USERINFO (USERNAME TEXT, PASSWD TEXT)"
#define SQL_SELECT_USERINFO         @"SELECT * FROM USERINFO"
#define SQL_INSERT_USERINFO         @"INSERT INTO USERINFO VALUES ('', '')"
#define SQL_CREATE_USERTS           @"CREATE TABLE IF NOT EXISTS USERTS (USERNAME TEXT, TS TEXT)"
#define SQL_SELECT_USERTS           @"SELECT * FROM USERTS ORDER BY TS DESC"
#define SQL_CREATE_TAG_DB           @"CREATE TABLE IF NOT EXISTS TAGTABLE (WORD TEXT, TAG TEXT, USERNAME TEXT)"
#define SQL_CREATE_LASTLOGIN_DB     @"CREATE TABLE IF NOT EXISTS LASTLOGIN (USERNAME TEXT PRIMARY KEY)"
#define SQL_SELECT_LASTLOGIN        @"SELECT * FROM LASTLOGIN"
#define SQL_INSERT_LASTLOGIN_FORMAT @"INSERT INTO LASTLOGIN VALUES ('%@')"

#define SQL_CREATE_TRANS_HISTORY_DB @"CREATE TABLE IF NOT EXISTS TRANHISTORY (SENTENCE TEXT, RESULT TEXT, LANGUAGE INTEGER, DATE TEXT, TIME TEXT, PRIMARY KEY(SENTENCE,LANGUAGE));"

// colors
#define COLOR_LITTLE_GRAY           RGBACOLOR(182, 175, 162, 1)
#define COLOR_DEFAULT_BACKGROUND    RGBACOLOR(0xF0, 0xF0, 0xF0, 1)
#define COLOR_FONT_BLACK            RGBACOLOR(0x4e, 0x4c, 0x4a, 1)
#define COLOR_FONT_LIGHT_BLACK      RGBACOLOR(0xb6, 0xaf, 0xa2, 1)
#define COLOR_FONT_BLUE             RGBACOLOR(0xf6, 0x4c, 0x47, 1)
#define COLOR_DIVIDER               RGBACOLOR(0xb6, 0xaf, 0xa2, 1)
#define COLOR_ITEM_SELECTED_BG      RGBACOLOR(0xe0, 0xe0, 0xe0, 1)

// ERRORS
#define DICT_REQUEST_ERROR_DOMAIN      @"DictRequestErrorDomain"
//登录错误
#define LOGIN_STATE_DOMAIN             @"LoginStateDomain"
// authServer错误
#define AUTH_SERVER_DOMAIN             @"AuthServerDomain"

#define DICT_GENERAL_ERROR_DEMAIN      @"DictGeneralErrorDomain"

#define kAuthServerV2UserName       @"username"
#define kAuthServerV2UserID         @"userid"
#define kAuthServerV2PC             @"DICT-PC"
#define kAuthServerV2ECode          @"ecode"
#define kAuthServerV2TPCode         @"tpcode"
#define kAuthServerV2ImageUrl       @"imageurl_big"

// AuthServer
#define kAuthServerUser              @"user"
#define kAuthServerLogin             @"login"
#define kAuthServerPCI               @"pci"
#define kAuthServerPC                @"pc"
#define kAuthServerID                @"id"
#define kAuthServerName              @"name"
#define kAuthServerEmail             @"email"
#define kAuthServerAccessToken       @"ac"

// 登录的第三方，tp需要用到的参数
#ifdef DICT_NORMAL
#define kTPTSina            @"tsina-normal"
#define kTPURSToken         @"urstoken"
#define kTPURSCookie        @"urscookie"
#define kTPCqq              @"cqq-normal"
#define kTPWqq              @"wqq"
#else
#define kTPTSina            @"tsina"
#define kTPURSToken         @"urstoken"
#define kTPURSCookie        @"urscookie"
#define kTPCqq              @"cqq"
#define kTPWqq              @"wqq"
#endif

#define kSharerQQReturn     @"kSharerQQReturn"


typedef enum REQUEST_DICT_TYPE {
    REQUEST_DICT_TYPE_DICT_DETIAL,
    REQUEST_DICT_TYPE_WIKI,
    REQUEST_DICT_TYPE_WIKI_LIST
} REQUEST_DICT_TYPE;

// authServerV2的base url
#ifdef DEBUG
//#define kAuthServerV2BaseURL      @"note.youdao.com/login/acc/"
#define AUTH_SERVER_HOST    @"dict.youdao.com"
#define PRODUCT             @"DICT"
#define AUTH_LOGIN_PATH     @"/login/acc/"
#else
//#define kAuthServerV2BaseURL      @"note.youdao.com/login/acc/"
#define AUTH_SERVER_HOST    @"dict.youdao.com"
#define PRODUCT             @"DICT"
#define AUTH_LOGIN_PATH     @"/login/acc/"
#endif

#define AUTH_SERVER_CROSS_FIRST_URL @"http://dict.youdao.com/login/acc/se/cross/first?product=DICT"
#define AUTH_SERVER_CROSS_SECOND_URL @"http://dict.youdao.com/login/acc/cross/second?pci=%@&ru=%@"

// patch plist file name
#define kPatchPlistFileName @"patch.plist"
#define kPatchFileName      @"ec_patch.dat"

// 目前用的是andorid的id
#define YOUDAO_GA_TRACK_ID @"UA-39123478-1"

#define kYDBlackColor   RGBCOLOR(0x4e, 0x4c, 0x4a)
#define kYDGrayColor    RGBCOLOR(0xb6, 0xaf, 0xa2)
#define kYDBlueColor    RGBCOLOR(0x27, 0x9a, 0xec)

#define degreesToRadians(x)(x * M_PI / 180)

#pragma mark - CONFIGURATIONS
#define kEnablePatch    NO

#pragma mark - 常量
#pragma mark Wordbook

#pragma mark
#pragma mark - Block

#define weakSelf() __weak __typeof(self) weakSelf = self
#define blockSelf() __block __typeof(self) blockSelf = self

#endif

