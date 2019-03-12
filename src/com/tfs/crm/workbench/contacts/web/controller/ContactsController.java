package com.tfs.crm.workbench.contacts.web.controller;

import com.tfs.crm.commons.domain.ContactsVO;
import com.tfs.crm.commons.domain.PaginationVO;
import com.tfs.crm.commons.util.DateUtil;
import com.tfs.crm.commons.util.UUIDUtil;
import com.tfs.crm.settings.qx.user.domain.User;
import com.tfs.crm.settings.qx.user.service.UserService;
import com.tfs.crm.workbench.contacts.domain.Contacts;
import com.tfs.crm.workbench.contacts.serivice.ContactsService;
import com.tfs.crm.workbench.customer.domain.Customer;
import com.tfs.crm.workbench.customer.serivce.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("workbench/contacts")
public class ContactsController {

    @Autowired
    private UserService userService;
    @Autowired
    private CustomerService customerService;
    @Autowired
    private ContactsService contactsService;

    /**
     * 创建联系人
     * @return
     */
    @RequestMapping(value = "createContacts.do",method = RequestMethod.POST)
    @ResponseBody
    public List<User> createContactsBtn(){

        List<User> userList = userService.quertAllUsers();
        return userList;
    }

    /**
     * 自动补全客户名称
     * @param name
     * @return
     */
    @RequestMapping(value = "queryCustomerByName.do",method = RequestMethod.POST)
    @ResponseBody
    public List<Customer> queryCustomerByName(@RequestParam(value = "name",required = true) String name){

        List<Customer> customerList = customerService.queryCustomerByName(name);
        return customerList;
    }

    /**
     * 保存创建的联系人
     * @param request
     * @param owner 所有者
     * @param fullName 联系人姓名
     * @param source 来源
     * @param appellation 称呼
     * @param job 职业
     * @param mphone 手机
     * @param email 邮箱
     * @param birth 生日
     * @param customerId 客户Id
     * @param description 描述
     * @param contactSummary 联系纪要
     * @param country 国家
     * @param province 省
     * @param city 市
     * @param street 街道
     * @param zipcode 邮编
     * @return
     */
    @RequestMapping(value = "saveCreateContacts.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> saveCreateContacts(HttpServletRequest request, @RequestParam(value = "owner",required = true) String owner,
                                                 @RequestParam(value = "fullName",required = true) String fullName,
                                                 @RequestParam(value = "source",required = false) String source,
                                                 @RequestParam(value = "appellation",required = false) String appellation,
                                                 @RequestParam(value = "job",required = false) String job,
                                                 @RequestParam(value = "mphone",required = false) String mphone,
                                                 @RequestParam(value = "email",required = false) String email,
                                                 @RequestParam(value = "birth",required = false) String birth,
                                                 @RequestParam(value = "customerId",required = false) String customerId,
                                                 @RequestParam(value = "description",required = false) String description,
                                                 @RequestParam(value = "contactSummary",required = false) String contactSummary,
                                                 @RequestParam(value = "country",required = false) String country,
                                                 @RequestParam(value = "province",required = false) String province,
                                                 @RequestParam(value = "city",required = false) String city,
                                                 @RequestParam(value = "street",required = false) String street,
                                                 @RequestParam(value = "zipcode",required = false) String zipcode){
        //封装参数
        Contacts contacts = new Contacts();
        contacts.setId(UUIDUtil.getUuid());
        User user = (User) request.getSession().getAttribute("user");
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(DateUtil.formateDateTime(new Date()));
        contacts.setOwner(owner);
        contacts.setFullName(fullName);
        contacts.setSource(source);
        contacts.setAppellation(appellation);
        contacts.setJob(job);
        contacts.setMphone(mphone);
        contacts.setEmail(email);
        contacts.setBirth(birth);
        contacts.setCustomerId(customerId);
        contacts.setDescription(description);
        contacts.setContactSummary(contactSummary);
        contacts.setCountry(country);
        contacts.setProvince(province);
        contacts.setCity(city);
        contacts.setStreet(street);
        contacts.setZipcode(zipcode);

        int ret = contactsService.saveCreateContacts(contacts);
        Map<String,Object> retMap = new HashMap<String, Object>();
        if (ret > 0){
            retMap.put("success",true);
        }else {
            retMap.put("success",false);
        }
        return retMap;
    }

    @PostMapping("queryContactsForPageByCondition.do")
    @ResponseBody
    public PaginationVO<Contacts> queryContactsForPageByCondition(@RequestParam(value = "pageNo",required = true) String pageNoStr,
                                                                  @RequestParam(value = "pageSize",required = true) String pageSizeStr,
                                                                  @RequestParam(value = "owner",required = false) String owner,
                                                                  @RequestParam(value = "fullName",required = false) String fullName,
                                                                  @RequestParam(value = "customerName",required = false) String customerName,
                                                                  @RequestParam(value = "source",required = false) String source,
                                                                  @RequestParam(value = "birth",required = false) String birth){
        //封装参数
        Map<String,Object> paramMap = new HashMap<String, Object>();
        paramMap.put("owner",owner);
        paramMap.put("fullName",fullName);
        paramMap.put("customerName",customerName);
        paramMap.put("source",source);
        paramMap.put("birth",birth);
        int pageNo = 1;
        if (pageNoStr != null && pageNoStr.length() > 0 && !"0".equals(pageNoStr) ){
            pageNo = Integer.parseInt(pageNoStr);
        }
        int pageSize = 10;
        if (pageSizeStr != null && pageSizeStr.length() > 0 && !"0".equals(pageSizeStr) ){
            pageSize = Integer.parseInt(pageSizeStr);
        }
        int beginNo = (pageNo-1) * pageSize;
        paramMap.put("pageSize",pageSize);
        paramMap.put("beginNo",beginNo);
        //调用service方法
        PaginationVO<Contacts> vo = contactsService.queryContactsForPageByCondition(paramMap);
        return vo;
    }

    @RequestMapping(value = "queryContactsBeforeEdit.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> queryContactsBeforeEdit(String id){

        List<User> userList = userService.quertAllUsers();
        ContactsVO vo = contactsService.queryContactsById(id);
        Map<String,Object> retMap = new HashMap<String, Object>();
        retMap.put("userList",userList);
        retMap.put("vo",vo);
        return retMap;
    }
}
