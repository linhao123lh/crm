package com.tfs.crm.workbench.contacts.dao;

import com.tfs.crm.workbench.contacts.domain.ContactsRemark;

import java.util.List;

public interface ContactsRemarkDao {
    int saveContactsRemarkByList(List<ContactsRemark> corList);

    List<ContactsRemark> selectContactsDetailByContactsId(String contactsId);

    int insertContactsRemark(ContactsRemark remark);

    int deleteContactsRemarkById(String id);

    int updateContactsRemark(ContactsRemark remark);
}
