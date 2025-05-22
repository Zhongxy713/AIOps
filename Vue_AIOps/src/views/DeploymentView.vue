<template>
  <div class="deployment-container">
    <div class="header">
      <h1>算法管道模型部署</h1>
      <button class="back-btn" @click="goBack">返回节点列表</button>
    </div>

    <div class="content">
      <div class="node-info" v-if="selectedNode">
        <h2>目标节点: {{ selectedNode.name }}</h2>
        <div class="node-details">
          <span>状态: {{ selectedNode.status }}</span>
          <span>IP: {{ selectedNode.ip }}</span>
          <span>CPU: {{ selectedNode.cpu }}%</span>
          <span>内存: {{ selectedNode.memory }}%</span>
        </div>
      </div>

      <div class="models-section">
        <h2>待部署模型列表</h2>
        <ModelList
            :models="availableModels"
            :selected-node="selectedNode"
            @deploy-to-node="handleDeployToNode"
            @auto-deploy="handleAutoDeploy"
        />
      </div>
    </div>

    <!-- 部署确认对话框 -->
    <div class="dialog-overlay" v-if="showDeployDialog">
      <div class="dialog">
        <h3>确认部署</h3>
        <p>确定要将模型 <strong>{{ deployModel.name }}</strong> 部署到节点 <strong>{{ deployNode.name }}</strong> 吗？</p>
        <div class="dialog-actions">
          <button @click="showDeployDialog = false">取消</button>
          <button @click="confirmDeploy">确认部署</button>
        </div>
      </div>
    </div>

    <!-- 自动部署结果对话框 -->
    <div class="dialog-overlay" v-if="showAutoDeployDialog">
      <div class="dialog">
        <h3>自动部署结果</h3>
        <p>模型 <strong>{{ autoDeployModel.name }}</strong> 已自动部署到以下节点:</p>
        <ul>
          <li v-for="node in autoDeployNodes" :key="node.id">{{ node.name }}</li>
        </ul>
        <div class="dialog-actions">
          <button @click="showAutoDeployDialog = false">关闭</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import ModelList from './ModelList.vue'

export default {
  components: {
    ModelList
  },
  data() {
    return {
      availableModels: [
        {
          id: 201,
          name: '图像分类模型',
          version: '1.5',
          size: '256MB',
          type: '计算机视觉',
          description: '用于识别和分类图像中的对象，支持1000种常见类别。'
        },
        {
          id: 202,
          name: '文本情感分析',
          version: '2.0',
          size: '128MB',
          type: '自然语言处理',
          description: '分析文本内容的情感倾向，支持中英文。'
        },
        {
          id: 203,
          name: '时间序列预测',
          version: '1.2',
          size: '180MB',
          type: '数据分析',
          description: '基于历史数据预测未来趋势，适用于销售、流量等预测场景。'
        }
      ],
      nodes: [
        {
          id: 1,
          name: '节点服务器-1',
          status: 'active',
          uptime: '5天12小时',
          ip: '192.168.1.101',
          cpu: 32,
          memory: 45,
          models: [
            { id: 101, name: '图像识别模型', version: '1.2' },
            { id: 102, name: '自然语言处理', version: '2.1' }
          ]
        },
        {
          id: 2,
          name: '节点服务器-2',
          status: 'active',
          uptime: '2天3小时',
          ip: '192.168.1.102',
          cpu: 68,
          memory: 72,
          models: [
            { id: 103, name: '预测分析模型', version: '3.0' }
          ]
        },
        {
          id: 3,
          name: '节点服务器-3',
          status: 'inactive',
          uptime: '0天0小时',
          ip: '192.168.1.103',
          cpu: 0,
          memory: 0,
          models: []
        }
      ],
      showDeployDialog: false,
      deployModel: null,
      deployNode: null,
      showAutoDeployDialog: false,
      autoDeployModel: null,
      autoDeployNodes: []
    }
  },
  computed: {
    selectedNode() {
      const nodeId = this.$route.query.nodeId
      if (!nodeId) return null
      return this.nodes.find(node => node.id === parseInt(nodeId))
    }
  },
  methods: {
    goBack() {
      this.$router.push('/')
    },
    handleDeployToNode({ model, node }) {
      this.deployModel = model
      this.deployNode = node
      this.showDeployDialog = true
    },
    confirmDeploy() {
      // 在实际应用中，这里应该调用API进行部署
      console.log(`部署模型 ${this.deployModel.name} 到节点 ${this.deployNode.name}`)
      this.showDeployDialog = false
      alert(`模型 ${this.deployModel.name} 已成功部署到节点 ${this.deployNode.name}`)
    },
    handleAutoDeploy(model) {
      this.autoDeployModel = model
      // 模拟自动选择节点逻辑 - 选择资源使用率最低的活跃节点
      const suitableNodes = this.nodes
          .filter(node => node.status === 'active')
          .sort((a, b) => (a.cpu + a.memory) - (b.cpu + b.memory))
          .slice(0, 1) // 选择最优的一个节点

      this.autoDeployNodes = suitableNodes
      this.showAutoDeployDialog = true

      // 在实际应用中，这里应该调用API进行自动部署
      console.log(`自动部署模型 ${model.name} 到节点`, suitableNodes)
    }
  }
}
</script>

<style scoped>
.deployment-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
}

.back-btn {
  padding: 10px 15px;
  background-color: #f5f5f5;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.content {
  margin-top: 20px;
}

.node-info {
  margin-bottom: 30px;
  padding: 15px;
  background-color: #f9f9f9;
  border-radius: 8px;
}

.node-details {
  margin-top: 10px;
}

.node-details span {
  margin-right: 15px;
  color: #666;
}

.models-section {
  margin-top: 30px;
}

.dialog-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.dialog {
  background-color: white;
  padding: 20px;
  border-radius: 8px;
  width: 500px;
  max-width: 90%;
}

.dialog-actions {
  display: flex;
  justify-content: flex-end;
  margin-top: 20px;
}

.dialog-actions button {
  padding: 8px 15px;
  margin-left: 10px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.dialog-actions button:first-child {
  background-color: #f5f5f5;
}

.dialog-actions button:last-child {
  background-color: #4CAF50;
  color: white;
}
</style>
