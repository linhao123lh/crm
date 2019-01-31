package com.tfs.crm.workbench.activity.service;

import com.tfs.crm.commons.domain.PaginationVO;
import com.tfs.crm.workbench.activity.domain.MarketActivity;

import java.util.Map;

public interface MarketActivityService {

    int saveCreateActivityByActivity(MarketActivity activity);

    PaginationVO<MarketActivity> queryMarketActivityForPageByCondition(Map<String, Object> paramMap);

    int deleteMarketActivitiesByIds(String[] ids);
}
