package com.tfs.crm.workbench.customer.serivce;

import com.tfs.crm.workbench.customer.domain.CustomerRemark;

import java.util.List;

/**
 * @ClassName:CustomerRemarkService
 * @Package:com.tfs.crm.workbench.customer.serivce
 * @Desc:
 * @Date:2019/04/24 10:28
 * @Author:linhao
 */
public interface CustomerRemarkService {

    List<CustomerRemark> queryCustomerRemarkByCustomerId(String id);
}
