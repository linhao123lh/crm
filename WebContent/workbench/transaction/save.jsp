<<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
	$("#create-customerName").typeahead({
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
			$("#create-customerId").val(name2Id[item]);
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
		$("#create-activityName").val(name);
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
		$("#create-contactsName").val(name);
	});

	//给"保存"按钮添加点击事件
	$("#saveCreateTransactionBtn").click(function () {
		//收集参数
		var owner = $("#create-owner").val();
		var amountOfMoney = $.trim($("#create-amountOfMoney").val());
		var name = $.trim($("#create-name").val());
		var expectedClosingDate = $("#create-expectedClosingDate").val();
		var customerId = $("#create-customerId").val();
		var stage = $("#create-stage").val();
		var type = $("#create-type").val();
		var source = $("#create-source").val();
		var activityId = $("#findActivityId").val();
		var contactsId = $("#findContactsId").val();
		var description = $.trim($("#create-description").val());
		var contactSummary = $.trim($("#create-contactSummary").val());
		var nextContactTime = $("#create-nextContactTime").val();
		alert("customerId===="+customerId);

		//表单验证
		if (name == null || name.length ==0){
			alert("名称不能为空！");
			return;
		}
		if (expectedClosingDate == null || expectedClosingDate.length ==0){
			alert("预计成交日期不能为空！");
			return;
		}
		if (customerId == null || customerId.length ==0){
			alert("客户名称不能为空！");
			return;
		}
		if (stage == null || stage.length ==0){
			alert("阶段不能为空！");
			return;
		}
		//发起ajax请求
		$.ajax({
			url:"workbench/transaction/saveCreateContacts.do",
			data:{
				owner:owner,
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
					//跳转到交易首页
					window.location.href = "workbench/transaction/index.jsp";
				} else {
					alert("创建失败！");
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
							<%--<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>广告</td>
								<td>激活的</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>广告</td>
								<td>激活的</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>--%>
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
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="contactsListTBody">
							<%--<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button id="saveCreateTransactionBtn" type="button" class="btn btn-primary">保存</button>
			<button type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-owner">
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
			<label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-amountOfMoney">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-name">
			</div>
			<label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control mydate" id="create-expectedClosingDate">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
				<input type="hidden" id="create-customerId">
			</div>
			<label for="create-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="create-stage">
			  	<option></option>
			  	<c:if test="${not empty stageList}">
					<c:forEach var="sl" items="${stageList}">
						<option value="${sl.id}">${sl.text}</option>
					</c:forEach>
				</c:if>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-type">
				  <option></option>
				  <c:if test="${not empty transactionTypeList}">
					  <c:forEach var="ttl" items="${transactionTypeList}">
						  <option value="${ttl.id}">${ttl.text}</option>
					  </c:forEach>
				  </c:if>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-possibility" readonly="readonly">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-source">
				  <option></option>
				  <c:if test="${not empty sourceList}">
					  <c:forEach var="sl" items="${sourceList}">
						  <option value="${sl.id}">${sl.text}</option>
					  </c:forEach>
				  </c:if>
				</select>
			</div>
			<label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findMarketActivity"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-activityName" value="点击左边搜索" readonly="readonly">
				<input id="findActivityId" type="hidden">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findContacts"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-contactsName" value="点击左边搜索" readonly="readonly">
				<input id="findContactsId" type="hidden">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-description"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control mydate" id="create-nextContactTime">
			</div>
		</div>
		
	</form>
</body>
</html>