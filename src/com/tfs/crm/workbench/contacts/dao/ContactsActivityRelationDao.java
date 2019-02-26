package com.tfs.crm.workbench.contacts.dao;

import com.tfs.crm.workbench.contacts.domain.ContactsActivityRelation;

import java.util.List;

public interface ContactsActivityRelationDao {
    int saveContactsActivityRelationByList(List<ContactsActivityRelation> coarList);
}
