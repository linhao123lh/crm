package com.tfs.crm.settings.dictionary.value.service;

import com.tfs.crm.settings.dictionary.value.domain.DictionaryValue;

import java.util.List;

public interface DictionaryValueService {
    List<DictionaryValue> queryDictorynaryValueByTypeCode(String marketActivityStatus);
}
