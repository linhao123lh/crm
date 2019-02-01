package com.tfs.crm.workbench.activity.service.impl;

import com.tfs.crm.commons.domain.PaginationVO;
import com.tfs.crm.workbench.activity.dao.MarketActivityDao;
import com.tfs.crm.workbench.activity.domain.MarketActivity;
import com.tfs.crm.workbench.activity.service.MarketActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class MarketActivityServiceImpl implements MarketActivityService {

    @Autowired
    private MarketActivityDao marketActivityDao;

    /**
     * 保存创建的市场活动
     * @param activity
     * @return
     */
    @Override
    public int saveCreateActivityByActivity(MarketActivity activity) {
        return marketActivityDao.saveCreateActivityByActivity(activity);
    }

    /**
     *根据条件查询市场活动
     * @param paramMap
     * @return
     */
    @Override
    public PaginationVO<MarketActivity> queryMarketActivityForPageByCondition(Map<String, Object> paramMap) {

        PaginationVO<MarketActivity> vo =  new PaginationVO<MarketActivity>();

        Long count = marketActivityDao.queryCountForPageByCondition(paramMap);
        List<MarketActivity> activityList = marketActivityDao.queryMarketActivityForPageByCondition(paramMap);
        vo.setCount(count);
        vo.setDataList(activityList);

        return vo;
    }

    /**
     * 批量删除市场活动
     * @param ids
     * @return
     */
    @Override
    public int deleteMarketActivitiesByIds(String[] ids) {
        return marketActivityDao.deleteActivitiesByIds(ids);
    }

    /**
     * 根据Id获取市场活动信息
     * @param id
     * @return
     */
    @Override
    public MarketActivity queryMarketActivityById(String id) {
        return marketActivityDao.queryMarketActivityById(id);
    }

    @Override
    public MarketActivity queryActivityDetailRemarkById(String activityId) {
        return marketActivityDao.queryActivityDetailRemarkById(activityId);
    }

    @Override
    public int saveEditMarketActivity(MarketActivity activity) {
        return marketActivityDao.saveEditMarketActivity(activity);
    }
}
