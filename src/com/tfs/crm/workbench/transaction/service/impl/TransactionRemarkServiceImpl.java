package com.tfs.crm.workbench.transaction.service.impl;

import com.tfs.crm.workbench.transaction.dao.TransactionRemarkDao;
import com.tfs.crm.workbench.transaction.domain.TransactionRemark;
import com.tfs.crm.workbench.transaction.service.TransactionRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @ClassName:TransactionRemarkServiceImpl
 * @Package:com.tfs.crm.workbench.transaction.service.impl
 * @Desc:
 * @Date:2019/04/29 9:18
 * @Author:linhao
 */
@Service
public class TransactionRemarkServiceImpl implements TransactionRemarkService {

    @Autowired
    private TransactionRemarkDao transactionRemarkDao;

    /**
     *  查询某个交易下的备注列表
     * @param transactionId
     * @return
     */
    @Override
    public List<TransactionRemark> queryRemarkListByTransactionId(String transactionId) {
        return transactionRemarkDao.selectRemarkListByTransactionId(transactionId);
    }

    /**
     * 创建交易备注
     * @param remark
     * @return
     */
    @Override
    public int saveCreateTransactionRemark(TransactionRemark remark) {
        return transactionRemarkDao.insertTransactionRemark(remark);
    }
}
