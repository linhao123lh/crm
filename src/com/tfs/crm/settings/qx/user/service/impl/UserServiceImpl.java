package com.tfs.crm.settings.qx.user.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tfs.crm.settings.qx.user.dao.UserDao;
import com.tfs.crm.settings.qx.user.domain.User;
import com.tfs.crm.settings.qx.user.service.UserService;

import java.util.List;

@Service
public class UserServiceImpl implements UserService{

	@Autowired
	private UserDao userDao;
	
	@Override
	public User queryUserByLoginActAndLoginPwd(String loginAct, String loginPwd) {
		
		return userDao.selectUserByLoginActAndLoginPwd(loginAct,loginPwd);
	}

	@Override
	public int modifyPwdById(String id, String newPwd) {
		
		return userDao.updatePwdById(id,newPwd);
	}

	@Override
	public List<User> quertAllUsers() {

		return userDao.selectAllUsers();
	}

}
