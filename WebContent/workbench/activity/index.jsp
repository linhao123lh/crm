<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="C" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<base href="<%=basePath %>">
<html>
<head>
<meta charset="UTF-8">
<%-- jQuery插件引入--%>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<%-- 日期插件引入 --%>
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<%-- 分页插件引入--%>
    <link href="jquery/bs_pagination/css/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet">
    <script type="text/javascript" src="jquery/bs_pagination/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/js/localization/en.js"></script>
<script type="text/javascript">
//D:\devsoft\crm\WebContent\jquery\bs_pagination\js\jquery.bs_pagination.min.js
	$(function(){
		//以下日历插件在FF中存在兼容问题，在IE浏览器中可以正常使用。
		/*
		$("#startTime").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
	        autoclose: true,
	        todayBtn: true,
	        pickerPosition: "bottom-left"
		});
		
		$("#endTime").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
	        autoclose: true,
	        todayBtn: true,
	        pickerPosition: "bottom-left"
		});
		*/

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
		$("#createActivityBtn").click(function () {
			//重置表单
			$("#createActivityForm")[0].reset();
			//发起ajax请求
			$.ajax({
				url:"workbench/activity/createMarketActivity.do",
				type:"post",
				dataType:"json",
				success:function (data) {
                    var htmlStr = "";
                    $.each(data,function (index,obj) {
                        if (obj.id == '${user.id}'){
                            htmlStr += "<option value='"+obj.id+"' selected>"+obj.name+"</option>";
                        }else {
                            htmlStr += "<option value='"+obj.id+"'>"+obj.name+"</option>";
                        }
                    });
                    $("#create-owner").html(htmlStr);
                    //显示模态窗口
                    $("#createActivityModal").modal("show");
				},
				error:function () {
					alert("请求失败！");
				}
			});
		});

		//给"保存"按钮添加点击事件
        $("#saveCreateActivityBtn").click(function () {
            //收集参数
            var owner = $("#create-owner").val();
            var type = $("#create-type").val();
            var name = $("#create-name").val();
            var state = $("#create-state").val();
            var startDate = $("#create-startDate").val();
            var endDate = $("#create-endDate").val();
            var actualCost = $.trim($("#create-actualCost").val());
            var budgetCost = $.trim($("#create-budgetCost").val());
            var description = $.trim($("#create-description").val());
            //表单验证
            //活动名称不能为空
            if (name == null || name.length == 0){
                alert("活动名称不能为空！");
                return;
            }
            //开始日期不能大于结束日期
            if (startDate!=null && startDate.length>0 && endDate!=null && endDate.length>0){
                if (endDate < startDate){
                    alert("结束时间不能小于开始时间！");
                    return;
                }
            }
            //实际成本和预算成本必须为非负整数
            var regExp=/^([1-9][0-9]*|0)$/;
            if (actualCost != null && actualCost.length >0 && !regExp.test(actualCost)) {
                alert("实际成本必须为非负整数！");
                return;
            }
            if (budgetCost != null && budgetCost.length >0 && !regExp.test(budgetCost)) {
                alert("预算成本必须为非负整数！");
                return;
            }
            //发起ajax请求
            $.ajax({
                url:"workbench/activity/saveCreateMarketActivity.do",
                data:{
                    owner:owner,
                    type:type,
                    name:name,
                    state:state,
                    startDate:startDate,
                    endDate:endDate,
                    actualCost:actualCost,
                    budgetCost:budgetCost,
                    description:description
                },
                type:"post",
                dataType:"json",
                success:function (data) {
					if (data.success){
						//关闭模态窗口
						$("#createActivityModal").modal("hide");
						//市场活动列表第一页
						display(1,$("#pageNoDiv").bs_pagination('getOption','rowsPerPage'));
					} else {
						alert("创建市场活动失败！")
						$("#createActivityModal").modal("show");
					}
                },
                error:function () {
					alert("请求失败！")
                }
            });
        });

        //页面加载完显示所有数据第一页
        display(1,10);

        //给"查询"按钮添加点击事件
        $("#queryActivityBtn").click(function () {
            display(1,$("#pageNoDiv").bs_pagination('getOption','rowsPerPage'));
        });

        //给"删除"按钮添加点击事件
		$("#deleteActivityBtn").click(function () {
			//收集参数
			var ckdIds = $("#showActivityTBody input[type='checkbox']:checked");
			if (ckdIds.length == 0){
				alert("请选择要删除的市场活动！");
				return;
			}
			if (confirm("您确定要删除吗？")){
				var ids = "";
				$.each(ckdIds,function (index,obj) {
					ids += "id="+obj.value+"&";
				});
				ids = ids.substr(0,ids.length-1);

				//发起ajax请求
				$.ajax({
					url:"workbench/activity/deleteMarketActivities.do",
					data:ids,
					type:"post",
					dataType:"json",
					success:function (data) {
						if (data.success){
							//展示第一页
							display(1,$("#pageNoDiv").bs_pagination('getOption','rowsPerPage'));
						} else {
							alert("删除市场活动失败！");
						}
					},
					error:function () {
						alert("请求失败！")
					}
				});
			}
		});

		//给"修改"按钮添加点击事件
		$("#editActivityBtn").click(function () {
			//收集参数
			var ckdId = $("#showActivityTBody input[type='checkbox']:checked");
			if (ckdId.length == 0){
				alert("请选择要修改的市场活动！");
				return;
			}
			if (ckdId.length > 1){
				alert("只能修改一条市场活动！");
				return;
			}
			var id = ckdId.val();
			//发起ajax请求
			$.ajax({
				url:"workbench/activity/editMarketActivityById.do",
				data:{
					id:id
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					var htmlStr = "";
					$.each(data.userList,function (index,obj) {
						if (obj.id == data.activity.owner){
							htmlStr += "<option value='"+obj.id+"' selected>"+obj.name+"</option>";
						}else {
							htmlStr += "<option value='"+obj.id+"'>"+obj.name+"</option>";
						}
					});
					$("#edit-owner").html(htmlStr);
					$("#edit-id").val(data.activity.id);
					$("#edit-type").val(data.activity.type);
					$("#edit-name").val(data.activity.name);
					$("#edit-state").val(data.activity.state);
					$("#edit-startDate").val(data.activity.startDate);
					$("#edit-endDate").val(data.activity.endDate);
					$("#edit-actualCost").val(data.activity.actualCost);
					$("#edit-description").val(data.activity.description);
					//显示模态窗口
					$("#editActivityModal").modal("show");
				},
				error:function () {
					alert("请求失败！")
				}
			});
		});

		//给"更新"按钮添加点击事件
		$("#saveEditActivityBtn").click(function () {
			//收集参数
			var owner = $("#edit-owner").val();
			var type = $("#edit-type").val();
			var name = $.trim($("#edit-name").val());
			var state = $("#edit-state").val();
			var startDate = $("#edit-startDate").val();
			var endDate = $("#edit-endDate").val();
			var actualCost = $.trim($("#edit-actualCost").val());
			var budgetCost = $.trim($("#edit-budgetCost").val());
			var description = $.trim($("#edit-description").val());
			var id = $("#edit-id").val();
			//表单验证
			//活动名称不能为空
			if (name == null || name.length == 0){
				alert("活动名称不能为空！");
				return;
			}
			//开始日期不能大于结束日期
			if (startDate!=null && startDate.length>0 && endDate!=null && endDate.length>0){
				if (endDate < startDate){
					alert("结束时间不能小于开始时间！");
					return;
				}
			}
			//实际成本和预算成本必须为非负整数
			var regExp=/^([1-9][0-9]*|0)$/;
			if (actualCost != null && actualCost.length >0 && !regExp.test(actualCost)) {
				alert("实际成本必须为非负整数！");
				return;
			}
			if (budgetCost != null && budgetCost.length >0 && !regExp.test(budgetCost)) {
				alert("预算成本必须为非负整数！");
				return;
			}
			//发起ajax请求
			$.ajax({
				url:"workbench/activity/saveEditMarketActivity.do",
				data:{
					id:id,
					owner:owner,
					type:type,
					name:name,
					state:state,
					startDate:startDate,
					endDate:endDate,
					actualCost:actualCost,
					budgetCost:budgetCost,
					description:description
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if (data.success){
						//关闭模态窗口
						$("#editActivityModal").modal("hide");
						//显示市场活动类别第一页
						display(1,$("#pageNoDiv").bs_pagination("getOption","rowsPerPage"));
					} else {
						alert("修改市场活动失败！");
						$("#editActivityModal").modal("show");
					}
				},
				error:function () {
					alert("请求失败！");
				}
			});

		});

		//当页面加载完成之后,默认选中"添加字段"下的所有复选框
		$("#definedColumns input[type='checkbox']").prop("checked",true);

		//给"添加字段"下所有的复选框添加单击事件
		$("#definedColumns input[type='checkbox']").click(function () {
			if (this.checked){
				$("td[name='"+this.name+"']").show();
			}else {
				$("td[name='"+this.name+"']").hide();
			}
		});

		//给"全选"复选框添加单击事件
		$("#ckd_all").click(function () {
			$("#showActivityTBody input[type='checkbox']").prop("checked",this.checked);

		});

		//给列表中所有的复选框添加单击事件
		$("#showActivityTBody").on("click","input[type='checkbox']",function () {
			if ($("#showActivityTBody input[type='checkbox']").size() == $("#showActivityTBody input[type='checkbox']:checked").size()) {
				$("#ckd_all").prop("checked",true);
			}else {
				$("#ckd_all").prop("checked",false);
			}
		});

        //页面展示
        function display(pageNo,pageSize) {
            //收集参数
            var name = $.trim($("#query-name").val());
            var owner = $.trim($("#query-owner").val());
            var type = $("#query-type").val();
            var state = $("#query-state").val();
            var startDate = $("#query-startDate").val();
            var endDate = $("#query-endDate").val();
            //发起ajax请求
            $.ajax({
                url:"workbench/activity/queryMarketActivityForPageByCondition.do",
                type:"post",
                dataType:"json",
                data:{
                    name:name,
                    owner:owner,
                    type:type,
                    state:state,
                    startDate:startDate,
                    endDate:endDate,
                    pageNo:pageNo,
                    pageSize:pageSize
                },
                success:function (data) {
                    var htmlStr ="";
                    $.each(data.dataList,function (index,obj) {
                        htmlStr +="<tr>";
                        htmlStr += "<td><input value='"+obj.id+"' type='checkbox' /></td>";

                        if ($("#definedColumns input[name='name']").prop("checked")){
							htmlStr += "<td name='name'><a style='text-decoration: none; cursor: pointer;' onclick='window.location.href=\"detail.html\";'>"+obj.name+"</a></td>";
						}else {
							htmlStr += "<td name='name' style='display: none'><a style='text-decoration: none; cursor: pointer;' onclick='window.location.href=\"detail.html\";'>"+obj.name+"</a></td>";
						}

						if ($("#definedColumns input[name='type']").prop("checked")){
							htmlStr += "<td name='type'>"+(obj.type==null?'':obj.type)+"</td>";
						}else {
							htmlStr += "<td name='type' style='display: none'>"+(obj.type==null?'':obj.type)+"</td>";
						}

						if ($("#definedColumns input[name='state']").prop("checked")){
							htmlStr += "<td name='state'>"+(obj.state==null?'':obj.state)+"</td>";
						}else {
							htmlStr += "<td name='state' style='display: none'>"+(obj.state==null?'':obj.state)+"</td>";
						}

						if ($("#definedColumns input[name='startDate']").prop("checked")){
							htmlStr += "<td name='startDate'>"+obj.startDate+"</td>";
						}else {
							htmlStr += "<td name='startDate' style='display: none'>"+obj.startDate+"</td>";
						}

						if ($("#definedColumns input[name='endDate']").prop("checked")){
							htmlStr += "<td name='endDate'>"+obj.endDate+"</td>";
						}else {
							htmlStr += "<td name='endDate' style='display: none'>"+obj.endDate+"</td>";
						}

						if ($("#definedColumns input[name='owner']").prop("checked")){
							htmlStr += "<td name='owner'>"+obj.owner+"</td>";
						}else {
							htmlStr += "<td name='owner' style='display: none'>"+obj.owner+"</td>";
						}

						if ($("#definedColumns input[name='budgetCost']").prop("checked")){
							htmlStr += "<td name='budgetCost'>"+(obj.budgetCost==null?'':obj.budgetCost)+"</td>";
						}else {
							htmlStr += "<td name='budgetCost' style='display: none'>"+(obj.budgetCost==null?'':obj.budgetCost)+"</td>";
						}

						if ($("#definedColumns input[name='actualCost']").prop("checked")){
							htmlStr += "<td name='actualCost'>"+(obj.actualCost==null?'':obj.actualCost)+"</td>";
						}else {
							htmlStr += "<td name='actualCost' style='display: none'>"+(obj.actualCost==null?'':obj.actualCost)+"</td>";
						}

						if ($("#definedColumns input[name='createBy']").prop("checked")){
							htmlStr += "<td name='createBy'>"+obj.createBy+"</td>";
						}else {
							htmlStr += "<td name='createBy' style='display: none'>"+obj.createBy+"</td>";
						}

						if ($("#definedColumns input[name='createTime']").prop("checked")){
							htmlStr += "<td name='createTime'>"+obj.createTime+"</td>";
						}else {
							htmlStr += "<td name='createTime' style='display: none'>"+obj.createTime+"</td>";
						}

						if ($("#definedColumns input[name='editBy']").prop("checked")){
							htmlStr += "<td name='editBy'>"+(obj.editBy==null?'':obj.editBy)+"</td>";
						}else {
							htmlStr += "<td name='editBy' style='display: none'>"+(obj.editBy==null?'':obj.editBy)+"</td>";
						}

						if ($("#definedColumns input[name='editTime']").prop("checked")){
							htmlStr += "<td name='editTime'>"+(obj.editTime==null?'':obj.editTime)+"</td>";
						}else {
							htmlStr += "<td name='editTime' style='display: none'>"+(obj.editTime==null?'':obj.editTime)+"</td>";
						}

						if ($("#definedColumns input[name='description']").prop("checked")){
							htmlStr += "<td name='description'>"+obj.description+"</td>";
						}else {
							htmlStr += "<td name='description' style='display: none'>"+obj.description+"</td>";
						}

                        htmlStr +="</tr>";
                    });
                    $("#showActivityTBody").html(htmlStr);
                    //隔行变色
                    $("#showActivityTBody tr:even").addClass("active");


                    //总页数
                    var totalPages = 1;
                    if (data.count % pageSize == 0){
                        totalPages = Math.floor(data.count / pageSize);
                    }else {
                        totalPages = Math.floor(data.count / pageSize) + 1;
                    }
                    //alert("totalPages="+totalPages);
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
        };

	});
	
</script>
</head>
<body>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" <%--id="myModalLabel"--%>>创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form id="createActivityForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
								  <%--<option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>--%>
								</select>
							</div>
							<label class="col-sm-2 control-label">类型</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-type">
								  <option></option>
								  <C:if test="${not empty marketActivityTypeList}">
									  <c:forEach var="tl" items="${marketActivityTypeList}">
										  <option value="${tl.id}">${tl.text}</option>
									  </c:forEach>
								  </C:if>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-name">
							</div>
							<label class="col-sm-2 control-label">状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-state">
								  <option></option>
								  <c:if test="${not empty marketActivityStatusList}">
									  <c:forEach var="sl" items="${marketActivityStatusList}">
										  <option value="${sl.id}">${sl.text}</option>
									  </c:forEach>
								  </c:if>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="create-startDate">
							</div>
							<label class="col-sm-2 control-label mydate">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="create-endDate">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-actualCost" class="col-sm-2 control-label">实际成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-actualCost">
							</div>
							<label for="create-budgetCost" class="col-sm-2 control-label">预算成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-budgetCost">
							</div>
						</div>
						
						<div class="form-group">
							<label class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveCreateActivityBtn" type="button" class="btn btn-primary">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" <%--id="myModalLabel"--%>>修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id">
						<div class="form-group">
							<label class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
								  <%--<option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>--%>
								</select>
							</div>
							<label class="col-sm-2 control-label">类型</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-type">
								  <option></option>
								  <c:if test="${not empty marketActivityTypeList}">
									  <c:forEach var="tl" items="${marketActivityTypeList}">
										  <option value="${tl.id}">${tl.text}</option>
									  </c:forEach>
								  </c:if>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-name" value="发传单">
							</div>
							<label class="col-sm-2 control-label">状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-state">
								  <option></option>
								  <c:if test="${not empty marketActivityStatusList}">
									  <c:forEach var="sl" items="${marketActivityStatusList}">
										  <option value="${sl.id}">${sl.text}</option>
									  </c:forEach>
								  </c:if>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="edit-startDate" value="2020-10-10">
							</div>
							<label class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="edit-endDate" value="2020-10-20">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-actualCost" class="col-sm-2 control-label">实际成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-actualCost" value="4,000">
							</div>
							<label for="edit-budgetCost" class="col-sm-2 control-label">预算成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-budgetCost" value="5,000">
							</div>
						</div>
						
						<div class="form-group">
							<label class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveEditActivityBtn" type="button" class="btn btn-primary">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	<!-- 导入市场活动的模态窗口 -->
	<div class="modal fade" id="importActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
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
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
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
				      <div class="input-group-addon">类型</div>
					  <select id="query-type" class="form-control">
					  	  <option></option>
                          <c:if test="${not empty marketActivityTypeList}">
                              <c:forEach var="tList" items="${marketActivityTypeList}">
                                  <option value="${tList.id}">${tList.text}</option>
                              </c:forEach>
                          </c:if>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">状态</div>
					  <select id="query-state" class="form-control">
					  	<option></option>
					    <c:if test="${not empty marketActivityStatusList}">
                            <c:forEach var="sList" items="${marketActivityStatusList}">
                                <option value="${sList.id}">${sList.text}</option>
                            </c:forEach>
                        </c:if>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control mydate" type="text" id="query-startDate" />
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control mydate" type="text" id="query-endDate">
				    </div>
				  </div>
				  
				  <button id="queryActivityBtn" type="button" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button id="createActivityBtn" type="button" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button id="editActivityBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="deleteActivityBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
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
						<li><a href="javascript:void(0);"><input name="name" type="checkbox"/> 名称</a></li>
						<li><a href="javascript:void(0);"><input name="type" type="checkbox"/> 类型</a></li>
						<li><a href="javascript:void(0);"><input name="state" type="checkbox"/> 状态</a></li>
						<li><a href="javascript:void(0);"><input name="startDate" type="checkbox"/> 开始日期</a></li>
						<li><a href="javascript:void(0);"><input name="endDate" type="checkbox"/> 结束日期</a></li>
						<li><a href="javascript:void(0);"><input name="owner" type="checkbox"/> 所有者</a></li>
						<li><a href="javascript:void(0);"><input name="budgetCost" type="checkbox"/> 预算成本</a></li>
						<li><a href="javascript:void(0);"><input name="actualCost" type="checkbox"/> 实际成本</a></li>
						<li><a href="javascript:void(0);"><input name="createBy" type="checkbox"/> 创建者</a></li>
						<li><a href="javascript:void(0);"><input name="createTime" type="checkbox"/> 创建时间</a></li>
						<li><a href="javascript:void(0);"><input name="editBy" type="checkbox"/> 修改者</a></li>
						<li><a href="javascript:void(0);"><input name="editTime" type="checkbox"/> 修改时间</a></li>
						<li><a href="javascript:void(0);"><input name="description" type="checkbox"/> 描述</a></li>
					</ul>
				</div>

				<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
					<form class="form-inline" role="form">
					  <div class="form-group has-feedback">
					    <input type="email" class="form-control" style="width: 300px;" placeholder="支持任何字段搜索">
					    <span class="glyphicon glyphicon-search form-control-feedback"></span>
					  </div>
					</form>
				</div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id ="ckd_all"  type="checkbox" /></td>
							<td name="name">名称</td>
							<td name="type">类型</td>
							<td name="state">状态</td>
							<td name="startDate">开始日期</td>
							<td name="endDate">结束日期</td>
							<td name="owner">所有者</td>
							<td name="budgetCost">预算成本</td>
							<td name="actualCost">实际成本</td>
							<td name="createBy">创建者</td>
							<td name="createTime">创建时间</td>
							<td name="editBy">修改者</td>
							<td name="editTime">修改时间</td>
							<td name="description" width="10%">描述</td>
						</tr>
					</thead>
					<tbody id="showActivityTBody">
						<%--<tr class="active">
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">发传单</a></td>
							<td>广告</td>
							<td>激活的</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td>5,000</td>
							<td>4,000</td>
							<td>zhangsan</td>
							<td>2017-01-18 10:10:10</td>
							<td>zhangsan</td>
							<td>2017-01-19 10:10:10</td>
							<td>发传单....</td>
						</tr>
						<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">发传单</a></td>
							<td>广告</td>
							<td>激活的</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td>5,000</td>
							<td>4,000</td>
							<td>zhangsan</td>
							<td>2017-01-18 10:10:10</td>
							<td>zhangsan</td>
							<td>2017-01-19 10:10:10</td>
							<td>发传单....</td>
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