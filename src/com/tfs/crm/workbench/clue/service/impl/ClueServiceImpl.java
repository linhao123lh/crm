package com.tfs.crm.workbench.clue.service.impl;

import com.tfs.crm.commons.domain.PaginationVO;
import com.tfs.crm.workbench.clue.dao.ClueDao;
import com.tfs.crm.workbench.clue.domain.Clue;
import com.tfs.crm.workbench.clue.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class ClueServiceImpl implements ClueService {

    @Autowired
    private ClueDao clueDao;

    @Override
    public int saveCreateClueByClue(Clue clue) {
        return clueDao.saveCreateClueByClue(clue);
    }

    @Override
    public PaginationVO<Clue> queryClueForPageByCondition(Map<String, Object> paramMap) {
        PaginationVO<Clue> vo = new PaginationVO<Clue>();
        //线索列表
        List<Clue> clueList = clueDao.selectClueForPageByCondition(paramMap);
        vo.setDataList(clueList);
        //线索总条数
        Long count = clueDao.selectCountByCondition(paramMap);
        vo.setCount(count);
        return vo;
    }

    @Override
    public int batchDeleteClueByIds(String[] ids) {
        return clueDao.deleteClueByIds(ids);
    }
}
