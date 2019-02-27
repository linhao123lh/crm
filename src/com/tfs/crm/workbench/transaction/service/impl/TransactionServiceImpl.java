package com.tfs.crm.workbench.transaction.service.impl;

import com.tfs.crm.commons.domain.PaginationVO;
import com.tfs.crm.workbench.transaction.dao.TransactionDao;
import com.tfs.crm.workbench.transaction.domain.Transaction;
import com.tfs.crm.workbench.transaction.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

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

    /**
     * 根据条件分页查询交易
     * @param paramMap
     * @return
     */
    @Override
    public PaginationVO<Transaction> queryTransactionForPageByCondition(Map<String, Object> paramMap) {
        PaginationVO<Transaction> vo = new PaginationVO<Transaction>();
        //数据List
        List<Transaction> dataList = transactionDao.queryTransactionForPageByCondition(paramMap);
        //记录条数
        Long count = transactionDao.queryTransactionCountByCondition(paramMap);
        vo.setDataList(dataList);
        vo.setCount(count);
        return vo;
    }
}
