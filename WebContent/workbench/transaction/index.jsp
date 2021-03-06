<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%
	String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<base href="<%=basePath %>">
<html>
<head>
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<%-- 分页插件引入--%>
	<link href="jquery/bs_pagination/css/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet">
	<script type="text/javascript" src="jquery/bs_pagination/js/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/js/localization/en.js"></script>
<%-- 自动补全插件引入--%>
	<script type="text/javascript" src="jquery/bs_typeahead/js/bootstrap3-typeahead.js"></script>

<script type="text/javascript">

	$(function(){
		
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });

		//给"创建"按钮添加点击事件
		$("#createTransactionBtn").click(function () {
			window.location.href = "workbench/transaction/createTransaction.do";
		});

		//给"修改"按钮添加点击事件
		$("#queryEditTransactionBtn").click(function () {
			//收集参数
			var ckdId = $("#transactionListTBody input[type='checkbox']:checked");
			if (ckdId.length == 0){
				alert("请选择要修改的交易!");
				return;
			}
			if (ckdId.length > 1){
				alert("只能选择一条交易进行修改!");
				return;
			}
			var id = ckdId.val();
			window.location.href = 'workbench/transaction/queryTransactionBeforeEdit.do?id='+id;
		});



		//页面加载完，显示交易列表第一页
		display(1,10);

		//给"查询"按钮添加点击事件
		$("#queryTransactionBtn").click(function () {
			display(1,$("#pageNoDiv").bs_pagination("getOption","rowsPerPage"));
		});

		//给"删除"按钮添加点击事件
		$("#deleteTransactionBtn").click(function () {
			//收集参数
			var ckdIds = $("#transactionListTBody input[type='checkbox']:checked");
			if (ckdIds.length == 0){
				alert("请选择要删除的交易！");
				return;
			}
			if (confirm("你确定要删除选中的交易吗？")){
				var ids = "";
				$.each(ckdIds,function (index,obj) {
					ids += "id="+obj.value+"&";
				});
				ids = ids.substr(0,ids.length - 1);
				//发起ajax请求
				$.ajax({
					url:"workbench/transaction/deleteTransaction.do",
					data:ids,
					type:"post",
					dataType:"json",
					success:function (data) {
						if (data.success){
							//刷新列表第一页
							display(1,$("#pageNoDiv").bs_pagination("getOption","rowsPerPage"));
						} else {
							alert("删除失败！");
						}
					},
					error:function () {
						alert("请求失败！");
					}
				});
			}
		});

		//页面加载完毕，给"添加字段"下面的所有复选框被选中
		$("#definedColumns input[type='checkbox']").prop("checked",true);

		//给"添加字段"下面的所有复选框添加点击事件
		$("#definedColumns input[type='checkbox']").click(function () {
			if (this.checked){
				$("td[name='"+this.name+"']").show();
			} else {
				$("td[name='"+this.name+"']").hide();
			}
		});

		//给"全选"复选框添加点击事件
		$("#ckd_all").click(function () {
			$("#transactionListTBody input[type='checkbox']").prop("checked",this.checked);
		});

		//给列表所有复选框添加点击事件
		$("#transactionListTBody").on("click","input[type='checkbox']",function () {
			if ($("#transactionListTBody input[type='checkbox']").length == $("#transactionListTBody input[type='checkbox']:checked").length){
				$("#ckd_all").prop("checked",true);
			} else {
				$("#ckd_all").prop("checked",false);
			}
		});


		//分页查询
		function display(pageNo,pageSize) {
			//收集参数
			var owner = $.trim($("#query-owner").val());
			var name = $.trim($("#query-name").val());
			var amountOfMoney = $.trim($("#query-amountOfMoney").val());
			var customerName = $.trim($("#query-customerName").val());
			var stage = $("#query-stage").val();
			var type = $("#query-type").val();
			var source = $("#query-source").val();
			var contactsName = $.trim($("#query-contactsName").val());
			//发起ajax请求
			$.ajax({
				url:"workbench/transaction/queryTransactionForPageByCondition.do",
				data:{
					pageNoStr:pageNo,
					pageSizeStr:pageSize,
					owner:owner,
					name:name,
					amountOfMoneyStr:amountOfMoney,
					contactsName:contactsName,
					stage:stage,
					type:type,
					source:source,
					customerName:customerName
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					var htmlStr = "";
					$.each(data.dataList,function (index,obj) {
						htmlStr += " <tr>";
						htmlStr += " <td><input value='"+obj.id+"' type='checkbox' /></td>";
						htmlStr += " <td name='name'><a style='text-decoration: none; cursor: pointer;' onclick='window.location.href=\"workbench/transaction/queryTransactionDetail.do?id="+obj.id+"\";'</a>"+obj.name+"</td>";
						htmlStr += " <td name='customerName'>"+obj.customerId+"</td>";
						htmlStr += " <td name='amountOfMoney'>"+obj.amountOfMoney+"</td>";
						htmlStr += " <td name='expectedClosingDate'>"+obj.expectedClosingDate+"</td>";
						htmlStr += " <td name='stage'>"+obj.stage+"</td>";
						htmlStr += " <td name='type'>"+obj.type+"</td>";
						htmlStr += " <td name='owner'>"+obj.owner+"</td>";
						htmlStr += " <td name='source'>"+obj.source+"</td>";
						htmlStr += " <td name='activityName'>"+obj.activityId+"</td>";
						htmlStr += " <td name='contactsName'>"+obj.contactsId+"</td>";
						htmlStr += " <td name='createBy'>"+obj.createBy+"</td>";
						htmlStr += " <td name='createTime'>"+obj.createTime+"</td>";
						htmlStr += " <td name='editBy'>"+(obj.editBy==null?'':obj.editBy)+"</td>";
						htmlStr += " <td name='editTime'>"+(obj.editTime==null?'':obj.editTime)+"</td>";
						htmlStr += " <td name='description'>"+obj.description+"</td>";
						htmlStr += " <td name='contactSummary'>"+obj.contactSummary+"</td>";
						htmlStr += " <td name='nextContactTime'>"+obj.nextContactTime+"</td>";
						htmlStr += " </tr>";
					});
					$("#transactionListTBody").html(htmlStr);
					$("#transactionListTBody td:even").addClass("active");

					var totalPages = 10;
					if (data.count % pageSize == 0){
						totalPages = Math.floor(data.count / pageSize);
					} else {
						totalPages = Math.floor(data.count / pageSize) + 1;
					}

					//分页
					$("#pageNoDiv").bs_pagination({
						currentPage:pageNo,//当前页号
						rowsPerPage:pageSize,//每页显示条数
						totalRows:data.count,//总条数
						totalPages: totalPages, //总页数. 必须根据总条数和每页显示条数手动计算总页数.

						visiblePageLinks:5,//最多可以显示的卡片数

						showGoToPage:true,//是否显示跳转到第几页
						showRowsPerPage:true,//是否显示每页显示条数
						showRowsInfo:true,//是否显示记录信息
						/**
						 用来监听页号切换的事件.
						 event就代表这个事件;pageObj就代表翻页信息.
						 */
						onChangePage: function(event,pageObj) { // returns page_num and rows_per_page after a link has clicked
							display(pageObj.currentPage,pageObj.rowsPerPage);
						}
					});
				},
				error:function () {
					alert("请求失败！")
				}
			});
		}

	});
	
</script>
</head>
<body>

	<!-- 导入交易的模态窗口 -->
	<div class="modal fade" id="importClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">导入交易</h4>
				</div>
				<div class="modal-body" style="height: 350px;">
					<div style="position: relative;top: 20px; left: 50px;">
						请选择要上传的文件：<small style="color: gray;">[仅支持.xls或.xlsx格式]</small>
					</div>
					<div style="position: relative;top: 40px; left: 50px;">
						<input type="file">
					</div>
					<div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
						<h3>重要提示</h3>
						<ul>
							<li>给定文件的第一行将视为字段名。</li>
							<li>请确认您的文件大小不超过5MB。</li>
							<li>从XLS/XLSX文件中导入全部重复记录之前都会被忽略。</li>
							<li>复选框值应该是1或者0。</li>
							<li>日期值必须为MM/dd/yyyy格式。任何其它格式的日期都将被忽略。</li>
							<li>日期时间必须符合MM/dd/yyyy hh:mm:ss的格式，其它格式的日期时间将被忽略。</li>
							<li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
							<li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
						</ul>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal">导入</button>
				</div>
			</div>
		</div>
	</div>
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 200%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="query-owner" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input id="query-name" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">金额</div>
				      <input id="query-amountOfMoney" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input id="query-customerName" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">阶段</div>
					  <select id="query-stage" class="form-control">
					  	<option></option>
					  	<c:if test="${not empty stageList}">
							<c:forEach items="${stageList}" var="sl">
								<option value="${sl.id}">${sl.text}</option>
							</c:forEach>
						</c:if>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select id="query-type" class="form-control">
					  	<option></option>
					  	<c:if test="${not empty transactionTypeList}">
							<c:forEach items="${transactionTypeList}" var="ttl">
								<option value="${ttl.id}">${ttl.text}</option>
							</c:forEach>
						</c:if>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select id="query-source" class="form-control" id="create-source">
						  <option></option>
						  <c:if test="${not empty sourceList}">
							  <c:forEach items="${sourceList}" var="sl">
								  <option value="${sl.id}">${sl.text}</option>
							  </c:forEach>
						  </c:if>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人名称</div>
				      <input id="query-contactsName" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <button id="queryTransactionBtn" type="button" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button id="createTransactionBtn" type="button" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button id="queryEditTransactionBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="deleteTransactionBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importClueModal"><span class="glyphicon glyphicon-import"></span> 导入</button>
				  <button type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 导出</button>
				</div>
				
				<div class="btn-group" style="position: relative; top: 18%; left: 5px;">
					<button type="button" class="btn btn-default">添加字段</button>
					<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
						<span class="caret"></span>
						<span class="sr-only">Toggle Dropdown</span>
					</button>
					<ul id="definedColumns" class="dropdown-menu" role="menu"> 
						<li><a href="javascript:void(0);"><input name="name" type="checkbox"/> 名称</a></li>
						<li><a href="javascript:void(0);"><input name="customerName" type="checkbox"/> 客户名称</a></li>
						<li><a href="javascript:void(0);"><input name="amountOfMoney" type="checkbox"/> 金额</a></li>
						<li><a href="javascript:void(0);"><input name="expectedClosingDate" type="checkbox"/> 预计成交日期</a></li>
						<li><a href="javascript:void(0);"><input name="stage" type="checkbox"/> 阶段</a></li>
						<li><a href="javascript:void(0);"><input name="type" type="checkbox"/> 类型</a></li>
						<li><a href="javascript:void(0);"><input name="owner" type="checkbox"/> 所有者</a></li>
						<li><a href="javascript:void(0);"><input name="source" type="checkbox"/> 来源</a></li>
						<li><a href="javascript:void(0);"><input name="activityName" type="checkbox"/> 市场活动源</a></li>
						<li><a href="javascript:void(0);"><input name="contactsName" type="checkbox"/> 联系人名称</a></li>
						<li><a href="javascript:void(0);"><input name="createBy" type="checkbox"/> 创建者</a></li>
						<li><a href="javascript:void(0);"><input name="createTime" type="checkbox"/> 创建时间</a></li>
						<li><a href="javascript:void(0);"><input name="editBy" type="checkbox"/> 修改者</a></li>
						<li><a href="javascript:void(0);"><input name="editTime" type="checkbox"/> 修改时间</a></li>
						<li><a href="javascript:void(0);"><input name="description" type="checkbox"/> 描述</a></li>
						<li><a href="javascript:void(0);"><input name="contactSummary" type="checkbox"/> 联系纪要</a></li>
						<li><a href="javascript:void(0);"><input name="nextContactTime" type="checkbox"/> 下次联系时间</a></li>
					</ul>
				</div>

				<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
					<form class="form-inline" role="form">
					  <div class="form-group has-feedback">
					    <input type="text" class="form-control" style="width: 300px;" placeholder="支持任何字段搜索">
					    <span class="glyphicon glyphicon-search form-control-feedback"></span>
					  </div>
					</form>
				</div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="ckd_all" type="checkbox" /></td>
							<td name="name">名称</td>
							<td name="customerName">客户名称</td>
							<td name="amountOfMoney">金额</td>
							<td name="expectedClosingDate">预计成交日期</td>
							<td name="stage">阶段</td>
							<td name="type">类型</td>
							<td name="owner">所有者</td>
							<td name="source">来源</td>
							<td name="activityName">市场活动源</td>
							<td name="contactsName">联系人名称</td>
							<td name="createBy">创建者</td>
							<td name="createTime">创建时间</td>
							<td name="editBy">修改者</td>
							<td name="editTime">修改时间</td>
							<td name="description">描述</td>
							<td name="contactSummary">联系纪要</td>
							<td name="nextContactTime">下次联系时间</td>
						</tr>
					</thead>
					<tbody id="transactionListTBody">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detaidetail.jsp力节点-交易01</a></td>
							<td>动力节点</td>
							<td>5,000</td>
							<td>2017-02-07</td>
							<td>谈判/复审</td>
							<td>新业务</td>
							<td>90</td>
							<td>zhangsan</td>
							<td>广告</td>
							<td>发传单</td>
							<td>李四</td>
							<td>zhangsan</td>
							<td>2017-01-18 10:10:10</td>
							<td>zhangsan</td>
							<td>2017-01-19 10:10:10</td>
							<td>这是一条线索的描述信息 （线索转换之后会将线索的描述转换到交易的描述中）</td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detaidetail.jsp力节点-交易01</a></td>
							<td>动力节点</td>
							<td>5,000</td>
							<td>2017-02-07</td>
							<td>谈判/复审</td>
							<td>新业务</td>
							<td>90</td>
							<td>zhangsan</td>
							<td>广告</td>
							<td>发传单</td>
							<td>李四</td>
							<td>zhangsan</td>
							<td>2017-01-18 10:10:10</td>
							<td>zhangsan</td>
							<td>2017-01-19 10:10:10</td>
							<td>这是一条线索的描述信息 （线索转换之后会将线索的描述转换到交易的描述中）</td>
							<td></td>
							<td></td>
						</tr>--%>
					</tbody>
				</table>
				<div id="pageNoDiv"></div>
			</div>
			
			<%--<div style="height: 50px; position: relative;top: 20px;">
				<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>
				</div>
				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>
					<div class="btn-group">
						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
							10
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li><a href="#">20</a></li>
							<li><a href="#">30</a></li>
						</ul>
					</div>
					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
				</div>
				<div style="position: relative;top: -88px; left: 285px;">
					<nav>
						<ul class="pagination">
							<li class="disabled"><a href="#">首页</a></li>
							<li class="disabled"><a href="#">上一页</a></li>
							<li class="active"><a href="#">1</a></li>
							<li><a href="#">2</a></li>
							<li><a href="#">3</a></li>
							<li><a href="#">4</a></li>
							<li><a href="#">5</a></li>
							<li><a href="#">下一页</a></li>
							<li class="disabled"><a href="#">末页</a></li>
						</ul>
					</nav>
				</div>
			</div>--%>
			
		</div>
		
	</div>
</body>
</html>