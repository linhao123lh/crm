package com.tfs.crm.workbench.activity.service;

import com.tfs.crm.workbench.activity.domain.MarketActivityRemark;

import java.util.List;

public interface MarketActivityRemarkService {
    List<MarketActivityRemark> queryMarketAcitivityRemarkById(String id);

    int saveCreateMarketActivityRemark(MarketActivityRemark remark);

    int deleteActivityRemarkById(String id);

    int saveEditActivityRemark(MarketActivityRemark remark);
}
