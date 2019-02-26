package com.tfs.crm.workbench.clue.service.impl;

import com.tfs.crm.commons.domain.PaginationVO;
import com.tfs.crm.commons.util.DateUtil;
import com.tfs.crm.commons.util.UUIDUtil;
import com.tfs.crm.settings.qx.user.domain.User;
import com.tfs.crm.workbench.transaction.dao.TransactionDao;
import com.tfs.crm.workbench.transaction.dao.TransactionRemarkDao;
import com.tfs.crm.workbench.transaction.domain.Transaction;
import com.tfs.crm.workbench.clue.dao.ClueActivityRelationDao;
import com.tfs.crm.workbench.clue.dao.ClueDao;
import com.tfs.crm.workbench.clue.dao.ClueRemarkDao;
import com.tfs.crm.workbench.clue.domain.Clue;
import com.tfs.crm.workbench.clue.domain.ClueActivityRelation;
import com.tfs.crm.workbench.clue.domain.ClueRemark;
import com.tfs.crm.workbench.clue.service.ClueService;
import com.tfs.crm.workbench.contacts.dao.ContactsActivityRelationDao;
import com.tfs.crm.workbench.contacts.dao.ContactsDao;
import com.tfs.crm.workbench.contacts.dao.ContactsRemarkDao;
import com.tfs.crm.workbench.contacts.domain.Contacts;
import com.tfs.crm.workbench.contacts.domain.ContactsActivityRelation;
import com.tfs.crm.workbench.contacts.domain.ContactsRemark;
import com.tfs.crm.workbench.customer.dao.CustomerDao;
import com.tfs.crm.workbench.customer.dao.CustomerRemarkDao;
import com.tfs.crm.workbench.customer.domain.Customer;
import com.tfs.crm.workbench.customer.domain.CustomerRemark;
import com.tfs.crm.workbench.transaction.domain.TransactionRemark;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
public class ClueServiceImpl implements ClueService {

    @Autowired
    private ClueDao clueDao;
    @Autowired
    private CustomerDao customerDao;
    @Autowired
    private ContactsDao contactsDao;
    @Autowired
    private ClueRemarkDao clueRemarkDao;
    @Autowired
    private ContactsRemarkDao contactsRemarkDao;
    @Autowired
    private CustomerRemarkDao customerRemarkDao;
    @Autowired
    private ContactsActivityRelationDao contactsActivityRelationDao;
    @Autowired
    private ClueActivityRelationDao clueActivityRelationDao;
    @Autowired
    private TransactionDao transactionDao;
    @Autowired
    private TransactionRemarkDao transactionRemarkDao;

    @Override
    public int saveCreateClueByClue(Clue clue) {
        return clueDao.saveCreateClueByClue(clue);
    }

    @Override
    public PaginationVO<Clue> queryClueForPageByCondition(Map<String, Object> paramMap) {
        PaginationVO<Clue> vo = new PaginationVO<Clue>();
        //线索列表
        List<Clue> clueList = clueDao.selectClueForPageByCondition(paramMap);
        vo.setDataList(clueList);
        //线索总条数
        Long count = clueDao.selectCountByCondition(paramMap);
        vo.setCount(count);
        return vo;
    }

    @Override
    public int batchDeleteClueByIds(String[] ids) {
        return clueDao.deleteClueByIds(ids);
    }

    @Override
    public Clue queryClueById(String id) {
        return clueDao.queryClueById(id);
    }

    @Override
    @Transactional
    public int saveEditClueByClue(Clue clue) {
        int ret =  clueDao.saveEditClueByClue(clue);
        System.out.println("修改线索的条数为: "+ret);
        return ret;
    }

    @Override
    public Clue queryDetailClueById(String id) {
        return clueDao.queryDetailClueById(id);
    }

    @Override
    @Transactional
    public int saveClueConvert(Map<String, Object> paramMap) {
        User user  = (User) paramMap.get("user");
        String clueId = (String) paramMap.get("clueId");
        String isCreateTransaction = (String) paramMap.get("isCreateTransaction");

        //根据线索Id获取线索信息
        Clue clue = clueDao.queryClueById(clueId);


        //根据线索的公司名称精准查询客户信息
        Customer c = customerDao.queryCustomerByClueCompany(clue.getCompany());
        //把线索中有关公司的信息转换到客户表中
        if (c == null){
            c = new Customer();
            c.setId(UUIDUtil.getUuid());
            c.setPhone(clue.getPhone());
            c.setStreet(clue.getStreet());
            c.setProvince(clue.getProvince());
            c.setCity(clue.getCity());
            c.setCountry(clue.getCountry());
            c.setDescription(clue.getDescription());
            c.setIndustry(clue.getIndustry());
            c.setEmpNums(clue.getEmpNums());
            c.setAnnualIncome(clue.getAnnualIncome());
            c.setWebsite(clue.getWebsite());
            c.setGrade(clue.getGrade());
            c.setName(clue.getCompany());
            c.setOwner(clue.getOwner());
            c.setCreateBy(user.getId());
            c.setCreateTime(DateUtil.formateDateTime(new Date()));
            c.setZipcode(clue.getZipcode());
            int ret1 = customerDao.saveCreateCustomer(c);
            System.out.println("保存客户ret1=="+ret1);
        }


        //根据线索的名称精准查询联系人信息
        Contacts cs = contactsDao.queryContactsByClueFullName(clue.getFullName());
        //把线索中有关个人的信息转换到联系人表中
        if (cs == null){
            cs = new Contacts();
            cs.setId(UUIDUtil.getUuid());
            cs.setZipcode(clue.getZipcode());
            cs.setStreet(clue.getStreet());
            cs.setCity(clue.getCity());
            cs.setProvince(clue.getProvince());
            cs.setCountry(clue.getCountry());
            cs.setContactSummary(clue.getContactSummary());
            cs.setDescription(clue.getDescription());
            cs.setCustomerId(c.getId());   //客户Id
            cs.setEmail(clue.getEmail());
            cs.setMphone(clue.getMphone());
            cs.setJob(clue.getJob());
            cs.setAppellation(clue.getAppellation());
            cs.setSource(clue.getSource());
            cs.setOwner(clue.getOwner());
            cs.setCreateTime(DateUtil.formateDateTime(new Date()));
            cs.setCreateBy(user.getId());   //创建者
            cs.setFullName(clue.getFullName());
            int ret2 = contactsDao.saveCreateContacts(cs);
            System.out.println("保存联系人ret2=="+ret2);
        }


        //根据clueId查询该线索下所有的备注信息
        List<ClueRemark> crList = clueRemarkDao.queryClueRemarkListByClueId(clueId);
        //把线索的备注信息转换到客户备注表中一份
        List<CustomerRemark> curList = new ArrayList<CustomerRemark>();
        CustomerRemark cur = null;
        //把线索的备注信息转换到联系人备注表中一份
        List<ContactsRemark> corList = new ArrayList<ContactsRemark>();
        ContactsRemark cor = null;
        if (crList != null && crList.size() >0){

            for (ClueRemark cr : crList) {
                //客户
                cur = new CustomerRemark();
                cur.setId(UUIDUtil.getUuid());
                cur.setCustomerId(c.getId());   //客户Id
                cur.setEditFlag(cr.getEditFlag());
                cur.setNoteContent(cr.getNoteContent());
                cur.setNoteTime(cr.getNoteTime());
                cur.setNotePerson(cr.getNotePerson());
                cur.setEditPerson(cr.getEditPerson());
                cur.setEditTime(cr.getEditTime());
                curList.add(cur);

                //联系人
                cor = new ContactsRemark();
                cor.setId(UUIDUtil.getUuid());
                cor.setContactsId(cs.getId());   //联系人Id
                cor.setEditFlag(cr.getEditFlag());
                cor.setNoteContent(cr.getNoteContent());
                cor.setNotePerson(cr.getNotePerson());
                cor.setNoteTime(cr.getNoteTime());
                cor.setEditPerson(cr.getEditPerson());
                cor.setEditTime(cr.getEditTime());
                corList.add(cor);
            }
            int ret3 = customerRemarkDao.saveCustomerRemarkByList(curList);
            System.out.println("保存客户备注ret3=="+ret3);

            int ret4 = contactsRemarkDao.saveContactsRemarkByList(corList);
            System.out.println("保存联系人备注ret4=="+ret4);
        }


        //根据线索Id查询和线索有关的市场活动
        List<ClueActivityRelation> carList = clueActivityRelationDao.queryRelationByClueId(clueId);
        //把线索和市场活动的关联关系转换到联系人和市场活动的关联关系表中
        List<ContactsActivityRelation> coarList = new ArrayList<ContactsActivityRelation>();
        ContactsActivityRelation coar = null;
        if (carList != null && carList.size() > 0){
            for (ClueActivityRelation car : carList) {
                //联系人
                coar = new ContactsActivityRelation();
                coar.setId(UUIDUtil.getUuid());
                coar.setActivityId(car.getActivityId());
                coar.setContactsId(cs.getId());    //联系人Id
                coarList.add(coar);
            }
            int ret5 = contactsActivityRelationDao.saveContactsActivityRelationByList(coarList);
            System.out.println("联系人和市场活动关系ret5=="+ret5);
        }


        if ("true".equals(isCreateTransaction)){
            //如果需要创建交易,还要往交易表中添加一条记录
            Transaction transaction = new Transaction();
            transaction.setId(UUIDUtil.getUuid());
            transaction.setActivityId((String) paramMap.get("activityId"));
            String amountOfMoney = (String) paramMap.get("amountOfMoney");
            if (amountOfMoney != null && amountOfMoney.length() > 0){
                transaction.setAmountOfMoney(Long.parseLong(amountOfMoney));
            }
            transaction.setContactsId(cs.getId());   //联系人Id
            transaction.setCreateBy(user.getId());   //创建者Id
            transaction.setCreateTime(DateUtil.formateDateTime(new Date()));
                transaction.setCustomerId(c.getId());    //客户Id
                transaction.setExpectedClosingDate((String) paramMap.get("expectedClosingDate"));
                transaction.setName((String) paramMap.get("tradeName"));
                transaction.setOwner(user.getId());    //所有者Id
                transaction.setStage((String) paramMap.get("stage"));
                int ret6 = transactionDao.saveTransaction(transaction);
                System.out.println("保存交易ret6=="+ret6);

                //如果需要创建交易,还要把线索的备注信息转换到交易备注表中一份
                List<TransactionRemark> tRemarkList = new ArrayList<TransactionRemark>();
                TransactionRemark tRemark = null;
                if (crList != null && crList.size() > 0){
                    for (ClueRemark cr : crList) {
                        tRemark = new TransactionRemark();
                        tRemark.setId(UUIDUtil.getUuid());
                        tRemark.setEditFlag(0);
                        tRemark.setEditPerson(cr.getEditPerson());
                        tRemark.setEditTime(cr.getEditTime());
                        tRemark.setNoteContent(cr.getNoteContent());
                        tRemark.setNotePerson(cr.getNotePerson());
                        tRemark.setNoteTime(cr.getNoteTime());
                        tRemark.setTransactionId(transaction.getId());
                        tRemarkList.add(tRemark);
                    }
                    int ret7 = transactionRemarkDao.saveTransactionRemarkByList(tRemarkList);
                    System.out.println("保存交易备注ret7=="+ret7);
            }
        }


        //删除该线索下的所有备注
        int ret8 = clueRemarkDao.deleteClueRemarkByClueId(clueId);
        System.out.println("删除线索备注ret8=="+ret8);

        //删除该线索和市场活动的关联关系
        int ret9 = clueActivityRelationDao.deleteRelationByClueId(clueId);
        System.out.println("删除与线索有关的市场活动ret9=="+ret9);

        //删除该线索
        int ret10 = clueDao.deleteClueById(clueId);
        System.out.println("删除该条线索ret10=="+ret10);

        return 0;
    }
}
