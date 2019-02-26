package com.tfs.crm.workbench.transaction.service;

import com.tfs.crm.workbench.transaction.domain.Transaction;

public interface TransactionService {
    int saveCreateTransaction(Transaction transaction);
}
