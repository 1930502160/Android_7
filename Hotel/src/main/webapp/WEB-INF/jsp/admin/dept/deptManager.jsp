<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>layui</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/statics/layui/lib/layui-v2.5.5/css/layui.css" media="all">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/statics/layui/css/public.css" media="all">
</head>
<body>
<div class="layuimini-container">
    <div class="layuimini-main">

        <%-- 搜索条件区域 --%>
        <fieldset class="table-search-fieldset">
            <legend>搜索信息</legend>
            <div style="margin: 10px 10px 10px 10px">
                <form class="layui-form layui-form-pane" action="">
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">部门名称</label>
                            <div class="layui-input-inline">
                                <input type="text" name="deptName" autocomplete="off" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <button type="submit" class="layui-btn"  lay-submit lay-filter="data-search-btn"><i class="layui-icon layui-icon-search"></i>搜索</button>
                            <button type="reset" class="layui-btn layui-btn-warm"><i class="layui-icon layui-icon-refresh-1"></i>重置</button>
                        </div>
                    </div>
                </form>
            </div>
        </fieldset>

        <%-- 头部工具栏区域 --%>
        <script type="text/html" id="toolbarDemo">
            <div class="layui-btn-container">
                <button class="layui-btn layui-btn-normal layui-btn-sm data-add-btn" lay-event="add"><i class="layui-icon layui-icon-add-1"></i>添加 </button>
            </div>
        </script>

        <%-- 表格区域 --%>
        <table class="layui-hide" id="currentTableId" lay-filter="currentTableFilter"></table>

        <%-- 行工具栏区域 --%>
        <script type="text/html" id="currentTableBar">
            <a class="layui-btn layui-btn-xs data-count-edit" lay-event="edit"><i class="layui-icon layui-icon-edit"></i>编辑</a>
            <a class="layui-btn layui-btn-xs layui-btn-danger data-count-delete" lay-event="delete"><i class="layui-icon layui-icon-delete"></i>删除</a>
        </script>

            <%-- 添加和修改窗口 --%>
            <div style="display: none;padding: 5px" id="addOrUpdateWindow">
                <form class="layui-form" style="width:90%;" id="dataFrm" lay-filter="dataFrm">
                    <div class="layui-form-item">
                        <label class="layui-form-label">部门名称</label>
                        <div class="layui-input-block">
                            <%-- 隐藏域 --%>
                            <%-- 输入框对应实体类部门中id --%>
                            <input type="text" name="id">
                                <%-- 输入框对应实体类部门中deptName --%>
                            <input type="text" name="deptName" lay-verify="required" autocomplete="off"
                                   placeholder="请输入部门名称" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">部门地址</label>
                        <div class="layui-input-block">
                            <%-- 输入框对应实体类部门中address --%>
                            <input type="text" name="address" lay-verify="required" autocomplete="off" placeholder="请输入部门地址"
                                   class="layui-input">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">部门备注</label>
                        <div class="layui-input-block">
                            <%-- 输入框对应实体类部门中remark --%>
                            <textarea class="layui-textarea" name="remark" id="content"></textarea>
                        </div>
                    </div>
                    <div class="layui-form-item layui-row layui-col-xs12">
                        <div class="layui-input-block" style="text-align: center;">
                            <button type="button" class="layui-btn" lay-submit lay-filter="doSubmit"><span
                                    class="layui-icon layui-icon-add-1"></span>提交
                            </button>
                            <button type="reset" class="layui-btn layui-btn-warm"><span
                                    class="layui-icon layui-icon-refresh-1"></span>重置
                            </button>
                        </div>
                    </div>
                </form>
            </div>


    </div>
</div>
<script src="${pageContext.request.contextPath}/statics/layui/lib/layui-v2.5.5/layui.js" charset="utf-8"></script>
<script>
    layui.use(['form', 'table','layer'], function () {
        var $ = layui.jquery,
            form = layui.form,
            layer = layui.layer,
            table = layui.table;

        var tableInfos = table.render({
            elem: '#currentTableId',
            url: "${pageContext.request.contextPath}/admin/dept/list",
            toolbar: '#toolbarDemo',
            cols: [[
                {field: 'id', width: 120, title: "部门编号",align: 'center'},
                {field: 'deptName', minWidth: 120, title: '部门名称',align: 'center'},
                {field: 'address', minWidth: 150, title: '部门地址',align: 'center'},
                {field: 'createDate', minWidth: 120, title: '创建时间',align: 'center'},
                {field: 'remark', minWidth: 120, title: '备注',align: 'center'},
                {title: '操作', minWidth: 150, toolbar: '#currentTableBar', align: "center"}
            ]],
            page: true,
        });

        // 监听搜索操作
        form.on('submit(data-search-btn)', function (data) {
            tableInfos.reload({
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
                //添加按钮-lay-event="add"
                case "add":
                    //打开添加窗口
                    openAddWindow();
                    break;
            }
        });

        /**
         * tool是行工具栏事件
         * 监听行工具栏事件---编辑工具栏
         */
        table.on("tool(currentTableFilter)",function (obj) {
            console.log(obj);
            switch (obj.event) {
                //编辑按钮-lay-event="edit"
                case "edit":
                    //打开编辑窗口
                    openEditorWindow(obj.data);
                    break;
                case "delete":
                    //删除事件
                    deleteById(obj.data);
                    break;
            }
        });


        //url---提交地址
        var url;
        //打开窗口的索引
        var mainIndex;


        /**
        * 添加窗口function
        */
        function openAddWindow() {
            mainIndex = layer.open({
                type: 1,//打开类型
                title: "添加部门",//窗口标题
                area: ["800px", "400px"],//窗口的宽度800px，高度400px
                content: $("#addOrUpdateWindow"),//引用的内容窗口
                success: function () {
                    //清空表单数据
                    $("#dataFrm")[0].reset();
                    //添加的提交请求
                    url = "${pageContext.request.contextPath}/admin/dept/addDept";
                }
            });
        }

        /**
         * 编辑窗口
         * @Param data 当前编辑行的数据
         */
        function openEditorWindow(data) {
            mainIndex = layer.open({
                type: 1,//打开类型
                title: "修改部门",//窗口标题
                area: ["800px", "400px"],//窗口的宽度800px，高度400px
                content: $("#addOrUpdateWindow"),//引用的内容窗口
                success: function () {
                    /**
                     * 获取表单的数据
                     * 参数1，jsp中的form表单中lay-filter的值
                     * 参数2，回显的数据
                     */
                    form.val("dataFrm",data);
                    //编辑的提交请求
                    url = "${pageContext.request.contextPath}/admin/dept/editDept";
                }
            });
        }

        /**
         * 删除部门事件
         * @param data
         */
        function deleteById(data){
            //首先判断该部门下是否存在员工,将要进行删除的部门id传到controller层
            $.get("/admin/dept/checkEmployeeByDeptId",{"id":data.id},function (result) {
                if(result.exist){
                    //提示该部门无法删除，存在员工
                    layer.msg(result.message);
                }else {
                    //提示用户确认删除该部门
                    layer.confirm("确定删除["+data.deptName+"]?",{icon: 3, title:'提示'}, function (index) {
                        //发送ajax请求进行删除
                        $.post("/admin/dept/deleteByDeptId",{"id":data.id},function (result) {
                            if(result.success){
                                //刷新数据表格
                                tableInfos.reload();
                            }
                            //提示信息
                            layer.msg(result.message);
                        },"json");
                        layer.close(index);
                    });
                }
            },"json")
        }


        //监听表单事件
        form.on("submit(doSubmit)",function (data) {
            $.post(url,data.field,function(result) {
                if(result.success){
                    //刷新数据表格
                    tableInfos.reload();
                    //关闭窗口
                    layer.close(mainIndex);
                }
                //接收controller传过来的json信息，并提示添加状态
                layer.msg(result.message);
            },"json");
            //禁止页面刷新
            return false;
        });



    });
</script>

</body>
</html>
