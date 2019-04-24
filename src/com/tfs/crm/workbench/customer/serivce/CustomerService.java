package com.tfs.crm.workbench.customer.serivce;

import com.tfs.crm.commons.domain.PaginationVO;
import com.tfs.crm.workbench.customer.domain.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerService {

    int saveCreateCustomer(Customer customer);

    PaginationVO<Customer> queryCustomerForPageByCondition(Map<String, Object> paramMap);

    List<Customer> queryCustomerByName(String name);

    Customer queryCustomerById(String id);

    int saveEditCustomerByCustomer(Customer customer);

    int deleteCustomerByIds(String[] ids);

    Customer queryCustomerDetailById(String id);
}
