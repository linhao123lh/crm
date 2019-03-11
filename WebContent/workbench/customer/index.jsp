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
<script type="text/javascript">

	$(function(){
		
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });
		
		//给"创建"按钮添加点击事件
		$("#createCustomerBtn").click(function () {
			//重置表单
			$("#createCustomerFrom")[0].reset();
			//发起ajax请求
			$.ajax({
				url:"workbench/customer/createCustomer.do",
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
					$("#create-customerOwner").html(htmlStr);
					//显示模态窗口
					$("#createCustomerModal").modal("show");
				},
				error:function () {
					alert("请求失败！");
				}
			});
		});

		//给"保存"按钮添加点击事件
		$("#saveCreateCustomer").click(function () {
			//收集参数
			var owner = $("#create-customerOwner").val();
			var name = $.trim($("#create-customerName").val());
			var grade = $("#create-grade").val();
			var phone = $.trim($("#create-phone").val());
			var website = $.trim($("#create-website").val());
			var annualIncome = $.trim($("#create-annualIncome").val());
			var empNums = $.trim($("#create-empNums").val());
			var industry = $("#create-industry").val();
			var description = $.trim($("#create-description").val());
			var country = $.trim($("#create-country").val());
			var province = $.trim($("#create-province").val());
			var city = $.trim($("#create-city").val());
			var street = $.trim($("#create-street").val());
			var zipcode = $.trim($("#create-zipcode").val());
			//表单验证
			if (name == null || name.length == 0){
				alert("名称不能为空！");
				return;
			}
			//发起ajax请求
			$.ajax({
				url:"workbench/customer/saveCreateCustomer.do",
				data:{
					owner:owner,
					name:name,
					grade:grade,
					phone:phone,
					website:website,
					annualIncome:annualIncome,
					empNums:empNums,
					industry:industry,
					description:description,
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
						$("#createCustomerModal").modal("hide");
						//刷新列表
						display(1,$("#pageNoDiv").bs_pagination("getOption","rowsPerPage"));
					} else {
						alert("创建客户失败！");
						$("#createCustomerModal").modal("show");
					}
				},
				error:function () {
					alert("请求失败！");
				}
			})
		});

		//页面加载完，显示第一页列表
		display(1,10);

		//给"查询"按钮添加点击事件
		$("#queryCustomerBtn").click(function () {
			display(1,$("#pageNoDiv").bs_pagination("getOption","rowsPerPage"));
		});

		//给"修改"按钮添加点击事件
		$("#editQueryCustomerBtn").click(function () {
			//收集参数
			var ckdId = $("#customerTBody input[type='checkbox']:checked");
			if (ckdId.length == 0){
				alert("请选择要修改的客户！");
				return;
			}
			if (ckdId.length > 1){
				alert("只能选择一条客户信息进行修改");
				return;
			}
			var id = ckdId.val();
			//发起ajax请求
			$.ajax({
				url:"workbench/customer/beforeEditQueryCustomer.do",
				data:{
					id:id
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					var htmlStr = "";
					$.each(data.userList,function (index,obj) {
						if (obj.id == data.customer.owner){
							htmlStr += "<option value='"+obj.id+"' selected>"+obj.name+"</option>"
						}else {
							htmlStr += "<option value='"+obj.id+"'>"+obj.name+"</option>"
						}
					});
					//修改
					$("#edit-customerOwner").html(htmlStr);
					$("#edit-id").val(data.customer.id);
					$("#edit-customerName").val(data.customer.name);
					$("#edit-grade").val(data.customer.grade);
					$("#edit-phone").val(data.customer.phone);
					$("#edit-website").val(data.customer.website);
					$("#edit-annualIncome").val(data.customer.annualIncome);
					$("#edit-empnums").val(data.customer.empNums);
					$("#edit-industry").val(data.customer.industry);
					$("#edit-describe").val(data.customer.description);
					$("#edit-country").val(data.customer.country);
					$("#edit-province").val(data.customer.province);
					$("#edit-city").val(data.customer.city);
					$("#edit-street").val(data.customer.street);
					$("#edit-zipcode").val(data.customer.zipcode);
					//显示模态窗口
					$("#editCustomerModal").modal("show");
				},
				error:function () {
					alert("请求失败！");
				}
			});
		});

		//给"更新"按钮添加点击事件
		$("#saveEditCustomerBtn").click(function () {
			//收集参数
			var id = $("#edit-id").val();
			var owner = $("#edit-customerOwner").val();
			var name = $.trim($("#edit-customerName").val());
			var grade = $("#edit-grade").val();
			var phone = $.trim($("#edit-phone").val());
			var website = $.trim($("#edit-website").val());
			var annualIncome = $.trim($("#edit-annualIncome").val());
			var empnums = $.trim($("#edit-empnums").val());
			var industry = $("#edit-industry").val();
			var description = $.trim($("#edit-describe").val());
			var country = $.trim($("#edit-country").val());
			var province = $.trim($("#edit-province").val());
			var city = $.trim($("#edit-city").val());
			var street = $.trim($("#edit-street").val());
			var zipcode = $.trim($("#edit-zipcode").val());
			//发起ajax请求
			$.ajax({
				url:"workbench/customer/saveEditCustomer.do",
				data:{
					id:id,
					owner:owner,
					name:name,
					grade:grade,
					phone:phone,
					website:website,
					annualIncomeStr:annualIncome,
					empnumsStr:empnums,
					industry:industry,
					description:description,
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
						$("#editCustomerModal").modal("hide");
						//显示客户列表第一页
						display(1,$("#pageNoDiv").bs_pagination("getOption","rowsPerPage"));
					} else {
						alert("修改失败！");
						$("#editCustomerModal").modal("show");
					}
				},
				error:function () {
					alert("请求失败！");
				}
			});

		});

		//给"删除"按钮添加点击事件
		$("#deleteCustomerBtn").click(function () {
			var ckdIds = $("#customerTBody input[type='checkbox']:checked");
			if (ckdIds.length == 0){
				alert("请选择要修改的客户！");
				return;
			}
			if (confirm("你确定要删除选中的客户吗？")){
				var ids = "";
				$.each(ckdIds,function (index,obj) {
					ids += "id="+obj.value+"&";
				});
				ids = ids.substr(0,ids.length - 1);
			}
			//发起ajax请求
			$.ajax({
				url:"workbench/customer/deleteCustomer.do",
				data:ids,
				type:"post",
				dataType:"json",
				success:function (data) {
					if (data.success){
						//显示客户列表第一页
						display(1,$("#pageNoDiv").bs_pagination("getOption","rowsPerPage"));
					} else {
						alert("删除失败！");
					}
				},
				error:function () {
					alert("请求失败！");
				}
			});
		});



		//根据条件分页查询客户
		function display(pageNo,pageSize) {
			//收集参数
			var name = $.trim($("#query-name").val());
			var owner = $.trim($("#query-owner").val());
			var phone = $.trim($("#query-phone").val());
			var website = $.trim($("#query-website").val());
			var grade = $("#query-grade").val();
			var industry = $("#query-industry").val();
			//发起ajax请求
			$.ajax({
				url:"workbench/customer/queryCustomerForPageByCondition.do",
				data:{
					pageNo:pageNo,
					pageSize:pageSize,
					name:name,
					owner:owner,
					phone:phone,
					website:website,
					grade:grade,
					industry:industry
				},
				type:"post",
				dataTyep:"json",
				success:function (data) {
					//刷新列表
					var htmlStr = "";
					htmlStr += " ";
					$.each(data.dataList,function (index,obj) {
						htmlStr += " <tr>";
						htmlStr += " <td><input value='"+obj.id+"' type='checkbox' /></td>";
						htmlStr += " <td><a style='text-decoration: none; cursor: pointer;' onclick='window.location.href=\"detail.html\";'>"+obj.name+"</a></td>";
						htmlStr += " <td>"+obj.owner+"</td>";
						htmlStr += " <td>"+obj.grade+"</td>";
						htmlStr += " <td>"+obj.phone+"</td>";
						htmlStr += " <td>"+obj.website+"</td>";
						htmlStr += " <td>"+obj.industry+"</td>";
						htmlStr += " <td>"+obj.annualIncome+"</td>";
						htmlStr += " <td>"+obj.empNums+"</td>";
						htmlStr += " <td>"+obj.createBy+"</td>";
						htmlStr += " <td>"+obj.createTime+"</td>";
						htmlStr += " <td>"+(obj.editBy==null?'':obj.editBy)+"</td>";
						htmlStr += " <td>"+(obj.editTime==null?'':obj.editTime)+"</td>";
						htmlStr += " <td>"+obj.country+obj.province+obj.city+obj.street+"</td>";
						htmlStr += " <td>"+obj.description+"</td>";
						htmlStr += " </tr>";
					});
					$("#customerTBody").html(htmlStr);
					//隔行变色
					$("#customerTBody tr:even").addClass("active");

					//总页数
					var totalPages = 1;
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

	<!-- 创建客户的模态窗口 -->
	<div class="modal fade" id="createCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建客户</h4>
				</div>
				<div class="modal-body">
					<form id="createCustomerFrom" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-customerOwner">
								  <%--<option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>--%>
								</select>
							</div>
							<label for="create-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-customerName">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-grade" class="col-sm-2 control-label">等级</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-grade">
								  <option></option>
								  <c:if test="${not empty gradeList}">
									  <c:forEach var="gl" items="${gradeList}">
										  <option value="${gl.id}">${gl.text}</option>
									  </c:forEach>
								  </c:if>
								</select>
							</div>
							<label for="create-phone" class="col-sm-2 control-label">电话</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
						</div>
						
						<div class="form-group">
							
							<label for="create-website" class="col-sm-2 control-label">网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
							
							<label for="create-annualIncome" class="col-sm-2 control-label">年收入</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-annualIncome">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-empNums" class="col-sm-2 control-label">员工数</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-empNums">
							</div>
							<label for="create-industry" class="col-sm-2 control-label">行业</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-industry">
								  <option></option>
								  <c:if test="${not empty industryList}">
									  <c:forEach var="il" items="${industryList}">
										  <option value="${il.id}">${il.text}</option>
									  </c:forEach>
								  </c:if>
								</select>
							</div>
							
						</div>
						
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-country" class="col-sm-2 control-label">开票地址-国家/地区</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="create-country">
								</div>
								<label for="create-province" class="col-sm-2 control-label">开票地址-省/市</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="create-province">
								</div>
							</div>
							
							<div class="form-group">
								<label for="create-city" class="col-sm-2 control-label">开票地址-城市</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="create-city">
								</div>
								<label for="create-street" class="col-sm-2 control-label">开票地址-街道</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="create-street">
								</div>
							</div>
							
							<div class="form-group">
								<label for="create-zipcode" class="col-sm-2 control-label">开票地址-邮编</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="create-zipcode">
								</div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveCreateCustomer" type="button" class="btn btn-primary">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改客户的模态窗口 -->
	<div class="modal fade" id="editCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id">
						<div class="form-group">
							<label for="edit-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-customerOwner">
								  <option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>
								</select>
							</div>
							<label for="edit-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customerName" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-grade" class="col-sm-2 control-label">等级</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-grade">
								  <option></option>
									<c:if test="${not empty gradeList}">
										<c:forEach var="gl" items="${gradeList}">
											<option value="${gl.id}">${gl.text}</option>
										</c:forEach>
									</c:if>
								</select>
							</div>
							<label for="edit-phone" class="col-sm-2 control-label">电话</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
						</div>
						
						<div class="form-group">
							
							<label for="edit-website" class="col-sm-2 control-label">网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
							</div>
							
							<label for="edit-annualIncome" class="col-sm-2 control-label">年收入</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-annualIncome" value="10,000,000">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-empnums" class="col-sm-2 control-label">员工数</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-empnums" value="100">
							</div>
							<label for="edit-industry" class="col-sm-2 control-label">行业</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-industry">
								  <option></option>
									<c:if test="${not empty industryList}">
										<c:forEach var="il" items="${industryList}">
											<option value="${il.id}">${il.text}</option>
										</c:forEach>
									</c:if>
								</select>
							</div>
							
						</div>
						
						
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-country" class="col-sm-2 control-label">开票地址-国家/地区</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-country" value="中国">
								</div>
								<label for="edit-province" class="col-sm-2 control-label">开票地址-省/市</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-province" value="北京市">
								</div>
							</div>
							
							<div class="form-group">
								<label for="edit-city" class="col-sm-2 control-label">开票地址-城市</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-city" value="北京市">
								</div>
								<label for="edit-street" class="col-sm-2 control-label">开票地址-街道</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-street" value="大兴区大族企业湾10号楼A座3层">
								</div>
							</div>
							
							<div class="form-group">
								<label for="edit-zipcode" class="col-sm-2 control-label">开票地址-邮编</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-zipcode" value="100176">
								</div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveEditCustomerBtn" type="button" class="btn btn-primary">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	<!-- 导入客户的模态窗口 -->
	<div class="modal fade" id="importActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">导入客户</h4>
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
				<h3>客户列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 130%; height: 100%;">
	
		<div style="width: 130%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input id="query-name" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="query-owner" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">电话</div>
				      <input id="query-phone" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">网站</div>
				      <input id="query-website" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">等级</div>
				      <select class="form-control" id="query-grade">
						  <option></option>
						  <c:if test="${not empty gradeList}">
							  <c:forEach var="gl" items="${gradeList}">
								  <option value="${gl.id}">${gl.text}</option>
							  </c:forEach>
						  </c:if>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">行业</div>
					      <select class="form-control" id="query-industry">
							  <option></option>
							  <c:if test="${not empty industryList}">
								  <c:forEach var="il" items="${industryList}">
									  <option value="${il.id}">${il.text}</option>
								  </c:forEach>
							  </c:if>
							</select>
				    </div>
				  </div>
				  
				  <button id="queryCustomerBtn" type="button" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button id="createCustomerBtn" type="button" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button id="editQueryCustomerBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="deleteCustomerBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal"><span class="glyphicon glyphicon-import"></span> 导入</button>
				  <button type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 导出</button>
				</div>
				
				<div class="btn-group" style="position: relative; top: 18%; left: 5px;">
					<button type="button" class="btn btn-default">添加字段</button>
					<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
						<span class="caret"></span>
						<span class="sr-only">Toggle Dropdown</span>
					</button>
					<ul id="definedColumns" class="dropdown-menu" role="menu"> 
						<li><a href="javascript:void(0);"><input type="checkbox"/> 名称</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 所有者</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 等级</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 电话</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 网站</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 行业</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 年收入</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 员工数</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 创建者</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 创建时间</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 修改者</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 修改时间</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 地址</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 描述</a></li>
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
							<td><input type="checkbox" /></td>
							<td>名称</td>
							<td>所有者</td>
							<td>等级</td>
							<td>电话</td>
							<td>网站</td>
							<td>行业</td>
							<td>年收入</td>
							<td>员工数</td>
							<td>创建者</td>
							<td>创建时间</td>
							<td>修改者</td>
							<td>修改时间</td>
							<td>地址</td>
							<td width="10%">描述</td>
						</tr>
					</thead>
					<tbody id="customerTBody">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">动力节点</a></td>
							<td>zhangsan</td>
							<td>已获得</td>
							<td>010-84846003</td>
							<td>http://www.bjpowernode.com</td>
							<td>中小企业</td>
							<td>10,000,000</td>
							<td>100</td>
							<td>zhangsan</td>
							<td>2017-01-18 10:10:10</td>
							<td>zhangsan</td>
							<td>2017-01-19 10:10:10</td>
							<td></td>
							<td>这是一条线索的描述信息 （线索转换之后会将线索的描述转换到客户的描述中）</td>
						</tr>
						<tr class="active">
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">动力节点</a></td>
							<td>zhangsan</td>
							<td>已获得</td>
							<td>010-84846003</td>
							<td>http://www.bjpowernode.com</td>
							<td>中小企业</td>
							<td>10,000,000</td>
							<td>100</td>
							<td>zhangsan</td>
							<td>2017-01-18 10:10:10</td>
							<td>zhangsan</td>
							<td>2017-01-19 10:10:10</td>
							<td></td>
							<td>这是一条线索的描述信息 （线索转换之后会将线索的描述转换到客户的描述中）</td>
						</tr>--%>
					</tbody>
				</table>
				<div id="pageNoDiv"></div>
			</div>
			
			<%--<div style="height: 50px; position: relative;top: 30px;">
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