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
$(function () {

	//添加日历
	$('.mydate').datetimepicker({
		language: 'zh-CN',//显示中文
		format: 'yyyy-mm-dd',//显示格式
		minView: 3,//设置只显示到月份.  0,1,2,3,4分别代表分,时,天,月,年
		initialDate: new Date(),//初始化当前日期
		autoclose: true,//选中自动关闭
		todayBtn: true,//显示今日按钮
		clearBtn:true //显示清空按钮
	});

	//自动补全客户姓名
	var name2Id = {};//姓名对应的id
	//typeahead只能处理简单的列表，所以要构造一个array string。名称对应的id放到objMap里面；
	$("#edit-customerName").typeahead({
		source: function (query, process) {
			//query是输入的值
			$.post("workbench/contacts/queryCustomerByName.do", { name: query }, function (e) {
				//if (e.success) {
				/*if (e.length == 0) {
                    alert("没有查到对应的人");
                    return;
                }*/
				var array = [];
				$.each(e, function (index, ele) {
					name2Id[ele.name] = ele.id;//键值对保存下来。
					array.push(ele.name);
				});
				process(array);
				//}
			});
		},
		items: 8,
		afterSelect: function (item) {
			//console.log(name2Id[item]);//打印对应的id
			//alert(name2Id[item]);
			$("#edit-customerId").val(name2Id[item]);
		},
		delay: 500
	});

	//给查找市场活动"搜索框"添加键盘弹起事件
	$("#findActivityText").keyup(function () {
		//收集参数
		var name = this.value;
		//发起ajax请求
		$.ajax({
			url:"workbench/clue/queryMarketActivityByName.do",
			data:{
				name:name
			},
			type:"post",
			dataType:"json",
			success:function (data) {
				var htmlStr = "";
				$.each(data,function (index,obj) {
					htmlStr += "<tr>";
					htmlStr += "<td><input value='"+obj.id+"' type='radio' name='"+obj.name+"'/></td>";
					htmlStr += "<td>"+obj.name+"</td>";
					htmlStr += "<td>"+obj.type+"</td>";
					htmlStr += "<td>"+obj.state+"</td>";
					htmlStr += "<td>"+obj.startDate+"</td>";
					htmlStr += "<td>"+obj.endDate+"</td>";
					htmlStr += "<td>"+obj.owner+"</td>";
					htmlStr += "</tr>";
				})
				$("#activityListTBody").html(htmlStr);
			},
			error:function () {
				alert("请求失败！");
			}
		});
	});

	//给查找市场活动"单选框"添加选中事件
	$("#activityListTBody").on("click","input[type='radio']:checked",function () {
		var id = $(this).val();
		$("#findActivityId").val(id);
		var name = $(this).prop("name");
		//关闭模态窗口
		$("#findMarketActivity").modal("hide");
		$("#edit-activityName").val(name);
	});

	//查找联系人"搜索框"键盘弹起事件事件
	$("#findContactsText").keyup(function () {
		var name = this.value;
		//发起ajax请求
		$.ajax({
			url:"workbench/transaction/queryContactsByLikeName.do",
			data:{
				name:name
			},
			type:"post",
			dataType:"json",
			success:function (data) {
				var htmlStr = "";
				$.each(data,function (index,obj) {
					htmlStr += "<tr>";
					htmlStr += "<td><input value='"+obj.id+"' type='radio' name='"+obj.fullName+"'/></td>";
					htmlStr += "<td>"+obj.fullName+"</td>";
					htmlStr += "<td>"+obj.email+"</td>";
					htmlStr += "<td>"+obj.mphone+"</td>";
					htmlStr += "</tr>";
				});
				$("#contactsListTBody").html(htmlStr);
			},
			error:function () {
				alert("请求失败！");
			}
		});
	});

	//给查找联系人"单选框"添加选中事件
	$("#contactsListTBody").on("click","input[type='radio']:checked",function () {
		var id = $(this).val();
		$("#findContactsId").val(id);
		var name = $(this).prop("name");
		//关闭模态窗口
		$("#findContacts").modal("hide");
		$("#edit-contactsName").val(name);
	});

	//给"取消"按钮添加点击事件
	$("#cancelEditTransactionBtn").click(function () {
		//跳转到交易首页
		window.location.href = "workbench/transaction/index.jsp";
	});

	//给"更新"按钮添加点击事件
	$("#saveEditTransactionBtn").click(function () {
		//收集参数
		var owner = $("#edit-owner").val();
		var id = $("#edit-id").val();
		var amountOfMoney = $.trim($("#edit-amountOfMoney").val());
		var name = $.trim($("#edit-name").val());
		var expectedClosingDate = $("#edit-expectedClosingDate").val();
		var customerId = $("#edit-customerId").val();
		var stage = $("#edit-stage").val();
		var type = $("#edit-type").val();
		var source = $("#edit-source").val();
		var activityId = $("#findActivityId").val();
		var contactsId = $("#findContactsId").val();
		var description = $.trim($("#edit-description").val());
		var contactSummary = $.trim($("#edit-contactSummary").val());
		var nextContactTime = $("#edit-nextContactTime").val();
		//发起ajax请求
		$.ajax({
			url:"workbench/transaction/saveEditTransaction.do",
			data:{
				owner:owner,
				id:id,
				amountOfMoneyStr:amountOfMoney,
				name:name,
				expectedClosingDate:expectedClosingDate,
				customerId:customerId,
				stage:stage,
				type:type,
				source:source,
				activityId:activityId,
				contactsId:contactsId,
				description:description,
				contactSummary:contactSummary,
				nextContactTime:nextContactTime
			},
			type:"post",
			dataType:"json",
			success:function (data) {
				if (data.success){
					//返回交易首页
					window.location.href = "workbench/transaction/index.jsp";
				} else {
					alert("修改失败！");
				}
			},
			error:function () {
				alert("请求失败！");
			}
		});

	});

})	
</script>
</head>
<body>

	<!-- 查找市场活动 -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="findActivityText" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>类型</td>
								<td>状态</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="activityListTBody">

						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="findContactsText" type="text" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="contactsTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="contactsListTBody">

						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>更新交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button id="saveEditTransactionBtn" type="button" class="btn btn-primary">更新</button>
			<button id="cancelEditTransactionBtn" type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<input type="hidden" id="edit-id" value="${sessionScope.transaction.id}">
		<div class="form-group">
			<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-owner">
					<c:if test="${not empty userList}">
						<c:forEach items="${userList}" var="u">
							<c:if test="${u.id == user.id}">
								<option value="${u.id}" selected>${u.name}</option>
							</c:if>
							<c:if test="${u.id != user.id}">
								<option value="${u.id}">${u.name}</option>
							</c:if>
						</c:forEach>
					</c:if>
				</select>
			</div>
			<label for="edit-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-amountOfMoney" value="${sessionScope.transaction.amountOfMoney}">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-expectedClosingDate" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-name" value="${sessionScope.transaction.name}">
			</div>
			<label for="edit-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control mydate" id="edit-expectedClosingDate" value="${sessionScope.transaction.expectedClosingDate}">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-customerName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-customerName" value="${sessionScope.transaction.customerId}" placeholder="支持自动补全，输入客户不存在则新建">
				<input type="hidden" id="edit-customerId">
			</div>
			<label for="edit-stage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="edit-stage" value="${sessionScope.transaction.stage}">
			  	<option></option>
				  <c:if test="${not empty stageList}">
					  <c:forEach var="sl" items="${stageList}">
						  <c:if test="${sl.id == sessionScope.transaction.stage}">
							  <option value="${sl.id}" selected>${sl.text}</option>
						  </c:if>
						  <c:if test="${sl.id != sessionScope.transaction.stage}">
							  <option value="${sl.id}">${sl.text}</option>
						  </c:if>
					  </c:forEach>
				  </c:if>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-type" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-type">
				  <option></option>
					<c:if test="${not empty transactionTypeList}">
						<c:forEach var="ttl" items="${transactionTypeList}">
							<c:if test="${ttl.id == sessionScope.transaction.type}">
								<option value="${ttl.id}" selected>${ttl.text}</option>
							</c:if>
							<c:if test="${ttl.id != sessionScope.transaction.type}">
								<option value="${ttl.id}">${ttl.text}</option>
							</c:if>
						</c:forEach>
					</c:if>
				</select>
			</div>
			<label for="edit-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-possibility" value="" readonly="readonly">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-source" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-source">
				  <option></option>
					<c:if test="${not empty sourceList}">
						<c:forEach var="sl" items="${sourceList}">
							<c:if test="${sl.id == sessionScope.transaction.source}">
								<option value="${sl.id}" selected>${sl.text}</option>
							</c:if>
							<c:if test="${sl.id != sessionScope.transaction.source}">
								<option value="${sl.id}">${sl.text}</option>
							</c:if>
						</c:forEach>
					</c:if>
				</select>
			</div>
			<label for="edit-activityName" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findMarketActivity"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-activityName" value="${sessionScope.transaction.activityId}" readonly="readonly">
				<input id="findActivityId" type="hidden">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findContacts"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-contactsName" value="${sessionScope.transaction.contactsId}" readonly="readonly">
				<input id="findContactsId" type="hidden">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-description" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<%--<textarea class="form-control" rows="3" id="edit-description" value="${sessionScope.transaction.description}"></textarea>--%>
					<input type="text" class="form-control" rows="3" id="edit-description" value="${sessionScope.transaction.description}">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<%--<textarea class="form-control" rows="3" id="edit-contactSummary" value="sessionScope."></textarea>--%>
					<input type="text" class="form-control" rows="3" id="edit-contactSummary" value="${sessionScope.transaction.description}">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control mydate" id="edit-nextContactTime" value="${sessionScope.transaction.nextContactTime}">
			</div>
		</div>
		
	</form>
</body>
</html>