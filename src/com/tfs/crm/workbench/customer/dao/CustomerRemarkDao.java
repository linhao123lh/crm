package com.tfs.crm.workbench.customer.dao;

import com.tfs.crm.workbench.customer.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkDao {
    int saveCustomerRemarkByList(List<CustomerRemark> curList);

    List<CustomerRemark> selectCustomerRemarkByCustomerId(String id);

    int insertCustomerRemark(CustomerRemark remark);

    int deleteCustomerRemarkById(String id);

    int updateCustomerRemark(CustomerRemark remark);
}
