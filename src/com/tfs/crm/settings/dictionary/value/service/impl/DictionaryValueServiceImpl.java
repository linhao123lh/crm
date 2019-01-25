package com.tfs.crm.settings.dictionary.value.service.impl;

import com.tfs.crm.settings.dictionary.value.dao.DictionaryValueDao;
import com.tfs.crm.settings.dictionary.value.domain.DictionaryValue;
import com.tfs.crm.settings.dictionary.value.service.DictionaryValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DictionaryValueServiceImpl implements DictionaryValueService {

    @Autowired
    private DictionaryValueDao dictionaryValueDao;

    @Override
    public List<DictionaryValue> queryDictorynaryValueByTypeCode(String typeCode) {
        return dictionaryValueDao.selectDictonaryValueByTypeCode(typeCode);
    }
}
