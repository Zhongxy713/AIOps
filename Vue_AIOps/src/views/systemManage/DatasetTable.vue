<template>
  <div>
    <div style="margin: 10px 0">
      <el-input style="width: 200px" placeholder="请输入名称" suffix-icon="el-icon-search"></el-input>
      <el-button class="ml-5" type="primary" >搜索</el-button>
      <el-button type="warning" >重置</el-button>
    </div>
    <div style="margin: 10px 0">
        <el-button type="primary" class="ml-5">上传文件 <i class="el-icon-top"></i></el-button>
      <el-popconfirm
          class="ml-5"
          confirm-button-text='确定'
          cancel-button-text='我再想想'
          icon="el-icon-info"
          icon-color="red"
          title="您确定批量删除这些数据吗？"
      >
        <el-button type="danger" slot="reference">批量删除 <i class="el-icon-remove-outline"></i></el-button>
      </el-popconfirm>
    </div>
    <el-tabs v-model="activeTab" type="card">
      <el-tab-pane label="我的数据集" name="myDataSets">
        <el-table ref="multipleTable" :data="myDataSets"  style="width: 100%" @selection-change="handleSelectionChange">
          <el-table-column prop="id" label="ID" width="100"></el-table-column>
          <el-table-column prop="name" label="名称"></el-table-column>
          <el-table-column prop="dataType" label="数据类型"></el-table-column>
          <el-table-column prop="progress" label="进度">
            <template slot-scope="scope">
              <el-progress :percentage="scope.row.progress" status="success"></el-progress>
            </template>
          </el-table-column>
          <el-table-column prop="labelType" label="标注类型"></el-table-column>
          <el-table-column prop="status" label="状态">
            <template slot-scope="scope">
              <el-tag v-if="scope.row.status === '正常'" type="success">正常</el-tag>
              <el-tag v-else-if="scope.row.status === '异常'" type="warning">异常</el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="currentVersion" label="当前版本"></el-table-column>
          <el-table-column prop="updateTime" label="更新时间"></el-table-column>
          <el-table-column prop="description" label="数据集描述"></el-table-column>
          <el-table-column label="操作">
            <template slot-scope="scope">
              <el-button @click="editItem(scope.row)" size="mini" type="primary">编辑</el-button>
              <el-button @click="deleteItem(scope.row)" size="mini" type="danger">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>

      <el-tab-pane label="预置数据集" name="presetDataSets">
        <el-table ref="multipleTable" :data="presetDataSets" style="width: 100%" @selection-change="handleSelectionChange">
          <el-table-column prop="id" label="ID" width="100"></el-table-column>
          <el-table-column prop="name" label="名称"></el-table-column>
          <el-table-column prop="dataType" label="数据类型"></el-table-column>
          <el-table-column prop="progress" label="进度">
            <template slot-scope="scope">
              <el-progress :percentage="scope.row.progress" status="success"></el-progress>
            </template>
          </el-table-column>
          <el-table-column prop="labelType" label="标注类型"></el-table-column>
          <el-table-column prop="status" label="状态">
            <template slot-scope="scope">
              <el-tag v-if="scope.row.status === '正常'" type="success">正常</el-tag>
              <el-tag v-else-if="scope.row.status === '异常'" type="warning">异常</el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="currentVersion" label="当前版本"></el-table-column>
          <el-table-column prop="updateTime" label="更新时间"></el-table-column>
          <el-table-column prop="description" label="数据集描述"></el-table-column>
          <el-table-column label="操作">
            <template slot-scope="scope">
              <el-button @click="editItem(scope.row)" size="mini" type="primary">编辑</el-button>
              <el-button @click="deleteItem(scope.row)" size="mini" type="danger">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
export default {
  data() {
    return {
      activeTab: 'myDataSets', // 默认显示“我的数据集”
      myDataSets: [
        { id: 1, name: '数据集1', dataType: '文本', progress: '80', labelType: '手动', status: '正常', currentVersion: 'v1.0', updateTime: '2025-02-20', description: '描述信息' },
        { id: 2, name: '数据集2', dataType: '图像', progress: '60', labelType: '自动', status: '异常', currentVersion: 'v2.1', updateTime: '2025-02-18', description: '描述信息' },
        // 更多数据
      ],
      presetDataSets: [
        { id: 1, name: '预置数据集1', dataType: '文本', progress: '100', labelType: '手动', status: '正常', currentVersion: 'v1.2', updateTime: '2025-02-20', description: '' },
        { id: 2, name: '预置数据集2', dataType: '音频', progress: '100', labelType: '自动', status: '正常', currentVersion: 'v1.0', updateTime: '2025-02-19', description: '' },
        { id: 3, name: '预置数据集3', dataType: '视频', progress: '100', labelType: '半自动', status: '正常', currentVersion: 'v1.1', updateTime: '2025-02-21', description: '' },
        { id: 4, name: '预置数据集4', dataType: '文本', progress: '100', labelType: '手动', status: '正常', currentVersion: 'v2.0', updateTime: '2025-02-22', description: '' },
        { id: 5, name: '预置数据集5', dataType: '图像', progress: '100', labelType: '自动', status: '正常', currentVersion: 'v2.1', updateTime: '2025-02-20', description: '' },
        { id: 6, name: '预置数据集6', dataType: '音频', progress: '100', labelType: '手动', status: '正常', currentVersion: 'v1.0', updateTime: '2025-02-18', description: '' }
      ],
      multipleSelection: []
    };
  },
  methods: {
    editItem(row) {
      console.log('编辑', row);
      // 编辑功能逻辑
    },
    deleteItem(row) {
      console.log('删除', row);
      // 删除功能逻辑
    },
    handleSelectionChange(val) {
      this.multipleSelection = val;
    }
  }
};
</script>

<style scoped>
.el-card {
  margin-bottom: 20px;
}
</style>
