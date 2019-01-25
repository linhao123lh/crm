package com.tfs.crm.commons.util;

import java.util.UUID;

/**
 * 获取UUID
 */
public class UUIDUtil {

    public static String getUuid(){
        return UUID.randomUUID().toString().replace("-","");
    }

}
