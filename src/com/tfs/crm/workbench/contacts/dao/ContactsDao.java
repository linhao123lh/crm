package com.tfs.crm.workbench.contacts.dao;

import com.tfs.crm.commons.domain.ContactsVO;
import com.tfs.crm.workbench.contacts.domain.Contacts;

import java.util.List;
import java.util.Map;

public interface ContactsDao {
    int saveCreateContacts(Contacts contacts);

    List<Contacts> queryContactsForPageByCondition(Map<String, Object> paramMap);

    Long queryCountByCondition(Map<String, Object> paramMap);

    Contacts queryContactsByClueFullName(String fullName);

    List<Contacts> queryContactsByLikeName(String name);

    Contacts queryContactsById(String id);

    String queryCustomerNameById(String id);

    int saveEditContactsByContacts(Contacts contacts);

    int deleteContactsById(String[] id);
}
