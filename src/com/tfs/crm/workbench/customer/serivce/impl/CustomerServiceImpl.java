package com.tfs.crm.workbench.customer.serivce.impl;

import com.tfs.crm.commons.domain.PaginationVO;
import com.tfs.crm.workbench.customer.dao.CustomerDao;
import com.tfs.crm.workbench.customer.domain.Customer;
import com.tfs.crm.workbench.customer.serivce.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class CustomerServiceImpl implements CustomerService {

    @Autowired
    private CustomerDao customerDao;

    /**
     * 保存创建的客户
     * @param customer
     * @return
     */
    @Override
    public int saveCreateCustomer(Customer customer) {
        return customerDao.saveCreateCustomer(customer);
    }

    /**
     * 根据条件分页查询客户
     * @param paramMap
     * @return
     */
    @Override
    public PaginationVO<Customer> queryCustomerForPageByCondition(Map<String, Object> paramMap) {
        PaginationVO<Customer> vo = new PaginationVO<Customer>();
        //客户列表
        List<Customer> dataList = customerDao.queryCustomerForPageByCondition(paramMap);
        //条数
        Long count = customerDao.queryCountByCondition(paramMap);
        vo.setDataList(dataList);
        vo.setCount(count);
        return vo;
    }
}
