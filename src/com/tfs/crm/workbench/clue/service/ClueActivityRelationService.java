package com.tfs.crm.workbench.clue.service;

import com.tfs.crm.workbench.clue.domain.ClueActivityRelation;

import java.util.List;
import java.util.Map;

public interface ClueActivityRelationService {
    int relationActivityByActivityIdClueId(List<ClueActivityRelation> relationList);

    int saveUnbundActivityByActivityIdClueId(Map<String, Object> paramMap);
}
