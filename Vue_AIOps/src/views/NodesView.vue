<template>
  <div class="nodes-container">
    <div class="header">
      <h1>算法管道模型部署节点</h1>
      <div class="actions">
        <button class="add-node-btn" @click="showAddNodeDialog">新增部署节点</button>
        <button class="deploy-model-btn" @click="goToDeploymentView">部署算法管道模型</button>
      </div>
    </div>

    <div class="nodes-list">
      <NodeCard
          v-for="node in nodes"
          :key="node.id"
          :node="node"
          @deploy="handleDeploy"
      />
    </div>

    <!-- 添加节点对话框 -->
    <div class="dialog-overlay" v-if="showDialog">
      <div class="dialog">
        <h3>添加新节点</h3>
        <form @submit.prevent="addNode">
          <div class="form-group">
            <label>节点名称</label>
            <input v-model="newNode.name" required>
          </div>
          <div class="form-group">
            <label>IP地址</label>
            <input v-model="newNode.ip" required>
          </div>
          <div class="form-group">
            <label>初始状态</label>
            <select v-model="newNode.status">
              <option value="active">活跃</option>
              <option value="inactive">不活跃</option>
            </select>
          </div>
          <div class="dialog-actions">
            <button type="button" @click="cancelAddNode">取消</button>
            <button type="submit">确认添加</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import NodeCard from './NodeCard.vue'

export default {
  components: {
    NodeCard
  },
  data() {
    return {
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
      showDialog: false,
      newNode: {
        name: '',
        ip: '',
        status: 'active'
      }
    }
  },
  methods: {
    showAddNodeDialog() {
      this.showDialog = true
    },
    cancelAddNode() {
      this.showDialog = false
      this.resetNewNode()
    },
    addNode() {
      const newNode = {
        id: this.nodes.length + 1,
        name: this.newNode.name,
        ip: this.newNode.ip,
        status: this.newNode.status,
        uptime: '0天0小时',
        cpu: 0,
        memory: 0,
        models: []
      }
      this.nodes.push(newNode)
      this.showDialog = false
      this.resetNewNode()
    },
    resetNewNode() {
      this.newNode = {
        name: '',
        ip: '',
        status: 'active'
      }
    },
    goToDeploymentView() {
      this.$router.push('/deploy')
    },
    handleDeploy(node) {
      this.$router.push({ path: '/deploy', query: { nodeId: node.id } })
    }
  }
}
</script>

<style scoped>
.nodes-container {
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

.actions button {
  padding: 10px 15px;
  margin-left: 10px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-weight: bold;
}

.add-node-btn {
  background-color: #4CAF50;
  color: white;
}

.deploy-model-btn {
  background-color: #2196F3;
  color: white;
}

.nodes-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
  gap: 20px;
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
  width: 400px;
  max-width: 90%;
}

.form-group {
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
}

.form-group input, .form-group select {
  width: 100%;
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
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
