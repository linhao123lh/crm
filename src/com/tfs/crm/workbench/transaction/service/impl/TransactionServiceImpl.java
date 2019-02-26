package com.tfs.crm.workbench.transaction.service.impl;

import com.tfs.crm.workbench.transaction.dao.TransactionDao;
import com.tfs.crm.workbench.transaction.domain.Transaction;
import com.tfs.crm.workbench.transaction.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class TransactionServiceImpl implements TransactionService {

    @Autowired
    private TransactionDao transactionDao;

    /**
     * 保存创建的交易
     * @param transaction
     * @return
     */
    @Override
    @Transactional
    public int saveCreateTransaction(Transaction transaction) {
        return transactionDao.saveCreateTransaction(transaction);
    }
}
