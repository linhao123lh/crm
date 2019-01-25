package com.tfs.crm.workbench.activity.service.impl;

import com.tfs.crm.workbench.activity.dao.MarketActivityDao;
import com.tfs.crm.workbench.activity.domain.MarketActivity;
import com.tfs.crm.workbench.activity.service.MarketActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MarketActivityServiceImpl implements MarketActivityService {

    @Autowired
    private MarketActivityDao marketActivityDao;

    @Override
    public int saveCreateActivityByActivity(MarketActivity activity) {
        return marketActivityDao.saveCreateActivityByActivity(activity);
    }
}
