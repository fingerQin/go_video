# 数据库文件
DROP DATABASE IF EXISTS gostudy;
CREATE DATABASE gostudy;

USE gostudy;

# 课程收藏表
DROP TABLE IF EXISTS `v_favorite`;
CREATE TABLE `v_favorite`(
	favoriteid INT(10) UNSIGNED AUTO_INCREMENT COMMENT '收藏ID',
	courseid INT(10) UNSIGNED NOT NULL COMMENT '课程ID',
	userid INT(10) UNSIGNED NOT NULL COMMENT '用户ID',
	addtime DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '收藏时间',
	PRIMARY KEY(favoriteid)
)ENGINE = MyISAM DEFAULT CHARSET UTF8 COMMENT '课程收藏表';
INSERT INTO `v_favorite` VALUES ('1', '1', '1', '2013-12-16 11:27:17');
INSERT INTO `v_favorite` VALUES ('2', '3', '1', '0000-00-00 00:00:00');
INSERT INTO `v_favorite` VALUES ('3', '2', '1', '0000-00-00 00:00:00');

# 分类表
# -- 视频或文档或试卷分类表，方便搜索
DROP TABLE IF EXISTS `v_category`;
CREATE TABLE `v_category`(
	catid SMALLINT(5) UNSIGNED AUTO_INCREMENT COMMENT '分类ID',
	catname VARCHAR(30) NOT NULL COMMENT '分类名称',
	parentid SMALLINT(5) UNSIGNED NOT NULL COMMENT '父分类ID',
	listorder SMALLINT(5) UNSIGNED NOT NULL DEFAULT '0' COMMENT '排序',
	PRIMARY KEY(catid)
)ENGINE = MyISAM DEFAULT CHARSET UTF8 COMMENT '分类表';
INSERT INTO v_category(catid, catname, parentid, listorder) VALUES(1001, '程序语言', '0', '0');
INSERT INTO v_category(catid, catname, parentid, listorder) VALUES(1002, 'PHP语言', '1001', '0');
INSERT INTO v_category(catid, catname, parentid, listorder) VALUES(1003, 'HTML&HTML5', '1001', '0');
INSERT INTO v_category(catid, catname, parentid, listorder) VALUES(1004, 'JavaScript', '1001', '0');

INSERT INTO v_category(catid, catname, parentid, listorder) VALUES(2001, '安全防御', '0', '0');
INSERT INTO v_category(catid, catname, parentid, listorder) VALUES(2002, '工具安全', '2001', '0');
INSERT INTO v_category(catid, catname, parentid, listorder) VALUES(2003, '系统安全', '2001', '0');
INSERT INTO v_category(catid, catname, parentid, listorder) VALUES(2004, 'WEB安全', '2001', '0');


# 视频表
# -- 视频表只管放学习视频，供课程调用播放
DROP TABLE IF EXISTS `v_video`;
CREATE TABLE `v_video`(
	videoid INT(10) UNSIGNED AUTO_INCREMENT COMMENT '主键、自增',
	courseid INT(10) UNSIGNED NOT NULL COMMENT '课程ID,关联v_course.courseid',
	videoname VARCHAR(255) NOT NULL COMMENT '视频名称',
	duration SMALLINT(3) UNSIGNED NOT NULL DEFAULT '0' COMMENT '视频时长',
	videourl VARCHAR(255) NOT NULL DEFAULT '' COMMENT '视频地址',
	videoaddtime DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '添加时间',
	PRIMARY KEY(videoid)
)ENGINE = MyISAM DEFAULT CHARSET UTF8 COMMENT '视频表';

# 视频笔记
# -- 视频笔记等于是对视频做一个知识点自我总结，方便知识点回顾。
DROP TABLE IF EXISTS `v_note`;
CREATE TABLE `v_note`(
	noteid INT(10) UNSIGNED AUTO_INCREMENT COMMENT '视频笔记',
	typeid TINYINT(1) NOT NULL DEFAULT '0' COMMENT '笔记类型:1视频、2课程、3文档、4试题',
	relateid INT(10) UNSIGNED NOT NULL COMMENT '关联ID，如：视频ID、课程ID、文档ID、试题ID', 
	userid INT(10) UNSIGNED NOT NULL COMMENT '用户ID',
	addtime DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '添加时间',
	lasttime DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '最后更新时间',
	content TEXT COMMENT '笔记内容',
	PRIMARY KEY(noteid),
	KEY(relateid)
)ENGINE = MyISAM DEFAULT CHARSET UTF8 COMMENT '视频笔记';

# 课程表
# -- 每课程（一个或多个视频）可以设置练习来强化自己。
# -- 视频的ID是一串特定的格式，即视频ID中间用半角逗号（,）分隔。
DROP TABLE IF EXISTS `v_course`;
CREATE TABLE `v_course`(
	courseid INT(10) UNSIGNED AUTO_INCREMENT COMMENT '课程ID',
	hits INT(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '课程浏览次数',
	recommend TINYINT(1) NOT NULL DEFAULT '0' COMMENT '是否是推荐课程:0否、1是',
	display TINYINT(1) NOT NULL DEFAULT '1' COMMENT '课程显示状态：1显示、0隐藏',
	courseimg VARCHAR(255) NOT NULL DEFAULT '' COMMENT '课程图片地址',
	coursename VARCHAR(255) NOT NULL DEFAULT '' COMMENT '课程名称',
	intro VARCHAR(1000) NOT NULL DEFAULT '' COMMENT '课程介绍',
	remark VARCHAR(1000) NOT NULL DEFAULT '' COMMENT '视频备注:如视频出处、版权、以及相关资料',
	listorder SMALLINT(5) UNSIGNED NOT NULL DEFAULT '0' COMMENT '排序',
	addtime DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '添加时间',
	paperid INT(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '试卷ID，关联v_paper.pid',
	teacher VARCHAR(10) NOT NULL DEFAULT '' COMMENT '讲师姓名/讲座人',
	buytimes INT(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '购买次数',
	lessontimes INT(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '课程数/视频数',
	star TINYINT(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '星星',
	appraise INT(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '评价次数',
	price SMALLINT(5) UNSIGNED NOT NULL DEFAULT '0' COMMENT '价格，单位（元）',
	coursetag VARCHAR(255) NOT NULL DEFAULT '' COMMENT '课程标签',
	PRIMARY KEY(courseid)
)ENGINE = MyISAM DEFAULT CHARSET UTF8 COMMENT '课程表';
INSERT INTO `v_course` (courseid, hits, recommend, courseimg, coursename, intro, remark, listorder, addtime, paperid, teacher) VALUES (NULL, '0', '1', '/static/Upload/VideoImgs/201312/51a57ef025c86.png', '细说Javascript 与 JQuery', '大家在看到很多很炫的网页的时候是否觉得很酷呢, 大部分的网站需要多少js（js是javascript的简称，以下简称js）呢，自己学建站是否需要学会js呢？\r\n常用的js有那些呢？这些这节统统告诉你，让你在建网站过程中解决大部分js问题。', '', '0', '2013-12-16 09:10:52', '0', '寒冰');
INSERT INTO `v_course` (courseid, hits, recommend, courseimg, coursename, intro, remark, listorder, addtime, paperid, teacher) VALUES (NULL, '0', '1', '/static/Upload/VideoImgs/201312/51d105ebe512b.png', 'PHP模板引擎Smarty 3系列', '大家在看到很多很炫的网页的时候是否觉得很酷呢, 大部分的网站需要多少js（js是javascript的简称，以下简称js）呢，自己学建站是否需要学会js呢？', '', '0', '0000-00-00 00:00:00', '0', '寒冰');
INSERT INTO `v_course` (courseid, hits, recommend, courseimg, coursename, intro, remark, listorder, addtime, paperid, teacher) VALUES (NULL, '0', '1', '/static/Upload/VideoImgs/201312/51ed4b2132771.png', 'thinkphp 3.1.2 系列视频教程', '大家在看到很多很炫的网页的时候是否觉得很酷呢, 大部分的网站需要多少js（js是javascript的简称，以下简称js）呢，自己学建站是否需要学会js呢？', '', '0', '0000-00-00 00:00:00', '0', '寒冰');
INSERT INTO `v_course` (courseid, hits, recommend, courseimg, coursename, intro, remark, listorder, addtime, paperid, teacher) VALUES (NULL, '0', '1', '/static/Upload/VideoImgs/201312/51ed4dbf60478.png', 'JAVA零基础入门编程', '大家在看到很多很炫的网页的时候是否觉得很酷呢, 大部分的网站需要多少js（js是javascript的简称，以下简称js）呢，自己学建站是否需要学会js呢？', '', '0', '0000-00-00 00:00:00', '0', '寒冰');
INSERT INTO `v_course` (courseid, hits, recommend, courseimg, coursename, intro, remark, listorder, addtime, paperid, teacher) VALUES (NULL, '0', '1', '/static/Upload/VideoImgs/201312/510b7ea4b36bc.jpg', 'android 小案例跟我学', '大家在看到很多很炫的网页的时候是否觉得很酷呢, 大部分的网站需要多少js（js是javascript的简称，以下简称js）呢，自己学建站是否需要学会js呢？', '', '0', '0000-00-00 00:00:00', '0', '寒冰');
INSERT INTO `v_course` (courseid, hits, recommend, courseimg, coursename, intro, remark, listorder, addtime, paperid, teacher) VALUES (NULL, '0', '1', '/static/Upload/VideoImgs/201312/510b80f532699.jpg', 'PHP微信公众平台开发接口', '大家在看到很多很炫的网页的时候是否觉得很酷呢, 大部分的网站需要多少js（js是javascript的简称，以下简称js）呢，自己学建站是否需要学会js呢？', '', '0', '0000-00-00 00:00:00', '0', '寒冰');
INSERT INTO `v_course` (courseid, hits, recommend, courseimg, coursename, intro, remark, listorder, addtime, paperid, teacher) VALUES (NULL, '0', '0', '/static/Upload/VideoImgs/201312/515a890f5f8d7.jpg', 'PHP 十天快速入门教程', '大家在看到很多很炫的网页的时候是否觉得很酷呢, 大部分的网站需要多少js（js是javascript的简称，以下简称js）呢，自己学建站是否需要学会js呢？', '', '0', '0000-00-00 00:00:00', '0', '寒冰');
INSERT INTO `v_course` (courseid, hits, recommend, courseimg, coursename, intro, remark, listorder, addtime, paperid, teacher) VALUES (NULL, '0', '0', '/static/Upload/VideoImgs/201312/5174ea297420d.png', 'HTML5 视频教程（入门）', '大家在看到很多很炫的网页的时候是否觉得很酷呢, 大部分的网站需要多少js（js是javascript的简称，以下简称js）呢，自己学建站是否需要学会js呢？', '', '0', '0000-00-00 00:00:00', '0', '寒冰');
INSERT INTO `v_course` (courseid, hits, recommend, courseimg, coursename, intro, remark, listorder, addtime, paperid, teacher) VALUES (NULL, '0', '0', '/static/Upload/VideoImgs/201312/51594ddeb1ef6.jpg', '新浪微博接口API开发', '大家在看到很多很炫的网页的时候是否觉得很酷呢, 大部分的网站需要多少js（js是javascript的简称，以下简称js）呢，自己学建站是否需要学会js呢？', '', '0', '0000-00-00 00:00:00', '0', '寒冰');
INSERT INTO `v_course` (courseid, hits, recommend, courseimg, coursename, intro, remark, listorder, addtime, paperid, teacher) VALUES (NULL, '0', '0', '/static/Upload/VideoImgs/201312/510695ac8c7a6.jpg', 'PHP GD2库 图形图像的处理', '大家在看到很多很炫的网页的时候是否觉得很酷呢, 大部分的网站需要多少js（js是javascript的简称，以下简称js）呢，自己学建站是否需要学会js呢？', '', '0', '0000-00-00 00:00:00', '0', '寒冰');
INSERT INTO `v_course` (courseid, hits, recommend, courseimg, coursename, intro, remark, listorder, addtime, paperid, teacher) VALUES (NULL, '0', '0', '/static/Upload/VideoImgs/201312/515707a774778.png', 'PHP常用模块的开发学习', '大家在看到很多很炫的网页的时候是否觉得很酷呢, 大部分的网站需要多少js（js是javascript的简称，以下简称js）呢，自己学建站是否需要学会js呢？', '', '0', '0000-00-00 00:00:00', '0', '寒冰');
INSERT INTO `v_course` (courseid, hits, recommend, courseimg, coursename, intro, remark, listorder, addtime, paperid, teacher) VALUES (NULL, '0', '0', '/static/Upload/VideoImgs/201312/515935b725650.jpg', 'PHP模板引擎Smarty 2.x', '大家在看到很多很炫的网页的时候是否觉得很酷呢, 大部分的网站需要多少js（js是javascript的简称，以下简称js）呢，自己学建站是否需要学会js呢？', '', '0', '0000-00-00 00:00:00', '0', '寒冰');
INSERT INTO `v_course` (courseid, hits, recommend, courseimg, coursename, intro, remark, listorder, addtime, paperid, teacher) VALUES (NULL, '0', '0', '/static/Upload/VideoImgs/201312/518760dab4733.jpg', 'Android 快速入门开发教程', 'Android是一种基于Linux的自由及开放源代码的操作系统，主要使用于移动设备，如智能手机和平板电脑，由Google公司和开放手机联盟领导及开发。尚未有统一中文名称，中国大陆地区较多人使用“安卓”或“安致”。Android操作系统最初由Andy Rubin开发，主要支持手机。2005年8月由Google收购注资。2007年11月，Google与84家硬件制造商、软件开发商及电信营运商组建开放手机联盟共同研发改良Android系统。随后Google以Apache开源许可证的授权方式，发布了Android的源代码。第一部Android智能手机发布于2008年10月。Android逐渐扩展到平板电脑及其他领域上，如电视、数码相机、游戏机等。2011年第一季度，Android在全球的市场份额首次超过塞班系统，跃居全球第一。 2012年11月数据显示，Android占据全球智能手机操作系统市场76%的份额', '', '0', '0000-00-00 00:00:00', '0', '寒冰');
INSERT INTO `v_course` (courseid, hits, recommend, courseimg, coursename, intro, remark, listorder, addtime, paperid, teacher) VALUES (NULL, '0', '0', '/static/Upload/VideoImgs/201312/5106953e96b54.jpg', 'XHTML DIV CSS 快速入门', '大家在看到很多很炫的网页的时候是否觉得很酷呢, 大部分的网站需要多少js（js是javascript的简称，以下简称js）呢，自己学建站是否需要学会js呢？', '', '0', '0000-00-00 00:00:00', '0', '寒冰');
INSERT INTO `v_course` (courseid, hits, recommend, courseimg, coursename, intro, remark, listorder, addtime, paperid, teacher) VALUES (NULL, '0', '0', '/static/Upload/VideoImgs/201312/5159383b0e97c.jpg', 'Linux 命令与服务器快速入门', '大家在看到很多很炫的网页的时候是否觉得很酷呢, 大部分的网站需要多少js（js是javascript的简称，以下简称js）呢，自己学建站是否需要学会js呢？', '', '0', '0000-00-00 00:00:00', '0', '寒冰');
INSERT INTO `v_course` (courseid, hits, recommend, courseimg, coursename, intro, remark, listorder, addtime, paperid, teacher) VALUES (NULL, '0', '0', '/static/Upload/VideoImgs/201312/516055066d43a.jpg', 'IOS 开发视频教程objective-c', '大家在看到很多很炫的网页的时候是否觉得很酷呢, 大部分的网站需要多少js（js是javascript的简称，以下简称js）呢，自己学建站是否需要学会js呢？', '', '0', '0000-00-00 00:00:00', '0', '寒冰');
INSERT INTO `v_course` (courseid, hits, recommend, courseimg, coursename, intro, remark, listorder, addtime, paperid, teacher) VALUES (NULL, '0', '0', '/static/Upload/VideoImgs/201312/5159326825136.jpg', 'javascript & jQuery 入门课程', '大家在看到很多很炫的网页的时候是否觉得很酷呢, 大部分的网站需要多少js（js是javascript的简称，以下简称js）呢，自己学建站是否需要学会js呢？', '', '0', '0000-00-00 00:00:00', '0', '寒冰');

# 用户课程
# -- 通过购买获得的课程。
DROP TABLE IF EXISTS `v_user_course`;
CREATE TABLE `v_user_course`(
	ucid INT(10) UNSIGNED AUTO_INCREMENT COMMENT '主键',
	userid INT(10) UNSIGNED NOT NULL COMMENT '用户ID',
	courseid INT(10) UNSIGNED NOT NULL COMMENT '课程ID',
	addtime DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '添加时间',
	PRIMARY KEY(ucid),
	KEY(userid),
	KEY(courseid)
)ENGINE = MyISAM DEFAULT CHARSET UTF8 COMMENT '用户课程';


# 配置表
# -- 保存系统的一些配置信息，如提醒时间、提醒人等
DROP TABLE IF EXISTS `v_config`;
CREATE TABLE `v_config`(
	cid SMALLINT(3) UNSIGNED AUTO_INCREMENT COMMENT '主键、自增',
	ckey VARCHAR(50) NOT NULL COMMENT '配置键名',
	cval VARCHAR(1000) NOT NULL COMMENT '配置键值',
	cremark VARCHAR(50) NOT NULL DEFAULT '' COMMENT '配置备注说明',
	PRIMARY KEY(cid)
)ENGINE = MyISAM DEFAULT CHARSET UTF8 COMMENT '配置表';
-- ----------------------------
-- Records of v_config
-- ----------------------------
INSERT INTO `v_config` VALUES ('1', 'index_ad', '[{\"LinkUrl\":\"http://www.meitianbikan.com/Index/VideoView?courseid=22\",\"ImgUrl\":\"/static/Upload/Poster/201401/1390802480917618462.png\",\"Target\":\"\"},{\"LinkUrl\":\"http://www.meitianbikan.com/Index/VideoView?courseid=20\",\"ImgUrl\":\"/static/Upload/Poster/201401/1390802480918237910.png\",\"Target\":\"\"},{\"LinkUrl\":\"http://www.meitianbikan.com/Index/VideoView?courseid=21\",\"ImgUrl\":\"/static/Upload/Poster/201401/1390802480918621018.png\",\"Target\":\"\"},{\"LinkUrl\":\"http://www.meitianbikan.com/Index/VideoView?courseid=18\",\"ImgUrl\":\"/static/Upload/Poster/201401/1390816361915832060.png\",\"Target\":\"\"},{\"LinkUrl\":\"http://www.meitianbikan.com\",\"ImgUrl\":\"/static/Upload/Poster/201401/1390816361933952515.png\",\"Target\":\"\"}]', '首页轮换广告');
INSERT INTO `v_config` VALUES ('2', 'video_start_ad', '{\"LinkUrl\":\"http://www.meitianbikan.com\",\"ImgUrl\":\"/static/Upload/Poster/201401/1390707581781883476.png\",\"Target\":\"\"}', '视频播放开始时的广告');
INSERT INTO `v_config` VALUES ('3', 'sponsor_ad', '{\"LinkUrl\":\"http://www.meitianbikan.com\",\"ImgUrl\":\"/static/Upload/Poster/201401/1390816361934670318.jpg\",\"Target\":\"\"}', '赞助商推荐广告');
INSERT INTO `v_config` VALUES ('4', 'cooperation_ad', '{\"LinkUrl\":\"http://www.meitianbikan.com\",\"ImgUrl\":\"/static/Upload/Poster/201401/1390816361935076383.jpg\",\"Target\":\"\"}', '合作推荐广告');


# 用户表
# -- 年级ID用来记录当前用户的所在层次
DROP TABLE IF EXISTS `v_user`;
CREATE TABLE `v_user`(
	userid INT(10) UNSIGNED AUTO_INCREMENT COMMENT '主键、自增',
	username VARCHAR(20) NOT NULL COMMENT '账号',
	password VARCHAR(32) NOT NULL COMMENT '密码',
	salt CHAR(6) NOT NULL COMMENT '盐',
	realname VARCHAR(20) NOT NULL COMMENT '真实姓名',
	avatar VARCHAR(255) NOT NULL DEFAULT '' COMMENT '头像地址',
	sex TINYINT(1) NOT NULL DEFAULT '1' COMMENT '性别：1男、2女',
	point INT(10) NOT NULL DEFAULT '0' COMMENT '学分',
	gold INT(10) NOT NULL DEFAULT '0' COMMENT '金币',
	cash INT(10) NOT NULL DEFAULT '0' COMMENT '现金',
	level INT(10) NOT NULL DEFAULT '0' COMMENT '等级',
	email VARCHAR(255) NOT NULL DEFAULT '' COMMENT '邮箱地址',
	isactive TINYINT(1) NOT NULL DEFAULT '0' COMMENT '邮箱激活：0否、1是',
	login_count SMALLINT(3) UNSIGNED NOT NULL DEFAULT '0' COMMENT '登录次数',
	regtime DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '添加时间',
	gradeid SMALLINT(3) UNSIGNED NOT NULL DEFAULT '0' COMMENT '年级ID',
	last_classid SMALLINT(3) UNSIGNED NOT NULL DEFAULT '0' COMMENT '最后学习的科目ID',
	last_cuid INT(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '最后学习的单元',
	`from` VARCHAR(10) NOT NULL DEFAULT '' COMMENT '来源：qq、sina',
	connectid VARCHAR(255) NOT NULL DEFAULT '' COMMENT 'qq或sina的connectid，与from连用',
	PRIMARY KEY(userid),
	KEY(username),
	KEY(isactive)
)ENGINE = MyISAM DEFAULT CHARSET UTF8 COMMENT '用户表';
INSERT INTO v_user(`userid`, username, password, salt, realname, avatar, sex, login_count, regtime, gradeid, last_classid, last_cuid)
VALUES(NULL, 'adminme', '4e9ad92bc7d8a0b486cd33efae9f0c76', 'WM50hC', '创始人', '/static/themes/default/images/t1_user.jpg', '1', '0', '2013-12-02 22:16:46', '0', '0', '0'); 

# 登录历史表
DROP TABLE IF EXISTS `v_login_history`;
CREATE TABLE `v_login_history`(
	id INT(10) UNSIGNED AUTO_INCREMENT COMMENT '主键、自增',
	userid SMALLINT(3) UNSIGNED NOT NULL COMMENT '用户ID',
	loginip VARCHAR(15) NOT NULL DEFAULT '' COMMENT '登录IP',
	login_time DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '添加时间',
	PRIMARY KEY(id)
)ENGINE = MyISAM DEFAULT CHARSET UTF8 COMMENT '登录历史表';

# 题库表
# -- 题库表，保存题目供试卷调用。
DROP TABLE IF EXISTS `v_question`;
CREATE TABLE `v_question`(
	qid INT(10) UNSIGNED AUTO_INCREMENT COMMENT '主键、自增',
	qtitle VARCHAR(255) NOT NULL COMMENT '题目',
	qsubtitle VARCHAR(255) NOT NULL COMMENT '子标题',
	qtype TINYINT(1) NOT NULL COMMENT '题目类型：1单选、2多选、3判断、4填空、5解答、6作文',
	display TINYINT(1) NOT NULL DEFAULT '0' COMMENT '显示：1是、0否',
	addtime DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '添加时间',
	qoption TEXT COMMENT '题目选项',
	qanswer TEXT COMMENT '答案',
	PRIMARY KEY(qid)
)ENGINE = MyISAM DEFAULT CHARSET UTF8 COMMENT '题库表';

# 试卷题目表
# -- 题目表
DROP TABLE IF EXISTS `v_question_subject`;
CREATE TABLE `v_question_subject`(
	subjectid INT(10) UNSIGNED AUTO_INCREMENT COMMENT '题目ID',
	paperid INT(10) UNSIGNED NOT NULL COMMENT '试卷ID',
	subject_name VARCHAR(50) NOT NULL COMMENT '标题',
	listorder SMALLINT(3) UNSIGNED NOT NULL DEFAULT '0' COMMENT '排序',
	PRIMARY KEY(subjectid)
)ENGINE = MyISAM DEFAULT CHARSET UTF8 COMMENT '试卷题目表';

# 试卷表
# -- 试卷表供单元使用，做为测试使用。
# -- 视频对应的试卷ID用来做训练使用。
DROP TABLE IF EXISTS `v_paper`;
CREATE TABLE `v_paper`(
	pid INT(10) UNSIGNED AUTO_INCREMENT COMMENT '试卷ID',	
	ptitle VARCHAR(255) NOT NULL COMMENT '试卷标题',
	pintro VARCHAR(1000) NOT NULL COMMENT '试卷介绍',
	addtime DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '添加时间',
	display TINYINT(1) NOT NULL DEFAULT '0' COMMENT '状态：1显示、0隐藏',
	PRIMARY KEY(pid),
	KEY(ptitle)
)ENGINE = MyISAM DEFAULT CHARSET UTF8 COMMENT '试卷表';

# 试卷试题表
# -- 试卷包含的试题
DROP TABLE IF EXISTS `v_paper_question`;
CREATE TABLE `v_paper_question`(
	pqid INT(10) UNSIGNED AUTO_INCREMENT COMMENT '主键、自增',
	pid INT(10) UNSIGNED NOT NULL COMMENT '试卷ID,关联v_paper.pid',
	subjectid INT(10) UNSIGNED COMMENT '题目ID,关联v_question_subject.subjectid',
	qid INT(10) UNSIGNED NOT NULL COMMENT '试题ID,关联v_question.qid',
	listorder SMALLINT(5) UNSIGNED NOT NULL DEFAULT '0' COMMENT '排序',
	addtime DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '添加时间',
	PRIMARY KEY(pqid),
	KEY(pid, qid)
)ENGINE = MyISAM DEFAULT CHARSET UTF8 COMMENT '试卷试题表';

# 用户试卷答案记录表
# 用户测试的时候的答案保存位置
# 与训练模式的答案保存地方不一样，分表好维护。
DROP TABLE IF EXISTS `v_u_paper_answer`;
CREATE TABLE `v_u_paper_answer`(
	upaid INT(10) UNSIGNED AUTO_INCREMENT COMMENT '主键、自增',
	userid INT(10) UNSIGNED NOT NULL COMMENT '用户ID，关联v_user.userid',
	pid INT(10) UNSIGNED NOT NULL COMMENT '试卷ID,关联v_paper.pid',
	qid INT(10) UNSIGNED NOT NULL COMMENT '试卷ID,关联v_question.qid',
	addtime DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '添加时间',
	answer TEXT COMMENT '答案，可采用JSON保存答案',
	PRIMARY KEY(upaid),
	KEY(userid,pid,qid)
)ENGINE = MyISAM DEFAULT CHARSET UTF8 COMMENT '用户试卷答案记录表';

# 科目表
DROP TABLE IF EXISTS `v_class`;
CREATE TABLE `v_class`(
	classid SMALLINT(3) UNSIGNED COMMENT '科目ID',
	classname VARCHAR(50) NOT NULL COMMENT '科目名称',
	listorder SMALLINT(5) UNSIGNED NOT NULL DEFAULT '0' COMMENT '排序',
	display TINYINT(1) NOT NULL DEFAULT '0' COMMENT '显示：1显示、0隐藏。用于删除',
	intro TEXT COMMENT '科目介绍',
	PRIMARY KEY(classid)
)ENGINE = MyISAM DEFAULT CHARSET UTF8 COMMENT '科目表';
INSERT INTO v_class (classid, classname, listorder, display, intro) VALUES(100, '语文', '0', '1', '语文');
INSERT INTO v_class (classid, classname, listorder, display, intro) VALUES(101, '英语', '0', '1', '英语');
INSERT INTO v_class (classid, classname, listorder, display, intro) VALUES(103, '数学', '0', '1', '数学');

# 年级表
DROP TABLE IF EXISTS `v_grade`;
CREATE TABLE `v_grade`(
	gradeid SMALLINT(3) UNSIGNED COMMENT '年级ID',
	gradename VARCHAR(50) NOT NULL COMMENT '年级名称',
	listorder SMALLINT(5) UNSIGNED NOT NULL DEFAULT '0' COMMENT '排序',
	display TINYINT(1) NOT NULL DEFAULT '0' COMMENT '显示：1显示、0隐藏。用于删除',
	intro TEXT COMMENT '年级介绍',
	PRIMARY KEY(gradeid)
)ENGINE = MyISAM DEFAULT CHARSET UTF8 COMMENT '科目表';
INSERT INTO v_grade (gradeid, gradename, listorder, display, intro) VALUES('100', '幼儿园', '0', '1', '幼儿园');
INSERT INTO v_grade (gradeid, gradename, listorder, display, intro) VALUES('101', '学前班', '0', '1', '学前班');
INSERT INTO v_grade (gradeid, gradename, listorder, display, intro) VALUES('102', '一年级', '0', '1', '一年级');
INSERT INTO v_grade (gradeid, gradename, listorder, display, intro) VALUES('103', '二年级', '0', '1', '二年级');
INSERT INTO v_grade (gradeid, gradename, listorder, display, intro) VALUES('104', '三年级', '0', '1', '三年级');
INSERT INTO v_grade (gradeid, gradename, listorder, display, intro) VALUES('105', '四年级', '0', '1', '四年级');
INSERT INTO v_grade (gradeid, gradename, listorder, display, intro) VALUES('106', '五年级', '0', '1', '五年级');
INSERT INTO v_grade (gradeid, gradename, listorder, display, intro) VALUES('107', '六年级', '0', '1', '六年级');
INSERT INTO v_grade (gradeid, gradename, listorder, display, intro) VALUES('108', '七年级', '0', '1', '七年级');
INSERT INTO v_grade (gradeid, gradename, listorder, display, intro) VALUES('109', '八年级', '0', '1', '八年级');
INSERT INTO v_grade (gradeid, gradename, listorder, display, intro) VALUES('110', '九年级', '0', '1', '九年级');
INSERT INTO v_grade (gradeid, gradename, listorder, display, intro) VALUES('111', '高中一年级', '0', '1', '高中一年级');
INSERT INTO v_grade (gradeid, gradename, listorder, display, intro) VALUES('112', '高中二年级', '0', '1', '高中二年级');
INSERT INTO v_grade (gradeid, gradename, listorder, display, intro) VALUES('113', '高中三年级', '0', '1', '高中三年级');

# -- 科目、年级、科目单元综合信息表
# -- 后期设置一条记录对应一个知识点
DROP TABLE IF EXISTS `v_class_unit`;
CREATE TABLE `v_class_unit`(
	cuid INT(10) UNSIGNED AUTO_INCREMENT COMMENT '主键、自增',
	classid SMALLINT(3) UNSIGNED NOT NULL COMMENT '科目ID，关联v_class.classid',
	gradeid SMALLINT(3) UNSIGNED NOT NULL COMMENT '年级ID：关联v_grade.gradeid',
	unitname VARCHAR(255) NOT NULL DEFAULT '' COMMENT '单元名称',
	semester TINYINT(1) NOT NULL DEFAULT '1' COMMENT '学期：1上学期、2下学期',
	unitnumber SMALLINT(5) UNSIGNED NOT NULL COMMENT '单元：1、2、3...',
	listorder SMALLINT(5) UNSIGNED NOT NULL DEFAULT '0' COMMENT '排序',
	videoids VARCHAR(500) NOT NULL DEFAULT '' COMMENT '视频ID：格式：1,2,3',
	paperids VARCHAR(500) NOT NULL DEFAULT '' COMMENT '试卷ID：格式：1,2,3',
	intro TEXT COMMENT '单元介绍',
	PRIMARY KEY(cuid)
)ENGINE = MyISAM DEFAULT CHARSET UTF8 COMMENT '科目年级单元表';
INSERT INTO v_class_unit(cuid, classid, gradeid, unitname, semester, unitnumber, listorder, videoids, paperids, intro)
VALUES(NULL, 100, 100, '语言第一单元', 1, '1', 0, '1,2', '0', '单元');

# 评论表
DROP TABLE IF EXISTS `v_comment`;
CREATE TABLE `v_comment`(
	commentid INT(10) UNSIGNED AUTO_INCREMENT COMMENT '评论ID',
	userid INT(10) UNSIGNED NOT NULL COMMENT '用户ID',
	touserid INT(10) UNSIGNED NOT NULL COMMENT '留言ID:即留言类型时，填写被留言的ID。',
	relateid INT(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '关联ID：视频ID、课程ID、留言与反馈为0、文章ID',
	typeid TINYINT(1) NOT NULL DEFAULT '0' COMMENT '评论类别：1视频、2课程、3留言、4反馈、5文章评论',
	star TINYINT(1) NOT NULL DEFAULT '1' COMMENT '评星',
	addtime DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '添加时间',
	content VARCHAR(1000) NOT NULL COMMENT '评论内容',
	PRIMARY KEY(commentid),
	KEY(userid),
	KEY(touserid)
)ENGINE = MyISAM DEFAULT CHARSET UTF8 COMMENT '评论表';
INSERT INTO `v_comment` (commentid,userid,touserid,relateid,typeid,addtime,content) VALUES (NULL, '1', 0, '1', '2', '2013-12-16 11:42:03', '不错的说啊');
INSERT INTO `v_comment` (commentid,userid,touserid,relateid,typeid,addtime,content) VALUES (NULL, '1', 0, '1', '2', '2013-12-16 11:44:23', '唉！有几节课视频好模糊！');
INSERT INTO `v_comment` (commentid,userid,touserid,relateid,typeid,addtime,content) VALUES (NULL, '1', 0, '1', '2', '2013-12-16 11:44:26', '老师可以给个视频下载地址吗？我是网卡用户；邮箱7026715@qq.com ');
INSERT INTO `v_comment` (commentid,userid,touserid,relateid,typeid,addtime,content) VALUES (NULL, '1', 0, '1', '2', '2013-12-16 11:44:30', '很细致的讲解');
INSERT INTO `v_comment` (commentid,userid,touserid,relateid,typeid,addtime,content) VALUES (NULL, '1', 0, '1', '2', '2013-12-16 11:44:33', '第二课变量 视频跟音频不同步，根本没法');
INSERT INTO `v_comment` (commentid,userid,touserid,relateid,typeid,addtime,content) VALUES (NULL, '1', 0, '1', '2', '2013-12-16 11:44:33', '第二课变量 视频跟音频不同步，根本没法');
INSERT INTO `v_comment` (commentid,userid,touserid,relateid,typeid,addtime,content) VALUES (NULL, '1', 2, '0', '3', '2013-12-16 11:44:33', '您好。交个朋友呗。');
INSERT INTO `v_comment` (commentid,userid,touserid,relateid,typeid,addtime,content) VALUES (NULL, '1', 3, '0', '3', '2013-12-16 11:44:33', '您好。交个朋友呗。');

# 好友表
DROP TABLE IF EXISTS `v_friend`;
CREATE TABLE `v_friend`(
	friendid INT(10) UNSIGNED AUTO_INCREMENT COMMENT '主键',
	userid INT(10) UNSIGNED NOT NULL COMMENT '用户ID',
	fuserid INT(10) UNSIGNED NOT NULL COMMENT '朋友ID',
	addtime DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '添加时间',
	PRIMARY KEY(friendid),
	KEY(userid)
)ENGINE = MyISAM DEFAULT CHARSET UTF8 COMMENT '好友表';
INSERT INTO v_friend VALUES(NULL, 1, 2, '2013-12-17 14:38:35');
INSERT INTO v_friend VALUES(NULL, 1, 3, '2013-12-17 14:38:35');

# 新闻文章表
DROP TABLE IF EXISTS `v_news`;
CREATE TABLE `v_news`(
	newsid INT(10) UNSIGNED AUTO_INCREMENT COMMENT '文章ID',
	title VARCHAR(255) NOT NULL COMMENT '文章标题',
	catid SMALLINT(5) UNSIGNED NOT NULL COMMENT '分类ID,v_category.catid',
	userid INT(10) UNSIGNED NOT NULL COMMENT '责任编辑,v_user.userid',
	author VARCHAR(20) NOT NULL DEFAULT '' COMMENT '作者',
	lasttime DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '最后更新',
	addtime DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '添加时间',
	iscomment TINYINT(1) NOT NULL DEFAULT '1' COMMENT '是否允许评论',
	isnotice TINYINT(1) NOT NULL DEFAULT '1' COMMENT '是否为公告：只展示最新一条',
	hits INT(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '浏览次数',
	display TINYINT(1) NOT NULL DEFAULT '0' COMMENT '显示状态：0隐藏、1显示',
	source VARCHAR(255) NOT NULL DEFAULT '' COMMENT '来源',
	intro VARCHAR(255) NOT NULL DEFAULT '' COMMENT '文章概要：列表时展示或作为公告时展示',
	star TINYINT(1) NOT NULL DEFAULT '1' COMMENT '评星',
	appraise INT(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '评价次数',
	content TEXT,
	PRIMARY KEY(newsid),
	KEY(userid),
	KEY(author)
)ENGINE = MyISAM DEFAULT CHARSET UTF8 COMMENT '新闻文章表';

# 友情链接
DROP TABLE IF EXISTS `v_link`;
CREATE TABLE `v_link`(
	linkid SMALLINT(5) UNSIGNED AUTO_INCREMENT COMMENT '主键ID',
	linkname VARCHAR(20) NOT NULL COMMENT '链接名称',
	linkurl VARCHAR(255) NOT NULL DEFAULT '' COMMENT '链接URL',
	display TINYINT(1) NOT NULL DEFAULT '0' COMMENT '显示状态：0否、1是',
	listorder SMALLINT(5) NOT NULL DEFAULT '0' COMMENT '排序，小在前',
	PRIMARY KEY(linkid)
)ENGINE = MyISAM DEFAULT CHARSET UTF8 COMMENT '友情链接表';
INSERT INTO v_link(linkid, linkname, linkurl, display, listorder) VALUES(NULL, 'WEB开发云课堂', 'http://go.phpcxz.com', 1, '1');
INSERT INTO v_link(linkid, linkname, linkurl, display, listorder) VALUES(NULL, 'PHP初学者', 'http://www.phpcxz.com', 1, '1');

# 用户订单表
DROP TABLE IF EXISTS `v_order`;
CREATE TABLE `v_order`(
	id INT(10) UNSIGNED AUTO_INCREMENT COMMENT '主键ID',
	orderno VARCHAR(20) NOT NULL COMMENT '订单号',
	userid INT(10) UNSIGNED NOT NULL COMMENT '用户ID',
	username VARCHAR(20) NOT NULL COMMENT '用户账号',
	money SMALLINT(3) UNSIGNED NOT NULL COMMENT '订单金额',
	status TINYINT(1) NOT NULL DEFAULT '0' COMMENT '支付状态：0未',
	paytype TINYINT(1) NOT NULL DEFAULT '1' COMMENT '支付方式：1支付宝',
	addtime DATETIME NOT NULL COMMENT '创建时间',
	remark VARCHAR(255) NOT NULL COMMENT '订单备注',
	PRIMARY KEY(id),
	KEY(userid),
	KEY(orderno)
)ENGINE = MyISAM DEFAULT CHARSET UTF8 COMMENT '用户订单表';

# 特殊验证信息表
# 诸如校验码、激活码等存放的表
DROP TABLE IF EXISTS `v_code`;
CREATE TABLE `v_code`(
	codeid INT(10) UNSIGNED AUTO_INCREMENT COMMENT '主键',
	addtime INT(10) UNSIGNED NOT NULL COMMENT '添加时间时间戳',
	typeid TINYINT(1) NOT NULL DEFAULT '0' COMMENT '验证信息类型：1找回密码、2邮箱验证',
	valitime INT(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '验证信息生效时间：单位秒',
	isuse TINYINT(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '该激活码或验证码是否成功使用：0未使用、1已使用',
	userid INT(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '用户ID，关联v_user.userid',
	codetext VARCHAR(255) NOT NULL COMMENT '验证信息',
	PRIMARY KEY(codeid),
	KEY(codetext)
)ENGINE = MyISAM DEFAULT CHARSET UTF8 COMMENT '特殊验证信息表';



########################################
# 用户中心UCenter

# UC管理员表
# 通过与用户表进行对应
DROP TABLE IF EXISTS `v_uc_admins`;
CREATE TABLE `v_uc_admins`(
	`uid` MEDIUMINT(8) UNSIGNED AUTO_INCREMENT COMMENT '管理员ID',
	`username` CHAR(15) NOT NULL COMMENT '管理员账号',
	PRIMARY KEY(uid),
	UNIQUE KEY `username` (`username`)
)ENGINE = MyISAM DEFAULT CHARSET UTF8 COMMENT 'UC管理员表';


# UC用户表
DROP TABLE IF EXISTS `v_uc_members`;
CREATE TABLE `v_uc_members`(
	`uid` MEDIUMINT(8) UNSIGNED AUTO_INCREMENT COMMENT '管理员ID',
	`username` CHAR(15) NOT NULL COMMENT '用户账号',
    `password` CHAR(32) NOT NULL COMMENT '账号密码',
    `email` CHAR(32) NOT NULL COMMENT '邮件地址',
	`salt` CHAR(6) NOT NULL COMMENT '密码盐',
	`regdate` DATETIME NOT NULL COMMENT '注册日期',
	PRIMARY KEY(uid),
	UNIQUE KEY(username)
)ENGINE = MyISAM DEFAULT CHARSET UTF8 COMMENT 'UC用户表';


# UC SESSION
DROP TABLE IF EXISTS `v_uc_session`;
CREATE TABLE `v_uc_session` (
  `sessionid` CHAR(32) NOT NULL COMMENT 'SESSION ID',
  `userid` MEDIUMINT(8) UNSIGNED NOT NULL DEFAULT '0' COMMENT '用户ID',
  `data` CHAR(255) NOT NULL,
  PRIMARY KEY (`sessionid`)
) ENGINE=MEMORY DEFAULT CHARSET UTF8 COMMENT 'UC SESSION表';


# UC配置表
DROP TABLE IF EXISTS `v_uc_settings`;
CREATE TABLE `v_uc_settings`(
	`ckey` VARCHAR(32) NOT NULL COMMENT '配置键',
	`cvalue` TEXT COMMENT '配置值',
	PRIMARY KEY (`ckey`)
)ENGINE = MyISAM DEFAULT CHARSET UTF8 COMMENT 'UC配置表';


# UC应用表。
DROP TABLE IF EXISTS `v_uc_applications`;
CREATE TABLE `v_uc_applications` (
  `appid` SMALLINT(6) unsigned NOT NULL AUTO_INCREMENT,
  `typeid` CHAR(16) NOT NULL DEFAULT '',
  `name` CHAR(20) NOT NULL DEFAULT '',
  `url` CHAR(255) NOT NULL DEFAULT '',
  `authkey` CHAR(255) NOT NULL DEFAULT '',
  `ip` CHAR(15) NOT NULL DEFAULT '',
  `apifilename` CHAR(30) NOT NULL DEFAULT 'phpsso.php',
  `charset` CHAR(8) NOT NULL DEFAULT '',
  `synlogin` TINYINT(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`appid`),
  KEY `synlogin` (`synlogin`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET UTF8 COMMENT 'UC应用表';




