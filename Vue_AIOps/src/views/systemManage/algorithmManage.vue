<template>
  <div class="container">
    <!-- 页面顶部操作栏 -->
    <div class="top-bar">
      <el-button type="primary" icon="el-icon-upload">上传算法</el-button>
      <el-input
          v-model="searchText"
          placeholder="请输入算法名称或 ID"
          suffix-icon="el-icon-search"
          class="search-input"
      ></el-input>
    </div>

    <!-- 算法管理表格 -->
    <el-table
        :data="tableData"
        border
        style="width: 100%; margin-top: 20px"
        :current-page="currentPage"
        :page-size="pageSize"
        @selection-change="handleSelectionChange"
    >
      <el-table-column label="ID" prop="id" ></el-table-column>
      <el-table-column label="名称" prop="name" ></el-table-column>
      <el-table-column label="模型类别" prop="modelType" ></el-table-column>
      <el-table-column label="是否支持推理" prop="supportsInference" ></el-table-column>
      <el-table-column label="描述" prop="description" ></el-table-column>
      <el-table-column label="创建时间" prop="createTime" ></el-table-column>
      <el-table-column label="操作" width="180">
        <template slot-scope="scope">
          <el-button
              size="mini"
              @click="editItem(scope.row)"
              type="text"
              icon="el-icon-edit"
          >在线编辑</el-button
          >
          <el-button
              size="mini"
              @click="downloadItem(scope.row)"
              type="text"
              icon="el-icon-download"
          >下载</el-button
          >
          <el-dropdown @command="handleFork" trigger="click">
            <span class="el-dropdown-link">
              <el-button size="mini" type="text">更多</el-button>
            </span>
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item command="fork">Fork</el-dropdown-item>
              <el-dropdown-item command="delete">删除</el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
        </template>
      </el-table-column>
    </el-table>

    <!-- 分页 -->
    <el-pagination
        :current-page="currentPage"
        :page-size="pageSize"
        :total="totalItems"
        layout="total, prev, pager, next"
        @current-change="handleCurrentChange"
    ></el-pagination>
  </div>
</template>

<script>
export default {
  name: "AlgorithmManage",
  data() {
    return {
      searchText: "", // 搜索文本
      tableData: [
        {
          id: 375,
          name: "test-01",
          modelType: "--",
          supportsInference: "不支持",
          description: "",
          createTime: "2021-06-11 14:22:23"
        },
        {
          id: 374,
          name: "oneflow-re",
          modelType: "图像分类",
          supportsInference: "不支持",
          description: "test",
          createTime: "2021-06-11 13:55:07"
        }
      ], // 表格数据
      totalItems: 2, // 总数据项数量
      currentPage: 1, // 当前页
      pageSize: 10 // 每页显示数量
    };
  },
  methods: {
    handleSelectionChange(val) {
      console.log("选中的行:", val);
    },
    handleCurrentChange(page) {
      this.currentPage = page;
    },
    editItem(row) {
      console.log("编辑", row);
    },
    createTask(row) {
      console.log("创建训练任务", row);
    },
    downloadItem(row) {
      console.log("下载", row);
    },
    handleFork(command) {
      console.log("操作:", command);
    }
  }
};
</script>

<style scoped>
.container {
  padding: 20px;
}

.top-bar {
  display: flex;
  justify-content: space-between;
  margin-bottom: 20px;
}

.search-input {
  width: 250px;
}

.el-button {
  margin-left: 10px;
}

.el-dropdown-link {
  cursor: pointer;
}
</style>
