package com.tfs.crm.workbench.clue.dao;

import com.tfs.crm.workbench.clue.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {
    List<ClueRemark> queryClueRemarkByClueId(String clueId);
}
