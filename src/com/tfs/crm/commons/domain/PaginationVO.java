package com.tfs.crm.commons.domain;

import java.util.List;

public class PaginationVO<T> {

    private Long count;

    private List<T> dataList;

    public Long getCount() {
        return count;
    }

    public void setCount(Long count) {
        this.count = count;
    }

    public List<T> getDataList() {
        return dataList;
    }

    public void setDataList(List<T> dataList) {
        this.dataList = dataList;
    }
}
