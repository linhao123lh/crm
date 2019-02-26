package com.tfs.crm.workbench.customer.dao;

import com.tfs.crm.workbench.customer.domain.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerDao {

    int saveCreateCustomer(Customer customer);

    List<Customer> queryCustomerForPageByCondition(Map<String, Object> paramMap);

    Long queryCountByCondition(Map<String, Object> paramMap);

    List<Customer> queryCustomerByName(String name);

    Customer queryCustomerByClueCompany(String name);
}
