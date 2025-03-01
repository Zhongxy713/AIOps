<template>
  <div class="algorithm-page">
    <el-row>
      <el-col :span="24">
        <h1>算法列表</h1>

        <!-- 搜索框 -->
        <el-input
            v-model="APMName"
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
          <el-col :span="8" v-for="algorithm in tableData" :key="algorithm.id">
            <el-card class="algorithm-card" shadow="hover">
              <el-container>
                <el-aside width="60px">
                  <router-link
                      :to="{ path: '/back/newModeling', query: { ID: algorithm.id } }"
                  >
                    <img src="../../assets/svg/魔方-copy-copy.svg"  style="width: 50px; height: 50px; margin-top: 20px"/>
                  </router-link>
                </el-aside>
                <el-main>
                  <h3>{{ algorithm.apmName }}</h3>
                  <p>{{ algorithm.description }}</p>
                </el-main>
              </el-container>
            </el-card>
          </el-col>
        </el-row>

        <!-- 列表风格视图 -->
        <el-table v-if="currentView === 'list'" :data="tableData" style="width: 100%">
          <el-table-column prop="apmName" label="算法名称" width="180"></el-table-column>
          <el-table-column prop="description" label="描述"></el-table-column>
        </el-table>

        <!-- 分页组件 -->
        <el-pagination
            @size-change="handleSizeChange"
            @current-change="handleCurrentChange"
            style="margin-top: 20px;"
            background
            :current-page="pageNum"
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
import {getAPMData} from "@/axios/node";

export default {
  data() {
    return {
      currentView: 'card', // 默认视图为卡片风格
      pageNum: 1,
      APMName: "",
      currentPage: 1, // 当前页码
      pageSize: 3, // 每页显示的算法数量
      tableData: [],
      total: 0,
    };
  },
  computed: {
  },
  created() {
    this.getAllAPMData()
  },
  methods: {
    // 处理搜索
    handleSearch() {
      this.currentPage = 1; // 搜索时重置到第一页
    },
    handleSizeChange(pageSize) {
      console.log(pageSize)
      this.pageSize = pageSize
      this.getAllAPMData()
    },
    handleCurrentChange(pageNum) {
      console.log(pageNum)
      this.pageNum = pageNum
      this.getAllAPMData()
    },
    getAllAPMData() {
      let param = {
        pageNum: this.pageNum,
        pageSize: this.pageSize,
        apmName: this.APMName
      }
      getAPMData(param).then(res => {

        this.tableData = res.data.records
        this.total = res.data.total
        console.log(this.tableData)
        console.log(this.total)
      })
    }
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
