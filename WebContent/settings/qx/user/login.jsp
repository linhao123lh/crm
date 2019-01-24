<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
	//页面加载
	$(function(){
		//使login.jsp在整个页面打开
		if(window.top != window ){
			window.top.location = window.location;
		}
		
		//获取焦点
		$("#loginAct").focus();
		
		//键盘按下事件
		$(window).keydown(function(e){
			if(e.keycody == 13){
				$("$loginBtn").click();
			}
		});
		
		//登录操作
		$("#loginBtn").click(function(){
			//设置参数
			var loginAct = $.trim($("#loginAct").val());
			var loginPwd = $.trim($("#loginPwd").val());
			var isRemUser = $("#isRemUser").prop("checked");
			//表单验证
			if(loginAct == null || loginAct.length == 0){
				alert("用户名不能为空 !")
				return;
			}
			if(loginPwd == null || loginPwd.length == 0){
				alert("密码不能为空 !")
				return;
			}
			//发起ajax请求
			$.ajax({
				url:"settings/qx/user/login.do",
				data:{
					loginAct:loginAct,
					loginPwd:loginPwd,
					isRemUser:isRemUser
				},
				type:"post",
				dataType:"json",
				async:false,
				beforeSend:function(){
					$("#msgTip").html("数据请求中,请稍后...");
					return true;
				},
				success:function(data){
					alert("请求数据");
					if(data.success){
						window.location.href = "workbench/index.jsp";
					}else{
						$("#msgTip").html(data.msg);
					}
				},
				error:function(){
					alert("请求数据失败");
				}
			});
			
		});
		
	});

</script>

</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; widows: 100%; height: 100%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2019&nbsp;丰田金融</span></div>
	</div>
	
	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form action="workbench/index.html" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input id="loginAct" value="${cookie.loginAct.value }" class="form-control" type="text" placeholder="用户名">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input id="loginPwd" value="${cookie.loginPwd.value }" class="form-control" type="password" placeholder="密码">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						<label>
							<c:if test="${not empty cookie.loginAct and not empty cookie.loginPwd }">
								<input id="isRemUser" type="checkbox" checked>
							</c:if>
							<c:if test="${empty cookie.loginAct or empty cookie.loginPwd }">
								<input id="isRemUser" type="checkbox">
							</c:if>
							 十天内免登录<font color="red"><span id="msgTip"></span></font>
						</label>
					</div>
					<button id="loginBtn" type="submit" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;" onclick="return false">登录</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>