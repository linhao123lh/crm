package com.tfs.crm.workbench.transaction.dao;

import com.tfs.crm.workbench.transaction.domain.TransactionRemark;

import java.util.List;

public interface TransactionRemarkDao {
    int saveTransactionRemarkByList(List<TransactionRemark> tRemarkList);

    List<TransactionRemark> selectRemarkListByTransactionId(String transactionId);
}
