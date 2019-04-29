package com.tfs.crm.workbench.transaction.web.controller;

import com.tfs.crm.commons.domain.PaginationVO;
import com.tfs.crm.commons.util.DateUtil;
import com.tfs.crm.commons.util.UUIDUtil;
import com.tfs.crm.settings.qx.user.domain.User;
import com.tfs.crm.settings.qx.user.service.UserService;
import com.tfs.crm.workbench.contacts.domain.Contacts;
import com.tfs.crm.workbench.contacts.serivice.ContactsService;
import com.tfs.crm.workbench.transaction.domain.Transaction;
import com.tfs.crm.workbench.transaction.domain.TransactionRemark;
import com.tfs.crm.workbench.transaction.service.TransactionRemarkService;
import com.tfs.crm.workbench.transaction.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
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
    @Autowired
    private TransactionRemarkService transactionRemarkService;

    /**
     * 创建交易
     * @param request
     * @return
     */
    @RequestMapping(value = "createTransaction.do",method = RequestMethod.GET)
    public String createTransaction(HttpServletRequest request){

        List<User> userList = userService.quertAllUsers();
        request.setAttribute("userList",userList);
        return "forward:/workbench/transaction/save.jsp";
    }

    /**
     * 根据交易名称模糊查询交易列表
     * @param name
     * @return
     */
    @RequestMapping(value = "queryContactsByLikeName.do",method = RequestMethod.POST)
    @ResponseBody
    public List<Contacts> queryContactsByLikeName(String name){

        List<Contacts> contactsList = contactsService.queryContactsByLikeName(name);
        return contactsList;
    }

    /**
     * 保存创建的交易
     * @param request
     * @param owner
     * @param amountOfMoneyStr
     * @param name
     * @param expectedClosingDate
     * @param customerId
     * @param stage
     * @param type
     * @param source
     * @param activityId
     * @param contactsId
     * @param description
     * @param contactSummary
     * @param nextContactTime
     * @return
     */
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

    /**
     * 分页查询交易
     * @param pageNoStr
     * @param pageSizeStr
     * @param owner
     * @param name
     * @param amountOfMoneyStr
     * @param contactsName
     * @param stage
     * @param type
     * @param source
     * @param customerName
     * @return
     */
    @PostMapping("queryTransactionForPageByCondition.do")
    @ResponseBody
    public PaginationVO<Transaction> queryTransactionForPageByCondition(String pageNoStr,String pageSizeStr,String owner,String name,String
            amountOfMoneyStr,String contactsName,String stage,String type,String source,String customerName){

        //封装参数
        Map<String,Object> paramMap = new HashMap<String, Object>();
        paramMap.put("owner",owner);
        paramMap.put("name",name);
        paramMap.put("contactsName",contactsName);
        paramMap.put("stage",stage);
        paramMap.put("type",type);
        paramMap.put("source",source);
        paramMap.put("customerName",customerName);
        if (amountOfMoneyStr != null && amountOfMoneyStr.trim().length()>0){
            paramMap.put("amountOfMoney",Long.parseLong(amountOfMoneyStr));
        }
        int pageNo = 1;
        if (pageNoStr != null && pageNoStr.trim().length()>0 && !"0".equals(pageNoStr)){
            pageNo = Integer.parseInt(pageNoStr);
        }
        int pageSize = 10;
        if (pageSizeStr != null && pageSizeStr.trim().length()>0 && !"0".equals(pageSizeStr)){
            pageSize = Integer.parseInt(pageSizeStr);
        }
        int beginNo = (pageNo - 1) * pageSize;
        paramMap.put("beginNo",beginNo);
        paramMap.put("pageSize",pageSize);
        //调用service方法
        PaginationVO<Transaction> vo = transactionService.queryTransactionForPageByCondition(paramMap);
        return vo;
    }

    /**
     * 修改前查询交易
     * @param id
     * @param request
     * @return
     */
    @GetMapping(value = "queryTransactionBeforeEdit.do")
    public ModelAndView queryTransactionBeforeEdit(@RequestParam(value = "id",required = true) String id, HttpServletRequest request){

        Transaction transaction = transactionService.queryTransactionBeforeEditById(id);
        List<User> userList = userService.quertAllUsers();
        request.setAttribute("userList",userList);

        Transaction transaction1 = transactionService.queryTransactionById(id);
        String customerId = transaction1.getCustomerId();
        String contactsId = transaction1.getContactsId();
        ModelAndView mv = new ModelAndView();
        mv.addObject("customerId",customerId);
        mv.addObject("contactsId",contactsId);
        mv.setViewName("forward:/workbench/transaction/edit.jsp");
        request.getSession().setAttribute("transaction",transaction);
        //return "forward:/workbench/transaction/edit.jsp";
        return mv;
    }

    /**
     * 保存修改的交易
     * @param request
     * @param id
     * @param amountOfMoneyStr
     * @param name
     * @param expectedClosingDate
     * @param customerId
     * @param stage
     * @param type
     * @param source
     * @param activityId
     * @param contactsId
     * @param description
     * @param contactSummary
     * @param nextContactTime
     * @return
     */
    @PostMapping(value = "saveEditTransaction.do")
    @ResponseBody
    public Map<String,Object> saveEditTransaction(HttpServletRequest request,String owner,String id,
           String amountOfMoneyStr,String name,String expectedClosingDate,String customerId,String stage,String type,
           String source,String activityId,String contactsId,String description,String contactSummary,String nextContactTime){

        //封装参数
        Transaction transaction = new Transaction();
        transaction.setOwner(owner);
        transaction.setId(id);
        transaction.setType(type);
        transaction.setSource(source);
        transaction.setNextContactTime(nextContactTime);
        transaction.setDescription(description);
        transaction.setContactSummary(contactSummary);
        transaction.setStage(stage);
        transaction.setName(name);
        transaction.setExpectedClosingDate(expectedClosingDate);
        transaction.setCustomerId(customerId);
        transaction.setContactsId(contactsId);
        if (amountOfMoneyStr!= null && amountOfMoneyStr.trim().length()>0){
            transaction.setAmountOfMoney(Long.parseLong(amountOfMoneyStr));
        }
        transaction.setActivityId(activityId);
        transaction.setEditTime(DateUtil.formateDateTime(new Date()));
        User user = (User) request.getSession().getAttribute("user");
        transaction.setEditBy(user.getId());
        //调用service方法
        int ret = transactionService.saveEditTransaction(transaction);
        Map<String,Object> retMap = new HashMap<String, Object>();
        if (ret > 0){
            retMap.put("success",true);
        }else {
            retMap.put("success",false);
        }
        return retMap;
    }

    @PostMapping(value = "deleteTransaction.do")
    @ResponseBody
    public Map<String,Object> deleteTransaction(String[] id){
        int ret = transactionService.deleteTransactionByIds(id);
        Map<String,Object> retMap = new HashMap<String, Object>();
        if (ret > 0){
            retMap.put("success",true);
        }else {
            retMap.put("success",false);
        }
        return retMap;
    }

    /**
     * 交易详情页面
     * @param id
     * @return
     */
    @RequestMapping("queryTransactionDetail.do")
    public ModelAndView queryTransactionDetail(String id){

        //交易
        Transaction transaction = transactionService.queryTransactionForDetailById(id);

        //交易备注
        List<TransactionRemark> remarkList = transactionRemarkService.queryRemarkListByTransactionId(id);

        ModelAndView mv = new ModelAndView();
        mv.addObject("transaction",transaction);
        mv.addObject("remarkList",remarkList);
        mv.setViewName("forward:/workbench/transaction/detail.jsp");
        return mv;
    }


    /**
     * 创建交易备注
     * @param transactionId
     * @param noteContent
     * @param request
     * @return
     */
    @PostMapping("saveCreateTransactionRemark.do")
    @ResponseBody
    public Map<String,Object> saveCreateTransactionRemark(String transactionId, String noteContent, HttpServletRequest request){

        TransactionRemark remark = new TransactionRemark();
        remark.setId(UUIDUtil.getUuid());
        remark.setTransactionId(transactionId);
        remark.setNoteTime(DateUtil.formateDateTime(new Date()));
        User user = (User) request.getSession().getAttribute("user");
        remark.setNotePerson(user.getId());
        remark.setNoteContent(noteContent);
        remark.setEditFlag(0);

        int ret = transactionRemarkService.saveCreateTransactionRemark(remark);
        Map<String,Object> retMap = new HashMap<String, Object>();
        if (ret > 0){
            retMap.put("success",true);
            retMap.put("remark",remark);
        }else {
            retMap.put("success",false);
        }

        return retMap;
    }

    @PostMapping("removeTransactionRemark.do")
    @ResponseBody
    public Map<String,Object> removeTransactionRemark(String id){

        int ret = transactionRemarkService.removeTransactionRemarkById(id);
        Map<String,Object> retMap = new HashMap<String, Object>();
        if (ret >0){
            retMap.put("success",true);
        }else {
            retMap.put("success",false);
        }
        return retMap;
    }

}
