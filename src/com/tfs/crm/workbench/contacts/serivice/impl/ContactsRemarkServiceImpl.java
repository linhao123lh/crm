package com.tfs.crm.workbench.contacts.serivice.impl;

import com.tfs.crm.workbench.contacts.dao.ContactsRemarkDao;
import com.tfs.crm.workbench.contacts.domain.ContactsRemark;
import com.tfs.crm.workbench.contacts.serivice.ContactsRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @ClassName:ContactsRemarkServiceImpl
 * @Package:com.tfs.crm.workbench.contacts.serivice.impl
 * @Desc:
 * @Date:2019/04/28 9:49
 * @Author:linhao
 */
@Service
public class ContactsRemarkServiceImpl implements ContactsRemarkService {

    @Autowired
    private ContactsRemarkDao contactsRemarkDao;

    @Override
    public List<ContactsRemark> queryContactsDetailByContactsId(String contactsId) {
        return contactsRemarkDao.selectContactsDetailByContactsId(contactsId);
    }
}
