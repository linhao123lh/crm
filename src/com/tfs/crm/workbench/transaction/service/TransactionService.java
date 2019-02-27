package com.tfs.crm.workbench.transaction.service;

import com.tfs.crm.commons.domain.PaginationVO;
import com.tfs.crm.workbench.transaction.domain.Transaction;

import java.util.Map;

public interface TransactionService {
    int saveCreateTransaction(Transaction transaction);

    PaginationVO<Transaction> queryTransactionForPageByCondition(Map<String, Object> paramMap);
}
