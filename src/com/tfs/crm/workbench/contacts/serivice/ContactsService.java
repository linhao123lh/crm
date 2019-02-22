package com.tfs.crm.workbench.contacts.serivice;

import com.tfs.crm.commons.domain.PaginationVO;
import com.tfs.crm.workbench.contacts.domain.Contacts;

import java.util.Map;

public interface ContactsService {

    int saveCreateContacts(Contacts contacts);

    PaginationVO<Contacts> queryContactsForPageByCondition(Map<String, Object> paramMap);
}
