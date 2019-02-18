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
		$("#remarkDivList").on("mouseout",".myHref",function () {
			$(this).children("span").css("color","#E6E6E6");
		});

		//给"保存"按钮添加点击事件
		$("#saveCreateBtn").click(function () {
			//收集参数
			var noteContent = $.trim($("#remark").val());
			var clueId = '${clue.id}';
			//验证表单
			if (noteContent == null || noteContent.length == 0){
				alert("备注不能为空！");
				return;
			}
			//发起ajax请求
			$.ajax({
				url:"workbench/clue/saveCreateRemark.do",
				data:{
					noteContent:noteContent,
					clueId:clueId
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if (data.success){
						//清空输入框
						$("#remark").val("");
						var htmlStr = "";
						htmlStr += "";
						htmlStr += " <div id='div_"+data.remark.id+"' class='remarkDiv' style='height: 60px;'>";
						htmlStr += " <img title='${user.name}' src='image/user-thumbnail.png' style='width: 30px; height:30px;'>";
						htmlStr += " <div style='position: relative; top: -40px; left: 40px;' >";
						htmlStr += " <h5>"+data.remark.noteContent+"</h5>";
						htmlStr += " <font color='gray'>线索</font> <font color='gray'>-</font> <b>${clue.fullName}${clue.appellation}-${clue.company}</b> <small style='color: gray;'> "+data.remark.noteTime+" 由${user.name}创建</small>";
						htmlStr += " <div style='position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;'>";
						htmlStr += " <a name='editA' remark-id='"+data.remark.id+"' class='myHref' href='javascript:void(0);'><span class='glyphicon glyphicon-edit' style='font-size: 20px; color: #E6E6E6;'></span></a>";
						htmlStr += " &nbsp;&nbsp;&nbsp;&nbsp;";
						htmlStr += " <a name='deleteA' remark-id='"+data.remark.id+"' class='myHref' href='javascript:void(0);'><span class='glyphicon glyphicon-remove' style='font-size: 20px; color: #E6E6E6;'></span></a>";
						htmlStr += " </div>";
						htmlStr += " </div>";
						htmlStr += " </div>";
						$("#remarkDiv").before(htmlStr);
					}else {
						alert("创建线索备注失败！");
					}
				},
				error:function () {
					alert("请求失败！");
				}
			});
		});

		//给"删除"图标绑定点击事件
		$("#remarkDivList").on("click","a[name='deleteA']",function () {
			var id = $(this).attr("remark-id");
			//发起ajax请求
			$.ajax({
				url:"workbench/clue/deleteClueRemark.do",
				data:{
					id:id
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if (data.success){
						//删除备注,刷新类表
						$("#div_"+id).remove();
					} else {
						alert("删除线索备注失败！");
					}
				},
				error:function () {
					alert("请求失败！");
				}
			});
		});

		//给"修改"图标添加点击事件
		$("#remarkDivList").on("click","a[name='editA']",function () {
			//收集参数
			var id = $(this).attr("remark-id");
			var noteContent = $("#div_"+id+" h5").html();
			//把内容写入输入框内
			$("#edit-remarkId").val(id);
			$("#edit-noteContent").html(noteContent);
			//显示模态窗口
			$("#editClueRemarkModal").modal("show");
		});

		//给"更新"按钮添加点击事件
		$("#saveEditRemarkBtn").click(function () {
			//收集参数
			var id = $("#edit-remarkId").val();
			var noteContent = $.trim($("#edit-noteContent").val());
			//表单验证
			if (noteContent == null || noteContent.length == 0){
				alert("备注不能为空！");
				return;
			}
			//发起ajax请求
			$.ajax({
				url:"workbench/clue/saveEditClueRemark.do",
				data:{
					id:id,
					noteContent:noteContent
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if (data.success){
						//关闭模态窗口
						$("#editClueRemarkModal").modal("hide");
						//刷新列表
						$("#div_"+id+" h5").html(noteContent);
						$("#div_"+id+" small").html(" "+data.remark.editTime+" 由${user.name}修改");
					} else {
						alert("修改备注失败！");
						$("#editClueRemarkModal").modal("show");
					}
				},
				error:function () {
					alert("请求失败！");
				}
			})
		});

		//给"关联市场活动"按钮添加点击事件
		$("#bundActivityBtn").click(function () {
			//清空列表和搜索框
			$("#activityListTBody").html("");
			$("#searchActivityText").val("");
			//显示模态窗口
			$("#bundModal").modal("show");
		});
		
		//给"搜索框"添加键盘弹起事件
		$("#searchActivityText").keyup(function () {
			//收集参数
			var name = this.value;
			var clueId = "${clue.id}";
			//发起ajax请求
			$.ajax({
				url:"workbench/clue/bundMarketActivity.do",
				data:{
					name:name,
					clueId:clueId
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					var htmlStr = "";
					$.each(data,function (index,obj) {
						htmlStr += "<tr>";
						htmlStr += "<td><input value='"+obj.id+"' type='checkbox'/></td>";
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

		//给"关联"按钮添加点击事件
        $("#relationActivityBtn").click(function () {
            //收集参数
            var ckdActivityIds = $("#activityListTBody input[type='checkbox']:checked");
            var clueId = "${clue.id}";
            //验证参数
            if (ckdActivityIds == null || ckdActivityIds.length == 0){
                alert("请选择要关联的市场活动！");
                return;
            }
            //优化参数
			var ids = "";
			$.each(ckdActivityIds,function (index,obj) {
				ids += "activityId="+obj.value+"&"
			});
			ids += "clueId="+clueId;
			//发起ajax请求
			$.ajax({
				url:"workbench/clue/relationActivityByActivityIdClueId.do",
				data:ids,
				type:"post",
				dataType:"json",
				success:function (data) {
					if (data.success){
						//关闭模态窗口
						$("#bundModal").modal("hide");
						//刷新列表
						var htmlStr = "";
						$.each(data.activityList,function (index,obj) {
							htmlStr += "<tr id='tr_"+obj.id+"'>";
							htmlStr += "<td>"+obj.name+"</td>";
							htmlStr += "<td>"+obj.type+"</td>";
							htmlStr += "<td>"+obj.state+"</td>";
							htmlStr += "<td>"+obj.startDate+"</td>";
							htmlStr += "<td>"+obj.endDate+"</td>";
							htmlStr += "<td>"+obj.owner+"</td>";
							htmlStr += "<td><a activity-id="+obj.id+" href='javascript:void(0);' style='text-decoration: none;'><span class='glyphicon glyphicon-remove'></span>解除关联</a></td>";
							htmlStr += "</tr>";
						});
						$("#activityTableTBody").append(htmlStr);
					} else {
						alert("关联失败！");
						$("#bundModal").modal("show");
					}
				},
				error:function () {
					alert("请求失败！");
				}
			});

        });

        //给"解除关联按钮"添加点击事件
		$("#activityTableTBody").on("click","a",function () {
			var id = $(this).attr("activity-id");
			$("#unbundActivityText").val(id);
			$("#unbundModal").modal("show");
		})

		//给"确定"按钮添加点击事件
		$("#saveUnbundActivityBtn").click(function () {
			//收集参数
			var activityId = $("#unbundActivityText").val();
			var clueId = "${clue.id}";
			//发起ajax请求
			$.ajax({
				url:"workbench/clue/saveUnbundActivity.do",
				data:{
					activityId:activityId,
					clueId:clueId
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if (data.success){
						//关闭模态窗口
						$("#unbundModal").modal("hide");
						//移除关联关系
						$("#tr_"+activityId).remove();
					} else {
						alert("解除关联失败！");
						$("#unbundModal").modal("show");
					}
				},
				error:function () {
					alert("请求失败！");
				}

			});
		});

		//给"转换"按钮添加点击事件
		$("#convertBtn").click(function () {
			var id = "${clue.id}";
			var fullName = "${clue.fullName}";
			var appellation = "${clue.appellation}";
			var owner = "${clue.owner}";
			var company = "${clue.company}";
			//发生请求
			window.location.href = "workbench/clue/convert.jsp?id="+id+"&fullName="+fullName+"&appellation="+appellation+"&owner="+owner+"&company="+company;
		});

	});
	
</script>

</head>
<body>

	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueRemarkModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalRemarkLabel">修改线索备注</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-remarkId">
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">备注</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-noteContent">这是一条线索的描述信息</textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveEditRemarkBtn" type="button" class="btn btn-primary" >更新</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 解除关联的模态窗口 -->
	<div class="modal fade" id="unbundModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">解除关联</h4>
				</div>
				<input id="unbundActivityText" type="hidden">
				<div class="modal-body">
					<p>您确定要解除该关联关系吗？</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button id="saveUnbundActivityBtn" type="button" class="btn btn-danger">确定</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="searchActivityText" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input type="checkbox"/></td>
								<td>名称</td>
								<td>类型</td>
								<td>状态</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="activityListTBody">
							<%--<tr>
								<td><input type="checkbox"/></td>
								<td>发传单</td>
								<td>广告</td>
								<td>激活的</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="checkbox"/></td>
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
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button id="relationActivityBtn" type="button" class="btn btn-primary">关联</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-clueOwner" class="col-sm-2 control-label">所有者</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueOwner">
								  <option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>
								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-call">
								  <option></option>
								  <option selected>先生</option>
								  <option>夫人</option>
								  <option>女士</option>
								  <option>博士</option>
								  <option>教授</option>
								</select>
							</div>
							<label for="edit-surname" class="col-sm-2 control-label">姓名</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-surname" value="李四">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">电话</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
							<label for="edit-status" class="col-sm-2 control-label">状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-status">
								  <option></option>
								  <option>试图联系</option>
								  <option>将来联系</option>
								  <option selected>已联系</option>
								  <option>虚假线索</option>
								  <option>丢失线索</option>
								  <option>未联系</option>
								  <option>需要条件</option>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
								  <option selected>广告</option>
								  <option>推销电话</option>
								  <option>员工介绍</option>
								  <option>外部介绍</option>
								  <option>在线商场</option>
								  <option>合作伙伴</option>
								  <option>公开媒介</option>
								  <option>销售邮件</option>
								  <option>合作伙伴研讨会</option>
								  <option>内部研讨会</option>
								  <option>交易会</option>
								  <option>web下载</option>
								  <option>web调研</option>
								  <option>聊天</option>
								</select>
							</div>
							<label for="edit-empnums" class="col-sm-2 control-label">员工数</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-empnums" value="100">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-industry" class="col-sm-2 control-label">行业</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-industry">
								  <option></option>
								  <option>应用服务提供商</option>
								  <option>数据/电信/OEM</option>
								  <option>企业资源管理</option>
								  <option>政府/军队</option>
								  <option>大企业</option>
								  <option>管理软件提供商</option>
								  <option>MSP（管理服务提供商）</option>
								  <option>网络设备（企业）</option>
								  <option>非管理软件提供商</option>
								  <option>光网络</option>
								  <option>服务提供商</option>
								  <option selected>中小企业</option>
								  <option>存储设备</option>
								  <option>存储服务提供商</option>
								  <option>系统集成</option>
								  <option>无线企业</option>
								</select>
							</div>
							<label for="edit-grade" class="col-sm-2 control-label">等级</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-grade">
								  <option></option>
								  <option selected>已获得</option>
								  <option>激活的</option>
								  <option>市场失败</option>
								  <option>项目取消</option>
								  <option>关闭</option>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-yearIncome" class="col-sm-2 control-label">年收入</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-yearIncome" value="10,000,000">
							</div>
						</div>
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe">这是一条线索的描述信息</textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-nextContactTime" value="2017-05-01">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
								<label for="edit-country" class="col-sm-2 control-label">国家/地区</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-country" value="中国">
								</div>
								<label for="edit-province" class="col-sm-2 control-label">省/市</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-province" value="北京市">
								</div>
							</div>
							
							<div class="form-group">
								<label for="edit-city" class="col-sm-2 control-label">城市</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-city" value="北京市">
								</div>
								<label for="edit-street" class="col-sm-2 control-label">街道</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-street" value="亦庄大族企业湾10号楼A座3层">
								</div>
							</div>
							
							<div class="form-group">
								<label for="edit-zipcode" class="col-sm-2 control-label">邮编</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-zipcode" value="100176">
								</div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
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
			<h3>${clue.fullName}${clue.appellation} <small>${clue.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default"><span class="glyphicon glyphicon-envelope"></span> 发送邮件</button>
			<button id="convertBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-retweet"></span> 转换</button>
			<button type="button" class="btn btn-default" data-toggle="modal" data-target="#editClueModal"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.fullName}${clue.appellation}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.owner}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.company}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.job}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">电话</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.state}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">员工数</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.empNums}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">行业</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.industry}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">等级</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.grade}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">收入</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.annualIncome}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 100px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 110px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
	</div>
	
	<!-- 地址信息 -->
	<div style="position: relative; top: 30px; left: 40px;">
		<div class="page-header">
			<h4>地址</h4>
		</div>
		<div style="position: relative; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">国家/地区</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.country}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">省/市</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.province}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">城市</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.city}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">街道</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.street}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">邮编</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.zipcode}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkDivList" style="position: relative; top: 60px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		<c:if test="${not empty remarkList}">
			<c:forEach var="remark" items="${remarkList}">
				<div id="div_${remark.id}" class="remarkDiv" style="height: 60px;">
					<img title="${remark.notePerson}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
					<div style="position: relative; top: -40px; left: 40px;" >
						<h5>${remark.noteContent}</h5>
						<font color="gray">线索</font> <font color="gray">-</font> <b>${clue.fullName}${clue.appellation}-${clue.company}</b> <small style="color: gray;"> ${remark.editFlag==0?remark.noteTime:remark.editTime} 由${remark.editFlag==0?remark.notePerson:remark.editPerson}${remark.editFlag==0?'创建':'修改'}</small>
						<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
							<a name="editA" remark-id="${remark.id}" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<a name='deleteA' remark-id="${remark.id}" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
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
				<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
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
				<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
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
					<button id="saveCreateBtn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>类型</td>
							<td>状态</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="activityTableTBody">
						<c:if test="${not empty activityList}">
							<c:forEach var="activity" items="${activityList}">
								<tr id="tr_${activity.id}">
									<td>${activity.name}</td>
									<td>${activity.type}</td>
									<td>${activity.state}</td>
									<td>${activity.startDate}</td>
									<td>${activity.endDate}</td>
									<td>${activity.owner}</td>
									<td><a activity-id="${activity.id}" href="javascript:void(0);" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
								</tr>
							</c:forEach>
						</c:if>
						<%--<tr>
							<td>发传单</td>
							<td>广告</td>
							<td>激活的</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td><a href="javascript:void(0);" data-toggle="modal" data-target="#unbundModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>
						<tr>
							<td>发传单</td>
							<td>广告</td>
							<td>激活的</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td><a href="javascript:void(0);" data-toggle="modal" data-target="#unbundModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
			<div>
				<a id="bundActivityBtn" href="javascript:void(0);" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>