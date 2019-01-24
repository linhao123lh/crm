package com.tfs.crm.settings.qx.user.web.controller;

import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.tfs.crm.commons.util.DateUtil;
import com.tfs.crm.settings.qx.user.domain.User;
import com.tfs.crm.settings.qx.user.service.UserService;

@Controller
@RequestMapping("settings/qx/user")
public class UserController {

	@Autowired
	private UserService userService;
	
	/**
	 * 登录
	 * @param request
	 * @param response
	 * @param loginAct
	 * @param loginPwd
	 * @param isRemUser
	 * @return
	 */
	@RequestMapping(value="login.do", method=RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> login(HttpServletRequest request, HttpServletResponse response,
								@RequestParam("loginAct") String loginAct,
								@RequestParam("loginPwd") String loginPwd,
								@RequestParam("isRemUser") String isRemUser) {
		//System.out.println("============"+isRemUser);
		System.out.println("+++++++++++" + request.getRemoteAddr());
		//获取结果
		User user = userService.queryUserByLoginActAndLoginPwd(loginAct,loginPwd);
		//结果集
		Map<String, Object> retMap = new HashMap<String,Object>();
		//验证
		if(user == null) {
			retMap.put("success", false);
			retMap.put("msg", "用户名或密码错误!");
		}else {
			//用户是否锁定
			if (user.getLockStatus() != null && "0".equals(user.getLockStatus())) {
				retMap.put("success", false);
				retMap.put("msg", "用户名已锁定!");
			//用户是否已过有效期	
			}else if (user.getExpireTime() != null && new Date().getTime() > DateUtil.parseDateTime(user.getExpireTime()).getTime()) {
				retMap.put("success", false);
				retMap.put("msg", "用户名已过期!");
			//用户是否被允许访问	
			}else if (user.getAllowIps() != null && !user.getAllowIps().contains(request.getRemoteAddr())) {
				retMap.put("success", false);
				retMap.put("msg", "ip受限!");
			}else {
				//登录成功
				retMap.put("success", true);
				retMap.put("msg", "success");
				
				//将用户存入session
				HttpSession session = request.getSession();
				session.setAttribute("user",user);
				
				//十天免登陆
				if ("true".equals(isRemUser)) {
					//保存cookie
					Cookie cookie1 = new Cookie("loginAct", loginAct);
					cookie1.setMaxAge(10*24*60*60);
					response.addCookie(cookie1);
					Cookie cookie2 = new Cookie("loginPwd", loginPwd);
					cookie1.setMaxAge(10*24*60*60);
					response.addCookie(cookie2);
				}else {
					//清空cookie
					Cookie cookie1 = new Cookie("loginAct", "");
					cookie1.setMaxAge(0);
					response.addCookie(cookie1);
					Cookie cookie2 = new Cookie("loginPwd", "");
					cookie1.setMaxAge(0);
					response.addCookie(cookie2);
				}
			}
		}
		
		return retMap;
	}
	
	/**
	 * 退出登录
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("logout.do")
	public void logout(HttpServletRequest request, HttpServletResponse response) throws IOException {
		//清空session
		HttpSession session = request.getSession(false);
		if (session != null) {
			session.invalidate();
		}
		
		//清除cookie
		Cookie cookie1 = new Cookie("loginAct","");
		cookie1.setMaxAge(0);
		response.addCookie(cookie1);
		Cookie cookie2 = new Cookie("loginPwd","");
		cookie1.setMaxAge(0);
		response.addCookie(cookie2);
		
		//重定向到登录页面
		response.sendRedirect(request.getContextPath());
	}
	
	/**
	 * 修改密码
	 * @param newPwd
	 * @param session
	 * @return
	 */
	@RequestMapping("modifyPwd.do")
	@ResponseBody
	public Map<String,Object> modifyPwd(@RequestParam("newPwd") String newPwd, HttpSession session) {
		
		//获取当前用户
		User user = (User) session.getAttribute("user");
		int ret = 0;
		if (user != null) {
			 ret = userService.modifyPwdById(user.getId(),newPwd);
		}
		//结果集
		Map<String,Object> retMap = new HashMap<String,Object>();
		if (ret > 0) {
			retMap.put("success",true);
		}else {
			retMap.put("success",false);
		}
		//System.out.println("=============="+retMap);
		return retMap;
	}
}
