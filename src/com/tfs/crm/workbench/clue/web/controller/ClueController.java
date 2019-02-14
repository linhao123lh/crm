package com.tfs.crm.workbench.clue.web.controller;

import com.tfs.crm.commons.domain.PaginationVO;
import com.tfs.crm.commons.util.DateUtil;
import com.tfs.crm.commons.util.UUIDUtil;
import com.tfs.crm.settings.qx.user.domain.User;
import com.tfs.crm.settings.qx.user.service.UserService;
import com.tfs.crm.workbench.clue.domain.Clue;
import com.tfs.crm.workbench.clue.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Stream;

@Controller
@RequestMapping("workbench/clue")
public class ClueController {

    @Autowired
    private UserService userService;
    @Autowired
    private ClueService clueService;

    /**
     * 创建线索
     * @return
     */
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

    /**
     * 保存创建的线索
     * @param request
     * @param owner 所有者
     * @param company 公司
     * @param fullName 名称
     * @param appellation 称呼
     * @param job 工作
     * @param email 邮箱
     * @param phone 电话
     * @param website 网页
     * @param mphone 手机
     * @param state 状态
     * @param source 来源
     * @param empNumsStr 员工数量
     * @param industry 行业
     * @param grade 等级
     * @param annualIncomeStr 年收入
     * @param description 描述
     * @param contactSummary 联系纪要
     * @param nextContactTime 下次联系时间
     * @param country 国家
     * @param province 省
     * @param city 市
     * @param street 街道
     * @param zipcode 邮箱
     * @return
     */
    @RequestMapping(value = "saveCreateClue.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> saveCreateClue(HttpServletRequest request, @RequestParam(value = "owner",required = true) String owner,
                                             @RequestParam(value = "company",required = true) String company,
                                             @RequestParam(value = "appellation",required = false) String appellation,
                                             @RequestParam(value = "fullName",required = true) String fullName,
                                             @RequestParam(value = "job",required = false) String job,
                                             @RequestParam(value = "email",required = false) String email,
                                             @RequestParam(value = "phone",required = false) String phone,
                                             @RequestParam(value = "website",required = false) String website,
                                             @RequestParam(value = "mphone",required = false) String mphone,
                                             @RequestParam(value = "state",required = false) String state,
                                             @RequestParam(value = "source",required = false) String source,
                                             @RequestParam(value = "empNums",required = false) String empNumsStr,
                                             @RequestParam(value = "industry",required = false) String industry,
                                             @RequestParam(value = "grade",required = false) String grade,
                                             @RequestParam(value = "annualIncome",required = false) String annualIncomeStr,
                                             @RequestParam(value = "description",required = false) String description,
                                             @RequestParam(value = "contactSummary",required = false) String contactSummary,
                                             @RequestParam(value = "nextContactTime",required = false) String nextContactTime,
                                             @RequestParam(value = "country",required = false) String country,
                                             @RequestParam(value = "province",required = false) String province,
                                             @RequestParam(value = "city",required = false) String city,
                                             @RequestParam(value = "street",required = false) String street,
                                             @RequestParam(value = "zipcode",required = false) String zipcode){
        //封装参数
        Clue clue = new Clue();
        clue.setId(UUIDUtil.getUuid());
        clue.setOwner(owner);
        clue.setCompany(company);
        clue.setAppellation(appellation);
        clue.setFullName(fullName);
        clue.setJob(job);
        clue.setEmail(email);
        clue.setPhone(phone);
        clue.setWebsite(website);
        clue.setMphone(mphone);
        clue.setState(state);
        clue.setSource(source);
        if (empNumsStr != null && empNumsStr.trim().length() > 0){
            clue.setEmpNums(Integer.parseInt(empNumsStr));
        }
        clue.setIndustry(industry);
        clue.setGrade(grade);
        if (annualIncomeStr != null && empNumsStr.trim().length() > 0){
            clue.setAnnualIncome(Long.parseLong(annualIncomeStr));
        }
        clue.setDescription(description);
        clue.setContactSummary(contactSummary);
        clue.setNextContactTime(nextContactTime);
        clue.setCountry(country);
        clue.setProvince(province);
        clue.setCity(city);
        clue.setStreet(street);
        clue.setZipcode(zipcode);
        clue.setCreateTime(DateUtil.formateDateTime(new Date()));
        User user = (User) request.getSession().getAttribute("user");
        clue.setCreateBy(user.getId());

        //调用service方法
        int ret = clueService.saveCreateClueByClue(clue);
        Map<String,Object> retMap = new HashMap<String, Object>();
        if (ret > 0){
            retMap.put("success",true);
        }else {
            retMap.put("success",false);
        }
        return retMap;
    }

    /**
     * 根据条件分页查询线索
     * @param pageNoStr
     * @param pageSizeStr
     * @param fullName
     * @param company
     * @param phone
     * @param source
     * @param owner
     * @param mphone
     * @param state
     * @param industry
     * @param grade
     * @return
     */
    @RequestMapping(value = "queryClueForPageByCondition.do",method = RequestMethod.POST)
    @ResponseBody
    public PaginationVO<Clue> queryClueForPageByCondition(@RequestParam(value = "pageNo",required = true) String pageNoStr,
                                                          @RequestParam(value = "pageSize",required = true) String pageSizeStr,
                                                          @RequestParam(value = "fullName",required = false) String fullName,
                                                          @RequestParam(value = "company",required = false) String company,
                                                          @RequestParam(value = "phone",required = false) String phone,
                                                          @RequestParam(value = "source",required = false) String source,
                                                          @RequestParam(value = "owner",required = false) String owner,
                                                          @RequestParam(value = "mphone",required = false) String mphone,
                                                          @RequestParam(value = "state",required = false) String state,
                                                          @RequestParam(value = "industry",required = false) String industry,
                                                          @RequestParam(value = "grade",required = false) String grade){
        //收集参数
        Map<String,Object> paramMap = new HashMap<String, Object>();
        paramMap.put("fullName",fullName);
        paramMap.put("company",company);
        paramMap.put("phone",phone);
        paramMap.put("source",source);
        paramMap.put("owner",owner);
        paramMap.put("mphone",mphone);
        paramMap.put("state",state);
        paramMap.put("industry",industry);
        paramMap.put("grade",grade);
        Long pageNo = 1L;
        if (pageNoStr != null && pageNoStr.trim().length() > 0 && !"0".equals(pageNoStr)){
            pageNo = Long.parseLong(pageNoStr);
        }
        int pageSize = 10;
        if (pageSizeStr != null && pageSizeStr.trim().length() > 0 && !"0".equals(pageSizeStr)){
            pageSize = Integer.parseInt(pageSizeStr);
        }
        Long beginNo = (pageNo - 1) * pageSize;
        paramMap.put("pageSize",pageSize);
        paramMap.put("beginNo",beginNo);

        //调用service方法
        PaginationVO<Clue> vo = clueService.queryClueForPageByCondition(paramMap);
        return vo;
    }

    /**
     * 批量删除线索
     * @param ids
     * @return
     */
    @RequestMapping(value = "deleteClue.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> batchDeleteClueByIds(@RequestParam(value = "id",required = true) String[] ids){

        int ret = clueService.batchDeleteClueByIds(ids);
        Map<String,Object> retMap = new HashMap<String, Object>();

        if (ret > 0){
            retMap.put("success",true);
        }else {
            retMap.put("success",false);
        }
        return retMap;
    }

    /**
     * 修改线索
     * @param id
     * @return
     */
    @RequestMapping(value = "editClue.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> editClueById(@RequestParam(value = "id",required = true) String id){

        //根据Id获取线索信息
        Clue clue = clueService.queryClueById(id);
        //获取所有用户
        List<User> userList = userService.quertAllUsers();
        Map<String,Object> retMap = new HashMap<String, Object>();
        retMap.put("clue",clue);
        retMap.put("userList",userList);
        return retMap;
    }

    @RequestMapping(value = "saveEditClue.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> saveEditClueByClue(HttpServletRequest request, @RequestParam(value = "owner",required = true) String owner,
                                                  @RequestParam(value = "company",required = true) String company,
                                                  @RequestParam(value = "appellation",required = false) String appellation,
                                                  @RequestParam(value = "fullName",required = true) String fullName,
                                                  @RequestParam(value = "job",required = false) String job,
                                                  @RequestParam(value = "email",required = false) String email,
                                                  @RequestParam(value = "phone",required = false) String phone,
                                                  @RequestParam(value = "website",required = false) String website,
                                                  @RequestParam(value = "mphone",required = false) String mphone,
                                                  @RequestParam(value = "state",required = false) String state,
                                                  @RequestParam(value = "source",required = false) String source,
                                                  @RequestParam(value = "empNums",required = false) String empNumsStr,
                                                  @RequestParam(value = "industry",required = false) String industry,
                                                  @RequestParam(value = "grade",required = false) String grade,
                                                  @RequestParam(value = "annualIncome",required = false) String annualIncomeStr,
                                                  @RequestParam(value = "description",required = false) String description,
                                                  @RequestParam(value = "contactSummary",required = false) String contactSummary,
                                                  @RequestParam(value = "nextContactTime",required = false) String nextContactTime,
                                                  @RequestParam(value = "country",required = false) String country,
                                                  @RequestParam(value = "province",required = false) String province,
                                                  @RequestParam(value = "city",required = false) String city,
                                                  @RequestParam(value = "street",required = false) String street,
                                                  @RequestParam(value = "zipcode",required = false) String zipcode,
                                                  @RequestParam(value = "id",required = true) String id){
        //封装参数
        Clue clue = new Clue();
        clue.setId(id);
        clue.setOwner(owner);
        clue.setCompany(company);
        clue.setAppellation(appellation);
        clue.setFullName(fullName);
        clue.setJob(job);
        clue.setEmail(email);
        clue.setPhone(phone);
        clue.setWebsite(website);
        clue.setMphone(mphone);
        clue.setState(state);
        clue.setSource(source);
        if (empNumsStr != null && empNumsStr.trim().length() > 0){
            clue.setEmpNums(Integer.parseInt(empNumsStr));
        }
        clue.setIndustry(industry);
        clue.setGrade(grade);
        if (annualIncomeStr != null && empNumsStr.trim().length() > 0){
            clue.setAnnualIncome(Long.parseLong(annualIncomeStr));
        }
        clue.setDescription(description);
        clue.setContactSummary(contactSummary);
        clue.setNextContactTime(nextContactTime);
        clue.setCountry(country);
        clue.setProvince(province);
        clue.setCity(city);
        clue.setStreet(street);
        clue.setZipcode(zipcode);
        clue.setEditTime(DateUtil.formateDateTime(new Date()));
        User user = (User) request.getSession().getAttribute("user");
        clue.setEditBy(user.getId());

        //调用service方法
        int ret = clueService.saveEditClueByClue(clue);
        Map<String,Object> retMap = new HashMap<String, Object>();
        if (ret > 0){
            retMap.put("success",true);
        }else {
            retMap.put("success",false);
        }
        return retMap;
    }
}
