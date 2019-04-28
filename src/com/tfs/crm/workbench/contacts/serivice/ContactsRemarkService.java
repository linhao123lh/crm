package com.tfs.crm.workbench.contacts.serivice;

import com.tfs.crm.workbench.contacts.domain.ContactsRemark;

import java.util.List;

/**
 * @ClassName:ContactsRemarkService
 * @Package:com.tfs.crm.workbench.contacts.serivice
 * @Desc:
 * @Date:2019/04/28 9:49
 * @Author:linhao
 */
public interface ContactsRemarkService {
    List<ContactsRemark> queryContactsDetailByContactsId(String id);

    int saveContactRemark(ContactsRemark remark);

    int removeContactsRemarkById(String id);
}
