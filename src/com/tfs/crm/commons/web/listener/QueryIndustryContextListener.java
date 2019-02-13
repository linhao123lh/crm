package com.tfs.crm.commons.web.listener;

import com.tfs.crm.settings.dictionary.value.domain.DictionaryValue;
import com.tfs.crm.settings.dictionary.value.service.DictionaryValueService;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.List;

public class QueryIndustryContextListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {

        //获取bean
        DictionaryValueService dictionaryValueService =
                WebApplicationContextUtils.getWebApplicationContext(sce.getServletContext()).getBean(DictionaryValueService.class);
        //调用service方法
        List<DictionaryValue> industryList = dictionaryValueService.queryDictorynaryValueByTypeCode("industry");
        //存入缓存
        ServletContext context = sce.getServletContext();
        context.setAttribute("industryList",industryList);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {}
}
