package com.tfs.crm.workbench.clue.dao;

import com.tfs.crm.workbench.clue.domain.Clue;
import com.tfs.crm.workbench.clue.domain.ClueActivityRelation;

import java.util.List;
import java.util.Map;

public interface ClueActivityRelationDao {


    int insertBatchRelationActivityClue(List<ClueActivityRelation> relationList);

    int deleteRelationByActivityIdClueId(Map<String, Object> paramMap);

    List<ClueActivityRelation> queryRelationByClueId(String clueId);

    int deleteRelationByClueId(String clueId);
}
