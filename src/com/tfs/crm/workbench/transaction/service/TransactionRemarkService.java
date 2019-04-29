package com.tfs.crm.workbench.transaction.service;

import com.tfs.crm.workbench.transaction.domain.TransactionRemark;

import java.util.List;

/**
 * @ClassName:TransactionRemarkService
 * @Package:com.tfs.crm.workbench.transaction.service
 * @Desc:
 * @Date:2019/04/29 9:17
 * @Author:linhao
 */
public interface TransactionRemarkService {
    List<TransactionRemark> queryRemarkListByTransactionId(String transactionId);
}
