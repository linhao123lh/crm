package com.tfs.crm.commons.web.listener;

import com.tfs.crm.settings.dictionary.value.domain.DictionaryValue;
import com.tfs.crm.settings.dictionary.value.service.DictionaryValueService;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.List;

public class QueryActivityTypeContextListener implements ServletContextListener {


    @Override
    public void contextInitialized(ServletContextEvent sce) {

        DictionaryValueService dictionaryValueService =
                WebApplicationContextUtils.getWebApplicationContext(sce.getServletContext()).getBean(DictionaryValueService.class);

        List<DictionaryValue> marketActivityTypeList = dictionaryValueService.queryDictorynaryValueByTypeCode("marketActivityType");

        ServletContext context = sce.getServletContext();
        context.setAttribute("marketActivityTypeList",marketActivityTypeList);

    }

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {

    }
}
