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

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<%-- 日期插件引入 --%>
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});

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
		
		/*$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});*/
		$("#remarkDivList").on("mouseover",".remarkDiv",function () {
            $(this).children("div").children("div").show();
        });
		
		/*$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});*/
		$("#remarkDivList").on("mouseout",".remarkDiv",function () {
            $(this).children("div").children("div").hide();
        });
		
		/*$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});*/
		$("#remarkDivList").on("mouseover",".myHref",function () {
            $(this).children("span").css("color","red");
        });
		
		/*$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});*/
		$("#remarkDivList").on("onmouseout",".myHref",function () {
            $(this).children("span").css("color","#E6E6E6");
        });

		//清空输入框
		/*$("#remark").click(function () {
			$("#remark").val('');
		});*/

		//给"保存"按钮添加点击事件
		$("#saveCreateRemarkBtn").click(function () {
			//收集参数
			var noteContent = $.trim($("#remark").val());
			var activityId = "${activity.id}";
			//验证表单
			if(noteContent == null || noteContent.length == 0){
				alert("备注内容不能为空！");
				return;
			}
			//发起ajax请求
			$.ajax({
				url:"workbench/activity/saveCreateActivityRemark.do",
				data:{
					noteContent:noteContent,
					activityId:activityId
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if (data.success){
						//清空输入框
						$("#remark").val("");
						var htmlStr = "";
						htmlStr += "";
						htmlStr += "<div class='remarkDiv' style='height: 60px;'>";
						htmlStr += "<img title='${user.name}' src='image/user-thumbnail.png' style='width: 30px; height:30px;'>";
						htmlStr += "<div style='position: relative; top: -40px; left: 40px;' >";
						htmlStr += "<h5>"+data.remark.noteContent+"</h5>";
						htmlStr += "<font color='gray'>市场活动</font> <font color='gray'>-</font> <b>${activity.name}</b> <small style='color: gray;'> "+data.remark.noteTime+" 由${user.name}创建</small>";
						htmlStr += "<div style='position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;'>";
						htmlStr += "<a remark_id='"+data.remark.id+"' class='myHref' href='javascript:void(0);'><span class='glyphicon glyphicon-edit' style='font-size: 20px; color: #E6E6E6;'></span></a>";
						htmlStr += "&nbsp;&nbsp;&nbsp;&nbsp;";
						htmlStr += "<a remark_id='"+data.remark.id+" class='myHref' href='javascript:void(0);'><span class='glyphicon glyphicon-remove' style='font-size: 20px; color: #E6E6E6;'></span></a>";
						htmlStr += "</div>";
						htmlStr += "</div>";
						htmlStr += "</div>";
						$("#remarkDiv").before(htmlStr);
					} else {
						alert("创建市场活动明细失败！");
					}
				},
				error:function () {
					alert("请求失败！");
				}
			});
		});

		//给"编辑"按钮添加点击事件
		$("#editActivityBtn").click(function () {
			var id = "${activity.id}";
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
					$("#edit-budgetCost").val(data.activity.budgetCost);
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
			alert("budgetCost=="+budgetCost);
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
						//跳转到市场活动明细页面
						window.location.href="workbench/activity/detailActivityRemark.do?id=${activity.id}";
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
		
	});
	
</script>

</head>
<body>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
						<input id="edit-id" type="hidden">
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
							<label  class="col-sm-2 control-label">状态</label>
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

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>市场活动-${activity.name} <small>${activity.startDate} ~ ${activity.endDate}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button id="editActivityBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">类型</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.type}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.name}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">状态</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.state}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.startDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">实际成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.actualCost}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">预算成本</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.budgetCost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${activity.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div ID="remarkDivList" style="position: relative; top: 30px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		<c:if test="${not empty remarkList}">
            <c:forEach var="remark" items="${remarkList}">
                <div class="remarkDiv" style="height: 60px;">
                    <img title="${remark.notePerson}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
                    <div style="position: relative; top: -40px; left: 40px;" >
                        <h5>${remark.noteContent}</h5>
                        <font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;">
                            ${remark.editFlag==0?remark.noteTime:remark.editTime} 由${remark.editFlag==0?remark.notePerson:remark.editPerson}${remark.editFlag==0?'创建':'修改'}</small>
                        <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                            <a remark_id="${remark.id}" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
                            &nbsp;&nbsp;&nbsp;&nbsp;
                            <a remark_id="${remark.id}" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:if>
		<!-- 备注1 -->
		<%--<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="../../image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>--%>
		
		<!-- 备注2 -->
		<%--<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="../../image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>呵呵！</h5>
				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>--%>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button id="saveCreateRemarkBtn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>