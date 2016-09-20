// UCenter
// @author 寒冰
// @date 2014年3月11日。

package ucenter

func init() {

}

type Ucenter struct {
}

// UC注册。
// @param username 用户账号。
// @param password 账号密码。
// @param email 邮箱地址。
func (this *Ucenter) Register(username string, password string, email string) int {
	return 1
}

// 用户账号检查。
func (this *Ucenter) UsernameCheck(username string) int {
	usernameLen := len(username)
	if usernameLen == 0 {
		return 1 // 用户不能为空。
	}
	// 验证用户名格式。
	type UserData struct {
		Username string
	}
	userinfo := UserData{Username: username}
	valid := validation.Validation{}
	valid.AlphaNumeric(userinfo.Username, username)
	if valid.HasErrors() {
		return 2 // 用户名格式不正确。
	}

	if usernameLen < 6 || usernameLen > 20 {
		return 3 // 用户必须6到20个字符间。
	}

	// 检查是否已经存在此用户。
	o := orm.NewOrm()
	var user models.VUser
	o.Raw("SELECT * FROM v_uc_members WHERE username = ?", username).QueryRow(&user)
	if user.Userid > 0 {
		return 4 // 用户已经存在。
	}
	return 5 // 用户正确。
}

// Email检查。
func (this *Ucenter) PasswordCheck(email string) int {
	emailLen := len(email)
	if emailLen == 0 {
		return 1 // 邮箱不能为空。
	}
	// 验证邮箱格式。
	type EmailData struct {
		Email string
	}
	emailinfo := EmailData{Email: email}
	valid := validation.Validation{}
	valid.Email(emailinfo.Email, email)
	if valid.HasErrors() {
		return 2 // 邮箱格式不正确。
	}

	if emailLen < 6 || emailLen > 60 {
		return 3 // 邮箱长度似乎有些异常。
	}

	// 检查是否已经存在邮箱。
	o := orm.NewOrm()
	var user models.VUser
	o.Raw("SELECT * FROM v_uc_members WHERE email = ?", email).QueryRow(&user)
	if user.Userid > 0 {
		return 4 // 邮箱已经存在。
	}
	return 5 // 邮箱格式正确。
}
