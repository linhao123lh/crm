package com.tfs.crm.workbench.activity.dao;

import com.tfs.crm.workbench.activity.domain.MarketActivity;

import java.util.List;
import java.util.Map;

public interface MarketActivityDao {
    int saveCreateActivityByActivity(MarketActivity activity);

    List<MarketActivity> queryMarketActivityForPageByCondition(Map<String, Object> paramMap);

    Long queryCountForPageByCondition(Map<String, Object> paramMap);
}
