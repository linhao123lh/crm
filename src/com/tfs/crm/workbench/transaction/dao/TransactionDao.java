package com.tfs.crm.workbench.transaction.dao;

import com.tfs.crm.workbench.transaction.domain.Transaction;

import java.util.List;
import java.util.Map;

public interface TransactionDao {


    int saveTransaction(Transaction transaction);

    int saveCreateTransaction(Transaction transaction);

    List<Transaction> queryTransactionForPageByCondition(Map<String, Object> paramMap);

    Long queryTransactionCountByCondition(Map<String, Object> paramMap);
}
