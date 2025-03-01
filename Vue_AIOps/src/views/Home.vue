<template>
  <div>
    <!-- 用户统计卡片区 -->
    <el-row :gutter="10" style="margin-bottom: 60px">
      <el-col :span="6">
        <el-card style="color: #409EFF">
          <div><i class="el-icon-user-solid" /> 用户总数</div>
          <div style="padding: 10px 0; text-align: center; font-weight: bold">
            100
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card style="color: #F56C6C">
          <div><i class="el-icon-money" /> 任务总量</div>
          <div style="padding: 10px 0; text-align: center; font-weight: bold">
            1000
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card style="color: #67C23A">
          <div><i class="el-icon-bank-card" /> 镜像数量</div>
          <div style="padding: 10px 0; text-align: center; font-weight: bold">
            300
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card style="color: #E6A23C">
          <div><i class="el-icon-s-shop" /> 算法管道模型数</div>
          <div style="padding: 10px 0; text-align: center; font-weight: bold">
            20
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 图表和日志管理并排显示 -->
    <el-row :gutter="10">
      <el-col :span="12">
        <el-card>
          <div id="main" style="height: 450px"></div>
        </el-card>
      </el-col>

      <el-col :span="12">
        <el-card>
          <div class="item_title">日志管理</div>
          <el-table :data="logs" style="width: 100%">
            <el-table-column prop="time" label="时间" width="180"></el-table-column>
            <el-table-column prop="level" label="级别" width="120"></el-table-column>
            <el-table-column prop="message" label="日志内容"></el-table-column>
          </el-table>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import * as echarts from 'echarts'

export default {
  // eslint-disable-next-line vue/multi-word-component-names
  name: "Home",
  data() {
    return {
      total: {},
      today: {},
      extData: {},
      // 日志数据
      logs: [
        { time: '2025-02-01 10:00', level: 'INFO', message: '系统启动成功' },
        { time: '2025-02-01 10:30', level: 'ERROR', message: '任务执行失败' },
        { time: '2025-02-01 11:00', level: 'INFO', message: '用户注册成功' },
        { time: '2025-02-01 12:00', level: 'WARNING', message: '内存使用量接近最大值' },
        { time: '2025-02-01 13:00', level: 'INFO', message: '数据处理完成' },
      ]
    }
  },
  mounted() { // 页面渲染之后再触发
    var chartDom = document.getElementById('main');
    var myChart = echarts.init(chartDom);
    var option;

    option = {
      title: {
        text: '工作节点日部署量'
      },
      tooltip: {
        trigger: 'axis'
      },
      legend: {
        data: ['W1', 'W2', 'W3', 'W4']
      },
      grid: {
        left: '3%',
        right: '4%',
        bottom: '3%',
        containLabel: true
      },
      toolbox: {
        feature: {
          saveAsImage: {}
        }
      },
      xAxis: {
        type: 'category',
        boundaryGap: false,
        data: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
      },
      yAxis: {
        type: 'value'
      },
      series: [
        {
          name: 'W1',
          type: 'line',
          stack: 'Total',
          data: [120, 132, 101, 134, 90, 230, 210]
        },
        {
          name: 'W2',
          type: 'line',
          stack: 'Total',
          data: [220, 182, 191, 234, 290, 330, 310]
        },
        {
          name: 'W3',
          type: 'line',
          stack: 'Total',
          data: [150, 232, 201, 154, 190, 330, 410]
        },
        {
          name: 'W4',
          type: 'line',
          stack: 'Total',
          data: [320, 332, 301, 334, 390, 330, 320]
        },
      ]
    };

    option && myChart.setOption(option);
  }
}
</script>

<style>
.item {
  text-align: center;
  width: 150px;
  height: 150px;
  margin-right: 5px;
  margin-bottom: 5px;
}
.item:nth-child(3n) {
  margin-right: 0;
}
.item_title {
  font-size: 16px;
  font-weight: bold;
  margin-top: 20px;
}
.item_num {
  margin-top: 10px;
  font-size: 30px;
  font-weight: bold;
}
.item_num_plus {
  font-size: 16px;
  color: #666;
}

.el-table .cell {
  text-align: center;
}
</style>
