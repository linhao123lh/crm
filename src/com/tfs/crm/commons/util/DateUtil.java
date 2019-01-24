package com.tfs.crm.commons.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 时间日期工具类
 * @author out.hao.lin
 *
 */
public class DateUtil {

	/**
	 * 将string转换为date
	 * @param string
	 * @return
	 */
	public static Date parseDateTime(String string) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date = null;
		try {
			date = sdf.parse(string);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		return date;
	}
	
	/**
	 * 将date转换为string
	 * @param date
	 * @return
	 */
	public static String formateDateTime(Date date) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String string = sdf.format(date);
		return string;
	}
}
