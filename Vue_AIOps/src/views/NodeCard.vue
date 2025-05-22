<template>
  <div class="node-card" :class="{ 'active': node.status === 'active', 'inactive': node.status !== 'active' }">
    <div class="card-header" @click="toggleDetails">
      <h3>{{ node.name }}</h3>
      <span class="status-badge">{{ node.status }}</span>
    </div>
    <div class="card-body" v-if="showDetails">
      <div class="info-row">
        <span class="label">运行时间:</span>
        <span>{{ node.uptime }}</span>
      </div>
      <div class="info-row">
        <span class="label">IP地址:</span>
        <span>{{ node.ip }}</span>
      </div>
      <div class="info-row">
        <span class="label">CPU使用率:</span>
        <span>{{ node.cpu }}%</span>
      </div>
      <div class="info-row">
        <span class="label">内存使用率:</span>
        <span>{{ node.memory }}%</span>
      </div>

      <div class="deployed-models" v-if="node.models && node.models.length > 0">
        <h4>已部署模型:</h4>
        <ul>
          <li v-for="model in node.models" :key="model.id">
            {{ model.name }} (v{{ model.version }})
          </li>
        </ul>
      </div>
      <div v-else class="no-models">
        暂无部署模型
      </div>

      <button class="deploy-btn" @click.stop="deployModel">部署模型</button>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    node: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      showDetails: false
    }
  },
  methods: {
    toggleDetails() {
      this.showDetails = !this.showDetails
    },
    deployModel() {
      this.$emit('deploy', this.node)
    }
  }
}
</script>

<style scoped>
.node-card {
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 15px;
  margin-bottom: 15px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
}

.node-card.active {
  border-left: 4px solid #4CAF50;
}

.node-card.inactive {
  border-left: 4px solid #F44336;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  cursor: pointer;
}

.status-badge {
  padding: 3px 8px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: bold;
  text-transform: capitalize;
}

.active .status-badge {
  background-color: #E8F5E9;
  color: #4CAF50;
}

.inactive .status-badge {
  background-color: #FFEBEE;
  color: #F44336;
}

.info-row {
  display: flex;
  margin: 8px 0;
}

.label {
  font-weight: bold;
  margin-right: 10px;
  min-width: 80px;
}

.deployed-models {
  margin-top: 15px;
  padding-top: 10px;
  border-top: 1px dashed #ddd;
}

.no-models {
  color: #888;
  font-style: italic;
  margin-top: 15px;
}

.deploy-btn {
  margin-top: 15px;
  padding: 8px 15px;
  background-color: #2196F3;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.deploy-btn:hover {
  background-color: #0b7dda;
}
</style>
