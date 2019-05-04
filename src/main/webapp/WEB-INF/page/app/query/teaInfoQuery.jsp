<%--
  Created by IntelliJ IDEA.
  User: 13681864361
  Date: 2019/4/16
  Time: 13:16
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <c:set var="ctx" value="${pageContext.request.contextPath}"/>
    <title></title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <link rel="stylesheet" href="${ctx}/static/plugins/layuiadmin/layui/css/layui.css" media="all">
    <link rel="stylesheet" href="${ctx}/static/plugins/layuiadmin/style/admin.css" media="all">
</head>
<body>

<div class="layui-fluid">
    <div class="layui-card">
        <div class="layui-form layui-card-header layuiadmin-card-header-auto">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">工号</label>
                    <div class="layui-input-inline">
                        <input type="text" name="teaId" placeholder="请输入" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">姓名</label>
                    <div class="layui-input-inline">
                        <input type="text" name="teaName" placeholder="请输入" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">职称</label>
                    <div class="layui-input-inline">
                        <select name="teaTitle">
                            <option value="">请选择标签</option>
                            <option value="教授">教授</option>
                            <option value="副教授">副教授</option>
                            <option value="讲师">讲师</option>
                        </select>
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">学院</label>
                    <div class="layui-input-inline">
                        <select id="teaCollege" name="teaCollege" lay-search>
                            <option value="">请输入或选择标签</option>
                        </select>
                    </div>
                </div>
                <div class="layui-inline">
                    <button class="layui-btn layuiadmin-btn-comm" data-type="reload" lay-submit
                            lay-filter="LAY-app-contcomm-search">
                        <i class="layui-icon layui-icon-search layuiadmin-button-btn"></i>
                    </button>
                </div>
            </div>
        </div>
        <div class="layui-card-body">
            <div style="padding-bottom: 10px;">
                <button class="layui-btn layuiadmin-btn-comm" data-type="batchdel" id="query-my-info">查询我的个人信息</button>
                <button class="layui-btn layuiadmin-btn-comm" data-type="batchdel" style="background-color: #FFB800" id="query-all-info">查询所有信息</button>
            </div>
            <%--<div style="padding-bottom: 10px;">--%>
            <%--<button class="layui-btn layuiadmin-btn-comm" data-type="batchdel">删除</button>--%>
            <%--</div>--%>
            <table id="teaInfoQuery" lay-filter="LAY-app-content-comm"></table>
            <%--<script type="text/html" id="table-content-com">--%>
            <%--<a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="edit"><i class="layui-icon layui-icon-edit"></i>编辑</a>--%>
            <%--<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del"><i class="layui-icon layui-icon-delete"></i>删除</a>--%>
            <%--</script>--%>
        </div>
    </div>
</div>

<script src="${ctx}/static/plugins/layuiadmin/layui/layui.js"></script>
<script>
    layui.config({
        base: '${ctx}/static/plugins/layuiadmin/' //静态资源所在路径
    }).extend({
        index: 'lib/index' //主入口模块
    }).use(['index', 'contlist', 'table', 'laypage'], function () {
        var $ = layui.$
            , form = layui.form
            , table = layui.table
            , laypage = layui.laypage;

        //从数据库异步获取学院数据填充到学院select框中
        $.ajax({
            type: "get",
            url: "${ctx}/college/getCollegeName",
            success: function (data) {
                for (var i = 0; i < data.length; i++) {
                    var json = data[i];
                    var str = "";
                    str += '<option value="' + json.collegeName + '">' + json.collegeName + '</option>';
                    $("#teaCollege").append(str);
                }
                form.render('select');
            }
        });

        //方法级渲染
        table.render({
            elem: '#teaInfoQuery'
            , url: '${ctx}/teacher/showAllTeaInfo' //向后端默认传page和limit
            , cols: [[
                {field: 'teaId', title: '工号', sort: true, fixed: true}
                , {field: 'teaName', title: '姓名'}
                , {field: 'teaSex', title: '性别', sort: true}
                , {field: 'teaAge', title: '年龄'}
                , {field: 'teaTitle', title: '职称', sort: true}
                , {field: 'teaMajorName', title: '专业', sort: true}
                , {field: 'teaCollegeName', title: '学院',width:200, sort: true}
                , {field: 'teaRemark', title: '评价', width: 300}
            ]]
            , page: true
            , limit: 10
            , limits: [5, 10, 15, 20]
            , request: {
                pageName: 'pageNum',
                limitName: 'pageSize'  //如不配置，默认为page=1&limit=10
            }
            , done: function (res, curr, count) {
                //如果是异步请求数据方式，res即为你接口返回的信息。
                //如果是直接赋值的方式，res即为：{data: [], count: 99} data为当前页数据、count为数据总长度
                console.log(res);

                //得到当前页码
                console.log(curr);

                //得到数据总量
                console.log(count);
            }

        });


        //监听搜索
        form.on('submit(LAY-app-contcomm-search)', function (data) {
            var field = data.field;

            console.log(field);
            //执行重载
            table.reload('teaInfoQuery', {
                url: '${ctx}/teacher/showAllTeaInfo' //向后端默认传page和limit
                , where: { //设定异步数据接口的额外参数，任意设
                    teaId: field.teaId
                    , teaName: field.teaName
                    , teaTitle: field.teaTitle
                    , teaCollege: field.teaCollege
                }
                , request: {
                    pageName: 'pageNum',
                    limitName: 'pageSize'  //如不配置，默认为page=1&limit=10
                }
                , page: {
                    curr: 1 //重新从第 1 页开始
                }
            });
        });


        $("#query-my-info").click(function () {
            table.reload('teaInfoQuery', {
                url: '${ctx}/teacher/myOwnInfo'
                ,request: {
                    pageName: 'pageNum',
                    limitName: 'pageSize'  //如不配置，默认为page=1&limit=10
                }
                ,page: {
                    curr: 1 //重新从第 1 页开始
                }
            });
        })

        $("#query-all-info").click(function () {
            table.reload('teaInfoQuery', {
                url: '${ctx}/teacher/showAllTeaInfo'
                ,request: {
                    pageName: 'pageNum',
                    limitName: 'pageSize'  //如不配置，默认为page=1&limit=10
                }
                , where: { //设定异步数据接口的额外参数，任意设
                    teaId: ''
                    , teaName: ''
                    , teaTitle: ''
                    , teaCollege: ''
                }
                ,page: {
                    curr: 1 //重新从第 1 页开始
                }
            });
        })
    });
</script>
</body>
</html>