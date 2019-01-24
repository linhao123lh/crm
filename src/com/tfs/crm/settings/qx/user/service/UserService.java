package com.tfs.crm.settings.qx.user.service;

import com.tfs.crm.settings.qx.user.domain.User;

import java.util.List;

public interface UserService {

	User queryUserByLoginActAndLoginPwd(String loginAct, String loginPwd);
	
	int modifyPwdById(String id, String newPwd);

    List<User> quertAllUsers();
}
