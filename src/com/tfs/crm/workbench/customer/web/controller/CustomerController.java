package com.tfs.crm.workbench.customer.web.controller;

import com.tfs.crm.commons.domain.PaginationVO;
import com.tfs.crm.commons.util.DateUtil;
import com.tfs.crm.commons.util.UUIDUtil;
import com.tfs.crm.settings.qx.user.domain.User;
import com.tfs.crm.settings.qx.user.service.UserService;
import com.tfs.crm.workbench.clue.domain.Clue;
import com.tfs.crm.workbench.contacts.domain.Contacts;
import com.tfs.crm.workbench.contacts.serivice.ContactsService;
import com.tfs.crm.workbench.customer.domain.Customer;
import com.tfs.crm.workbench.customer.domain.CustomerRemark;
import com.tfs.crm.workbench.customer.serivce.CustomerRemarkService;
import com.tfs.crm.workbench.customer.serivce.CustomerService;
import com.tfs.crm.workbench.transaction.domain.Transaction;
import com.tfs.crm.workbench.transaction.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.xml.bind.ValidationEvent;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("workbench/customer")
public class CustomerController {

    @Autowired
    private UserService userService;
    @Autowired
    private CustomerService customerService;
    @Autowired
    private CustomerRemarkService customerRemarkService;
    @Autowired
    private TransactionService transactionService;
    @Autowired
    private ContactsService contactsService;

    /**
     * 创建用户
     * @return
     */
    @RequestMapping(value = "createCustomer.do",method = RequestMethod.POST)
    @ResponseBody
    public List<User> createCustomer(){

        //获取所有用户
        List<User> userList = userService.quertAllUsers();
        return userList;
    }

    /**
     * 保存创建的客户
     * @param request
     * @param owner 拥有者
     * @param name 名称
     * @param grade 登记
     * @param phone 电话
     * @param website 网站
     * @param annualIncomeStr 年收入
     * @param empNumsStr 员工人数
     * @param industry 行业
     * @param description 描述
     * @param country 国家
     * @param province 省/市
     * @param city 市/区
     * @param street 街道
     * @param zipcode 邮编
     * @return
     */
    @RequestMapping(value = "saveCreateCustomer.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> saveCreateCustomer(HttpServletRequest request, @RequestParam(value = "owner",required = true) String owner,
                                                 @RequestParam(value = "name",required = true) String name,
                                                 @RequestParam(value = "grade",required = false) String grade,
                                                 @RequestParam(value = "phone",required = false) String phone,
                                                 @RequestParam(value = "website",required = false) String website,
                                                 @RequestParam(value = "annualIncome",required = false) String annualIncomeStr,
                                                 @RequestParam(value = "empNums",required = false) String empNumsStr,
                                                 @RequestParam(value = "industry",required = false) String industry,
                                                 @RequestParam(value = "description",required = false) String description,
                                                 @RequestParam(value = "country",required = false) String country,
                                                 @RequestParam(value = "province",required = false) String province,
                                                 @RequestParam(value = "city",required = false) String city,
                                                 @RequestParam(value = "street",required = false) String street,
                                                 @RequestParam(value = "zipcode",required = false) String zipcode){
        //封装参数
        Customer customer = new Customer();
        customer.setId(UUIDUtil.getUuid());
        customer.setCreateTime(DateUtil.formateDateTime(new Date()));
        User user = (User) request.getSession().getAttribute("user");
        customer.setCreateBy(user.getId());
        customer.setOwner(owner);
        customer.setName(name);
        customer.setGrade(grade);
        customer.setPhone(phone);
        customer.setWebsite(website);
        if (annualIncomeStr != null && annualIncomeStr.length() > 0){
            customer.setAnnualIncome(Long.parseLong(annualIncomeStr));
        }
        if (empNumsStr != null && empNumsStr.length() > 0){
            customer.setEmpNums(Integer.parseInt(empNumsStr));
        }
        customer.setIndustry(industry);
        customer.setDescription(description);
        customer.setCountry(country);
        customer.setCity(city);
        customer.setProvince(province);
        customer.setStreet(street);
        customer.setZipcode(zipcode);

        //调用service方法
        int ret = customerService.saveCreateCustomer(customer);
        Map<String,Object> retMap = new HashMap<String, Object>();

        if (ret > 0){
            retMap.put("success",true);
        }else {
            retMap.put("success",false);
        }
        return retMap;
    }

    /**
     * 根据条件分页获取客户信息
     * @param owner
     * @param name
     * @param grade
     * @param phone
     * @param website
     * @param industry
     * @param pageNoStr
     * @param pageSizeStr
     * @return
     */
    @RequestMapping(value = "queryCustomerForPageByCondition.do",method = RequestMethod.POST)
    @ResponseBody
    public PaginationVO<Customer> queryCustomerForPageByCondition(@RequestParam(value = "owner",required = true) String owner,
                                                                  @RequestParam(value = "name",required = true) String name,
                                                                  @RequestParam(value = "grade",required = false) String grade,
                                                                  @RequestParam(value = "phone",required = false) String phone,
                                                                  @RequestParam(value = "website",required = false) String website,
                                                                  @RequestParam(value = "industry",required = false) String industry,
                                                                  @RequestParam(value = "pageNo",required = false) String pageNoStr,
                                                                  @RequestParam(value = "pageSize",required = false) String pageSizeStr){
        //封装参数
        Map<String,Object> paramMap = new HashMap<String, Object>();
        paramMap.put("name",name);
        paramMap.put("owner",owner);
        paramMap.put("phone",phone);
        paramMap.put("website",website);
        paramMap.put("grade",grade);
        paramMap.put("industry",industry);
        int pageNo = 1;
        if (pageNoStr != null && pageNoStr.length() > 0 && !"0".equals(pageNoStr)){
            pageNo = Integer.parseInt(pageNoStr);
        }
        int pageSize = 10;
        if (pageSizeStr != null && pageSizeStr.length() > 0){
            pageSize = Integer.parseInt(pageSizeStr);
        }
        int beginNo = (pageNo - 1) * pageSize;
        paramMap.put("pageSize",pageSize);
        paramMap.put("beginNo",beginNo);

        //调用service方法
        PaginationVO<Customer> vo = customerService.queryCustomerForPageByCondition(paramMap);
        return vo;
    }


    /**
     * 根据id查询客户
     * @param id
     * @return
     */
    @RequestMapping(value = "beforeEditQueryCustomer.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> beforeEditQueryCustomer(String id){

        //查询所有用户
        List<User> userList = userService.quertAllUsers();
        //调用service方法
        Customer customer = customerService.queryCustomerById(id);
        Map<String,Object> retMap = new HashMap<String, Object>();
        retMap.put("userList",userList);
        retMap.put("customer",customer);

        return retMap;
    }


    /**
     * 更新客户信息
     * @param request
     * @param id
     * @param owner
     * @param name
     * @param grade
     * @param phone
     * @param website
     * @param street
     * @param annualIncomeStr
     * @param empnumsStr
     * @param industry
     * @param description
     * @param country
     * @param province
     * @param city
     * @param zipcode
     * @return
     */
    @RequestMapping(value = "saveEditCustomer.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> saveEditCustomer(HttpServletRequest request,String id,String owner,String name,String grade,String phone,String website,String street,
           String annualIncomeStr,String empnumsStr,String industry,String description,String country,String province,String city,String zipcode){
        //封装参数
        Customer customer = new Customer();
        customer.setId(id);
        customer.setZipcode(zipcode);
        customer.setOwner(owner);
        customer.setName(name);
        customer.setGrade(grade);
        customer.setWebsite(website);
        if (annualIncomeStr != null && annualIncomeStr.trim().length()>0){
            customer.setAnnualIncome(Long.parseLong(annualIncomeStr));
        }
        if (empnumsStr != null && empnumsStr.trim().length() > 0){
            customer.setEmpNums(Integer.parseInt(empnumsStr));
        }
        customer.setIndustry(industry);
        customer.setDescription(description);
        customer.setCountry(country);
        customer.setCity(city);
        customer.setProvince(province);
        customer.setStreet(street);
        customer.setPhone(phone);
        User user = (User) request.getSession().getAttribute("user");
        customer.setEditBy(user.getId());
        customer.setEditTime(DateUtil.formateDateTime(new Date()));

        //调用方法
        int ret = customerService.saveEditCustomerByCustomer(customer);
        Map<String,Object> retMap = new HashMap<String, Object>();
        if (ret > 0){
            retMap.put("success",true);
        }else {
            retMap.put("success",false);
        }
        return retMap;
    }

    @RequestMapping(value = "deleteCustomer.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> deleteCustomer(String[] id){

        int ret = customerService.deleteCustomerByIds(id);
        Map<String,Object> retMap = new HashMap<String, Object>();
        if (ret > 0){
            retMap.put("success",true);
        }else {
            retMap.put("success",false);
        }
        return retMap;
    }


    /**
     * 获取客户明细信息
     * @param id
     * @return
     */
    @RequestMapping(value = "queryCustomerDetail.do",method = RequestMethod.GET)
    //@ResponseBody
    public String queryCustomerDetail(String id, HttpServletRequest request){

        //客户
        Customer customer = customerService.queryCustomerDetailById(id);
        //备注
        List<CustomerRemark> cusRList = customerRemarkService.queryCustomerRemarkByCustomerId(id);
        //交易
        List<Transaction> transactionList = transactionService.queryTransactionByCustomerId(id);
        //联系人
        List<Contacts> contactsList = contactsService.queryContactsByCustomerId(id);

        //放到request域中
        request.setAttribute("customer",customer);
        request.setAttribute("cusRList",cusRList);
        request.setAttribute("transactionList",transactionList);
        request.setAttribute("contactsList",contactsList);

        return "detail.jsp";
    }


    @PostMapping("saveCreateRemark.do")
    @ResponseBody
    public Map<String,Object> saveCreateRemark(String noteContent, String customerId, HttpServletRequest request){

        //封装参数
        CustomerRemark remark = new CustomerRemark();
        User user = (User) request.getSession().getAttribute("user");
        remark.setNotePerson(user.getId());
        remark.setNoteTime(DateUtil.formateDateTime(new Date()));
        remark.setNoteContent(noteContent);
        remark.setCustomerId(customerId);
        remark.setEditFlag(0);
        remark.setId(UUIDUtil.getUuid());

        //调用service方法
        int ret = customerRemarkService.saveCreateCustomerRemark(remark);

        //处理返回的结果
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
