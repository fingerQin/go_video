// 公共的struct定义。
// @author 寒冰
// @date 2013年12月15日。

package services

// 视频信息结构。
type VideoInfo struct {
	Videoid      int64
	Courseid     int64
	Videoname    string
	Duration     int
	Videourl     string
	Videoaddtime string
}

// 用户信息结构。
// 后续如果还有更多信息，可以调整此结构。
type UserInfo struct {
	Username string // 用户名
	Email    string // 邮箱
	Isactive int    // 激活状态
	Cash     int64  // 现金
	Gold     int64  // 金币
	Point    int64  // 学分
	Avatar   string // 头像
	Level    int64  // 等级
	Userid   int64  // 用户ID
	Realname string // 真实名称
}

// 课程笔记结构。
type CourseNote struct {
	Courseid   int64
	Coursename string
	Courseimg  string
	Noteid     int64
	Typeid     int
	Relateid   int64
	Userid     int64
	Addtime    string
	Lasttime   string
	Content    string
}

// 好友信息结构。
type FriendInfo struct {
	Friendid int64
	Userid   int64
	Username string
	Addtime  string
	Realname string
	Sex      int
	Avatar   string
	Level    int64
}

// 评论信息结构。
type CommentInfo struct {
	Commentid int64
	Username  string
	Realname  string
	Avatar    string
	Sex       int
	Userid    int64
	Relateid  int64
	Level     int
	Addtime   string
	Content   string
	Star      int
}

// 文章信息结构。
type NewsInfo struct {
	Newsid    int64
	Catid     int
	Title     string
	Userid    int64
	Username  string
	Realname  string
	Author    string
	Lasttime  string
	Addtime   string
	Iscomment int
	Isnotice  int
	Hits      int64
	Display   int
	Source    string
	Intro     string
	Content   string
	Star      int
	Appraise  int
}

// 热门标签。
type HotTag struct {
	Coursetag string
}

// 广告。
type IndexAd struct {
	LinkUrl string
	ImgUrl  string
	Target  string
}

// ======== 以下struct用于接收微信推送过来的信息 ==========
// 微信普通消息之文本消息。
type WxMessageText struct {
	ToUserName   string
	FromUserName string
	CreateTime   string
	MsgType      string
	Content      string
	MsgId        string
}

// 微信普通消息之图片消息。
type WxMessageImage struct {
	ToUserName   string
	FromUserName string
	CreateTime   string
	MsgType      string
	PicUrl       string
	MsgId        string
	MediaId      string
}

// 微信普通消息之语音消息。
type WxMessageVoice struct {
	ToUserName   string
	FromUserName string
	CreateTime   string
	MsgType      string
	MediaId      string
	Format       string
	Recognition  string
}

// 微信事件
type WxEventUnsubscribe struct {
	ToUserName   string
	FromUserName string
	CreateTime   string
	MsgType      string
	Event        string
	EventKey     string
}

// ===== 微信struct 结束 ======
