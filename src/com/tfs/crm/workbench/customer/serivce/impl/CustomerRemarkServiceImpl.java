package com.tfs.crm.workbench.customer.serivce.impl;

import com.tfs.crm.workbench.customer.dao.CustomerRemarkDao;
import com.tfs.crm.workbench.customer.domain.CustomerRemark;
import com.tfs.crm.workbench.customer.serivce.CustomerRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @ClassName:CustomerRemarkServiceImpl
 * @Package:com.tfs.crm.workbench.customer.serivce.impl
 * @Desc:
 * @Date:2019/04/24 10:29
 * @Author:linhao
 */
@Service
public class CustomerRemarkServiceImpl implements CustomerRemarkService {

    @Autowired
    private CustomerRemarkDao customerRemarkDao;

    /**
     * 根据用户Id查询用户备注List
     * @param id
     * @return
     */
    @Override
    public List<CustomerRemark> queryCustomerRemarkByCustomerId(String id) {
        return customerRemarkDao.selectCustomerRemarkByCustomerId(id);
    }

    /**
     * 保存创建的客户备注
     * @param remark
     * @return
     */
    @Override
    public int saveCreateCustomerRemark(CustomerRemark remark) {
        return customerRemarkDao.insertCustomerRemark(remark);
    }

    /**
     * 根据Id删除客户备注
     * @param id
     * @return
     */
    @Override
    public int removeCustomerRemarkById(String id) {
        return customerRemarkDao.deleteCustomerRemarkById(id);
    }

    /**
     * 修改客户备注
     * @param remark
     * @return
     */
    @Override
    public int saveEditCustomerRemark(CustomerRemark remark) {
        return customerRemarkDao.updateCustomerRemark(remark);
    }
}
