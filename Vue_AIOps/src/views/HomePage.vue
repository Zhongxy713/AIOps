<template>
  <div class="home-container">
    <!-- 顶部标题 -->
    <div class="header">
      <h1>算法管道模型建模与部署平台</h1>
      <p class="subtitle">低代码算法服务开发工具 - 提升建模效率与部署智能化</p>
    </div>

    <!-- 主要内容区域 -->
    <div class="main-content">
      <!-- 用户信息卡片 -->
      <div class="card user-info-card">
        <div class="card-header">
          <i class="el-icon-user"></i>
          <span>用户信息</span>
          <el-tag :type="loginStatusTagType" class="status-tag">{{ loginStatusText }}</el-tag>
        </div>
        <div class="card-body">
          <div class="user-avatar">
<!--            <el-avatar :size="80" :src="user.avatar" class="avatar"></el-avatar>-->
            <img :src="user.avatar" alt="" class="avatar"
                 style="width: 80px; height: 80px; border-radius: 30%; position: relative; top: 0px; right: 5px; left: 10px">
            <div class="user-name">{{ user.name }}</div>
            <div class="user-role">{{ user.role }}</div>
          </div>
          <div class="user-details">
            <div class="detail-item">
              <span class="label">用户ID:</span>
              <span class="value">{{ user.userId }}</span>
            </div>
            <div class="detail-item">
              <span class="label">部门:</span>
              <span class="value">{{ user.department }}</span>
            </div>
            <div class="detail-item">
              <span class="label">邮箱:</span>
              <span class="value">{{ user.email }}</span>
            </div>
            <div class="detail-item">
              <span class="label">上次登录:</span>
              <span class="value">{{ user.lastLogin }}</span>
            </div>
            <div class="detail-item">
              <span class="label">项目数:</span>
              <span class="value">{{ user.projectCount }}</span>
            </div>
          </div>
        </div>
        <div class="card-footer">
          <el-button type="primary" icon="el-icon-edit" @click="editProfile">编辑资料</el-button>
          <el-button type="info" icon="el-icon-setting" @click="goToSettings">账户设置</el-button>
        </div>
      </div>

      <!-- 部署统计卡片 -->
      <div class="card deploy-stats-card">
        <div class="card-header">
          <i class="el-icon-data-line"></i>
          <span>部署情况统计</span>
        </div>
        <div class="card-body">
          <div class="stats-overview">
            <div class="stat-item">
              <div class="stat-value">{{ deploymentStats.totalNodes }}</div>
              <div class="stat-label">总节点数</div>
            </div>
            <div class="stat-item">
              <div class="stat-value" style="color: #67C23A;">{{ deploymentStats.runningNodes }}</div>
              <div class="stat-label">运行中</div>
            </div>
            <div class="stat-item">
              <div class="stat-value" style="color: #E6A23C;">{{ deploymentStats.warningNodes }}</div>
              <div class="stat-label">警告</div>
            </div>
            <div class="stat-item">
              <div class="stat-value" style="color: #F56C6C;">{{ deploymentStats.errorNodes }}</div>
              <div class="stat-label">异常</div>
            </div>
            <div class="stat-item">
              <div class="stat-value" style="color: #909399;">{{ deploymentStats.offlineNodes }}</div>
              <div class="stat-label">离线</div>
            </div>
          </div>

          <div class="deploy-chart">
            <div class="chart-container">
              <div id="deploymentChart" style="width: 100%; height: 300px;"></div>
            </div>
          </div>

          <div class="resource-usage">
            <div class="usage-item">
              <div class="usage-header">
                <span>CPU使用率</span>
                <span>{{ resourceUsage.cpu }}%</span>
              </div>
              <el-progress :percentage="resourceUsage.cpu" :color="getProgressColor(resourceUsage.cpu)"></el-progress>
            </div>
            <div class="usage-item">
              <div class="usage-header">
                <span>内存使用率</span>
                <span>{{ resourceUsage.memory }}%</span>
              </div>
              <el-progress :percentage="resourceUsage.memory" :color="getProgressColor(resourceUsage.memory)"></el-progress>
            </div>
            <div class="usage-item">
              <div class="usage-header">
                <span>存储使用率</span>
                <span>{{ resourceUsage.storage }}%</span>
              </div>
              <el-progress :percentage="resourceUsage.storage" :color="getProgressColor(resourceUsage.storage)"></el-progress>
            </div>
          </div>
        </div>
      </div>

      <!-- 平台日志卡片 -->
      <div class="card platform-logs-card">
        <div class="card-header">
          <i class="el-icon-notebook-2"></i>
          <span>平台日志与通知</span>
          <el-badge :value="unreadLogsCount" :max="99" class="badge"></el-badge>
        </div>
        <div class="card-body">
          <el-timeline>
            <el-timeline-item
                v-for="(log, index) in platformLogs"
                :key="index"
                :timestamp="log.timestamp"
                :type="log.type"
                :icon="log.icon"
                :color="log.color"
                :size="log.size"
                placement="top"
            >
              <el-card shadow="hover" :class="{'unread-log': !log.read}">
                <div class="log-content">
                  <h4>{{ log.title }}</h4>
                  <p>{{ log.content }}</p>
                  <div class="log-footer">
                    <span class="log-type">{{ log.logType }}</span>
                    <el-button
                        v-if="!log.read"
                        type="text"
                        size="mini"
                        @click="markAsRead(index)"
                    >
                      标记为已读
                    </el-button>
                  </div>
                </div>
              </el-card>
            </el-timeline-item>
          </el-timeline>
          <div class="load-more">
            <el-button type="text" @click="loadMoreLogs">加载更多日志</el-button>
          </div>
        </div>
      </div>
    </div>

    <!-- 快速入口 -->
    <div class="quick-actions">
      <el-tooltip content="新建算法管道模型" placement="top">
        <el-button type="primary" icon="el-icon-plus" circle @click="createNewPipeline"></el-button>
      </el-tooltip>
      <el-tooltip content="模型管理" placement="top">
        <el-button type="success" icon="el-icon-cpu" circle @click="goToModelManagement"></el-button>
      </el-tooltip>
      <el-tooltip content="数据集管理" placement="top">
        <el-button type="warning" icon="el-icon-data-board" circle @click="goToDatasetManagement"></el-button>
      </el-tooltip>
      <el-tooltip content="部署管理" placement="top">
        <el-button type="danger" icon="el-icon-cloudy" circle @click="goToDeploymentManagement"></el-button>
      </el-tooltip>
    </div>
  </div>
</template>

<script>
import * as echarts from 'echarts';

export default {
  name: 'HomePage',
  data() {
    return {
      user: {
        userId: 'DEV2023001',
        name: 'admin',
        role: '高级算法工程师',
        department: 'AI研发中心-算法组',
        email: 'admin@company.com',
        lastLogin: '2023-06-15 14:30:22',
        projectCount: 8,
        avatar: 'http://localhost:9090/file/29b047221f72435ea6d46b945a0b9410.jpeg',
        isOnline: true
      },
      deploymentStats: {
        totalNodes: 5,
        runningNodes: 4,
        warningNodes: 0,
        errorNodes: 0,
        offlineNodes: 1,
        nodeStatus: [
          { name: '运行中', value: 4 },
          { name: '警告', value: 0 },
          { name: '异常', value: 0 },
          { name: '离线', value: 1 }
        ]
      },
      resourceUsage: {
        cpu: 68,
        memory: 45,
        storage: 32
      },
      platformLogs: [
        {
          title: '系统升级通知',
          content: '平台将于2025-03-20 02:00-04:00进行系统升级，升级期间将暂停服务。',
          timestamp: '2025-03-15',
          type: 'primary',
          icon: 'el-icon-message-solid',
          color: '#409EFF',
          logType: '系统通知',
          read: false
        },
        {
          title: '新功能发布',
          content: '新增算法管道模型可视化编排功能，支持拖拽式组件连接与参数配置。',
          timestamp: '2025-02-14',
          type: 'success',
          icon: 'el-icon-circle-check',
          color: '#67C23A',
          logType: '功能更新',
          read: false
        },
        {
          title: '性能优化',
          content: '优化了模型部署流程，部署时间平均缩短30%。',
          timestamp: '2025-01-12',
          type: '',
          icon: 'el-icon-odometer',
          color: '#E6A23C',
          logType: '优化改进',
          read: true
        },
        {
          title: '安全提醒',
          content: '检测到部分用户使用弱密码，请及时修改为强密码以确保账户安全。',
          timestamp: '2025-01-10',
          type: 'warning',
          icon: 'el-icon-warning',
          color: '#E6A23C',
          logType: '安全通知',
          read: true
        },
        {
          title: '文档更新',
          content: '平台使用文档已更新，新增API接口说明和常见问题解答。',
          timestamp: '2024-12-08',
          type: 'info',
          icon: 'el-icon-document',
          color: '#909399',
          logType: '文档更新',
          read: true
        }
      ]
    };
  },
  computed: {
    loginStatusText() {
      return this.user.isOnline ? '在线' : '离线';
    },
    loginStatusTagType() {
      return this.user.isOnline ? 'success' : 'danger';
    },
    unreadLogsCount() {
      return this.platformLogs.filter(log => !log.read).length;
    }
  },
  mounted() {
    this.initDeploymentChart();
    // 模拟实时更新数据
    this.updateStatsInterval = setInterval(() => {
      this.updateResourceUsage();
    }, 5000);
  },
  beforeDestroy() {
    if (this.updateStatsInterval) {
      clearInterval(this.updateStatsInterval);
    }
    if (this.deploymentChart) {
      this.deploymentChart.dispose();
    }
  },
  methods: {
    initDeploymentChart() {
      const chartDom = document.getElementById('deploymentChart');
      this.deploymentChart = echarts.init(chartDom);

      const option = {
        tooltip: {
          trigger: 'item',
          formatter: '{a} <br/>{b}: {c} ({d}%)'
        },
        legend: {
          orient: 'vertical',
          right: 10,
          top: 'center',
          data: this.deploymentStats.nodeStatus.map(item => item.name)
        },
        series: [
          {
            name: '节点状态',
            type: 'pie',
            radius: ['50%', '70%'],
            avoidLabelOverlap: false,
            itemStyle: {
              borderRadius: 10,
              borderColor: '#fff',
              borderWidth: 2
            },
            label: {
              show: false,
              position: 'center'
            },
            emphasis: {
              label: {
                show: true,
                fontSize: '18',
                fontWeight: 'bold'
              }
            },
            labelLine: {
              show: false
            },
            data: this.deploymentStats.nodeStatus.map(item => {
              let color;
              switch (item.name) {
                case '运行中': color = '#67C23A'; break;
                case '警告': color = '#E6A23C'; break;
                case '异常': color = '#F56C6C'; break;
                case '离线': color = '#909399'; break;
                default: color = '#409EFF';
              }
              return {
                value: item.value,
                name: item.name,
                itemStyle: { color }
              };
            })
          }
        ]
      };

      this.deploymentChart.setOption(option);

      // 响应式调整
      window.addEventListener('resize', this.handleChartResize);
    },
    handleChartResize() {
      if (this.deploymentChart) {
        this.deploymentChart.resize();
      }
    },
    updateResourceUsage() {
      // 模拟资源使用率变化
      this.resourceUsage = {
        cpu: Math.min(100, Math.max(0, this.resourceUsage.cpu + (Math.random() * 6 - 3))),
        memory: Math.min(100, Math.max(0, this.resourceUsage.memory + (Math.random() * 4 - 2))),
        storage: Math.min(100, Math.max(0, this.resourceUsage.storage + (Math.random() * 2 - 1)))
      };
    },
    getProgressColor(percentage) {
      if (percentage > 80) return '#F56C6C';
      if (percentage > 60) return '#E6A23C';
      return '#67C23A';
    },
    markAsRead(index) {
      this.$set(this.platformLogs, index, {
        ...this.platformLogs[index],
        read: true
      });
    },
    loadMoreLogs() {
      // 模拟加载更多日志
      const newLogs = [
        {
          title: '模型训练优化',
          content: '优化了模型训练过程中的资源调度算法，训练速度提升15%。',
          timestamp: '2023-06-05',
          type: '',
          icon: 'el-icon-connection',
          color: '#409EFF',
          logType: '优化改进',
          read: true
        },
        {
          title: '新增数据集',
          content: '新增公开数据集ImageNet-1k，可直接在数据集管理中查看和使用。',
          timestamp: '2023-06-03',
          type: 'success',
          icon: 'el-icon-circle-plus',
          color: '#67C23A',
          logType: '数据集更新',
          read: true
        }
      ];
      this.platformLogs = [...this.platformLogs, ...newLogs];
      this.$message.success('已加载更多日志');
    },
    editProfile() {
      this.$message.info('跳转到编辑资料页面');
    },
    goToSettings() {
      this.$message.info('跳转到账户设置页面');
    },
    createNewPipeline() {
      this.$message.success('创建新算法管道');
    },
    goToModelManagement() {
      this.$message.info('跳转到模型管理');
    },
    goToDatasetManagement() {
      this.$message.info('跳转到数据集管理');
    },
    goToDeploymentManagement() {
      this.$message.info('跳转到部署管理');
    }
  }
};
</script>

<style scoped>
.home-container {
  padding: 20px;
  background-color: #f5f7fa;
  min-height: 100vh;
}

.header {
  text-align: center;
  margin-bottom: 30px;
  padding: 20px;
  background: linear-gradient(135deg, #409EFF, #67C23A);
  color: white;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

.header h1 {
  margin: 0;
  font-size: 28px;
  font-weight: bold;
}

.subtitle {
  margin: 10px 0 0;
  font-size: 16px;
  opacity: 0.9;
}

.main-content {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
  gap: 20px;
  margin-bottom: 20px;
}

@media (max-width: 1200px) {
  .main-content {
    grid-template-columns: 1fr 1fr;
  }
}

@media (max-width: 768px) {
  .main-content {
    grid-template-columns: 1fr;
  }
}

.card {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  overflow: hidden;
  transition: all 0.3s;
}

.card:hover {
  transform: translateY(-5px);
  box-shadow: 0 6px 18px 0 rgba(0, 0, 0, 0.15);
}

.card-header {
  padding: 15px 20px;
  border-bottom: 1px solid #ebeef5;
  font-size: 16px;
  font-weight: bold;
  display: flex;
  align-items: center;
}

.card-header i {
  margin-right: 10px;
  font-size: 18px;
}

.status-tag {
  margin-left: auto;
}

.badge {
  margin-left: auto;
}

.card-body {
  padding: 20px;
}

.user-info-card .card-body {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.user-avatar {
  text-align: center;
  margin-bottom: 20px;
}

.avatar {
  margin-bottom: 10px;
}

.user-name {
  font-size: 18px;
  font-weight: bold;
  margin-bottom: 5px;
}

.user-role {
  color: #909399;
  font-size: 14px;
}

.user-details {
  width: 100%;
}

.detail-item {
  display: flex;
  justify-content: space-between;
  padding: 8px 0;
  border-bottom: 1px dashed #ebeef5;
}

.detail-item:last-child {
  border-bottom: none;
}

.label {
  color: #909399;
}

.value {
  font-weight: 500;
}

.card-footer {
  padding: 15px 20px;
  border-top: 1px solid #ebeef5;
  text-align: center;
}

.stats-overview {
  display: flex;
  justify-content: space-around;
  margin-bottom: 20px;
  text-align: center;
}

.stat-item {
  padding: 10px;
}

.stat-value {
  font-size: 24px;
  font-weight: bold;
  margin-bottom: 5px;
}

.stat-label {
  color: #909399;
  font-size: 14px;
}

.deploy-chart {
  height: 300px;
  margin-bottom: 20px;
}

.usage-item {
  margin-bottom: 15px;
}

.usage-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 5px;
  font-size: 14px;
}

.unread-log {
  border-left: 4px solid #409EFF;
}

.log-content h4 {
  margin: 0 0 10px;
  color: #303133;
}

.log-content p {
  margin: 0 0 10px;
  color: #606266;
  font-size: 14px;
}

.log-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 12px;
  color: #909399;
}

.log-type {
  padding: 2px 8px;
  background-color: #f0f2f5;
  border-radius: 4px;
}

.load-more {
  text-align: center;
  margin-top: 10px;
}

.quick-actions {
  position: fixed;
  right: 30px;
  bottom: 30px;
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.quick-actions .el-button {
  width: 50px;
  height: 50px;
  font-size: 20px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}
</style>
