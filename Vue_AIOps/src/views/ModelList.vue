<template>
  <div class="model-list">
    <div class="model-item" v-for="model in models" :key="model.id">
      <div class="model-info">
        <h3>{{ model.name }}</h3>
        <div class="meta">
          <span>版本: v{{ model.version }}</span>
          <span>大小: {{ model.size }}</span>
          <span>类型: {{ model.type }}</span>
        </div>
        <div class="description">{{ model.description }}</div>
      </div>
      <div class="model-actions">
        <button class="deploy-btn" @click="deployToSelected(model)" v-if="selectedNode">
          部署到选中节点
        </button>
        <button class="auto-deploy-btn" @click="autoDeploy(model)">
          自动调度部署
        </button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    models: {
      type: Array,
      required: true
    },
    selectedNode: {
      type: Object,
      default: null
    }
  },
  methods: {
    deployToSelected(model) {
      this.$emit('deploy-to-node', { model, node: this.selectedNode })
    },
    autoDeploy(model) {
      this.$emit('auto-deploy', model)
    }
  }
}
</script>

<style scoped>
.model-list {
  margin-top: 20px;
}

.model-item {
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 15px;
  margin-bottom: 15px;
  display: flex;
  justify-content: space-between;
}

.model-info {
  flex: 1;
}

.meta {
  margin: 8px 0;
  color: #666;
  font-size: 14px;
}

.meta span {
  margin-right: 15px;
}

.description {
  color: #555;
  font-size: 14px;
}

.model-actions {
  display: flex;
  flex-direction: column;
  justify-content: center;
  margin-left: 15px;
}

.model-actions button {
  padding: 8px 15px;
  margin-bottom: 10px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  white-space: nowrap;
}

.deploy-btn {
  background-color: #2196F3;
  color: white;
}

.auto-deploy-btn {
  background-color: #4CAF50;
  color: white;
}
</style>
