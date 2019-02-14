package com.tfs.crm.workbench.clue.dao;

import com.tfs.crm.workbench.clue.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueDao {
    int saveCreateClueByClue(Clue clue);

    List<Clue> selectClueForPageByCondition(Map<String, Object> paramMap);

    Long selectCountByCondition(Map<String, Object> paramMap);
}
