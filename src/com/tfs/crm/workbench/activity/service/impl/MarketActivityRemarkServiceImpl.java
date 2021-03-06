package com.tfs.crm.workbench.activity.service.impl;

import com.tfs.crm.workbench.activity.dao.MarketActivityRemarkDao;
import com.tfs.crm.workbench.activity.domain.MarketActivityRemark;
import com.tfs.crm.workbench.activity.service.MarketActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MarketActivityRemarkServiceImpl implements MarketActivityRemarkService {

    @Autowired
    MarketActivityRemarkDao marketActivityRemarkDao;

    @Override
    public List<MarketActivityRemark> queryMarketAcitivityRemarkById(String id) {
        return marketActivityRemarkDao.queryMarketAcitivityRemarkById(id);
    }

    @Override
    public int deleteActivityRemarkById(String id) {
        return marketActivityRemarkDao.deleteActivityRemarkById(id);
    }

    @Override
    public int saveEditActivityRemark(MarketActivityRemark remark) {
        return marketActivityRemarkDao.saveEditActivityRemark(remark);
    }

    @Override
    public int saveCreateMarketActivityRemark(MarketActivityRemark remark) {
        return marketActivityRemarkDao.saveCreateMarketActivityRemark(remark);
    }
}
