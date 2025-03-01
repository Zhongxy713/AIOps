<template>
  <div>
    <div style="margin: 10px 0">
      <el-input style="width: 200px" placeholder="请输入名称" suffix-icon="el-icon-search" v-model="name"></el-input>
      <el-button style="margin-left: 5px" type="primary" @click="load">搜索</el-button>
      <el-button type="warning" @click="reset">重置</el-button>
    </div>

    <div style="margin: 10px 0">
      <el-button type="primary" @click="handleAdd">新增 <i class="el-icon-circle-plus-outline"></i></el-button>
      <el-popconfirm
          style="margin-left: 5px"
          confirm-button-text='确定'
          cancel-button-text='我再想想'
          icon="el-icon-info"
          icon-color="red"
          title="您确定批量删除这些数据吗？"
          @confirm="delBatch"
      >
        <el-button type="danger" slot="reference">批量删除 <i class="el-icon-remove-outline"></i></el-button>
      </el-popconfirm>
    </div>

    <el-table :data="tableData"
              row-key="id" default-expand-all @selection-change="handleSelectionChange" :row-class-name="tableRowClassName">
      <el-table-column type="selection" width="55"></el-table-column>
      <el-table-column prop="id" label="ID" width="80"></el-table-column>
      <el-table-column label="图标" class-name="fontSize18" align="center" label-class-name="fontSize12">
        <template slot-scope="scope">
<!--          <img :src="scope.row.img"  alt="" style="width: 40px; height: 40px">-->
          <el-image
              style="width: 40px; height: 40px"
              :src="scope.row.img"
              ></el-image>
        </template>
      </el-table-column>
      <el-table-column prop="id" label="组件id"></el-table-column>
      <el-table-column prop="nodeTitle" label="组件标题"></el-table-column>
      <el-table-column prop="sortNum" label="排序"></el-table-column>
      <el-table-column prop="type" label="类型"></el-table-column>
      <el-table-column prop="nodeContent" label="组件介绍"></el-table-column>
      <el-table-column label="操作"  width="300" align="center">
        <template slot-scope="scope">
          <el-button type="primary" @click="handleAdd(scope.row.id)" v-if="!scope.row.pid">新增组件 <i class="el-icon-plus"></i></el-button>
          <el-button type="success" @click="handleEdit(scope.row)">编辑 <i class="el-icon-edit"></i></el-button>
          <el-popconfirm
              class="ml-5"
              confirm-button-text='确定'
              cancel-button-text='我再想想'
              icon="el-icon-info"
              icon-color="red"
              title="您确定删除吗？"
              @confirm="del(scope.row.id)"
          >
            <el-button type="danger" slot="reference">删除 <i class="el-icon-remove-outline"></i></el-button>
          </el-popconfirm>
        </template>
      </el-table-column>
    </el-table>


    <!--    分页-->
    <div style="padding: 10px 0">
      <el-pagination
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
          :current-page="pageNum"
          :page-sizes="[2, 5, 10, 20]"
          :page-size="pageSize"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total">
      </el-pagination>
    </div>

    <el-dialog title="工作流组件信息" :visible.sync="dialogFormVisible" width="40%"
               :close-on-click-modal="false">
      <el-form :model="form">
        <el-form-item  label-width="120px">
          <el-upload
              class="avatar-uploader"
              :action="'http://' + serverIp +':9090/file/upload'"
              :show-file-list="false"
              :on-success="handleAvatarSuccess"
          >
<!--            <img v-if="form.img" :src="form.img" style="height: 40px; width: 40px">-->
            <el-image
                v-if="form.img"
                style="width: 40px; height: 40px"
                :src="form.img"
                ></el-image>
            <i v-else class="el-icon-plus avatar-uploader-icon"></i>
          </el-upload>
        </el-form-item>
        <el-form-item label="组件名称" label-width="120px">
          <el-input v-model="form.nodeName" autocomplete="off" style="width: 80%"></el-input>
        </el-form-item>
        <el-form-item label="组件数据" label-width="120px">
          <el-input v-model="form.nodeData" autocomplete="off" style="width: 80%"></el-input>
        </el-form-item>
        <el-form-item label="组件id" label-width="120px">
          <el-input v-model="form.nodeId" autocomplete="off" style="width: 80%"></el-input>
        </el-form-item>
        <el-form-item label="输入参数数量" label-width="120px">
<!--          <el-input v-model="form.nodeInput" autocomplete="off" style="width: 80%"></el-input>-->
          <el-input-number v-model="form.nodeInput" controls-position="right" :min="1" :max="10"></el-input-number>
        </el-form-item>
        <el-form-item label="输出参数数量" label-width="120px">
          <el-input-number v-model="form.nodeOutput" controls-position="right" :min="1" :max="10"></el-input-number>
        </el-form-item>
        <el-form-item label="组件标题" label-width="120px">
          <el-input v-model="form.nodeTitle" autocomplete="off" style="width: 80%"></el-input>
        </el-form-item>
        <el-form-item label="组件介绍" label-width="120px">
          <el-input v-model="form.nodeContent" autocomplete="off" style="width: 80%"></el-input>
        </el-form-item>
        <el-form-item label="排序" label-width="120px">
          <el-input v-model="form.sortNum" autocomplete="off" style="width: 80%"></el-input>
        </el-form-item>
        <el-form-item label="类型" label-width="120px">
          <el-input v-model="form.type" autocomplete="off" style="width: 80%"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取 消</el-button>
        <el-button type="primary" @click="save">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {serverIp} from "../../../public/config";

export default {
  // eslint-disable-next-line vue/multi-word-component-names
  name: "Node",
  data() {
    return {
      serverIp: serverIp,
      tableData: [],
      total: 0,
      pageNum: 1,
      pageSize: 10,
      name: "",
      form: {},
      dialogFormVisible: false,
      multipleSelection: [],
      roles: [],
      options: []
    }
  },
  created() {
    this.load()
  },
  methods: {
    load() {
      this.request.get("/node", {
        params: {
          name: this.name,
        }
      }).then(res => {
        this.tableData = res.data
        console.log("组件数据： ",this.tableData)
      })

    },
    save() {
      this.request.post("/node", this.form).then(res => {
        if (res.code === '200') {
          this.$message.success("保存成功")
          this.dialogFormVisible = false
          this.load()
        } else {
          this.$message.error("保存失败")
        }
      })
    },
    handleAdd(id) {
      this.dialogFormVisible = true
      this.form = {}
      if (id) {
        this.form.pid = id
      }
    },
    handleEdit(row) {
      this.form = JSON.parse(JSON.stringify(row))
      this.dialogFormVisible = true
    },
    handleAvatarSuccess(res) {
      this.form.img = res
    },
    del(id) {
      this.request.delete("/node/" + id).then(res => {
        if (res.code === '200') {
          this.$message.success("删除成功")
          this.load()
        } else {
          this.$message.error("删除失败")
        }
      })
    },
    handleSelectionChange(val) {
      console.log(val)
      this.multipleSelection = val
    },
    delBatch() {
      let ids = this.multipleSelection.map(v => v.id)  // [{}, {}, {}] => [1,2,3]
      this.request.post("/node/del/batch", ids).then(res => {
        if (res.code === '200') {
          this.$message.success("批量删除成功")
          this.load()
        } else {
          this.$message.error("批量删除失败")
        }
      })
    },
    reset() {
      this.name = ""
      this.load()
    },
    handleSizeChange(pageSize) {
      console.log(pageSize)
      this.pageSize = pageSize
      this.load()
    },
    handleCurrentChange(pageNum) {
      console.log(pageNum)
      this.pageNum = pageNum
      this.load()
    },
    handleFileUploadSuccess(res) {
      console.log(res)
      this.form.img = res
      this.load()
    },
    download(url) {
      window.open(url)
    },
    tableRowClassName(row) {
      if (row.row.pid==null) {
        return 'success-row';
      } else{
        return 'warning-row';
      }

    }
  }
}
</script>


<style>
.headerBg {
  background: #eee!important;
}
.el-table .warning-row {
  //background: oldlace;
  height: 80px !important; /* 设置你想要的高度 */
}
.el-table .success-row {
  background: #eeeeee;
  height: 10px !important; /* 设置你想要的高度 */
}
</style>
