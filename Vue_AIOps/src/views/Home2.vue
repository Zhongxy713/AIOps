<template>
  <div class="dashboard-container">
    <!-- 用户数量统计 -->
    <el-row gutter="20">
      <el-col :span="6" v-for="stat in userStats" :key="stat.name">
        <el-card class="card" :body-style="{ padding: '20px' }">
          <h4>{{ stat.name }}</h4>
          <p>{{ stat.value }}</p>
        </el-card>
      </el-col>
    </el-row>

    <!-- 任务数量统计 -->
    <el-row gutter="20">
      <el-col :span="6" v-for="stat in taskStats" :key="stat.name">
        <el-card class="card" :body-style="{ padding: '20px' }">
          <h4>{{ stat.name }}</h4>
          <p>{{ stat.value }}</p>
        </el-card>
      </el-col>
    </el-row>

    <!-- 镜像数量统计 -->
    <el-row gutter="20">
      <el-col :span="6" v-for="stat in imageStats" :key="stat.name">
        <el-card class="card" :body-style="{ padding: '20px' }">
          <h4>{{ stat.name }}</h4>
          <p>{{ stat.value }}</p>
        </el-card>
      </el-col>
    </el-row>

    <!-- 算法管道模型数量统计 -->
    <el-row gutter="20">
      <el-col :span="6" v-for="stat in pipelineStats" :key="stat.name">
        <el-card class="card" :body-style="{ padding: '20px' }">
          <div><i class="el-icon-s-shop" /> <h4>算法管道模型数</h4></div>
          <p>{{ stat.value }}</p>
        </el-card>
      </el-col>
    </el-row>

    <!-- 工作节点日部署量统计 -->
    <el-card class="card" :body-style="{ padding: '20px' }">
      <h3>工作节点日部署量统计</h3>
      <div class="chart-container">
        <v-chart :option="lineChartOption"></v-chart>
      </div>
    </el-card>
  </div>
</template>

<script>
export default {
  // eslint-disable-next-line vue/multi-word-component-names
  name: "Home2",
  data() {
    return {
      taskStats: [
        { name: '任务总数', value: 500 },
        { name: '进行中的任务', value: 200 },
        { name: '已完成任务', value: 300 },
      ],
      imageStats: [
        { name: '镜像总数', value: 50 },
        { name: '活跃镜像', value: 30 },
        { name: '已废弃镜像', value: 10 },
      ],
      pipelineStats: [
        { name: '算法管道总数', value: 10 },
        { name: '正在运行管道', value: 5 },
        { name: '已完成管道', value: 5 },
      ],
      lineChartOption: {
        title: {
          text: '工作节点日部署量统计',
        },
        tooltip: {
          trigger: 'axis',
        },
        xAxis: {
          type: 'category',
          data: ['2025-02-01', '2025-02-02', '2025-02-03', '2025-02-04', '2025-02-05', '2025-02-06', '2025-02-07'],
        },
        yAxis: {
          type: 'value',
        },
        series: [
          {
            data: [5, 20, 36, 10, 10, 20, 30],
            type: 'line',
            smooth: true,
          },
        ],
      },
    };
  },
};
</script>

<style scoped>
.dashboard-container {
  padding: 20px;
}

.card {
  margin-bottom: 20px;
}

.chart-container {
  width: 100%;
  height: 400px;
}

.el-row {
  margin-bottom: 20px;
}
</style>
