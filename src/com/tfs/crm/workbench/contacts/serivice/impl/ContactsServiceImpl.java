package com.tfs.crm.workbench.contacts.serivice.impl;

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
}
