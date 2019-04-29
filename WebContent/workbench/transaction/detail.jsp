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

<style type="text/css">
.mystage{
	font-size: 20px;
	vertical-align: middle;
	cursor: pointer;
}
.closingDate{
	font-size : 15px;
	cursor: pointer;
	vertical-align: middle;
}
</style>
	
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
		
		
		//阶段提示框
		$(".mystage").popover({
            trigger:'manual',
            placement : 'bottom',
            html: 'true',
            animation: false
        }).on("mouseenter", function () {
                    var _this = this;
                    $(this).popover("show");
                    $(this).siblings(".popover").on("mouseleave", function () {
                        $(_this).popover('hide');
                    });
                }).on("mouseleave", function () {
                    var _this = this;
                    setTimeout(function () {
                        if (!$(".popover:hover").length) {
                            $(_this).popover("hide")
                        }
                    }, 100);
                });

		//给"保存"按钮添加点击事件
		$("#saveCreateRemarkBtn").click(function () {
			//收集参数
			var transactionId = "${transaction.id}";
			var noteContent = $.trim($("#remark").val());
			//判断
			if (noteContent == null || noteContent.length == 0){
				alert("备注内容不能为空！");
				return;
			}
			//发起ajax请求
			$.ajax({
				url:"workbench/transaction/saveCreateTransactionRemark.do",
				data:{
					transactionId:transactionId,
					noteContent:noteContent
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if (data.success){
						//清空类别
						$("#remark").val("");
						//刷新列表
						var htmlStr = "";
						htmlStr += " <div id='div_"+data.remark.id+"' class='remarkDiv' style='height: 60px;'> ";
						htmlStr += " <img title='${user.name}' src='image/user-thumbnail.png' style='width: 30px; height:30px;'> ";
						htmlStr += " <div style='position: relative; top: -40px; left: 40px;' > ";
						htmlStr += " <h5>"+data.remark.noteContent+"</h5> ";
						htmlStr += " <font color='gray'>交易</font> <font color='gray'>-</font> <b>${transaction.name}</b> <small style='color: gray;'> "+data.remark.noteTime+" 由${user.name}创建</small> ";
						htmlStr += " <div style='position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;'> ";
						htmlStr += " <a name='editA' remark_id='"+data.remark.id+"' class='myHref' href='javascript:void(0);'><span class='glyphicon glyphicon-edit' style='font-size: 20px; color: #E6E6E6;'></span></a> ";
						htmlStr += " &nbsp;&nbsp;&nbsp;&nbsp; ";
						htmlStr += " <a name='deleteA' remark_id='"+data.remark.id+"' class='myHref' href='javascript:void(0);'><span class='glyphicon glyphicon-remove' style='font-size: 20px; color: #E6E6E6;'></span></a> ";
						htmlStr += " </div> ";
						htmlStr += " </div> ";
						htmlStr += " </div> ";
						$("#remarkDiv").before(htmlStr);
					} else {
						alert("创建备注失败！");
					}
				},
				error:function () {
					alert("请求失败！");
				}
			});
		});

		//给"删除"图标添加点击事件
		$("#remarkDivList").on("click","a[name='deleteA']",function () {
			//收集参数
			var id = $(this).attr("remark_id");
			//发起ajax请求
			$.ajax({
				url:"workbench/transaction/removeTransactionRemark.do",
				data:{
					id:id
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if (data.success){
						$("#div_"+id).remove();
					} else {
						alert("删除交易备注失败！");
					}
				},
				error:function () {
					alert("请求失败!");
				}
			});
		});

		//给"修改"图标添加点击事件
		$("#remarkDivList").on("click","a[name='editA']",function () {
			//收集参数
			var id = $(this).attr("remark_id");
			var noteContent = $("#div_"+id+" h5").html();
			//显示模态窗口
			$("#editTransactionRemarkModal").modal("show");
			$("#edit-remarkId").val(id);
			$("#edit-noteContent").val(noteContent);
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
				url:"workbench/transaction/saveEditTransactionRemark.do",
				data:{
					id:id,
					noteConent:noteContent
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if (data.success){
						//关闭模态窗口
						$("#editTransactionRemarkModal").modal("hide");
						$("#div_"+id+" h5").html(noteContent);
						$("#div_"+id+" small").html(" "+data.remark.editTime+" 由${user.name}修改");
					} else {
						$("#editTransactionRemarkModal").modal("show");
						alert("更新备注失败！");
					}
				},
				error:function () {
					alert("请求失败!");
					return;
				}
			})

		});

	});
	</script>
</head>
<body>

	<!-- 修改交易备注的模态窗口 -->
	<div class="modal fade" id="editTransactionRemarkModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myRemarkModalLabel">修改交易备注</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-remarkId">
						<div class="form-group">
							<label for="edit-noteContent" class="col-sm-2 control-label">备注</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-noteContent"></textarea>
							</div>
						</div>
					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveEditRemarkBtn" type="button" class="btn btn-primary">更新</button>
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
			<h3>${transaction.name} <small>${transaction.amountOfMoney}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" onclick="window.location.href='edit.jsp';"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>

	<!-- 阶段状态 -->
	<div style="position: relative; left: 40px; top: -50px;">
	
		阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="资质审查" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="需求分析" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="价值建议" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="确定决策者" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom" data-content="提案/报价" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="谈判/复审"></span>
		-----------
		<span class="glyphicon glyphicon-thumbs-up mystage" data-toggle="popover" data-placement="bottom" data-content="成交"></span>
		-----------
		<span class="glyphicon glyphicon-thumbs-down mystage" data-toggle="popover" data-placement="bottom" data-content="丢失的线索"></span>
		-----------
		<span class="glyphicon glyphicon-thumbs-down mystage" data-toggle="popover" data-placement="bottom" data-content="因竞争丢失关闭"></span>
		-----------
		<span class="closingDate">2010-10-10</span>
		
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: 0px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${transaction.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">金额</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>&nbsp;${transaction.amountOfMoney}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${transaction.name}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">预计成交日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>&nbsp;${transaction.expectedClosingDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">客户名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${transaction.customerId}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">阶段</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="detail-stage">&nbsp;${transaction.stage}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">类型</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${transaction.type}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">可能性</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="detail-possibility">&nbsp;90</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${transaction.source}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">市场活动源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>&nbsp;${transaction.activityId}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">联系人名称</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${transaction.contactsId}</b></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${transaction.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${transaction.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="detail-editBy">&nbsp;${transaction.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;" id="detail-editTime">${transaction.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					&nbsp;${transaction.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					&nbsp;${transaction.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 100px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${transaction.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkDivList" style="position: relative; top: 100px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>

		<c:if test="${not empty remarkList}">
			<c:forEach items="${remarkList}" var="remark">
				<div id="div_${remark.id}" class="remarkDiv" style="height: 60px;">
					<img title="${remark.notePerson}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
					<div style="position: relative; top: -40px; left: 40px;" >
						<h5>${remark.noteContent}</h5>
						<font color="gray">交易</font> <font color="gray">-</font> <b>${transaction.name}</b> <small style="color: gray;"> ${remark.editFlag==0?remark.noteTime:editTime} 由${remark.editFlag==0?remark.notePerson:editPerson}${remark.editFlag==0?'创建':'修改'}</small>
						<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
							<a name="editA" remark_id="${remark.id}" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<a name="deleteA" remark_id="${remark.id}" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
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
				<font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
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
				<font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
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
	
	<!-- 阶段历史 -->
	<div>
		<div style="position: relative; top: 100px; left: 40px;">
			<div class="page-header">
				<h4>阶段历史</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>阶段</td>
							<td>金额</td>
							<td>可能性</td>
							<td>预计成交日期</td>
							<td>修改时间</td>
							<td>修改者</td>
						</tr>
					</thead>
					<tbody id="thTBody">
						<tr>
							<td>资质审查</td>
							<td>100</td>
							<td>90</td>
							<td>1970-01-01</td>
							<td>1970-01-01</td>
							<td>zhangsan</td>
						</tr>
					</tbody>
				</table>
			</div>
			
		</div>
	</div>
	
	<div style="height: 200px;"></div>
	
</body>
</html>