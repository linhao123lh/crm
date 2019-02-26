package com.tfs.crm.workbench.transaction.web.controller;

import com.tfs.crm.commons.util.DateUtil;
import com.tfs.crm.commons.util.UUIDUtil;
import com.tfs.crm.settings.qx.user.domain.User;
import com.tfs.crm.settings.qx.user.service.UserService;
import com.tfs.crm.workbench.contacts.domain.Contacts;
import com.tfs.crm.workbench.contacts.serivice.ContactsService;
import com.tfs.crm.workbench.transaction.domain.Transaction;
import com.tfs.crm.workbench.transaction.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("workbench/transaction")
public class TransactionController {

    @Autowired
    private TransactionService transactionService;
    @Autowired
    private UserService userService;
    @Autowired
    private ContactsService contactsService;

    @RequestMapping(value = "createTransaction.do",method = RequestMethod.GET)
    public String createTransaction(HttpServletRequest request){

        List<User> userList = userService.quertAllUsers();
        request.setAttribute("userList",userList);
        return "forward:/workbench/transaction/save.jsp";
    }

    @RequestMapping(value = "queryContactsByLikeName.do",method = RequestMethod.POST)
    @ResponseBody
    public List<Contacts> queryContactsByLikeName(String name){

        List<Contacts> contactsList = contactsService.queryContactsByLikeName(name);
        return contactsList;
    }

    @RequestMapping(value = "saveCreateContacts.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> saveCreateContacts(HttpServletRequest request,String owner,String amountOfMoneyStr,String name,String expectedClosingDate,String customerId,
           String stage,String type,String source,String activityId,String contactsId,String description,String contactSummary,String nextContactTime){

        //封装参数
        Transaction transaction = new Transaction();
        transaction.setId(UUIDUtil.getUuid());
        transaction.setActivityId(activityId);
        if (amountOfMoneyStr != null && amountOfMoneyStr.trim().length()>0){
            transaction.setAmountOfMoney(Long.parseLong(amountOfMoneyStr));
        }
        transaction.setContactsId(contactsId);
        User user = (User) request.getSession().getAttribute("user");
        transaction.setCreateBy(user.getId());
        transaction.setCreateTime(DateUtil.formateDateTime(new Date()));
        transaction.setCustomerId(customerId);
        transaction.setExpectedClosingDate(expectedClosingDate);
        transaction.setName(name);
        transaction.setOwner(owner);
        transaction.setStage(stage);
        transaction.setContactSummary(contactSummary);
        transaction.setDescription(description);
        transaction.setNextContactTime(nextContactTime);
        transaction.setSource(source);
        transaction.setType(type);

        //调用service方法
        int ret = transactionService.saveCreateTransaction(transaction);
        Map<String,Object> retMap = new HashMap<String, Object>();
        if (ret > 0){
            retMap.put("success",true);
        }else {
            retMap.put("success",false);
        }
        return retMap;
    }
}
