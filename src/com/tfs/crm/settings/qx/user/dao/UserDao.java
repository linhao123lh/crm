package com.tfs.crm.settings.qx.user.dao;

import org.apache.ibatis.annotations.Param;

import com.tfs.crm.settings.qx.user.domain.User;

import java.util.List;

public interface UserDao {

	User selectUserByLoginActAndLoginPwd(@Param("loginAct") String loginAct, @Param("loginPwd") String loginPwd);
	
	int updatePwdById(@Param("id") String id, @Param("newPwd") String loginPwd);

    List<User> selectAllUsers();
}
