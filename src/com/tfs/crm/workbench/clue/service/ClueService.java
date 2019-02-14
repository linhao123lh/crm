package com.tfs.crm.workbench.clue.service;

import com.tfs.crm.commons.domain.PaginationVO;
import com.tfs.crm.workbench.clue.domain.Clue;

import java.util.Map;

public interface ClueService {


    int saveCreateClueByClue(Clue clue);

    PaginationVO<Clue> queryClueForPageByCondition(Map<String, Object> paramMap);
}
