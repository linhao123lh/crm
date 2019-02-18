package com.tfs.crm.workbench.clue.service.impl;

import com.tfs.crm.workbench.clue.dao.ClueActivityRelationDao;
import com.tfs.crm.workbench.clue.domain.ClueActivityRelation;
import com.tfs.crm.workbench.clue.service.ClueActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class ClueActivityRelationServiceImpl implements ClueActivityRelationService {

    @Autowired
    private ClueActivityRelationDao clueActivityRelationDao;

    /**
     * 批量添加线索和市场活动关联关系
     * @param relationList
     * @return
     */
    @Override
    public int relationActivityByActivityIdClueId(List<ClueActivityRelation> relationList) {
        return clueActivityRelationDao.insertBatchRelationActivityClue(relationList);
    }

    /**
     * 删除线索和市场活动关联关系
     * @param paramMap
     * @return
     */
    @Override
    public int saveUnbundActivityByActivityIdClueId(Map<String, Object> paramMap) {
        return clueActivityRelationDao.deleteRelationByActivityIdClueId(paramMap);
    }
}
