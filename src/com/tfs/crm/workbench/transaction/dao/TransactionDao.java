package com.tfs.crm.workbench.transaction.dao;

import com.tfs.crm.workbench.transaction.domain.Transaction;

public interface TransactionDao {


    int saveTransaction(Transaction transaction);
}
