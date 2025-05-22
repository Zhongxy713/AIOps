<template>
  <div id="app" class="container">
    <!-- 主界面 -->
    <div v-if="currentView === 'nodes'">
      <div class="header">
        <h1><i class="icon icon-server"></i> 算法管道模型部署</h1>
        <div class="actions">
          <button class="btn btn-primary" @click="showAddNodeModal1">
            <i class="icon icon-plus"></i> 新增部署节点
          </button>
          <button class="btn btn-success" @click="switchToDeployView">
            <i class="icon icon-upload"></i> 部署算法模型
          </button>
        </div>
      </div>

      <div class="metrics-display">
        <div class="metric-card">
          <div class="metric-title"><i class="icon icon-hash"></i> 总节点数</div>
          <div class="metric-value">{{ nodes.length }}</div>
        </div>
        <div class="metric-card">
          <div class="metric-title"><i class="icon icon-zap"></i> 活跃节点</div>
          <div class="metric-value">{{ activeNodesCount }}</div>
        </div>
        <div class="metric-card">
          <div class="metric-title"><i class="icon icon-box"></i> 部署模型数</div>
          <div class="metric-value">{{ totalDeployedModels }}</div>
        </div>
        <div class="metric-card">
          <div class="metric-title"><i class="icon icon-gauge"></i> 平均负载</div>
          <div class="metric-value">{{ averageLoad.toFixed(1) }}%</div>
        </div>
      </div>

      <div class="search-filter">
        <div class="search-input-container">
          <i class="icon icon-search"></i>
          <input
              type="text"
              v-model="searchQuery"
              placeholder="搜索节点..."
              class="search-input"
          />
        </div>
        <div class="filter-options">
          <label class="filter-label">
            <input
                type="checkbox"
                v-model="showActiveOnly"
                class="filter-checkbox"
            />
            <span><i class="icon icon-power"></i> 仅显示活跃节点</span>
          </label>
        </div>
      </div>

      <div class="node-list">
        <div
            v-for="node in filteredNodes"
            :key="node.id"
            class="node-card"
            :class="{
            active: node.status === 'active',
            inactive: node.status !== 'active',
            selected: selectedNodeId === node.id,
          }"
            @click="selectNode(node.id)"
        >
          <div class="node-header">
            <h3 class="node-name">
              <i class="icon icon-server"></i> {{ node.name }}
            </h3>
            <span
                class="status-badge"
                :class="{
                'status-active': node.status === 'active',
                'status-inactive': node.status !== 'active',
              }"
            >
              <i class="icon" :class="node.status === 'active' ? 'icon-power' : 'icon-off'"></i>
              {{ node.status === "active" ? "活跃" : "离线" }}
            </span>
          </div>
          <div class="node-metrics">
            <div class="metric-row">
              <div class="metric">
                <span class="metric-label"><i class="icon icon-cpu"></i> CPU:</span>
                <div class="progress-container">
                  <div
                      class="progress-bar"
                      :style="{ width: node.metrics.cpu + '%' }"
                      :class="{
                      'progress-bar-low': node.metrics.cpu < 30,
                      'progress-bar-medium': node.metrics.cpu >= 30 && node.metrics.cpu < 70,
                      'progress-bar-high': node.metrics.cpu >= 70,
                    }"
                  ></div>
                  <span class="progress-text">{{ node.metrics.cpu }}%</span>
                </div>
              </div>
              <div class="metric">
                <span class="metric-label"><i class="icon icon-gpu"></i> GPU:</span>
                <div class="progress-container">
                  <div
                      class="progress-bar"
                      :style="{ width: node.metrics.gpu + '%' }"
                      :class="{
                      'progress-bar-low': node.metrics.gpu < 30,
                      'progress-bar-medium': node.metrics.gpu >= 30 && node.metrics.gpu < 70,
                      'progress-bar-high': node.metrics.gpu >= 70,
                    }"
                  ></div>
                  <span class="progress-text">{{ node.metrics.gpu }}%</span>
                </div>
              </div>
            </div>
            <div class="metric-row">
              <div class="metric">
                <span class="metric-label"><i class="icon icon-memory"></i> 内存:</span>
                <div class="progress-container">
                  <div
                      class="progress-bar"
                      :style="{ width: node.metrics.memory + '%' }"
                      :class="{
                      'progress-bar-low': node.metrics.memory < 30,
                      'progress-bar-medium': node.metrics.memory >= 30 && node.metrics.memory < 70,
                      'progress-bar-high': node.metrics.memory >= 70,
                    }"
                  ></div>
                  <span class="progress-text">{{ node.metrics.memory }}%</span>
                </div>
              </div>
              <div class="metric">
                <span class="metric-label"><i class="icon icon-clock"></i> 运行时间:</span>
                <span class="metric-value">{{ node.uptime }}</span>
              </div>
            </div>
            <div class="metric-row">
              <div class="metric">
                <span class="metric-label"><i class="icon icon-globe"></i> 网络I/O:</span>
                <div class="progress-container">
                  <div
                      class="progress-bar"
                      :style="{ width: node.metrics.network + '%' }"
                      :class="{
                      'progress-bar-low': node.metrics.network < 30,
                      'progress-bar-medium': node.metrics.network >= 30 && node.metrics.network < 70,
                      'progress-bar-high': node.metrics.network >= 70,
                    }"
                  ></div>
                  <span class="progress-text">{{ node.metrics.network }}%</span>
                </div>
              </div>
              <div class="metric">
                <span class="metric-label"><i class="icon icon-storage"></i> 磁盘I/O:</span>
                <div class="progress-container">
                  <div
                      class="progress-bar"
                      :style="{ width: node.metrics.disk + '%' }"
                      :class="{
                      'progress-bar-low': node.metrics.disk < 30,
                      'progress-bar-medium': node.metrics.disk >= 30 && node.metrics.disk < 70,
                      'progress-bar-high': node.metrics.disk >= 70,
                    }"
                  ></div>
                  <span class="progress-text">{{ node.metrics.disk }}%</span>
                </div>
              </div>
            </div>
          </div>
          <div class="node-footer">
            <span class="deployed-models">
              <i class="icon icon-box"></i>
              已部署模型: {{ node.deployedModels.length }}
            </span>
            <button
                class="btn btn-sm btn-info"
                @click.stop="showNodeDetails(node)"
            >
              <i class="icon icon-info"></i> 详情
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- 部署界面 -->
    <div v-else-if="currentView === 'deploy'">
      <div class="header">
        <h1><i class="icon icon-upload"></i> 算法管道模型部署</h1>
        <button class="btn btn-back" @click="switchToNodesView">
          <i class="icon icon-arrow-left"></i> 返回节点列表
        </button>
      </div>

      <div class="deploy-container">
        <div class="model-list">
          <h2>
            <i class="icon icon-box"></i> 可部署的算法管道模型
            <span class="badge">{{ availableModels.length }}</span>
          </h2>
          <div
              v-for="model in availableModels"
              :key="model.id"
              class="model-card"
              :class="{ selected: selectedModelId === model.id }"
              @click="selectModel(model.id)"
          >
            <div class="model-header">
              <h3><i class="icon icon-cube"></i> {{ model.name }}</h3>
              <span class="model-version">v{{ model.version }}</span>
            </div>
            <div class="model-body">
              <p class="model-description">{{ model.description }}</p>
              <div class="model-requirements">
                <span class="requirement">
                  <i class="icon icon-cpu"></i> CPU: {{ model.requirements.cpu }}%
                </span>
                <span class="requirement">
                  <i class="icon icon-memory"></i> 内存: {{ model.requirements.memory }}GB
                </span>
                <span class="requirement" v-if="model.requirements.gpu">
                  <i class="icon icon-gpu"></i> GPU: {{ model.requirements.gpu }}%
                </span>
              </div>
            </div>
          </div>
        </div>

        <div class="deploy-details">
          <div v-if="selectedModelId">
            <h2>
              <i class="icon icon-server"></i> 可部署节点
              <span class="badge">{{ suitableNodes.length }}</span>
            </h2>
            <div class="deploy-options">
              <button
                  class="btn btn-primary"
                  :disabled="!selectedNodeId || !selectedModelId"
                  @click="deployToSelectedNode"
              >
                <i class="icon icon-check"></i> 部署到选中节点
              </button>
              <button
                  class="btn btn-success"
                  :disabled="!selectedModelId"
                  @click="autoDeployModel"
              >
                <i class="icon icon-robot"></i> 自动调度部署
              </button>
            </div>

            <div class="node-selection-list">
              <div
                  v-for="node in suitableNodes"
                  :key="node.id"
                  class="node-selection-card"
                  :class="{ selected: selectedNodeId === node.id }"
                  @click="selectDeployNode(node.id)"
              >
                <div class="node-selection-header">
                  <h4><i class="icon icon-server"></i> {{ node.name }}</h4>
                  <span
                      class="status-badge"
                      :class="{
                      'status-active': node.status === 'active',
                      'status-inactive': node.status !== 'active',
                    }"
                  >
                    <i class="icon" :class="node.status === 'active' ? 'icon-power' : 'icon-off'"></i>
                    {{ node.status === "active" ? "活跃" : "离线" }}
                  </span>
                </div>
                <div class="node-selection-metrics">
                  <div class="metric">
                    <span class="metric-label"><i class="icon icon-cpu"></i> CPU:</span>
                    <span class="metric-value">{{ node.metrics.cpu }}%</span>
                  </div>
                  <div class="metric">
                    <span class="metric-label"><i class="icon icon-memory"></i> 内存:</span>
                    <span class="metric-value">{{ node.metrics.memory }}%</span>
                  </div>
                  <div class="metric" v-if="selectedModel.requirements.gpu">
                    <span class="metric-label"><i class="icon icon-gpu"></i> GPU:</span>
                    <span class="metric-value">{{ node.metrics.gpu }}%</span>
                  </div>
                </div>
                <div class="node-selection-score">
                  <span class="score-label"><i class="icon icon-star"></i> AEW-KCSS评分:</span>
                  <span
                      class="score-value"
                      :class="{
                      'score-high': calculateNodeScore(node) >= 80,
                      'score-medium':
                        calculateNodeScore(node) >= 50 &&
                        calculateNodeScore(node) < 80,
                      'score-low': calculateNodeScore(node) < 50,
                    }"
                  >
                    {{ calculateNodeScore(node) }}/100
                  </span>
                </div>
              </div>
            </div>
          </div>
          <div v-else class="empty-selection">
            <i class="icon icon-hand-pointer"></i>
            <p>请从左侧选择一个算法管道模型</p>
          </div>
        </div>
      </div>
    </div>

    <!-- 节点详情模态框 -->
    <div v-if="showDetailsModal" class="modal-overlay">
      <div class="modal">
        <div class="modal-header">
          <h3>
            <i class="icon icon-server"></i> {{ selectedNodeDetails.name }} - 详情
          </h3>
          <button class="modal-close" @click="closeDetailsModal">
            <i class="icon icon-x"></i>
          </button>
        </div>
        <div class="modal-body">
          <div class="node-detail-section">
            <h4><i class="icon icon-info"></i> 基本信息</h4>
            <div class="detail-row">
              <span class="detail-label">状态:</span>
              <span
                  class="detail-value"
                  :class="{
                  'text-success': selectedNodeDetails.status === 'active',
                  'text-danger': selectedNodeDetails.status !== 'active',
                }"
              >
                <i class="icon" :class="selectedNodeDetails.status === 'active' ? 'icon-power' : 'icon-off'"></i>
                {{ selectedNodeDetails.status === "active" ? "活跃" : "离线" }}
              </span>
            </div>
            <div class="detail-row">
              <span class="detail-label">IP地址:</span>
              <span class="detail-value"><i class="icon icon-globe"></i> {{ selectedNodeDetails.ip }}</span>
            </div>
            <div class="detail-row">
              <span class="detail-label">运行时间:</span>
              <span class="detail-value"><i class="icon icon-clock"></i> {{ selectedNodeDetails.uptime }}</span>
            </div>
            <div class="detail-row">
              <span class="detail-label">最后活跃:</span>
              <span class="detail-value"><i class="icon icon-time"></i> {{ selectedNodeDetails.lastActive }}</span>
            </div>
          </div>

          <div class="node-detail-section">
            <h4><i class="icon icon-gauge"></i> 资源指标</h4>
            <div class="metrics-chart">
              <div class="chart-row">
                <span class="chart-label"><i class="icon icon-cpu"></i> CPU:</span>
                <div class="chart-bar-container">
                  <div
                      class="chart-bar"
                      :style="{ width: selectedNodeDetails.metrics.cpu + '%' }"
                      :class="{
                      'chart-bar-low': selectedNodeDetails.metrics.cpu < 30,
                      'chart-bar-medium': selectedNodeDetails.metrics.cpu >= 30 && selectedNodeDetails.metrics.cpu < 70,
                      'chart-bar-high': selectedNodeDetails.metrics.cpu >= 70,
                    }"
                  ></div>
                  <span class="chart-value">{{ selectedNodeDetails.metrics.cpu }}%</span>
                </div>
              </div>
              <div class="chart-row">
                <span class="chart-label"><i class="icon icon-gpu"></i> GPU:</span>
                <div class="chart-bar-container">
                  <div
                      class="chart-bar"
                      :style="{ width: selectedNodeDetails.metrics.gpu + '%' }"
                      :class="{
                      'chart-bar-low': selectedNodeDetails.metrics.gpu < 30,
                      'chart-bar-medium': selectedNodeDetails.metrics.gpu >= 30 && selectedNodeDetails.metrics.gpu < 70,
                      'chart-bar-high': selectedNodeDetails.metrics.gpu >= 70,
                    }"
                  ></div>
                  <span class="chart-value">{{ selectedNodeDetails.metrics.gpu }}%</span>
                </div>
              </div>
              <div class="chart-row">
                <span class="chart-label"><i class="icon icon-memory"></i> 内存:</span>
                <div class="chart-bar-container">
                  <div
                      class="chart-bar"
                      :style="{ width: selectedNodeDetails.metrics.memory + '%' }"
                      :class="{
                      'chart-bar-low': selectedNodeDetails.metrics.memory < 30,
                      'chart-bar-medium': selectedNodeDetails.metrics.memory >= 30 && selectedNodeDetails.metrics.memory < 70,
                      'chart-bar-high': selectedNodeDetails.metrics.memory >= 70,
                    }"
                  ></div>
                  <span class="chart-value">{{ selectedNodeDetails.metrics.memory }}%</span>
                </div>
              </div>
              <div class="chart-row">
                <span class="chart-label"><i class="icon icon-globe"></i> 网络I/O:</span>
                <div class="chart-bar-container">
                  <div
                      class="chart-bar"
                      :style="{ width: selectedNodeDetails.metrics.network + '%' }"
                      :class="{
                      'chart-bar-low': selectedNodeDetails.metrics.network < 30,
                      'chart-bar-medium': selectedNodeDetails.metrics.network >= 30 && selectedNodeDetails.metrics.network < 70,
                      'chart-bar-high': selectedNodeDetails.metrics.network >= 70,
                    }"
                  ></div>
                  <span class="chart-value">{{ selectedNodeDetails.metrics.network }}%</span>
                </div>
              </div>
              <div class="chart-row">
                <span class="chart-label"><i class="icon icon-storage"></i> 磁盘I/O:</span>
                <div class="chart-bar-container">
                  <div
                      class="chart-bar"
                      :style="{ width: selectedNodeDetails.metrics.disk + '%' }"
                      :class="{
                      'chart-bar-low': selectedNodeDetails.metrics.disk < 30,
                      'chart-bar-medium': selectedNodeDetails.metrics.disk >= 30 && selectedNodeDetails.metrics.disk < 70,
                      'chart-bar-high': selectedNodeDetails.metrics.disk >= 70,
                    }"
                  ></div>
                  <span class="chart-value">{{ selectedNodeDetails.metrics.disk }}%</span>
                </div>
              </div>
            </div>
          </div>

          <div class="node-detail-section">
            <h4><i class="icon icon-box"></i> 已部署模型</h4>
            <div
                v-if="selectedNodeDetails.deployedModels.length > 0"
                class="deployed-models-list"
            >
              <div
                  v-for="model in selectedNodeDetails.deployedModels"
                  :key="model.id"
                  class="deployed-model-item"
              >
                <div class="model-info">
                  <h5><i class="icon icon-cube"></i> {{ model.name }}</h5>
                  <span class="model-version">v{{ model.version }}</span>
                </div>
                <div class="model-meta">
                  <span class="deploy-time">
                    <i class="icon icon-clock"></i> 部署时间: {{ model.deployedAt }}
                  </span>
                  <span class="model-status">
                    <i
                        class="icon"
                        :class="{
                        'icon-check-circle text-success': model.status === 'running',
                        'icon-hourglass text-warning': model.status === 'pending',
                        'icon-x-circle text-danger': model.status === 'stopped',
                      }"
                    ></i>
                    {{ model.status === "running" ? "运行中" : model.status === "pending" ? "待启动" : "已停止" }}
                  </span>
                </div>
              </div>
            </div>
            <div v-else class="no-models">
              <i class="icon icon-box-open"></i>
              <p>该节点上未部署任何模型</p>
            </div>
          </div>

          <div class="node-detail-section">
            <h4><i class="icon icon-history"></i> 调度记录</h4>
            <div class="scheduling-history">
              <table class="history-table">
                <thead>
                <tr>
                  <td><i class="icon icon-clock"></i> 时间</td>
                  <td><i class="icon icon-activity"></i> 操作</td>
                  <td><i class="icon icon-box"></i> 模型</td>
                  <td><i class="icon icon-star"></i> AEW-KCSS评分</td>
                  <td><i class="icon icon-check"></i> 结果</td>
                </tr>
                </thead>
                <tbody>
                <tr v-for="(record, index) in schedulingHistory" :key="index">
                  <td>{{ record.time }}</td>
                  <td>{{ record.action }}</td>
                  <td>{{ record.model }}</td>
                  <td>
                      <span
                          :class="{
                          'text-success': record.score >= 80,
                          'text-warning': record.score >= 50 && record.score < 80,
                          'text-danger': record.score < 50,
                        }"
                      >
                        {{ record.score }}
                      </span>
                  </td>
                  <td>
                      <span
                          :class="{
                          'text-success': record.success,
                          'text-danger': !record.success,
                        }"
                      >
                        <i class="icon" :class="record.success ? 'icon-check' : 'icon-x'"></i>
                        {{ record.success ? "成功" : "失败" }}
                      </span>
                  </td>
                </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn btn-danger" @click="removeNode(selectedNodeDetails.id)">
            <i class="icon icon-trash"></i> 移除节点
          </button>
          <button class="btn btn-secondary" @click="closeDetailsModal">
            关闭
          </button>
        </div>
      </div>
    </div>

    <!-- 添加节点模态框 -->
    <div v-if="showAddNodeModal" class="modal-overlay">
      <div class="modal">
        <div class="modal-header">
          <h3><i class="icon icon-plus"></i> 添加新节点</h3>
          <button class="modal-close" @click="closeAddNodeModal">
            <i class="icon icon-x"></i>
          </button>
        </div>
        <div class="modal-body">
          <form @submit.prevent="addNewNode">
            <div class="form-group">
              <label for="nodeName"><i class="icon icon-server"></i> 节点名称</label>
              <input
                  type="text"
                  id="nodeName"
                  v-model="newNode.name"
                  class="form-control"
                  required
              />
            </div>
            <div class="form-group">
              <label for="nodeIp"><i class="icon icon-globe"></i> IP地址</label>
              <input
                  type="text"
                  id="nodeIp"
                  v-model="newNode.ip"
                  class="form-control"
                  required
                  placeholder="例如: 192.168.1.100"
              />
            </div>
            <div class="form-group">
              <label for="nodeStatus"><i class="icon icon-power"></i> 状态</label>
              <select
                  id="nodeStatus"
                  v-model="newNode.status"
                  class="form-control"
                  required
              >
                <option value="active">活跃</option>
                <option value="inactive">离线</option>
              </select>
            </div>
            <div class="form-row">
              <div class="form-group col-md-6">
                <label for="nodeCpu"><i class="icon icon-cpu"></i> CPU使用率 (%)</label>
                <input
                    type="number"
                    id="nodeCpu"
                    v-model="newNode.metrics.cpu"
                    min="0"
                    max="100"
                    class="form-control"
                    required
                />
              </div>
              <div class="form-group col-md-6">
                <label for="nodeGpu"><i class="icon icon-gpu"></i> GPU使用率 (%)</label>
                <input
                    type="number"
                    id="nodeGpu"
                    v-model="newNode.metrics.gpu"
                    min="0"
                    max="100"
                    class="form-control"
                    required
                />
              </div>
            </div>
            <div class="form-row">
              <div class="form-group col-md-6">
                <label for="nodeMemory"><i class="icon icon-memory"></i> 内存使用率 (%)</label>
                <input
                    type="number"
                    id="nodeMemory"
                    v-model="newNode.metrics.memory"
                    min="0"
                    max="100"
                    class="form-control"
                    required
                />
              </div>
              <div class="form-group col-md-6">
                <label for="nodeNetwork"><i class="icon icon-globe"></i> 网络I/O (%)</label>
                <input
                    type="number"
                    id="nodeNetwork"
                    v-model="newNode.metrics.network"
                    min="0"
                    max="100"
                    class="form-control"
                    required
                />
              </div>
            </div>
            <div class="form-group">
              <label for="nodeDisk"><i class="icon icon-storage"></i> 磁盘I/O (%)</label>
              <input
                  type="number"
                  id="nodeDisk"
                  v-model="newNode.metrics.disk"
                  min="0"
                  max="100"
                  class="form-control"
                  required
              />
            </div>
            <div class="form-group">
              <label for="nodeUptime"><i class="icon icon-clock"></i> 运行时间</label>
              <input
                  type="text"
                  id="nodeUptime"
                  v-model="newNode.uptime"
                  class="form-control"
                  required
                  placeholder="例如: 3天5小时"
              />
            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button class="btn btn-primary" @click="addNewNode">
            <i class="icon icon-save"></i> 保存
          </button>
          <button class="btn btn-secondary" @click="closeAddNodeModal">
            取消
          </button>
        </div>
      </div>
    </div>

    <!-- 部署成功模态框 -->
    <div v-if="showDeploySuccessModal" class="modal-overlay">
      <div class="modal success-modal">
        <div class="modal-body">
          <div class="success-icon">
            <i class="icon icon-check-circle"></i>
          </div>
          <h3>部署成功!</h3>
          <p>
            模型 <strong>{{ deployedModelName }}</strong> 已成功部署到节点
            <strong>{{ deployedNodeName }}</strong>
          </p>
          <div class="deploy-details">
            <div class="detail-row">
              <span class="detail-label"><i class="icon icon-star"></i> AEW-KCSS评分:</span>
              <span class="detail-value">{{ deployScore }}/100</span>
            </div>
            <div class="detail-row">
              <span class="detail-label"><i class="icon icon-clock"></i> 调度时间:</span>
              <span class="detail-value">{{ new Date().toLocaleString() }}</span>
            </div>
          </div>
          <button
              class="btn btn-success"
              @click="showDeploySuccessModal = false"
          >
            确定
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "AlgorithmPipelineDeploymentSystem",
  data() {
    return {
      currentView: "nodes", // 'nodes' 或 'deploy'
      searchQuery: "",
      showActiveOnly: false,
      selectedNodeId: null,
      selectedModelId: null,
      selectedDeployNodeId: null,
      showDetailsModal: false,
      showAddNodeModal: false,
      showDeploySuccessModal: false,
      deployedModelName: "",
      deployedNodeName: "",
      deployScore: 0,
      newNode: {
        id: null,
        name: "",
        ip: "",
        status: "active",
        uptime: "0天0小时",
        lastActive: new Date().toLocaleString(),
        metrics: {
          cpu: 0,
          gpu: 0,
          memory: 0,
          network: 0,
          disk: 0,
        },
        deployedModels: [],
      },
      nodes: [
        {
          id: 1,
          name: "AI计算节点-01",
          ip: "192.168.1.101",
          status: "active",
          uptime: "5天12小时",
          lastActive: new Date().toLocaleString(),
          metrics: {
            cpu: 45,
            gpu: 30,
            memory: 60,
            network: 25,
            disk: 15,
          },
          deployedModels: [
            {
              id: 101,
              name: "图像识别模型",
              version: "2.1.3",
              deployedAt: "2023-05-15 09:30",
              status: "running",
            },
            {
              id: 102,
              name: "自然语言处理模型",
              version: "1.4.2",
              deployedAt: "2023-05-18 14:15",
              status: "running",
            },
          ],
        },
        {
          id: 2,
          name: "GPU集群节点-02",
          ip: "192.168.1.102",
          status: "active",
          uptime: "12天3小时",
          lastActive: new Date().toLocaleString(),
          metrics: {
            cpu: 70,
            gpu: 85,
            memory: 75,
            network: 40,
            disk: 20,
          },
          deployedModels: [
            {
              id: 103,
              name: "深度学习推荐系统",
              version: "3.0.1",
              deployedAt: "2023-05-10 11:20",
              status: "running",
            },
          ],
        },
        {
          id: 3,
          name: "边缘计算节点-03",
          ip: "192.168.1.103",
          status: "inactive",
          uptime: "1天8小时",
          lastActive: "2023-05-20 16:45",
          metrics: {
            cpu: 10,
            gpu: 0,
            memory: 25,
            network: 5,
            disk: 10,
          },
          deployedModels: [],
        },
        {
          id: 4,
          name: "高性能计算节点-04",
          ip: "192.168.1.104",
          status: "active",
          uptime: "8天0小时",
          lastActive: new Date().toLocaleString(),
          metrics: {
            cpu: 30,
            gpu: 15,
            memory: 40,
            network: 15,
            disk: 5,
          },
          deployedModels: [
            {
              id: 104,
              name: "时间序列预测模型",
              version: "1.2.0",
              deployedAt: "2023-05-17 10:10",
              status: "running",
            },
            {
              id: 105,
              name: "异常检测模型",
              version: "2.3.1",
              deployedAt: "2023-05-19 13:45",
              status: "pending",
            },
          ],
        },
        {
          id: 5,
          name: "云端推理节点-05",
          ip: "192.168.1.105",
          status: "active",
          uptime: "15天20小时",
          lastActive: new Date().toLocaleString(),
          metrics: {
            cpu: 55,
            gpu: 65,
            memory: 70,
            network: 35,
            disk: 25,
          },
          deployedModels: [
            {
              id: 106,
              name: "语音识别模型",
              version: "4.2.0",
              deployedAt: "2023-05-12 08:30",
              status: "running",
            },
            {
              id: 107,
              name: "机器翻译模型",
              version: "3.5.2",
              deployedAt: "2023-05-14 16:20",
              status: "running",
            },
            {
              id: 108,
              name: "文本分类模型",
              version: "2.0.1",
              deployedAt: "2023-05-16 11:15",
              status: "stopped",
            },
          ],
        },
      ],
      availableModels: [
        {
          id: 201,
          name: "人脸识别模型",
          version: "1.5.3",
          description: "高性能人脸识别算法，支持实时检测和识别",
          requirements: {
            cpu: 30,
            gpu: 40,
            memory: 8,
          },
        },
        {
          id: 202,
          name: "目标检测模型",
          version: "2.2.1",
          description: "YOLOv5实现的多目标检测算法",
          requirements: {
            cpu: 40,
            gpu: 60,
            memory: 12,
          },
        },
        {
          id: 203,
          name: "情感分析模型",
          version: "1.0.2",
          description: "基于BERT的文本情感分析模型",
          requirements: {
            cpu: 20,
            memory: 4,
          },
        },
        {
          id: 204,
          name: "推荐系统模型",
          version: "3.1.0",
          description: "基于深度学习的个性化推荐系统",
          requirements: {
            cpu: 50,
            memory: 16,
          },
        },
        {
          id: 205,
          name: "图像生成模型",
          version: "1.8.4",
          description: "GAN实现的图像生成模型",
          requirements: {
            cpu: 25,
            gpu: 80,
            memory: 10,
          },
        },
      ],
      schedulingHistory: [
        {
          time: "2023-05-20 10:30",
          action: "部署",
          model: "图像识别模型",
          score: 85,
          success: true,
        },
        {
          time: "2023-05-19 14:15",
          action: "自动调度",
          model: "自然语言处理模型",
          score: 78,
          success: true,
        },
        {
          time: "2023-05-18 09:45",
          action: "部署",
          model: "深度学习推荐系统",
          score: 65,
          success: true,
        },
        {
          time: "2023-05-17 16:20",
          action: "自动调度",
          model: "时间序列预测模型",
          score: 72,
          success: true,
        },
        {
          time: "2023-05-16 11:10",
          action: "部署",
          model: "异常检测模型",
          score: 58,
          success: false,
        },
      ],
    };
  },
  computed: {
    filteredNodes() {
      let filtered = this.nodes;
      if (this.searchQuery) {
        const query = this.searchQuery.toLowerCase();
        filtered = filtered.filter((node) =>
            node.name.toLowerCase().includes(query)
        );
      }
      if (this.showActiveOnly) {
        filtered = filtered.filter((node) => node.status === "active");
      }
      return filtered;
    },
    activeNodesCount() {
      return this.nodes.filter((node) => node.status === "active").length;
    },
    totalDeployedModels() {
      return this.nodes.reduce(
          (total, node) => total + node.deployedModels.length,
          0
      );
    },
    averageLoad() {
      if (this.nodes.length === 0) return 0;
      const total = this.nodes.reduce(
          (sum, node) =>
              sum +
              (node.metrics.cpu +
                  node.metrics.gpu +
                  node.metrics.memory +
                  node.metrics.network +
                  node.metrics.disk) /
              5,
          0
      );
      return total / this.nodes.length;
    },
    selectedNodeDetails() {
      return this.nodes.find((node) => node.id === this.selectedNodeId) || {};
    },
    selectedModel() {
      return (
          this.availableModels.find((model) => model.id === this.selectedModelId) ||
          {}
      );
    },
    suitableNodes() {
      if (!this.selectedModelId) return [];

      return this.nodes.filter((node) => {
        // 检查节点是否满足模型的基本要求
        const hasGpu = this.selectedModel.requirements.gpu !== undefined;
        const gpuAvailable = hasGpu ? node.metrics.gpu + this.selectedModel.requirements.gpu <= 100 : true;

        return (
            node.status === "active" &&
            node.metrics.cpu + this.selectedModel.requirements.cpu <= 100 &&
            node.metrics.memory + (this.selectedModel.requirements.memory / 16) * 100 <= 100 &&
            gpuAvailable
        );
      });
    },
  },
  methods: {
    selectNode(nodeId) {
      this.selectedNodeId = nodeId;
    },
    selectModel(modelId) {
      this.selectedModelId = modelId;
      this.selectedDeployNodeId = null;
    },
    selectDeployNode(nodeId) {
      this.selectedDeployNodeId = nodeId;
    },
    showNodeDetails(node) {
      this.selectedNodeId = node.id;
      this.showDetailsModal = true;
    },
    closeDetailsModal() {
      this.showDetailsModal = false;
    },
    showAddNodeModal1() {
      // 生成新ID
      const maxId = Math.max(...this.nodes.map((node) => node.id), 0);
      this.newNode.id = maxId + 1;
      this.showAddNodeModal = true;
    },
    closeAddNodeModal() {
      this.showAddNodeModal = false;
      this.resetNewNode();
    },
    resetNewNode() {
      this.newNode = {
        id: null,
        name: "",
        ip: "",
        status: "active",
        uptime: "0天0小时",
        lastActive: new Date().toLocaleString(),
        metrics: {
          cpu: 0,
          gpu: 0,
          memory: 0,
          network: 0,
          disk: 0,
        },
        deployedModels: [],
      };
    },
    addNewNode() {
      this.nodes.push({ ...this.newNode });
      this.closeAddNodeModal();
    },
    removeNode(nodeId) {
      this.nodes = this.nodes.filter((node) => node.id !== nodeId);
      this.closeDetailsModal();
      this.selectedNodeId = null;
    },
    switchToDeployView() {
      this.currentView = "deploy";
      this.selectedModelId = null;
      this.selectedDeployNodeId = null;
    },
    switchToNodesView() {
      this.currentView = "nodes";
    },
    deployToSelectedNode() {
      if (!this.selectedModelId || !this.selectedDeployNodeId) return;

      const model = this.availableModels.find(
          (m) => m.id === this.selectedModelId
      );
      const node = this.nodes.find((n) => n.id === this.selectedDeployNodeId);

      if (!model || !node) return;

      // 计算AEW-KCSS评分
      const score = this.calculateNodeScore(node);

      // 添加到节点的部署模型列表
      node.deployedModels.push({
        id: model.id + 1000, // 生成唯一ID
        name: model.name,
        version: model.version,
        deployedAt: new Date().toLocaleString(),
        status: "running",
      });

      // 更新节点资源指标
      node.metrics.cpu += model.requirements.cpu;
      node.metrics.memory += (model.requirements.memory / 16) * 100;
      if (model.requirements.gpu) {
        node.metrics.gpu += model.requirements.gpu;
      }

      // 添加调度记录
      this.schedulingHistory.unshift({
        time: new Date().toLocaleString(),
        action: "部署",
        model: model.name,
        score: score,
        success: true,
      });

      // 显示成功消息
      this.deployedModelName = model.name;
      this.deployedNodeName = node.name;
      this.deployScore = score;
      this.showDeploySuccessModal = true;

      // 重置选择
      this.selectedModelId = null;
      this.selectedDeployNodeId = null;
    },
    autoDeployModel() {
      if (!this.selectedModelId) return;

      // 如果没有合适的节点，显示错误
      if (this.suitableNodes.length === 0) {
        alert("没有找到合适的节点来部署此模型");
        return;
      }

      // 根据AEW-KCSS评分选择最佳节点
      let bestNode = null;
      let bestScore = -1;

      this.suitableNodes.forEach((node) => {
        const score = this.calculateNodeScore(node);
        if (score > bestScore) {
          bestScore = score;
          bestNode = node;
        }
      });

      if (bestNode) {
        this.selectedDeployNodeId = bestNode.id;
        this.deployToSelectedNode();
      }
    },
    calculateNodeScore(node) {
      // AEW-KCSS算法实现
      // 这里我们模拟一个基于节点资源和模型需求的评分算法
      const model = this.selectedModel;

      // 计算资源余量分数 (0-100)
      const cpuScore = 100 - node.metrics.cpu;
      const memoryScore = 100 - node.metrics.memory;
      const gpuScore = model.requirements.gpu ? 100 - node.metrics.gpu : 100;

      // 计算均衡分数 (资源使用越均衡，分数越高)
      const balanceScore =
          100 -
          Math.sqrt(
              Math.pow(node.metrics.cpu - node.metrics.memory, 2) +
              (model.requirements.gpu
                  ? Math.pow(node.metrics.cpu - node.metrics.gpu, 2)
                  : 0)
          ) / 2;

      // 计算网络和磁盘分数
      const networkScore = 100 - node.metrics.network;
      const diskScore = 100 - node.metrics.disk;

      // 综合评分 (加权平均)
      const totalScore =
          cpuScore * 0.25 +
          memoryScore * 0.2 +
          gpuScore * (model.requirements.gpu ? 0.25 : 0) +
          balanceScore * 0.15 +
          networkScore * 0.1 +
          diskScore * 0.05;

      // 确保分数在0-100之间
      return Math.max(0, Math.min(100, Math.round(totalScore)));
    },
  },
};
</script>

<style>
/* 基础样式 */
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

body {
  font-family: 'Segoe UI', 'PingFang SC', 'Microsoft YaHei', sans-serif;
  line-height: 1.6;
  color: #333;
  background-color: #f5f7fa;
}

.container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 20px;
}

/* 图标样式 */
.icon {
  display: inline-block;
  margin-right: 6px;
  font-style: normal;
}

.icon-server:before { content: "🖥️"; }
.icon-plus:before { content: "➕"; }
.icon-upload:before { content: "⬆️"; }
.icon-arrow-left:before { content: "⬅️"; }
.icon-refresh:before { content: "🔄"; }
.icon-power:before { content: "🔌"; }
.icon-off:before { content: "🔋"; }
.icon-box:before { content: "📦"; }
.icon-clock:before { content: "⏱️"; }
.icon-cpu:before { content: "💻"; }
.icon-gpu:before { content: "🎮"; }
.icon-memory:before { content: "🧠"; }
.icon-storage:before { content: "💾"; }
.icon-globe:before { content: "🌐"; }
.icon-tag:before { content: "🏷️"; }
.icon-zap:before { content: "⚡"; }
.icon-info:before { content: "ℹ️"; }
.icon-file-text:before { content: "📄"; }
.icon-hash:before { content: "#"; }
.icon-check:before { content: "✓"; }
.icon-alert:before { content: "⚠️"; }
.icon-x:before { content: "✖️"; }
.icon-chevron-down:before { content: "⌄"; }
.icon-search:before { content: "🔍"; }
.icon-gauge:before { content: "📊"; }
.icon-cube:before { content: "🧊"; }
.icon-robot:before { content: "🤖"; }
.icon-star:before { content: "⭐"; }
.icon-hand-pointer:before { content: "👉"; }
.icon-box-open:before { content: "📦"; }
.icon-check-circle:before { content: "✅"; }
.icon-hourglass:before { content: "⏳"; }
.icon-x-circle:before { content: "❌"; }
.icon-save:before { content: "💾"; }
.icon-trash:before { content: "🗑️"; }
.icon-history:before { content: "🕰️"; }
.icon-activity:before { content: "📈"; }
.icon-time:before { content: "⏰"; }

/* 按钮样式 */
.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 8px 16px;
  border: none;
  border-radius: 6px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.btn i {
  margin-right: 6px;
}

.btn-primary {
  background-color: #4a6bdf;
  color: white;
}

.btn-primary:hover {
  background-color: #3a56c4;
  box-shadow: 0 4px 8px rgba(74, 107, 223, 0.3);
}

.btn-success {
  background-color: #2ecc71;
  color: white;
}

.btn-success:hover {
  background-color: #27ae60;
  box-shadow: 0 4px 8px rgba(46, 204, 113, 0.3);
}

.btn-info {
  background-color: #17a2b8;
  color: white;
}

.btn-info:hover {
  background-color: #138496;
  box-shadow: 0 4px 8px rgba(23, 162, 184, 0.3);
}

.btn-danger {
  background-color: #e74c3c;
  color: white;
}

.btn-danger:hover {
  background-color: #c0392b;
  box-shadow: 0 4px 8px rgba(231, 76, 60, 0.3);
}

.btn-secondary {
  background-color: #95a5a6;
  color: white;
}

.btn-secondary:hover {
  background-color: #7f8c8d;
  box-shadow: 0 4px 8px rgba(149, 165, 166, 0.3);
}

.btn-back {
  background-color: transparent;
  color: #4a6bdf;
  border: 1px solid #4a6bdf;
}

.btn-back:hover {
  background-color: #f0f8ff;
}

.btn-sm {
  padding: 5px 10px;
  font-size: 12px;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
}

/* 头部样式 */
.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding-bottom: 15px;
  border-bottom: 1px solid #e0e0e0;
}

.header h1 {
  font-size: 24px;
  color: #2c3e50;
  display: flex;
  align-items: center;
}

.actions {
  display: flex;
  gap: 10px;
}

/* 指标卡片样式 */
.metrics-display {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 15px;
  margin-bottom: 20px;
}

.metric-card {
  background-color: white;
  border-radius: 10px;
  padding: 15px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
  text-align: center;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.metric-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
}

.metric-title {
  font-size: 14px;
  color: #7f8c8d;
  margin-bottom: 5px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.metric-value {
  font-size: 24px;
  font-weight: bold;
  color: #2c3e50;
}

/* 搜索和筛选样式 */
.search-filter {
  display: flex;
  justify-content: space-between;
  margin-bottom: 20px;
  align-items: center;
}

.search-input-container {
  position: relative;
  width: 300px;
}

.search-input {
  padding: 10px 15px 10px 35px;
  border: 1px solid #ddd;
  border-radius: 6px;
  width: 100%;
  font-size: 14px;
  transition: all 0.3s ease;
}

.search-input:focus {
  outline: none;
  border-color: #4a6bdf;
  box-shadow: 0 0 0 2px rgba(74, 107, 223, 0.2);
}

.search-input-container .icon {
  position: absolute;
  left: 10px;
  top: 50%;
  transform: translateY(-50%);
  color: #95a5a6;
}

.filter-options {
  display: flex;
  align-items: center;
  gap: 10px;
}

.filter-label {
  display: flex;
  align-items: center;
  cursor: pointer;
  font-size: 14px;
}

.filter-checkbox {
  margin-right: 5px;
}

/* 节点卡片样式 */
.node-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
  gap: 20px;
}

.node-card {
  background-color: white;
  border-radius: 10px;
  overflow: hidden;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.node-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 15px rgba(0, 0, 0, 0.1);
}

.node-card.selected {
  border: 2px solid #4a6bdf;
}

.node-card.active {
  border-left: 4px solid #2ecc71;
}

.node-card.inactive {
  border-left: 4px solid #e74c3c;
}

.node-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px;
  background-color: #f8f9fa;
  border-bottom: 1px solid #eee;
}

.node-name {
  font-size: 18px;
  color: #2c3e50;
  margin: 0;
  display: flex;
  align-items: center;
}

.status-badge {
  padding: 4px 10px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: bold;
  display: flex;
  align-items: center;
}

.status-active {
  background-color: #e8f5e9;
  color: #27ae60;
}

.status-inactive {
  background-color: #fdecea;
  color: #e74c3c;
}

.node-metrics {
  padding: 15px;
}

.metric-row {
  display: flex;
  margin-bottom: 12px;
}

.metric-row:last-child {
  margin-bottom: 0;
}

.metric {
  flex: 1;
  margin-right: 10px;
}

.metric:last-child {
  margin-right: 0;
}

.metric-label {
  display: block;
  font-size: 12px;
  color: #7f8c8d;
  margin-bottom: 4px;
  display: flex;
  align-items: center;
}

.metric-value {
  font-size: 14px;
  font-weight: 500;
}

.progress-container {
  position: relative;
  height: 20px;
  background-color: #ecf0f1;
  border-radius: 10px;
  overflow: hidden;
}

.progress-bar {
  height: 100%;
  border-radius: 10px;
  transition: width 0.5s ease;
}

.progress-bar-low {
  background: linear-gradient(to right, #4CAF50, #8BC34A);
}

.progress-bar-medium {
  background: linear-gradient(to right, #FFC107, #FF9800);
}

.progress-bar-high {
  background: linear-gradient(to right, #F44336, #E91E63);
}

.progress-text {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  font-size: 10px;
  font-weight: bold;
  color: white;
  text-shadow: 0 0 2px rgba(0, 0, 0, 0.5);
}

.node-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 15px;
  background-color: #f8f9fa;
  border-top: 1px solid #eee;
}

.deployed-models {
  font-size: 13px;
  color: #7f8c8d;
  display: flex;
  align-items: center;
}

/* 部署界面样式 */
.deploy-container {
  display: flex;
  gap: 20px;
}

.model-list {
  flex: 1;
  max-width: 400px;
}

.model-list h2 {
  font-size: 18px;
  margin-bottom: 15px;
  color: #2c3e50;
  display: flex;
  align-items: center;
}

.model-list h2 .badge {
  margin-left: 8px;
  background-color: #4a6bdf;
  color: white;
  padding: 2px 8px;
  border-radius: 10px;
  font-size: 14px;
}

.deploy-details {
  flex: 2;
}

.model-card {
  background-color: white;
  border-radius: 8px;
  padding: 15px;
  margin-bottom: 15px;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: all 0.3s ease;
}

.model-card:hover {
  transform: translateX(5px);
  box-shadow: 0 5px 10px rgba(0, 0, 0, 0.1);
}

.model-card.selected {
  border-left: 4px solid #4a6bdf;
  background-color: #f5f8ff;
}

.model-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.model-header h3 {
  font-size: 16px;
  color: #2c3e50;
  margin: 0;
  display: flex;
  align-items: center;
}

.model-version {
  font-size: 12px;
  background-color: #ecf0f1;
  padding: 2px 6px;
  border-radius: 10px;
  color: #7f8c8d;
}

.model-body {
  font-size: 13px;
  color: #7f8c8d;
}

.model-description {
  margin-bottom: 10px;
  line-height: 1.5;
}

.model-requirements {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.requirement {
  font-size: 12px;
  background-color: #e8f4fc;
  padding: 3px 8px;
  border-radius: 12px;
  color: #4a6bdf;
  display: flex;
  align-items: center;
}

.deploy-options {
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
}

.node-selection-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 15px;
}

.node-selection-card {
  background-color: white;
  border-radius: 8px;
  padding: 15px;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: all 0.3s ease;
}

.node-selection-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 5px 10px rgba(0, 0, 0, 0.1);
}

.node-selection-card.selected {
  border: 2px solid #4a6bdf;
  background-color: #f5f8ff;
}

.node-selection-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.node-selection-header h4 {
  font-size: 15px;
  margin: 0;
  color: #2c3e50;
  display: flex;
  align-items: center;
}

.node-selection-metrics {
  display: flex;
  gap: 15px;
  margin-bottom: 10px;
}

.node-selection-metrics .metric {
  margin-right: 0;
}

.node-selection-score {
  margin-top: 10px;
  padding-top: 10px;
  border-top: 1px dashed #eee;
}

.score-label {
  font-size: 12px;
  color: #7f8c8d;
  display: flex;
  align-items: center;
}

.score-value {
  font-weight: bold;
  margin-left: 5px;
}

.score-high {
  color: #27ae60;
}

.score-medium {
  color: #f39c12;
}

.score-low {
  color: #e74c3c;
}

.empty-selection {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 300px;
  color: #95a5a6;
  text-align: center;
}

.empty-selection .icon {
  font-size: 48px;
  margin-bottom: 15px;
}

.empty-selection p {
  font-size: 16px;
}

/* 模态框样式 */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  backdrop-filter: blur(3px);
}

.modal {
  background-color: white;
  border-radius: 10px;
  width: 90%;
  max-width: 800px;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
  animation: modalFadeIn 0.3s ease;
}

@keyframes modalFadeIn {
  from {
    opacity: 0;
    transform: translateY(-20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 20px;
  border-bottom: 1px solid #eee;
  position: sticky;
  top: 0;
  background-color: white;
  z-index: 10;
}

.modal-header h3 {
  margin: 0;
  font-size: 18px;
  color: #2c3e50;
  display: flex;
  align-items: center;
}

.modal-close {
  background: none;
  border: none;
  font-size: 20px;
  color: #95a5a6;
  cursor: pointer;
  transition: color 0.3s ease;
}

.modal-close:hover {
  color: #e74c3c;
}

.modal-body {
  padding: 20px;
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  padding: 15px 20px;
  border-top: 1px solid #eee;
  gap: 10px;
  position: sticky;
  bottom: 0;
  background-color: white;
}

.node-detail-section {
  margin-bottom: 25px;
}

.node-detail-section h4 {
  font-size: 16px;
  color: #2c3e50;
  margin-bottom: 15px;
  padding-bottom: 5px;
  border-bottom: 1px solid #eee;
  display: flex;
  align-items: center;
}

.detail-row {
  display: flex;
  margin-bottom: 10px;
}

.detail-label {
  font-weight: 500;
  width: 120px;
  color: #7f8c8d;
}

.detail-value {
  flex: 1;
  display: flex;
  align-items: center;
}

.text-success {
  color: #27ae60;
}

.text-danger {
  color: #e74c3c;
}

.text-warning {
  color: #f39c12;
}

.metrics-chart {
  background-color: #f8f9fa;
  padding: 15px;
  border-radius: 8px;
}

.chart-row {
  display: flex;
  align-items: center;
  margin-bottom: 10px;
}

.chart-row:last-child {
  margin-bottom: 0;
}

.chart-label {
  width: 100px;
  font-size: 13px;
  color: #7f8c8d;
  display: flex;
  align-items: center;
}

.chart-bar-container {
  flex: 1;
  height: 20px;
  background-color: #ecf0f1;
  border-radius: 10px;
  position: relative;
  overflow: hidden;
}

.chart-bar {
  height: 100%;
  border-radius: 10px;
}

.chart-bar-low {
  background: linear-gradient(to right, #4CAF50, #8BC34A);
}

.chart-bar-medium {
  background: linear-gradient(to right, #FFC107, #FF9800);
}

.chart-bar-high {
  background: linear-gradient(to right, #F44336, #E91E63);
}

.chart-value {
  position: absolute;
  top: 50%;
  right: 10px;
  transform: translateY(-50%);
  font-size: 11px;
  font-weight: bold;
  color: white;
  text-shadow: 0 0 2px rgba(0, 0, 0, 0.5);
}

.deployed-models-list {
  max-height: 200px;
  overflow-y: auto;
}

.deployed-model-item {
  background-color: #f8f9fa;
  border-radius: 6px;
  padding: 10px;
  margin-bottom: 10px;
}

.deployed-model-item:last-child {
  margin-bottom: 0;
}

.model-info {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 5px;
}

.model-info h5 {
  margin: 0;
  font-size: 14px;
  display: flex;
  align-items: center;
}

.model-meta {
  display: flex;
  justify-content: space-between;
  font-size: 12px;
  color: #7f8c8d;
}

.deploy-time, .model-status {
  display: flex;
  align-items: center;
}

.no-models {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100px;
  color: #95a5a6;
  text-align: center;
}

.no-models .icon {
  font-size: 32px;
  margin-bottom: 10px;
}

.history-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 13px;
}

.history-table th,
.history-table td {
  padding: 8px 12px;
  text-align: left;
  border-bottom: 1px solid #eee;
}

.history-table th {
  background-color: #f8f9fa;
  color: #7f8c8d;
  font-weight: 500;
  display: flex;
  align-items: center;
}

.history-table tr:hover {
  background-color: #f5f7fa;
}

.success-modal {
  max-width: 500px;
  text-align: center;
  padding: 30px;
}

.success-icon {
  font-size: 60px;
  color: #2ecc71;
  margin-bottom: 15px;
}

.success-modal h3 {
  font-size: 24px;
  color: #2c3e50;
  margin-bottom: 10px;
}

.success-modal p {
  font-size: 16px;
  margin-bottom: 20px;
  line-height: 1.5;
}

.deploy-details {
  background-color: #f8f9fa;
  padding: 15px;
  border-radius: 8px;
  margin-top: 20px;
}

/* 表单样式 */
.form-group {
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  margin-bottom: 5px;
  font-size: 14px;
  font-weight: 500;
  color: #2c3e50;
  display: flex;
  align-items: center;
}

.form-control {
  width: 100%;
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 6px;
  font-size: 14px;
  transition: all 0.3s ease;
}

.form-control:focus {
  outline: none;
  border-color: #4a6bdf;
  box-shadow: 0 0 0 2px rgba(74, 107, 223, 0.2);
}

.form-row {
  display: flex;
  gap: 15px;
}

.form-row .form-group {
  flex: 1;
}

/* 响应式设计 */
@media (max-width: 1200px) {
  .deploy-container {
    flex-direction: column;
  }

  .model-list {
    max-width: 100%;
  }
}

@media (max-width: 768px) {
  .header {
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
  }

  .metrics-display {
    grid-template-columns: repeat(2, 1fr);
  }

  .search-filter {
    flex-direction: column;
    gap: 10px;
  }

  .search-input-container {
    width: 100%;
  }

  .node-list {
    grid-template-columns: 1fr;
  }

  .form-row {
    flex-direction: column;
    gap: 0;
  }

  .history-table th,
  .history-table td {
    padding: 6px 8px;
    font-size: 12px;
  }
}
</style>
