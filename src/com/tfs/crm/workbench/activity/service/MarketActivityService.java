package com.tfs.crm.workbench.activity.service;

import com.tfs.crm.commons.domain.PaginationVO;
import com.tfs.crm.workbench.activity.domain.MarketActivity;

import java.util.List;
import java.util.Map;

public interface MarketActivityService {

    int saveCreateActivityByActivity(MarketActivity activity);

    PaginationVO<MarketActivity> queryMarketActivityForPageByCondition(Map<String, Object> paramMap);

    int deleteMarketActivitiesByIds(String[] ids);

    MarketActivity queryMarketActivityById(String id);

    int saveEditMarketActivity(MarketActivity activity);

    MarketActivity queryActivityDetailRemarkById(String activityId);

    List<MarketActivity> queryActivityByClueId(String clueId);

    List<MarketActivity> queryActivityByNameClueId(Map<String, Object> paramMap);
}
