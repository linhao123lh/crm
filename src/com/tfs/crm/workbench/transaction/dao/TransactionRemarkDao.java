package com.tfs.crm.workbench.transaction.dao;

import com.tfs.crm.workbench.transaction.domain.TransactionRemark;

import java.util.List;

public interface TransactionRemarkDao {
    int saveTransactionRemarkByList(List<TransactionRemark> tRemarkList);

    List<TransactionRemark> selectRemarkListByTransactionId(String transactionId);

    int insertTransactionRemark(TransactionRemark remark);

    int deleteTransactionRemarkById(String id);

    int updateTransactionRemark(TransactionRemark remark);
}
