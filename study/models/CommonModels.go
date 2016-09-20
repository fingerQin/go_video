// 公共Model
// @author 寒冰
// @date 2013年11月20日

package models

import (
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	_ "github.com/go-sql-driver/mysql"
)

// COUNT 用于统计记录条数
type SqlData struct {
	Count int64
}

// v_user_course
type VUserCourse struct {
	Ucid     int64
	Userid   int64
	Courseid int64
	Addtime  string
}

// v_comment表
type VComment struct {
	Commentid int64
	Userid    int64
	Relateid  int64
	Typeid    int
	Addtime   string
	Star      int
	Content   string
}

// v_favorite表
type VFavorite struct {
	Favoriteid int64
	Courseid   int64
	Userid     int64
	Addtime    string
}

// v_category表
type VCategory struct {
	Catid     int `orm:"pk"`
	Catname   string
	Parentid  int
	Listorder int
}

// v_class表
type VClass struct {
	Classid   int `orm:"pk"`
	Classname string
	Listorder int
	Display   int
	Intro     string
}

// v_class_unit
type VClassUnit struct {
	Cuid       int64 `orm:"pk"`
	Classid    int
	Gradeid    int
	Unitname   string
	Semester   int
	Unitnumber int
	Listorder  int
	Videoids   string
	Paperids   string
	Intro      string
}

// v_config表
type VConfig struct {
	Cid     int `orm:"pk"`
	Ckey    string
	Cval    string
	Cremark string
}

// v_course表
type VCourse struct {
	Courseid    int64 `orm:"pk"`
	Hits        int64
	Recommend   int
	Display     int
	Courseimg   string
	Coursename  string
	Intro       string
	Remark      string
	Listorder   int
	Addtime     string
	Paperid     int64
	Teacher     string
	Buytimes    int64
	Lessontimes int64
	Star        int
	Appraise    int64
	Price       int
	Coursetag   string
}

// v_grade表
type VGrade struct {
	Gradeid   int `orm:"pk"`
	Gradename string
	Listorder int
	Display   int
	Intro     string
}

// v_note表
type VNote struct {
	Noteid   int64 `orm:"pk"`
	Typeid   int
	Relateid int64
	Userid   int64
	Addtime  string
	Lasttime string
	Content  string
}

// v_paper表
type VPaper struct {
	Pid     int64 `orm:"pk"`
	Ptitle  string
	Pintro  string
	Addtime string
	Display int
}

// v_paper_question表
type VPaperQuestion struct {
	Pqid      int64 `orm:"pk"`
	Pid       int64
	Qid       int64
	Subjectid int64
	Listorder int
	Addtime   string
}

// v_question表
type VQuestion struct {
	Qid       int64 `orm:"pk"`
	Qtitle    string
	Qsubtitle string
	Qtype     int
	Display   int
	Addtime   string
	Qoption   string
	Qanswer   string
}

// v_question_subject
type VQuestionSubject struct {
	Subjectid   int64
	Paperid     int64
	SubjectName string
	Listorder   int
}

// v_u_paper_answer表
type VUPaperAnswer struct {
	Upaid   int64 `orm:"pk"`
	Userid  int64
	Pid     int64
	Qid     int64
	Addtime string
	Answer  string
}

// v_login_history表
type VLoginHistory struct {
	Id        int64 `orm:"pk"`
	Userid    int
	Loginip   string
	LoginTime string
}

// v_user表
type VUser struct {
	Userid      int64 `orm:"pk"`
	Username    string
	Password    string
	Salt        string
	Realname    string
	Avatar      string
	Sex         int
	Point       int64
	Gold        int64
	Cash        int64
	Level       int64
	Email       string
	Isactive    int
	LoginCount  int
	Regtime     string
	Gradeid     int
	LastClassid int
	LastCuid    int64
	From        string
	Connectid   string
}

// v_video表
type VVideo struct {
	Videoid      int64 `orm:"pk"`
	Courseid     int64
	Videoname    string
	Duration     int64
	Videourl     string
	Videoaddtime string
}

// v_friend
type VFriend struct {
	Friendid int64
	Userid   int64
	Fuserid  int64
	Addtime  string
}

// v_news
type VNews struct {
	Newsid    int64
	Title     string
	Catid     int
	Userid    int64
	Author    string
	Lasttime  string
	Addtime   string
	Iscomment int
	Isnotice  int
	Hits      int64
	Display   int
	Source    string
	Intro     string
	Star      int
	Appraise  int
	Content   string
}

// v_link
type VLink struct {
	Linkid    int64
	Linkname  string
	Linkurl   string
	Display   int
	Listorder int
}

// v_order
type VOrder struct {
	Id       int64
	Orderno  string
	Userid   int64
	Username string
	Money    int64
	Status   int
	Paytype  int
	Addtime  string
	Remark   string
}

// v_code
type VCode struct {
	Codeid   int64
	Addtime  int64
	Typeid   int
	Valitime int64
	Isuse    int
	Userid   int64
	Codetext string
}

// v_uc_admins
type VUcAdmins struct {
	Uid      string
	Username string
}

// v_uc_applications
type VUcApplications struct {
	Appid       int
	Typeid      int
	Name        string
	Url         string
	Authkey     string
	Ip          string
	Apifilename string
	Charset     string
	Synlogin    int
}

// v_uc_members
type VUcMembers struct {
	Uid      int
	Username string
	Password string
	Email    string
	Salt     string
	Regdate  string
}

// v_uc_session
type VUcSession struct {
	Sessionid string
	Userid    int
	Data      string
}

// v_uc_settings
type VUcSettings struct {
	Ckey   string
	Cvalue string
}

func init() {
	orm.RegisterModel()

	// 读取配置文件
	dbuser := beego.AppConfig.String("mysqluser")
	dbpwd := beego.AppConfig.String("mysqlpass")
	dbhost := beego.AppConfig.String("mysqlhost")
	dbname := beego.AppConfig.String("mysqldb")
	dbport := beego.AppConfig.String("mysqlport")
	dbchart := beego.AppConfig.String("mysqlchart")
	//dbMaxIdle := beego.AppConfig.Int64("mysqlmaxIdle")
	//dbMaxConn := beego.AppConfig.Int64("mysqlmaxConn")

	dsn := dbuser + ":" + dbpwd + "@(" + dbhost + ":" + dbport + ")/" + dbname + "?charset=" + dbchart

	// 参数1 driverName
	// 参数2 数据库类型
	// 这个用来设置 driverName 对应的数据库类型
	// mysql / sqlite3 / postgres 这三种是默认已经注册过的，所以可以无需设置
	orm.RegisterDriver("mysql", orm.DR_MySQL)

	// 参数1 数据库的别名，用来在ORM中切换数据库使用
	// 参数2 driverName
	// 参数3 对应的链接字符串
	// 参数4(可选)  设置最大空闲连接
	// 参数5(可选)  设置最大数据库连接 (go >= 1.2)
	orm.RegisterDataBase("default", "mysql", dsn, 30, 50)
}
