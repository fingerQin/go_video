// 公共方法。
// @author 寒冰。
// @date 2013年12月17日。

package services

import (
	"crypto/rand"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"runtime"
	"strconv"
	"strings"
	"time"
)

// 获取随机字符串
func GetRandomString(n int) string {
	const alphanum = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
	var bytes = make([]byte, n)
	rand.Read(bytes)
	for i, b := range bytes {
		bytes[i] = alphanum[b%byte(len(alphanum))]
	}
	return string(bytes)
}

// 上传文件。
// -- 1、2014年1月29日：增加了自定义文件名功能。
// @param key 表单file名字。
// @param saveType 保存类型。avatar:头像、video:视频、cover:课程封面、doc:文档、poster:广告
// @param argFilename 是不带扩展的文件名。如：userAvater
// @return 0成功
// @todo 后续增加后缀判断。
func UploadFile(request *http.Request, key string, saveType string, argFilename string) (status int, savePathsuffix string) {
	file, FileHeader, err := request.FormFile(key)
	if err != nil {
		return 1, "" // 服务器异常
	}

	fileExt := filepath.Ext(FileHeader.Filename) // 取扩展名。
	addtime := time.Now().Format("200601")       // 文件保存的文件夹名称。

	// 取得当前脚本路径
	_, filetName, _, _ := runtime.Caller(0)
	// 取当前项目所在目录。
	dirName := filepath.Dir(filepath.Dir(filetName))

	// 允许的视频后缀扩展。
	var allowVideoExt []string = []string{".mp4", ".flv"}
	// 允许的图片后缀扩展。
	var allowImageExt []string = []string{".jpg", ".jpeg", ".gif", ".bmp", ".png"}
	// 允许的文档后缀扩展。
	var allowDocExt []string = []string{".doc", ".docx", ".pdf", ".xls", ".xlsx", ".ppt", ".pptx"}
	// 允许的Excal扩展。
	var allowExcelExt []string = []string{".xls", ".xlsx"}

	b := false
	switch saveType {
	case "avatar":
		savePathsuffix = "/static/Upload/Avatars/" + addtime + "/"
		b = isHashExt(fileExt, allowImageExt)
	case "video":
		savePathsuffix = "/static/Upload/Videos/" + addtime + "/"
		b = isHashExt(fileExt, allowVideoExt)
	case "cover":
		savePathsuffix = "/static/Upload/Covers/" + addtime + "/"
		b = isHashExt(fileExt, allowImageExt)
	case "doc":
		savePathsuffix = "/static/Upload/Docs/" + addtime + "/"
		b = isHashExt(fileExt, allowDocExt)
	case "poster":
		savePathsuffix = "/static/Upload/Poster/" + addtime + "/"
		b = isHashExt(fileExt, allowImageExt)
	case "excel":
		savePathsuffix = "/static/Upload/Excel/" + addtime + "/"
		b = isHashExt(fileExt, allowExcelExt)
	case "news":
		savePathsuffix = "/static/Upload/News/" + addtime + "/"
		b = isHashExt(fileExt, allowExcelExt)
	default:
		savePathsuffix = "/static/Upload/Others/" + addtime + "/"
		b = isHashExt(fileExt, allowImageExt)
	}

	if b == false {
		return 4, "" // 不允许的后缀。
	}

	uploadPath := dirName + savePathsuffix
	os.MkdirAll(uploadPath, 0777) // 循环创建目录
	Nanoseconds := time.Now().UnixNano()

	// 自定义文件名判断。
	basename := argFilename
	if len(argFilename) == 0 {
		basename = strconv.FormatInt(Nanoseconds, 10)
	}

	filename := basename + fileExt
	newFilename := uploadPath + filename       // 在服务器上的保存位置。
	savePathsuffix = savePathsuffix + filename // 保存在数据库里面的URL后缀部分，即除开域名的部分。

	defer file.Close()
	f, err := os.OpenFile(newFilename, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, 0666)
	if err != nil {
		return 2, "" // 服务器异常
	}
	defer f.Close()
	_, err = io.Copy(f, file) // 移动文件。
	if err != nil {
		return 3, "" // 服务器异常
	}
	return 0, savePathsuffix
}

// 判断指定后缀是否在某范围。
func isHashExt(ext string, exts []string) bool {
	ext = strings.ToLower(ext)
	for _, v := range exts {
		if ext == v {
			return true
		}
	}
	return false
}
