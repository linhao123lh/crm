package com.tfs.crm.workbench.activity.web.controller;

import com.tfs.crm.settings.qx.user.domain.User;
import com.tfs.crm.settings.qx.user.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("workbench/activity")
public class MarketActivityController {

    @Autowired
    private UserService userService;

    /**
     * 创建市场活动
     * @return
     */
    @RequestMapping("createMarketActivity.do")
    @ResponseBody
    public List<User> createActivity(){
        System.out.println("进入到createActivity");
        List<User> userList = userService.quertAllUsers();
        return userList;
    }

}
