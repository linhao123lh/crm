package com.tfs.crm.workbench.activity.dao;

import com.tfs.crm.workbench.activity.domain.MarketActivityRemark;

import java.util.List;

public interface MarketActivityRemarkDao {
    List<MarketActivityRemark> queryMarketAcitivityRemarkById(String activityId);
}
