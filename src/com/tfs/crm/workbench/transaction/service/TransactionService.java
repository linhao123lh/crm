package com.tfs.crm.workbench.transaction.service;

import com.tfs.crm.commons.domain.PaginationVO;
import com.tfs.crm.workbench.transaction.domain.Transaction;

import java.util.List;
import java.util.Map;

public interface TransactionService {
    int saveCreateTransaction(Transaction transaction);

    PaginationVO<Transaction> queryTransactionForPageByCondition(Map<String, Object> paramMap);

    Transaction queryTransactionBeforeEditById(String id);

    int saveEditTransaction(Transaction transaction);

    int deleteTransactionByIds(String[] id);

    List<Transaction> queryTransactionByCustomerId(String id);

    Transaction queryTransactionById(String id);

    List<Transaction> queryTransactionListByContactsId(String id);
}
