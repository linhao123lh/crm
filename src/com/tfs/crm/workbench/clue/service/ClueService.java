package com.tfs.crm.workbench.clue.service;

import com.tfs.crm.commons.domain.PaginationVO;
import com.tfs.crm.workbench.clue.domain.Clue;

import java.util.Map;

public interface ClueService {


    int saveCreateClueByClue(Clue clue);

    PaginationVO<Clue> queryClueForPageByCondition(Map<String, Object> paramMap);

    int batchDeleteClueByIds(String[] ids);

    Clue queryClueById(String id);

    int saveEditClueByClue(Clue clue);

    Clue queryDetailClueById(String id);

    int saveClueConvert(Map<String, Object> paramMap);
}
