package com.tfs.crm.workbench.contacts.serivice.impl;

import com.tfs.crm.commons.domain.ContactsVO;
import com.tfs.crm.commons.domain.PaginationVO;
import com.tfs.crm.workbench.contacts.dao.ContactsDao;
import com.tfs.crm.workbench.contacts.domain.Contacts;
import com.tfs.crm.workbench.contacts.serivice.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class ContactsServiceImpl implements ContactsService {

    @Autowired
    private ContactsDao contactsDao;

    /**
     * 保存创建的联系人
     * @param contacts
     * @return
     */
    @Override
    public int saveCreateContacts(Contacts contacts) {
        return contactsDao.saveCreateContacts(contacts);
    }

    /**
     * 根据条件分页查询联系人
     * @param paramMap
     * @return
     */
    @Override
    public PaginationVO<Contacts> queryContactsForPageByCondition(Map<String, Object> paramMap) {
        PaginationVO<Contacts> vo = new PaginationVO<Contacts>();
        //数据列表
        List<Contacts> dataList = contactsDao.queryContactsForPageByCondition(paramMap);
        //记录条数
        Long count = contactsDao.queryCountByCondition(paramMap);
        vo.setCount(count);
        vo.setDataList(dataList);
        return vo;
    }

    /**
     * 根据名称模糊查询客户信息
     * @param name
     * @return
     */
    @Override
    public List<Contacts> queryContactsByLikeName(String name) {
        return contactsDao.queryContactsByLikeName(name);
    }

    /**
     * 根据id获取联系人信息
     * @param id
     * @return
     */
    @Override
    public ContactsVO queryContactsById(String id) {
        ContactsVO vo = new ContactsVO();
        Contacts contacts = contactsDao.queryContactsById(id);
        String name = contactsDao.queryCustomerNameById(id);
        vo.setContacts(contacts);
        vo.setName(name);
        return vo;
    }

    /**
     * 保存创建的联系人
     * @param contacts
     * @return
     */
    @Override
    public int saveEditContactsByContacts(Contacts contacts) {
        return contactsDao.saveEditContactsByContacts(contacts);
    }

    /**
     * 批量删除联系人
     * @param id
     * @return
     */
    @Override
    public int deleteContactsById(String[] id) {
        return contactsDao.deleteContactsById(id);
    }

    @Override
    public List<Contacts> queryContactsByCustomerId(String customerId) {
        return contactsDao.queryContactsByCustomerId(customerId);
    }
}
