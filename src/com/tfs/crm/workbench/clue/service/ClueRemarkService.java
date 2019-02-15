package com.tfs.crm.workbench.clue.service;

import com.tfs.crm.workbench.clue.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkService {
    List<ClueRemark> queryClueRemarkByClueId(String clueId);
}
