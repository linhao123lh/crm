package com.tfs.crm.workbench.clue.service.impl;

import com.tfs.crm.workbench.clue.dao.ClueRemarkDao;
import com.tfs.crm.workbench.clue.domain.ClueRemark;
import com.tfs.crm.workbench.clue.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ClueRemarkServiceImpl implements ClueRemarkService {

    @Autowired
    private ClueRemarkDao clueRemarkDao;

    /**
     * 根据线索Id获取线索备注类别
     * @param clueId
     * @return
     */
    @Override
    public List<ClueRemark> queryClueRemarkByClueId(String clueId) {
        return clueRemarkDao.queryClueRemarkByClueId(clueId);
    }

    /**
     * 保存创建的线索备注
     * @param remark
     * @return
     */
    @Override
    public int saveCreateClueRemark(ClueRemark remark) {
        return clueRemarkDao.saveCreateClueRemark(remark);
    }
}
