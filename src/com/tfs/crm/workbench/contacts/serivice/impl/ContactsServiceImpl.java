package com.tfs.crm.workbench.contacts.serivice.impl;

import com.tfs.crm.workbench.contacts.dao.ContactsDao;
import com.tfs.crm.workbench.contacts.domain.Contacts;
import com.tfs.crm.workbench.contacts.serivice.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
}
