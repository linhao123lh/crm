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

    /**
     * 通过Id查询交易信息
     * @param id
     * @return
     */
    @Override
    public Transaction queryTransactionBeforeEditById(String id) {
        return transactionDao.queryTransactionById(id);
    }

    /**
     * 保存修改的交易
     * @param transaction
     * @return
     */
    @Override
    public int saveEditTransaction(Transaction transaction) {
        return transactionDao.saveEditTransaction(transaction);
    }

    /**
     * 批量删除交易
     * @param id
     * @return
     */
    @Override
    public int deleteTransactionByIds(String[] id) {
        return transactionDao.deleteTransactionByIds(id);
    }

    /**
     * 查询用户下面的交易
     * @param customerId
     * @return
     */
    @Override
    public List<Transaction> queryTransactionByCustomerId(String customerId) {
        return transactionDao.selectTransactionListByCustomerId(customerId);
    }


    /**
     * 根据交易Id查询客户id及联系人Id
     * @param id
     * @return
     */
    @Override
    public Transaction queryTransactionById(String id) {
        return transactionDao.selectCustomerIdContactsIdById(id);
    }

    /**
     * 根据联系人Id查询交易
     * @param contactsId
     * @return
     */
    @Override
    public List<Transaction> queryTransactionListByContactsId(String contactsId) {
        return transactionDao.selectTransactionLIstByContactsId(contactsId);
    }

    /**
     * 交易详情页面的交易信息
     * @param id
     * @return
     */
    @Override
    public Transaction queryTransactionForDetailById(String id) {
        return transactionDao.selectTransactionForDeatilById(id);
    }
}
