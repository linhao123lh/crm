package com.tfs.crm.commons.web.listener;


import com.tfs.crm.settings.dictionary.value.domain.DictionaryValue;
import com.tfs.crm.settings.dictionary.value.service.DictionaryValueService;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.List;

public class QueryClueStateContextListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {

        //获取bean实例
        DictionaryValueService dictionaryValueService =
                WebApplicationContextUtils.getWebApplicationContext(sce.getServletContext()).getBean(DictionaryValueService.class);

        //调用service方法
        List<DictionaryValue> clueStateList = dictionaryValueService.queryDictorynaryValueByTypeCode("clueState");
        //把数据保存到缓存中
        ServletContext context = sce.getServletContext();
        context.setAttribute("clueStateList",clueStateList);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {}
}
