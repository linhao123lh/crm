package com.tfs.crm.workbench.clue.service.impl;

import com.tfs.crm.workbench.clue.dao.ClueDao;
import com.tfs.crm.workbench.clue.domain.Clue;
import com.tfs.crm.workbench.clue.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ClueServiceImpl implements ClueService {

    @Autowired
    private ClueDao clueDao;

    @Override
    public int saveCreateClueByClue(Clue clue) {
        return clueDao.saveCreateClueByClue(clue);
    }
}
