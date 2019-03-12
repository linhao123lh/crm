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

		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });

		//给"创建"按钮添加点击事件
		$("#createContactsBtn").click(function () {
			//重置表单
			$("#createContactsForm")[0].reset();
			//发起ajax请求
			$.ajax({
				url:"workbench/contacts/createContacts.do",
				type:"post",
				dataType:"json",
				success:function (data) {
					var htmlStr = "";
					$.each(data,function (index,obj) {
						if (obj.id == ${user.id}){
							htmlStr += "<option value='"+obj.id+"' selected>"+obj.name+"</option>";
						} else {
							htmlStr += "<option value='"+obj.id+"'>"+obj.name+"</option>";
						}
					});
					$("#create-contactsOwner").html(htmlStr);
					//显示模态窗口
					$("#createContactsModal").modal("show");
				},
				error:function () {
					alert("请求失败！");
				}
			});
		});

		//创建联系人自动补全客户姓名
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

		//给"保存"按钮添加点击事件
		$("#saveCreateContactsBtn").click(function () {
			//收集参数
			var owner = $("#create-contactsOwner").val();
			var source = $("#create-clueSource").val();
			var fullName = $.trim($("#create-contactsName").val());
			var appellation = $("#create-appellation").val();
			var job = $.trim($("#create-job").val());
			var mphone = $.trim($("#create-mphone").val());
			var email = $.trim($("#create-email").val());
			var birth = $.trim($("#create-birth").val());
			var customerId = $.trim($("#create-customerId").val());
			var description = $.trim($("#create-description").val());
			var contactSummary = $.trim($("#create-contactSummary").val());
			var country = $.trim($("#create-country").val());
			var province = $.trim($("#create-province").val());
			var city = $.trim($("#create-city").val());
			var street = $.trim($("#create-street").val());
			var zipcode = $.trim($("#create-zipcode").val());
			//表单验证
			if(fullName == null || fullName.length == 0){
				alert("联系人名称不能为空！");
				return;
			}
			//发起ajax请求
			$.ajax({
				url:"workbench/contacts/saveCreateContacts.do",
				data:{
					owner:owner,
					source:source,
					fullName:fullName,
					appellation:appellation,
					job:job,
					mphone:mphone,
					email:email,
					birth:birth,
					customerId:customerId,
					description:description,
					contactSummary:contactSummary,
					country:country,
					province:province,
					city:city,
					street:street,
					zipcode:zipcode
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if (data.success){
						$("#createContactsModal").modal("hide");
						//显示列表第一页
						display(1,$("#pageNoDiv").bs_pagination("getOption","rowsPerPage"));
					} else {
						alert("创建联系人失败！");
						$("#createContactsModal").modal("show");
					}
				},
				error:function () {
					alert("请求失败！")
				}
			})
		});

		//页面加载完显示第一页
		display(1,10);

		//给"查询"按钮添加点击事件
		$("#queryContactsBtn").click(function () {
			display(1,$("#pageNoDiv").bs_pagination("getOption","rowsPerPage"));
		});
		
		//给"修改"添加点击事件
		$("#editQueryContactsBtn").click(function () {
			//收集参数
			var ckdId = $("#contactsListTBody input[type='checkbox']:checked");
			if (ckdId.length == 0){
				alert("请选择要修改的联系人");
				return;
			}
			if (ckdId.length > 1){
				alert("一次只能修改一个联系人！");
				return;
			}
			id = ckdId.val();
			//发起ajax请求
			$.ajax({
				url:"workbench/contacts/queryContactsBeforeEdit.do",
				data:{
					id:id
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					var htmlStr = "";
					$.each(data.userList,function (index,obj) {
						if (obj.id == data.vo.contacts.owner){
							htmlStr += "<option value='"+obj.id+"' selected>"+obj.name+"</option>"
						} else {
							htmlStr += "<option value='"+obj.id+"'>"+obj.name+"</option>";
						}
					});
					//联系人信息
					$("#edit-id").val(data.vo.contacts.id);
					$("#edit-contactsOwner").html(htmlStr);
					$("#edit-clueSource").val(data.vo.contacts.source);
					$("#edit-ContactsName").val(data.vo.contacts.fullName);
					$("#edit-appellation").val(data.vo.contacts.appellation);
					$("#edit-job").val(data.vo.contacts.job);
					$("#edit-mphone").val(data.vo.contacts.mphone);
					$("#edit-email").val(data.vo.contacts.email);
					$("#edit-birth").val(data.vo.contacts.birth);
					$("#edit-customerName").val(data.vo.name);
					$("#edit-customerId").val(data.vo.contacts.customerId);
					$("#edit-describtion").val(data.vo.contacts.description);
					$("#edit-contactSummary").val(data.vo.contacts.contactSummary);
					$("#edit-country").val(data.vo.contacts.country);
					$("#edit-province").val(data.vo.contacts.province);
					$("#edit-city").val(data.vo.contacts.city);
					$("#edit-street").val(data.vo.contacts.street);
					$("#edit-zipcode").val(data.vo.contacts.zipcode);

					//显示模态窗口
					$("#editContactsModal").modal("show");
				},
				error:function () {
					alert("请求失败！");
				}
			});
		});

		//修改联系人自动补全客户姓名
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
				//alert($("#edit-customerId").val());
			},
			delay: 500
		});

		//给"更新"添加点击事件
		$("#saveEditContactsBtn").click(function () {
			//收集参数
			var id = $("#edit-id").val();
			var owner = $("#edit-contactsOwner").val();
			var source = $("#edit-clueSource").val();
			var fullName = $.trim($("#edit-ContactsName").val());
			var appellation = $("#edit-appellation").val();
			var job = $.trim($("#edit-job").val());
			var mphone = $.trim($("#edit-mphone").val());
			var email = $.trim($("#edit-email").val());
			var birth = $.trim($("#edit-birth").val());
			var customerId = $("#edit-customerId").val();
			var description = $.trim($("#edit-describtion").val());
			var contactSummary = $.trim($("#edit-contactSummary").val());
			var country = $.trim($("#edit-country").val());
			var province = $.trim($("#edit-province").val());
			var city = $.trim($("#edit-city").val());
			var street = $.trim($("#edit-street").val());
			var zipcode = $.trim($("#edit-zipcode").val());
			//发起ajax请求
			$.ajax({
				url:"workbench/contacts/saveEditContacts.do",
				data:{
					id:id,
					owner:owner,
					source:source,
					fullName:fullName,
					appellation:appellation,
					job:job,
					mphone:mphone,
					email:email,
					birth:birth,
					customerId:customerId,
					description:description,
					contactSummary:contactSummary,
					country:country,
					province:province,
					city:city,
					street:street,
					zipcode:zipcode
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if (data.success){
						//关闭模态窗口
						$("#editContactsModal").modal("hide");
						//刷新列表
						display(1,$("#pageNoDiv").bs_pagination("getOption","rowsPerPage"));
					} else {

					}
				},
				error:function () {
					alert("请求失败！");
				}
			});
		});

		//分页查询
		function display(pageNo,pageSize) {
			//收集参数
			var owner = $.trim($("#query-owner").val());
			var fullName = $.trim($("#query-fullName").val());
			var customerName = $.trim($("#query-customerName").val());
			var source = $("#query-source").val();
			var birth = $.trim($("#query-birth").val());
			//发起ajax请求
			$.ajax({
				url:"workbench/contacts/queryContactsForPageByCondition.do",
				data:{
					pageNo:pageNo,
					pageSize:pageSize,
					owner:owner,
					fullName:fullName,
					customerName:customerName,
					source:source,
					birth:birth
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					var htmlStr = "";
					htmlStr += " ";
					$.each(data.dataList,function (index,obj) {
						htmlStr += " <tr>";
						htmlStr += " <td><input value='"+obj.id+"' type='checkbox' /></td>";
						htmlStr += " <td><a style='text-decoration: none; cursor: pointer;' onclick='window.location.href='detail.html';'>"+obj.fullName+"</a></td>";
						htmlStr += " <td>"+obj.appellation+"</td>";
						htmlStr += " <td>"+obj.customerId+"</td>";
						htmlStr += " <td>"+obj.owner+"</td>";
						htmlStr += " <td>"+obj.source+"</td>";
						htmlStr += " <td>"+obj.email+"</td>";
						htmlStr += " <td>"+obj.birth+"</td>";
						htmlStr += " <td>"+obj.job+"</td>";
						htmlStr += " <td>"+obj.mphone+"</td>";
						htmlStr += " <td>"+obj.createBy+"</td>";
						htmlStr += " <td>"+obj.createTime+"</td>";
						htmlStr += " <td>"+(obj.editBy == null?'' : obj.editBy)+"</td>";
						htmlStr += " <td>"+(obj.editTime == null?'' : obj.editTime)+"</td>";
						htmlStr += " <td>"+obj.country+obj.province+obj.city+obj.street+"</td>";
						htmlStr += " <td>"+obj.description+"</td>";
						htmlStr += " <td>"+obj.contactSummary+"</td>";
						htmlStr += " </tr>";
					});
					$("#contactsListTBody").html(htmlStr);
					$("#contactsListTBody tr:even").addClass("active");

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
					alert("请求失败！");
				}
			});
		}

	});
	
</script>
</head>
<body>

	
	<!-- 创建联系人的模态窗口 -->
	<div class="modal fade" id="createContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myCreateModalLabel">创建联系人</h4>
				</div>
				<div class="modal-body">
					<form id="createContactsForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-contactsOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-contactsOwner">
								  <%--<option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>--%>
								</select>
							</div>
							<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueSource">
								  <option></option>
									<c:if test="${not empty sourceList}">
										<c:forEach var="sl" items="${sourceList}">
											<option value="${sl.id}">${sl.text}</option>
										</c:forEach>
									</c:if>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-contactsName" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-contactsName">
							</div>
							<label for="create-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
								  <option></option>
									<c:if test="${not empty appellationList}">
										<c:forEach var="al" items="${appellationList}">
											<option value="${al.id}">${al.text}</option>
										</c:forEach>
									</c:if>
								</select>
							</div>
							
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
							<label for="create-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="create-birth">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
								<input type="hidden" id="create-customerId">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div class="form-group" style="position: relative; top : 13px;">
							<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
								<label for="create-country" class="col-sm-2 control-label">邮寄地址-国家/地区</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="create-country">
								</div>
								<label for="create-province" class="col-sm-2 control-label">邮寄地址-省/市</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="create-province">
								</div>
							</div>
							
							<div class="form-group">
								<label for="create-city" class="col-sm-2 control-label">邮寄地址-城市</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="create-city">
								</div>
								<label for="create-street" class="col-sm-2 control-label">邮寄地址-街道</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="create-street">
								</div>
							</div>
							
							<div class="form-group">
								<label for="create-zipcode" class="col-sm-2 control-label">邮寄地址-邮编</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="create-zipcode">
								</div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveCreateContactsBtn" type="button" class="btn btn-primary">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改联系人的模态窗口 -->
	<div class="modal fade" id="editContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myEditModalLabel">修改联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id">
						<div class="form-group">
							<label for="edit-contactsOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-contactsOwner">
								  <option selected>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>
								</select>
							</div>
							<label for="edit-clueSource" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueSource">
								  <option></option>
									<c:if test="${not empty sourceList}">
										<c:forEach var="sl" items="${sourceList}">
											<option value="${sl.id}">${sl.text}</option>
										</c:forEach>
									</c:if>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-ContactsName" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-ContactsName" value="李四">
							</div>
							<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
								  <option></option>
									<c:if test="${not empty appellationList}">
										<c:forEach var="al" items="${appellationList}">
											<option value="${al.id}">${al.text}</option>
										</c:forEach>
									</c:if>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
							<label for="edit-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="edit-birth">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customerName" placeholder="支持自动补全，输入客户不存在则新建">
								<input type="hidden" id="edit-customerId">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describtion" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describtion">这是一条线索的描述信息</textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div class="form-group" style="position: relative; top : 13px;">
							<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
								<label for="edit-country" class="col-sm-2 control-label">邮寄地址-国家/地区</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-country" value="中国">
								</div>
								<label for="edit-province" class="col-sm-2 control-label">邮寄地址-省/市</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-province" value="北京市">
								</div>
							</div>
							
							<div class="form-group">
								<label for="edit-city" class="col-sm-2 control-label">邮寄地址-城市</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-city" value="北京市">
								</div>
								<label for="edit-street" class="col-sm-2 control-label">邮寄地址-街道</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-street" value="大兴区亦庄大族企业湾10号楼A座3层">
								</div>
							</div>
							
							<div class="form-group">
								<label for="edit-zipcode" class="col-sm-2 control-label">邮寄地址-邮编</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-zipcode" value="100176">
								</div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveEditContactsBtn" type="button" class="btn btn-primary">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	<!-- 导入联系人的模态窗口 -->
	<div class="modal fade" id="importContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">导入联系人</h4>
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
				<h3>联系人列表</h3>
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
				      <div class="input-group-addon">姓名</div>
				      <input id="query-fullName" class="form-control" type="text">
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
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="query-source">
						  <option></option>
						  <c:if test="${not empty sourceList}">
							  <c:forEach var="sl" items="${sourceList}">
								  <option value="${sl.id}">${sl.text}</option>
							  </c:forEach>
						  </c:if>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">生日</div>
				      <input id="query-birth" class="form-control mydate" type="text">
				    </div>
				  </div>
				  
				  <button id="queryContactsBtn" type="button" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button id="createContactsBtn" type="button" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button id="editQueryContactsBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importContactsModal"><span class="glyphicon glyphicon-import"></span> 导入</button>
				  <button type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 导出</button>
				</div>
				
				<div class="btn-group" style="position: relative; top: 18%; left: 5px;">
					<button type="button" class="btn btn-default">添加字段</button>
					<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
						<span class="caret"></span>
						<span class="sr-only">Toggle Dropdown</span>
					</button>
					<ul id="definedColumns" class="dropdown-menu" role="menu"> 
						<li><a href="javascript:void(0);"><input type="checkbox"/> 姓名</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 称呼</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 客户名称</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 所有者</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 来源</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 邮箱</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 生日</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 职位</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 手机</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 创建者</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 创建时间</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 修改者</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 修改时间</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 地址</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 描述</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 联系纪要</a></li>
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
			<div style="position: relative;top: 20px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" /></td>
							<td>姓名</td>
							<td>称呼</td>
							<td>客户名称</td>
							<td>所有者</td>
							<td>来源</td>
							<td>邮箱</td>
							<td>生日</td>
							<td>职位</td>
							<td>手机</td>
							<td>创建者</td>
							<td>创建时间</td>
							<td>修改者</td>
							<td>修改时间</td>
							<td>地址</td>
							<td>描述</td>
							<td>联系纪要</td>
						</tr>
					</thead>
					<tbody id="contactsListTBody">
						<%--<tr class="active">
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">李四</a></td>
							<td>先生</td>
							<td>动力节点</td>
							<td>zhangsan</td>
							<td>广告</td>
							<td>lisi@bjpowernode.com</td>
							<td></td>
							<td>CTO</td>
							<td>12345678901</td>
							<td>zhangsan</td>
							<td>2017-01-18 10:10:10</td>
							<td>zhangsan</td>
							<td>2017-01-19 10:10:10</td>
							<td>中国北京市大兴区大族企业湾10号楼A座3层</td>
							<td>这是一条线索的描述信息 （线索转换之后会将线索的描述转换到联系人的描述中）</td>
							<td></td>
						</tr>
						<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">李四</a></td>
							<td>先生</td>
							<td>动力节点</td>
							<td>zhangsan</td>
							<td>广告</td>
							<td>lisi@bjpowernode.com</td>
							<td></td>
							<td>CTO</td>
							<td>12345678901</td>
							<td>zhangsan</td>
							<td>2017-01-18 10:10:10</td>
							<td>zhangsan</td>
							<td>2017-01-19 10:10:10</td>
							<td>中国北京市大兴区大族企业湾10号楼A座3层</td>
							<td>这是一条线索的描述信息 （线索转换之后会将线索的描述转换到联系人的描述中）</td>
							<td></td>
						</tr>--%>
					</tbody>
				</table>
				<div id="pageNoDiv"></div>
			</div>
			
			<%--<div style="height: 50px; position: relative;top: 10px;">
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