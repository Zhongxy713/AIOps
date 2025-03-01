<template>
  <div class="algorithm-page">
    <el-row>
      <el-col :span="24">
        <h1>算法列表</h1>

        <!-- 搜索框 -->
        <el-input
            v-model="ClassName"
            placeholder="搜索算法管道模型名称"
            @input="handleSearch"
            clearable
            style="width: 300px; margin-bottom: 20px"
        >
          <el-button slot="append" icon="el-icon-search" @click="getAllAPMData"></el-button>
        </el-input>

        <!-- 视图切换按钮 -->
        <div class="view-toggle" style="margin-bottom: 20px;">
          <el-button-group>
            <el-button
                :type="currentView === 'card' ? 'primary' : 'default'"
                @click="currentView = 'card'"
            >
              卡片视图
            </el-button>
            <el-button
                :type="currentView === 'list' ? 'primary' : 'default'"
                @click="currentView = 'list'"
            >
              列表视图
            </el-button>
          </el-button-group>
        </div>

        <!-- 卡片风格视图 -->
        <el-row v-if="currentView === 'card'" :gutter="20">
          <el-col :span="8" v-for="algorithm in displayedData" :key="algorithm.id">
            <el-card class="algorithm-card" shadow="hover">
              <el-container>
                <el-aside width="100px">
                  <img src="../assets/yuwen.jpg"  style="width: 100px; height: 150px; margin-top: 10px"/>
                </el-aside>
                <el-main>
<!--                  <h3>{{ algorithm.name }}</h3>-->
                  <el-button type="text" @click="open">{{ algorithm.name }}</el-button>
                  <p>{{ algorithm.description }}</p>
                </el-main>
              </el-container>
            </el-card>
          </el-col>
        </el-row>

        <!-- 列表风格视图 -->
        <el-table v-if="currentView === 'list'" :data="displayedData" style="width: 100%">
          <el-table-column prop="name" label="课程名称" width="180"></el-table-column>
          <el-table-column prop="description" label="描述"></el-table-column>
        </el-table>

        <!-- 分页组件 -->
        <el-pagination
            @size-change="handleSizeChange"
            @current-change="handleCurrentChange"
            style="margin-top: 20px;"
            background
            :current-page="currentPage"
            :page-sizes="[3, 5, 10, 20]"
            :page-size="pageSize"
            layout="total, sizes, prev, pager, next, jumper"
            :total="total">
        </el-pagination>
      </el-col>
    </el-row>
  </div>
</template>

<script>
export default {
  // eslint-disable-next-line vue/multi-word-component-names
  name: "classes",
  data() {
    return {
      currentView: 'card', // 默认视图为卡片风格
      pageNum: 1, // 当前页码
      pageSize: 3, // 每页显示的算法数量
      ClassName: "", // 搜索框的值
      tableData: [
        {id: 1, name: '语文', description: '语文课程'},
        {id: 2, name: '数学', description: '数学课程'},
        {id: 3, name: '英语', description: '英语课程'},
        {id: 4, name: '物理', description: '物理课程'},
        {id: 5, name: '化学', description: '化学课程'},
        {id: 6, name: '生物', description: '生物课程'},
        {id: 7, name: '历史', description: '历史课程'},
        {id: 8, name: '地理', description: '地理课程'},
        {id: 9, name: '政治', description: '政治课程'},
        {id: 10, name: '体育', description: '体育课程'},
        {id: 11, name: '音乐', description: '音乐课程'},
        {id: 12, name: '美术', description: '美术课程'},
        {id: 13, name: '信息技术', description: '信息技术课程'},
      ],
      total: 13, // 总数据项数量
      currentPage: 1, // 当前页码
    };
  },
  computed: {
    // 计算出当前页需要显示的数据
    displayedData() {
      const start = (this.currentPage - 1) * this.pageSize;
      const end = start + this.pageSize;
      return this.tableData.slice(start, end);
    }
  },
  methods: {
    // 处理搜索
    handleSearch() {
      this.currentPage = 1; // 搜索时重置到第一页
    },
    handleSizeChange(pageSize) {
      this.pageSize = pageSize;
      this.currentPage = 1; // 当每页显示条数改变时，回到第一页
    },
    handleCurrentChange(pageNum) {
      this.currentPage = pageNum;
    },
    open() {
      this.$alert('这是一段内容', '标题名称', {
        confirmButtonText: '确定',
        callback: action => {
          this.$message({
            type: 'info',
            message: `action: ${action}`
          });
        }
      }
      );}
  }
};
</script>

<style scoped>
.algorithm-page {
  padding: 20px;
}

h1 {
  margin-bottom: 20px;
}

.algorithm-card {
  margin-bottom: 20px;
  padding: 20px;
  border-radius: 10px;
}
</style>
