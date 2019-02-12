package com.tfs.crm.workbench.activity.dao;

import com.tfs.crm.workbench.activity.domain.MarketActivityRemark;

import java.util.List;

public interface MarketActivityRemarkDao {
    List<MarketActivityRemark> queryMarketAcitivityRemarkById(String activityId);

    int saveCreateMarketActivityRemark(MarketActivityRemark remark);

    int deleteActivityRemarkById(String id);

    int saveEditActivityRemark(MarketActivityRemark remark);
}
