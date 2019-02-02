package com.tfs.crm.workbench.activity.web.controller;

import com.tfs.crm.commons.domain.PaginationVO;
import com.tfs.crm.commons.util.DateUtil;
import com.tfs.crm.commons.util.UUIDUtil;
import com.tfs.crm.settings.qx.user.domain.User;
import com.tfs.crm.settings.qx.user.service.UserService;
import com.tfs.crm.workbench.activity.domain.MarketActivity;
import com.tfs.crm.workbench.activity.domain.MarketActivityRemark;
import com.tfs.crm.workbench.activity.service.MarketActivityRemarkService;
import com.tfs.crm.workbench.activity.service.MarketActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.*;

@Controller
@RequestMapping("workbench/activity")
public class MarketActivityController {

    @Autowired
    private UserService userService;
    @Autowired
    private MarketActivityService marketActivityService;
    @Autowired
    private MarketActivityRemarkService marketActivityRemarkService;

    /**
     * 创建市场活动
     * @return
     */
    @RequestMapping(value = "createMarketActivity.do", method = RequestMethod.POST)
    @ResponseBody
    public List<User> createActivity(){
        System.out.println("进入到createActivity");
        List<User> userList = userService.quertAllUsers();
        return userList;
    }

    /**
     * 保存创建的市场活动
     * @param request
     * @param owner
     * @param type
     * @param name
     * @param state
     * @param startDate
     * @param endDate
     * @param actualCostStr
     * @param budgetCostStr
     * @param description
     * @return
     */
    @RequestMapping(value = "saveCreateMarketActivity.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> saveActivity(HttpServletRequest request, @RequestParam(value = "owner",required = true) String owner,
                                           @RequestParam(value = "type",required = false) String type,
                                           @RequestParam(value = "name",required = true) String name,
                                           @RequestParam(value = "state",required = false) String state,
                                           @RequestParam(value = "startDate",required = false) String startDate,
                                           @RequestParam(value = "endDate",required = false) String endDate,
                                           @RequestParam(value = "actualCost",required = false) String actualCostStr,
                                           @RequestParam(value = "budgetCost",required = false) String budgetCostStr,
                                           @RequestParam(value = "description",required = false) String description){
//        System.out.println("type==========="+type);
//        System.out.println("name=========="+name);
//        System.out.println("description=========="+description);
        //封装参数
        MarketActivity activity = new MarketActivity();
        activity.setOwner(owner);
        activity.setType(type);
        activity.setName(name);
        activity.setState(state);
        activity.setStartDate(startDate);
        activity.setEndDate(endDate);
        if (actualCostStr != null && actualCostStr.trim().length() > 0){
            activity.setActualCost(Long.parseLong(actualCostStr));
        }
        if (budgetCostStr != null && budgetCostStr.trim().length() > 0){
            activity.setBudgetCost(Long.parseLong(budgetCostStr));
        }
        activity.setDescription(description);
        User user = (User) request.getSession().getAttribute("user");
        activity.setCreateBy(user.getId());
        activity.setCreateTime(DateUtil.formateDateTime(new Date()));
        activity.setId(UUIDUtil.getUuid());

        //调用方法
        int ret = marketActivityService.saveCreateActivityByActivity(activity);

        //返回结果
        Map<String,Object> retMap = new HashMap<String, Object>();
        if (ret > 0){
            retMap.put("success",true);
        }else {
            retMap.put("success",false);
        }
        return retMap;
    }

    /**
     * 根据条件分页查询市场活动
     * @param name
     * @param owner
     * @param state
     * @param type
     * @param startDate
     * @param endDate
     * @param pageNoStr
     * @param pageSizeStr
     * @return
     */
    @RequestMapping(value = "queryMarketActivityForPageByCondition.do", method = RequestMethod.POST)
    @ResponseBody
    public PaginationVO<MarketActivity> queryMarketActivity(@RequestParam(value = "name", required = false) String name,
                                                            @RequestParam(value = "owner", required = false) String owner,
                                                            @RequestParam(value = "state", required = false) String state,
                                                            @RequestParam(value = "type", required = false) String type,
                                                            @RequestParam(value = "startDate", required = false) String startDate,
                                                            @RequestParam(value = "endDate", required = false) String endDate,
                                                            @RequestParam(value = "pageNo", required = false) String pageNoStr,
                                                            @RequestParam(value = "pageSize", required = false) String pageSizeStr){
        System.out.println("进入到queryMarketActivity");
        //封装参数
        Map<String,Object> paramMap = new HashMap<String, Object>();
        paramMap.put("name",name);
        paramMap.put("owner",owner);
        paramMap.put("state",state);
        paramMap.put("type",type);
        paramMap.put("startDate",startDate);
        paramMap.put("endDate",endDate);
        int pageSize = 10;
        if (pageSizeStr != null || pageSizeStr.trim().length() > 0){
            pageSize = Integer.parseInt(pageSizeStr);
        }
        Long pageNo = 1L;
        if (pageNoStr != null || pageNoStr.trim().length() > 0){
            pageNo = Long.parseLong(pageNoStr);
        }
        Long beginNo = (pageNo-1)*pageSize;
        paramMap.put("pageSize",pageSize);
        paramMap.put("beginNo",beginNo);
        //调用service方法
        PaginationVO<MarketActivity> vo = marketActivityService.queryMarketActivityForPageByCondition(paramMap);
       // System.out.println("count=============="+vo.getCoount());
        //System.out.println("dataList=============="+vo.getDataList());
        return vo;
    }

    /**
     * 批量删除市场活动
     * @param ids
     * @return
     */
    @RequestMapping(value = "deleteMarketActivities.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> deleteMarketActivities(@RequestParam(value = "id",required = true) String[] ids){

        System.out.println(Arrays.toString(ids));
        int ret = marketActivityService.deleteMarketActivitiesByIds(ids);

        Map<String,Object> retMap = new HashMap<String, Object>();
        if (ret > 0){
            retMap.put("success",true);
        }else {
            retMap.put("success",false);
        }
        return retMap;
    }

    /**
     * 获取要修改的市场活动信息
     * @param id
     * @return
     */
    @RequestMapping(value = "editMarketActivityById.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> editMarketActivityById(@RequestParam(value = "id",required = true) String id){

        Map<String,Object> retMap = new HashMap<String, Object>();
        List<User> userList = userService.quertAllUsers();
        retMap.put("userList",userList);

        MarketActivity activity = marketActivityService.queryMarketActivityById(id);
        retMap.put("activity",activity);

        return retMap;
    }

    /**
     * 更新市场活动
     * @param owner
     * @param request
     * @param type
     * @param name
     * @param state
     * @param startDate
     * @param endDate
     * @param actualCostStr
     * @param budgetCostStr
     * @param description
     * @param id
     * @return
     */
    @RequestMapping(value = "saveEditMarketActivity.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> saveEditMarketActivity(@RequestParam(value = "owner",required = true) String owner, HttpServletRequest request,
                                                     @RequestParam(value = "type",required = false) String type,
                                                     @RequestParam(value = "name",required = true) String name,
                                                     @RequestParam(value = "state",required = false) String state,
                                                     @RequestParam(value = "startDate",required = false) String startDate,
                                                     @RequestParam(value = "endDate",required = false) String endDate,
                                                     @RequestParam(value = "actualCost",required = false) String actualCostStr,
                                                     @RequestParam(value = "budgetCost",required = false) String budgetCostStr,
                                                     @RequestParam(value = "description",required = false) String description,
                                                     @RequestParam(value = "id",required = true) String id){
        //封装参数
        MarketActivity activity = new MarketActivity();
        activity.setId(id);
        activity.setOwner(owner);
        activity.setType(type);
        activity.setName(name);
        activity.setState(state);
        activity.setStartDate(startDate);
        activity.setEndDate(endDate);
        if (actualCostStr != null && actualCostStr.trim().length() > 0){
            activity.setActualCost(Long.parseLong(actualCostStr));
        };
        if (budgetCostStr != null && budgetCostStr.trim().length() > 0){
            activity.setBudgetCost(Long.parseLong(budgetCostStr));
        }
        activity.setDescription(description);
        User user = (User) request.getSession().getAttribute("user");
        activity.setEditBy(user.getId());
        activity.setEditTime(DateUtil.formateDateTime(new Date()));

        //调用方法
        int ret = marketActivityService.saveEditMarketActivity(activity);
        Map<String,Object> retMap = new HashMap<String, Object>();
        if (ret > 0){
            retMap.put("success",true);
        }else {
            retMap.put("success",false);
        }
        return retMap;
    }

    /**
     * 市场活动明细
     * @param request
     * @param id
     * @return
     */
    @RequestMapping("detailActivityRemark.do")
    public String detailActivityRemark(HttpServletRequest request,
                                     @RequestParam(value = "id",required = true) String id){

        MarketActivity activity = marketActivityService.queryActivityDetailRemarkById(id);
        List<MarketActivityRemark> remarkList = marketActivityRemarkService.queryMarketAcitivityRemarkById(id);

        request.setAttribute("activity",activity);
        request.setAttribute("remarkList",remarkList);
        return "forward:/workbench/activity/detail.jsp";
    }

    @RequestMapping(value = "saveCreateActivityRemark.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> saveCreateMarketActivityRemark(HttpServletRequest request,@RequestParam(value = "noteContent",required = true)String noteContent,
                                                             @RequestParam(value = "activityId",required = true) String activityId){
        //封装参数
        MarketActivityRemark remark = new MarketActivityRemark();
        remark.setId(UUIDUtil.getUuid());
        remark.setNoteContent(noteContent);
        User user = (User) request.getSession().getAttribute("user");
        remark.setNotePerson(user.getId());
        remark.setNoteTime(DateUtil.formateDateTime(new Date()));
        remark.setEditFlag(0);
        remark.setMarketingActivitiesId(activityId);

        int ret = marketActivityRemarkService.saveCreateMarketActivityRemark(remark);
        Map<String,Object> retMap = new HashMap<String, Object>();
        if (ret > 0){
            retMap.put("success",true);
            retMap.put("remark",remark);
        }else {
            retMap.put("success",false);
        }
        return retMap;
    }
}
