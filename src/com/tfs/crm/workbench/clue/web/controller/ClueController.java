package com.tfs.crm.workbench.clue.web.controller;

import com.tfs.crm.settings.qx.user.domain.User;
import com.tfs.crm.settings.qx.user.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("workbench/clue")
public class ClueController {

    @Autowired
    private UserService userService;

    @RequestMapping(value = "createClue.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> createClue(){

        System.out.println("========进入到createClue========");
        //获取所有用户
        List<User> userList = userService.quertAllUsers();
        Map<String,Object> retMap = new HashMap<String,Object>();
        retMap.put("userList",userList);
        return retMap;
    }
}
