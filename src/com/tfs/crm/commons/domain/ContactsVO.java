package com.tfs.crm.commons.domain;

import com.tfs.crm.workbench.contacts.domain.Contacts;

public class ContactsVO {

    private Contacts contacts;

    private String name;

    public Contacts getContacts() {
        return contacts;
    }

    public void setContacts(Contacts contacts) {
        this.contacts = contacts;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
