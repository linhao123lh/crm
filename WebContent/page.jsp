<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <base href="http://127.0.0.1:8080/crm-bs_pagination/">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>演示bs_pagination插件</title>
    <!--  JQUERY -->
    <script type="text/javascript" src="${pageContext.request.contextPath}/jquery/jquery-1.11.1-min.js"></script>

    <!--  BOOTSTRAP -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/css/bootstrap.min.css">
    <script type="text/javascript" src="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <!--  PAGINATION plugin -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/jquery/bs_pagination/css/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="${pageContext.request.contextPath}/jquery/bs_pagination/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/jquery/bs_pagination/js/localization/en.js"></script>
    <script type="text/javascript">
        $(function() {

            $("#demo_pag1").bs_pagination({
                currentPage:1,//当前页号
                rowsPerPage:10,//每页显示条数
                totalRows:1000,//总条数
                totalPages: 100, //总页数. 必须根据总条数和每页显示条数手动计算总页数.

                visiblePageLinks:10,//最多可以显示的卡片数

                showGoToPage:true,//是否显示跳转到第几页
                showRowsPerPage:true,//是否显示每页显示条数
                showRowsInfo:true,//是否显示记录信息
                /**
                 用来监听页号切换的事件.
                 event就代表这个事件;pageObj就代表翻页信息.
                 */
                onChangePage: function(event,pageObj) { // returns page_num and rows_per_page after a link has clicked
                    alert(pageObj.currentPage);
                    alert(pageObj.rowsPerPage);
                }
            });

        });
    </script>
</head>
<body>
<!--  Just create a div and give it an ID -->

<div id="demo_pag1"></div>
</body>
</html>