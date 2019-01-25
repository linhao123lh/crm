package com.tfs.crm.settings.dictionary.value.dao;

import com.tfs.crm.settings.dictionary.value.domain.DictionaryValue;

import java.util.List;

public interface DictionaryValueDao {
    List<DictionaryValue> selectDictonaryValueByTypeCode(String typeCode);
}
