<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>layui</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/statics/layui/lib/layui-v2.5.5/css/layui.css"
          media="all">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/statics/layui/css/public.css" media="all">
</head>
<body>
<div class="layuimini-container">
    <div class="layuimini-main">

        <%-- 搜索条件 --%>
        <fieldset class="table-search-fieldset">
            <legend>搜索信息</legend>
            <div style="margin: 10px 10px 10px 10px">
                <form class="layui-form layui-form-pane" action="">
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">预订人</label>
                            <div class="layui-input-inline">
                                <input type="text" name="reservationname" autocomplete="off" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">身份证号</label>
                            <div class="layui-input-inline">
                                <input type="text" name="idcard" autocomplete="off" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">手机号码</label>
                            <div class="layui-input-inline">
                                <input type="text" name="phone" autocomplete="off" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">房间类型</label>
                            <div class="layui-input-inline">
                                <select name="roomtypeid"  autocomplete="off" class="layui-input s_roomTypeId">
                                    <option value="">全部</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">预订状态</label>
                            <div class="layui-input-inline">
                                <select name="status" autocomplete="off" class="layui-input">
                                    <option value="">全部</option>
                                    <option value="1">待确认</option>
                                    <option value="2">已确认</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">开始日期</label>
                            <div class="layui-input-inline">
                                <input type="text" name="startTime" id="startTime" autocomplete="off" class="layui-input" placeholder="请选择开始日期(预订)" readonly>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">结束日期</label>
                            <div class="layui-input-inline">
                                <input type="text" name="endTime" id="endTime" autocomplete="off" class="layui-input" placeholder="请选择结束日期(预订)" readonly>
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-input-block" style="text-align: center">
                            <button type="submit" class="layui-btn"  lay-submit lay-filter="data-search-btn"><i class="layui-icon layui-icon-search"></i>搜索</button>
                            <button type="reset" class="layui-btn layui-btn-warm"><i class="layui-icon layui-icon-refresh-1"></i>重置</button>
                        </div>
                    </div>
                </form>
            </div>
        </fieldset>

        <%-- 表格工具栏 --%>
        <script type="text/html" id="toolbarDemo">
            <div class="layui-btn-container">
                <button class="layui-btn layui-btn-normal layui-btn-sm data-add-btn" lay-event="batchConfirm"><i
                        class="layui-icon layui-icon-edit"></i>批量确认
                </button>
            </div>
        </script>

        <%-- 数据表格 --%>
        <table class="layui-hide" id="currentTableId" lay-filter="currentTableFilter"></table>

        <%-- 行工具栏 --%>
        <script type="text/html" id="currentTableBar">
            <a class="layui-btn layui-btn-xs data-count-edit" lay-event="edit"><i
                    class="layui-icon layui-icon-ok-circle"></i>确认</a>
        </script>


    </div>
</div>
<script src="${pageContext.request.contextPath}/statics/layui/lib/layui-v2.5.5/layui.js" charset="utf-8"></script>
<script>
    layui.use(['form', 'table', 'laydate', 'jquery', 'layer'], function () {
        var $ = layui.jquery,
            form = layui.form,
            laydate = layui.laydate,
            layer = layui.layer,
            table = layui.table;

        //渲染日期组件
        laydate.render({
            elem: '#startTime', //指定元素
            type: 'datetime'
        });
        laydate.render({
            elem: '#endTime', //指定元素
            type: 'datetime'
        });

        $.get("/admin/roomType/findAll",function (result) {
            var html = "";
            for (var i = 0; i < result.length; i++){
                html += "<option value='"+result[i].id+"'>"+result[i].typename+"</option>"
            }
            //追加网页代码
            $("[name='roomtypeid']").append(html);
            form.render("select");
        },"json");


        //渲染表格组件
        var tableIns = table.render({
            elem: '#currentTableId',
            url: '${pageContext.request.contextPath}/admin/orders/list',
            toolbar: '#toolbarDemo',
            cols: [[
                {type: "checkbox", width: 50},
                {field: 'id', width: 100, title: '预订编号', align: "center"},
                {field: 'roomType', width: 100, title: '预订房型', align: "center",templet:function (d) {
                        return d.roomType.typename;
                    }},
                {field: 'room', width: 80, title: '房间号', align: "center",templet:function (d) {
                        return d.room.roomnum;
                    }},
                {field: 'reservationname', width: 100, title: '预订人', align: "center"},
                {field: 'idcard', width: 170, title: '身份证号', align: "center"},
                {field: 'phone', width: 150, title: '手机号', align: "center"},
                {field: 'status', width: 80, title: '状态', align: "center",templet:function (d) {
                        if(d.status==1){
                            return "待确认";
                        }else if(d.status==2){
                            return "已确认";
                        }else if(d.status==3){
                            return "已入住";
                        }else {
                            return "已完成";
                        }
                    }},
                {field: 'reserveprice', width: 80, title: '预订价', align: "center"},
                {field: 'reservedate', width: 160, title: '预订时间', align: "center"},
                {field: 'arrivedate', width: 110, title: '入住日期', align: "center"},
                {field: 'leavedate', width: 110, title: '离店日期', align: "center"},
                {title: '操作', width: 120, toolbar: '#currentTableBar', align: "center",fixed:"right"}
            ]],
            page: true,

        });


        // 监听搜索操作
        form.on('submit(data-search-btn)', function (data) {
            tableIns.reload({
                where: data.field,
                page: {
                    curr: 1
                }
            });
            return false;
        });

        /**
         * toolbar是头部工具栏事件
         *监听头部工具栏事件---添加工具栏
         * currentTableFilter是表格lay-filter过滤器的值
         */
        table.on("toolbar(currentTableFilter)",function (obj) {
            switch (obj.event) {
                //批量确认按钮
                case "batchConfirm":
                    //批量确认事件
                    batchConfirm(obj.data);
                    break;
            }
        });

        /**
         * tool是行工具栏事件
         * 监听行工具栏事件---编辑工具栏
         */
        table.on("tool(currentTableFilter)",function (obj) {
            switch (obj.event) {
                case "edit":
                    //确认按钮事件
                    confirmOrders(obj.data);
                    break;
            }
        });

        /**
         * 订单确认
         * @param data
         */
        function confirmOrders(data) {
            //判断订单状态
            if(data.status == 1){
                //发送确认请求
                $.post("/admin/orders/confirmOrders",{"id":data.id},function (result) {
                    if(result.success){
                        layer.msg(result.message);
                        //刷新表格数据
                        tableIns.reload();
                    }
                },"json");

            }else {
                layer.msg("该订单已确认!");
            }
        }

        /**
         * 批量确认
         */
        function batchConfirm(data) {
            //获取选中行
            var checkstr = table.checkStatus('currentTableId');
            if(checkstr.data.length > 0){
                //判断选中行中是否有包含(已确认)的状态，如果包含已确认或已入住，此时提示用户“只能操作状态为待确认的订单”
                for (var i = 0; i < checkstr.data.length; i++){
                    if (checkstr.data[i].status != 1){
                        layer.alert("只能操作状态为<font color='red'>待确认的订单</font>",{icon:0})
                        return;
                    }
                }
                layer.confirm("确定要确认这些订单吗?",{icon:3,title:"提示"},function (index) {
                    //获取选中行数据
                    var data = checkstr.data;
                    //声明数组，保存选中行的数据
                    var idArr = [];
                    //循环遍历选中行的数据
                    for (var i = 0; i < checkstr.data.length; i++) {
                        idArr.push(data[i].id);
                    }
                    //将数组转换成字符串
                    var ids = idArr.join(",");

                    $.post("/admin/orders/batchConfirm",{"ids":ids},function (result) {
                        if(result.success){
                            table.reload();
                        }
                        layer.msg(result.message);
                        tableIns.reload();
                    },"json");
                });
            }else {
                layer.msg("选择为空！");
            }
        }

    });
</script>

</body>
</html>
