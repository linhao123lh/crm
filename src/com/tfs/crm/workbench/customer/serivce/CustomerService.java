package com.tfs.crm.workbench.customer.serivce;

import com.tfs.crm.commons.domain.PaginationVO;
import com.tfs.crm.workbench.customer.domain.Customer;

import java.util.Map;

public interface CustomerService {

    int saveCreateCustomer(Customer customer);

    PaginationVO<Customer> queryCustomerForPageByCondition(Map<String, Object> paramMap);
}
