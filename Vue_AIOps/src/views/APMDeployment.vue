<template>
  <div id="app">
    <!-- 主容器 -->
    <div class="app-container" :class="{ 'blur': showDialog || showDeployDialog || showAutoDeployDialog }">
      <!-- 节点列表视图 -->
      <div v-if="currentView === 'nodes'" class="nodes-view">
        <div class="header">
          <h1><i class="icon-server"></i> 算法管道模型部署节点</h1>
          <div class="actions">
            <button class="add-node-btn" @click="showAddNodeDialog">
              <i class="icon-plus"></i> 新增部署节点
            </button>
            <button class="deploy-model-btn" @click="switchToDeploymentView">
              <i class="icon-upload"></i> 部署算法管道模型
            </button>
          </div>
        </div>

        <div class="search-filter">
          <input type="text" v-model="searchQuery" placeholder="搜索节点名称或IP..." class="search-input">
          <div class="filter-group">
            <label>状态:</label>
            <select v-model="statusFilter" class="filter-select">
              <option value="all">全部</option>
              <option value="active">活跃</option>
              <option value="inactive">不活跃</option>
            </select>
          </div>
        </div>

        <div class="stats-bar">
          <div class="stat-item">
            <div class="stat-value">{{ filteredNodes.length }}</div>
            <div class="stat-label">总节点数</div>
          </div>
          <div class="stat-item">
            <div class="stat-value">{{ activeNodeCount }}</div>
            <div class="stat-label">活跃节点</div>
          </div>
          <div class="stat-item">
            <div class="stat-value">{{ totalDeployedModels }}</div>
            <div class="stat-label">已部署模型</div>
          </div>
        </div>

        <div class="nodes-list">
          <div v-for="node in filteredNodes" :key="node.id" class="node-card" :class="node.status">
            <div class="card-header" @click="toggleNodeDetails(node.id)">
              <div class="node-title">
                <i class="icon-server"></i>
                <h3>{{ node.name }}</h3>
                <span class="node-ip">{{ node.ip }}</span>
              </div>
              <div class="node-status">
                <span class="status-badge">{{ node.status === 'active' ? '活跃' : '离线' }}</span>
                <i class="icon-chevron-down" :class="{ 'rotate': expandedNodes[node.id] }"></i>
              </div>
            </div>

            <transition name="slide">
              <div class="card-body" v-if="expandedNodes[node.id]">
                <!-- 基本信息 -->
                <div class="info-grid">
                  <div class="info-item">
                    <i class="icon-clock"></i>
                    <span>运行: {{ node.uptime }}</span>
                  </div>
                  <div class="info-item">
                    <i class="icon-cpu"></i>
                    <span>CPU: {{ node.cpu.usage }}% ({{ node.cpu.cores }}核)</span>
                  </div>
                  <div class="info-item" v-if="node.gpu.hasGPU">
                    <i class="icon-gpu"></i>
                    <span>GPU: {{ node.gpu.usage }}% ({{ node.gpu.model }})</span>
                  </div>
                  <div class="info-item">
                    <i class="icon-memory"></i>
                    <span>内存: {{ node.memory.usage }}% ({{ node.memory.used }}/{{ node.memory.total }})</span>
                  </div>
                </div>

                <!-- 可折叠的详细指标 -->

                <div class="collapsible-section" :class="{ 'expanded': expandedMetrics[node.id] }">
                  <div class="section-header" @click="toggleMetrics(node.id)">
                    <span>详细指标</span>
                    <i class="icon-chevron"></i>
                  </div>

                  <div class="section-content" v-if="expandedMetrics[node.id]">
                    <!-- CPU详情 -->
                    <div class="metric-group">
                      <div class="metric-row">
                        <span class="metric-label">CPU温度</span>
                        <span class="metric-value">{{ node.cpu.temperature }}°C</span>
                      </div>
                      <div class="metric-row">
                        <span class="metric-label">频率</span>
                        <span class="metric-value">{{ node.cpu.frequency }}</span>
                      </div>
                    </div>

                    <!-- GPU详情 -->
                    <div class="metric-group" v-if="node.gpu.hasGPU">
                      <div class="metric-row">
                        <span class="metric-label">GPU显存</span>
                        <span class="metric-value">{{ node.gpu.usage }}/100</span>
                      </div>
                      <div class="metric-row">
                        <span class="metric-label">GPU温度</span>
                        <span class="metric-value">{{ node.gpu.temperature }}°C</span>
                      </div>
                    </div>

                    <!-- 磁盘详情 -->
                    <div class="metric-group">
                      <h5>磁盘</h5>
                      <div v-for="disk in node.disks" :key="disk.name" class="disk-row">
                        <span class="disk-name">{{ disk.name }} ({{ disk.type }})</span>
                        <div class="disk-usage">
                          <div class="usage-bar" :style="{ width: disk.usage + '%' }"></div>
                          <span class="usage-text">{{ disk.usage }}%</span>
                        </div>
                      </div>
                    </div>

                    <!-- 网络详情 -->
                    <div class="metric-group">
                      <h5>网络</h5>
                      <div class="network-row">
                        <span>上传: {{ node.network.totalUpload }}</span>
                        <span>下载: {{ node.network.totalDownload }}</span>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- 在节点卡片内添加已部署模型区域 -->
                <div class="deployed-models">
                  <div class="models-header" @click="toggleModels(node.id)">
    <span>
      <i class="icon-box"></i>
      已部署模型 ({{ node.models.length }})
    </span>
                    <i class="icon-chevron" :class="{ 'rotate': expandedModels[node.id] }"></i>
                  </div>

                  <transition name="fade">
                    <div v-if="expandedModels[node.id]" class="models-list">
                      <div v-if="node.models.length > 0">
                        <div v-for="model in node.models" :key="model.id" class="model-item">
                          <div class="model-info">
                            <span class="model-name">{{ model.name }}</span>
                            <span class="model-version">v{{ model.version }}</span>
                          </div>
                          <div class="model-actions">
                            <button @click.stop="showModelDetails(model)" class="btn-detail">
                              <i class="icon-info"></i> 详情
                            </button>
                            <button @click.stop="unDeploy(model, node)" class="btn-remove">
                              <i class="icon-trash"></i> 卸载
                            </button>
                          </div>
                        </div>
                      </div>
                      <div v-else class="empty-models">
                        暂无部署模型
                      </div>
                    </div>
                  </transition>
                </div>
              </div>
            </transition>
          </div>
        </div>
      </div>

      <!-- 模型部署视图 -->
      <div v-else class="deployment-view">
        <div class="header">
          <h1><i class="icon-upload"></i> 算法管道模型部署</h1>
          <button class="back-btn" @click="switchToNodesView">
            <i class="icon-arrow-left"></i> 返回节点列表
          </button>
        </div>

        <div class="deployment-content">
          <div class="node-selection">
            <h2><i class="icon-server"></i> 目标节点</h2>
            <div class="node-selector">
              <select v-model="selectedNodeId" class="node-select">
                <option value="">自动选择节点</option>
                <option v-for="node in activeNodes" :value="node.id" :key="node.id">
                  {{ node.name }} ({{ node.ip }}) - CPU: {{ node.cpu }}%, 内存: {{ node.memory }}%
                </option>
              </select>
              <button class="refresh-btn" @click="refreshNodeStats">
                <i class="icon-refresh"></i> 刷新状态
              </button>
            </div>

            <div v-if="selectedNode" class="selected-node-info">
              <div class="node-card-mini">
                <div class="node-title">
                  <i class="icon-server"></i>
                  <h3>{{ selectedNode.name }}</h3>
                  <span class="node-ip">{{ selectedNode.ip }}</span>
                </div>
                <div class="node-stats">
                  <span class="stat"><i class="icon-cpu"></i> CPU: {{ selectedNode.cpu }}%</span>
                  <span class="stat"><i class="icon-memory"></i> 内存: {{ selectedNode.memory }}%</span>
                </div>
              </div>
            </div>
          </div>

          <div class="model-selection">
            <h2><i class="icon-box"></i> 算法管道模型部署单元</h2>
            <div class="model-filters">
              <input type="text" v-model="modelSearch" placeholder="搜索算法管道模型..." class="search-input">
              <div class="filter-group">
                <label>类型:</label>
                <select v-model="modelTypeFilter" class="filter-select">
                  <option value="all">全部</option>
                  <option value="cv">计算机视觉</option>
                  <option value="nlp">自然语言处理</option>
                  <option value="audio">音频处理</option>
                  <option value="analytics">数据分析</option>
                </select>
              </div>
            </div>

            <div class="model-list">
              <div v-for="model in filteredModels" :key="model.id" class="model-card">
                <div class="model-header">
                  <h3>{{ model.name }}</h3>
                  <span class="model-version">v{{ model.version }}</span>
                </div>
                <div class="model-meta">
                  <span class="model-type" :class="model.type">{{ getModelTypeName(model.type) }}</span>
                  <span class="model-size">{{ model.size }}</span>
                  <span class="model-framework">{{ model.framework }}</span>
                </div>
                <div class="model-desc">{{ model.description }}</div>
                <div class="model-requirements">
                  <span v-if="model.gpu"><i class="icon-cpu"></i> 需要GPU</span>
                  <span><i class="icon-memory"></i> 最小内存: {{ model.minMemory }}</span>
                </div>
                <div class="model-actions">
                  <button class="deploy-btn" @click="deployModel1(model, selectedNode || null)">
                    <i class="icon-upload"></i>
                    {{ selectedNode ? '部署到选中节点' : '自动部署' }}
                  </button>
                  <button class="details-btn" @click="showModelDetails(model)">
                    <i class="icon-info"></i> 详情
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 添加节点对话框 -->
    <div v-if="showDialog" class="modal">
      <div class="modal-content">
        <div class="modal-header">
          <h3><i class="icon-plus"></i> 添加新节点</h3>
          <button class="close-btn" @click="closeAddNodeDialog">&times;</button>
        </div>
        <div class="modal-body">
          <form @submit.prevent="addNode">
            <div class="form-group">
              <label><i class="icon-tag"></i> 节点名称</label>
              <input v-model="newNode.name" required class="form-input">
            </div>
            <div class="form-group">
              <label><i class="icon-globe"></i> IP地址</label>
              <input v-model="newNode.ip" required class="form-input" placeholder="例如: 192.168.1.100">
            </div>
            <div class="form-group">
              <label><i class="icon-cpu"></i> CPU核心数</label>
              <input v-model="newNode.cores" type="number" min="1" class="form-input" placeholder="例如: 8">
            </div>
            <div class="form-group">
              <label><i class="icon-memory"></i> 内存(GB)</label>
              <input v-model="newNode.totalMemory" type="number" min="1" class="form-input" placeholder="例如: 32">
            </div>
            <div class="form-group">
              <label><i class="icon-zap"></i> 初始状态</label>
              <select v-model="newNode.status" class="form-input">
                <option value="active">活跃</option>
                <option value="inactive">离线</option>
              </select>
            </div>
            <div class="form-actions">
              <button type="button" class="cancel-btn" @click="closeAddNodeDialog">取消</button>
              <button type="submit" class="submit-btn">添加节点</button>
            </div>
          </form>
        </div>
      </div>
    </div>

    <!-- 部署确认对话框 -->
    <div v-if="showDeployDialog" class="modal">
      <div class="modal-content">
        <div class="modal-header">
          <h3><i class="icon-upload"></i> 确认部署</h3>
          <button class="close-btn" @click="showDeployDialog = false">&times;</button>
        </div>
        <div class="modal-body">
          <p>确定要将模型 <strong>{{ deployModel.name }} v{{ deployModel.version }}</strong> 部署到节点 <strong>{{ deployNode ? deployNode.name : '自动选择的最佳节点' }}</strong> 吗？</p>

          <div v-if="deployNode" class="compatibility-check">
            <h4>兼容性检查:</h4>
            <ul>
              <li v-if="deployModel.gpu && !deployNode.hasGPU" class="incompatible">
                <i class="icon-alert"></i> 模型需要GPU但节点无GPU
              </li>
              <li v-else-if="deployModel.gpu" class="compatible">
                <i class="icon-check"></i> GPU兼容
              </li>

              <li v-if="parseInt(deployModel.minMemory) > parseInt(deployNode.totalMemory || 32)" class="incompatible">
                <i class="icon-alert"></i> 内存不足 (需要 {{ deployModel.minMemory }}, 可用 {{ deployNode.totalMemory || '32GB' }})
              </li>
              <li v-else class="compatible">
                <i class="icon-check"></i> 内存充足
              </li>
            </ul>
          </div>

          <div class="deployment-options">
            <label>
              <input type="checkbox" v-model="forceDeploy"> 强制部署 (忽略兼容性警告)
            </label>
          </div>
        </div>
        <div class="modal-actions">
          <button class="cancel-btn" @click="showDeployDialog = false">取消</button>
          <button class="confirm-btn" @click="confirmDeploy" :disabled="!forceDeploy && hasCompatibilityIssues">
            确认部署
          </button>
        </div>
      </div>
    </div>

    <!-- 自动部署结果对话框 -->
    <div v-if="showAutoDeployDialog" class="modal">
      <div v-if="showAutoDeployDialog" class="modal">
        <div class="modal-content">
          <div class="modal-header">
            <h3><i class="icon-cpu"></i> 自动部署结果</h3>
            <button class="close-btn" @click="showAutoDeployDialog = false">&times;</button>
          </div>
          <div class="modal-body">
            <p>模型 <strong>{{ autoDeployModel.name }} v{{ autoDeployModel.version }}</strong> 已自动部署到以下节点:</p>

            <!-- 添加调度日志部分 -->
            <div class="scheduling-log">
              <h4><i class="icon-list"></i> 调度决策日志</h4>
              <div class="log-entry" v-for="(log, index) in schedulingLogs" :key="index">
                <div class="log-timestamp">{{ log.timestamp }}</div>
                <div class="log-message">{{ log.message }}</div>
                <div v-if="log.score" class="log-score">
                  AEW-KCSS评分: <span class="score-value">{{ log.score.toFixed(2) }}</span>
                  <div class="score-breakdown">
                <span v-for="(value, key) in log.scoreDetails" :key="key">
                  {{ key }}: {{ value.toFixed(2) }}
                </span>
                  </div>
                </div>
              </div>
            </div>

            <div v-for="node in autoDeployNodes" :key="node.id" class="deployed-node">
              <div class="node-info">
                <i class="icon-server"></i>
                <div>
                  <h4>{{ node.name }}</h4>
                  <p>{{ node.ip }} - CPU: {{ node.cpu }}%, 内存: {{ node.memory }}%</p>
                  <!-- 显示节点的AEW-KCSS评分 -->
                  <div class="node-score">
                    <div class="score-header">AEW-KCSS综合评分: <span class="score-value">{{ node.schedulingScore.toFixed(2) }}</span></div>
                    <div class="score-details">
                      <div class="score-item">
                        <span class="score-label">算法效率(A):</span>
                        <span class="score-value">{{ node.scoreDetails.algorithmEfficiency.toFixed(2) }}</span>
                      </div>
                      <div class="score-item">
                        <span class="score-label">资源权重(E):</span>
                        <span class="score-value">{{ node.scoreDetails.resourceWeight.toFixed(2) }}</span>
                      </div>
                      <div class="score-item">
                        <span class="score-label">工作负载(W):</span>
                        <span class="score-value">{{ node.scoreDetails.workload.toFixed(2) }}</span>
                      </div>
                      <div class="score-item">
                        <span class="score-label">知识协同(K):</span>
                        <span class="score-value">{{ node.scoreDetails.knowledgeCollaboration.toFixed(2) }}</span>
                      </div>
                      <div class="score-item">
                        <span class="score-label">成本效益(C):</span>
                        <span class="score-value">{{ node.scoreDetails.costEffectiveness.toFixed(2) }}</span>
                      </div>
                      <div class="score-item">
                        <span class="score-label">安全稳定(S):</span>
                        <span class="score-value">{{ node.scoreDetails.safetyStability.toFixed(2) }}</span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="deploy-status">
                <i class="icon-check success"></i> 部署成功
              </div>
            </div>

            <div class="deployment-summary">
              <h4>部署摘要:</h4>
              <ul>
                <li>模型大小: {{ autoDeployModel.size }}</li>
                <li>部署时间: 约 {{ Math.round(autoDeployModel.size.replace(/[^\d]/g, '') / 10) }} 秒</li>
                <li>预估资源占用: CPU +{{ Math.round(autoDeployModel.size.replace(/[^\d]/g, '') / 50) }}%, 内存 +{{ Math.round(autoDeployModel.size.replace(/[^\d]/g, '') / 20) }}%</li>
                <li>最佳节点评分: {{ bestNodeScore.toFixed(2) }} (AEW-KCSS)</li>
              </ul>
            </div>
          </div>
          <div class="modal-actions">
            <button class="close-btn" @click="showAutoDeployDialog = false">关闭</button>
          </div>
        </div>
      </div>
      <div class="modal-content">
        <div class="modal-header">
          <h3><i class="icon-cpu"></i> 自动部署结果</h3>
          <button class="close-btn" @click="showAutoDeployDialog = false">&times;</button>
        </div>
        <div class="modal-body">
          <p>模型 <strong>{{ autoDeployModel.name }} v{{ autoDeployModel.version }}</strong> 已自动部署到以下节点:</p>

          <div v-for="node in autoDeployNodes" :key="node.id" class="deployed-node">
            <div class="node-info">
              <i class="icon-server"></i>
              <div>
                <h4>{{ node.name }}</h4>
                <p>{{ node.ip }} - CPU: {{ node.cpu }}%, 内存: {{ node.memory }}%</p>
              </div>
            </div>
            <div class="deploy-status">
              <i class="icon-check success"></i> 部署成功
            </div>
          </div>

          <div class="deployment-summary">
            <h4>部署摘要:</h4>
            <ul>
              <li>模型大小: {{ autoDeployModel.size }}</li>
              <li>部署时间: 约 {{ Math.round(autoDeployModel.size.replace(/[^\d]/g, '') / 10) }} 秒</li>
              <li>预估资源占用: CPU +{{ Math.round(autoDeployModel.size.replace(/[^\d]/g, '') / 50) }}%, 内存 +{{ Math.round(autoDeployModel.size.replace(/[^\d]/g, '') / 20) }}%</li>
            </ul>
          </div>
        </div>
        <div class="modal-actions">
          <button class="close-btn" @click="showAutoDeployDialog = false">关闭</button>
        </div>
      </div>
    </div>

    <!-- 模型详情对话框 -->
    <div v-if="showModelDetailsDialog" class="modal">
      <div class="modal-content large">
        <div class="modal-header">
          <h3><i class="icon-box"></i> 模型详情 - {{ currentModel.name }} v{{ currentModel.version }}</h3>
          <button class="close-btn" @click="showModelDetailsDialog = false">&times;</button>
        </div>
        <div class="modal-body">
          <div class="model-detail-grid">
            <div class="detail-section">
              <h4><i class="icon-info"></i> 基本信息</h4>
              <table class="detail-table">
                <tr>
                  <td>模型名称:</td>
                  <td>{{ currentModel.name }}</td>
                </tr>
                <tr>
                  <td>版本:</td>
                  <td>v{{ currentModel.version }}</td>
                </tr>
                <tr>
                  <td>类型:</td>
                  <td><span :class="currentModel.type">{{ getModelTypeName(currentModel.type) }}</span></td>
                </tr>
                <tr>
                  <td>框架:</td>
                  <td>{{ currentModel.framework }}</td>
                </tr>
                <tr>
                  <td>大小:</td>
                  <td>{{ currentModel.size }}</td>
                </tr>
                <tr>
                  <td>创建时间:</td>
                  <td>{{ currentModel.createdAt || '2023-01-01' }}</td>
                </tr>
              </table>
            </div>

            <div class="detail-section">
              <h4><i class="icon-cpu"></i> 系统需求</h4>
              <table class="detail-table">
                <tr>
                  <td>GPU需求:</td>
                  <td>{{ currentModel.gpu ? '是' : '否' }}</td>
                </tr>
                <tr>
                  <td>最小内存:</td>
                  <td>{{ currentModel.minMemory }}</td>
                </tr>
                <tr>
                  <td>推荐内存:</td>
                  <td>{{ currentModel.recommendedMemory || currentModel.minMemory }}</td>
                </tr>
                <tr>
                  <td>CPU需求:</td>
                  <td>{{ currentModel.minCores || 4 }} 核心</td>
                </tr>
              </table>
            </div>

            <div class="detail-section full-width">
              <h4><i class="icon-file-text"></i> 描述</h4>
              <p>{{ currentModel.description }}</p>
            </div>

            <div class="detail-section full-width">
              <h4><i class="icon-hash"></i> 输入/输出</h4>
              <div class="io-spec">
                <div class="input-spec">
                  <h5>输入:</h5>
                  <pre>{{ currentModel.inputSpec || '{\n  "type": "tensor",\n  "shape": "variable",\n  "format": "RGB"\n}' }}</pre>
                </div>
                <div class="output-spec">
                  <h5>输出:</h5>
                  <pre>{{ currentModel.outputSpec || '{\n  "type": "classification",\n  "classes": 1000\n}' }}</pre>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="modal-actions">
          <button class="deploy-from-detail" @click="deployFromDetails">
            <i class="icon-upload"></i> 部署此模型
          </button>
          <button class="close-btn" @click="showModelDetailsDialog = false">关闭</button>
        </div>
      </div>
    </div>

    <!-- 取消部署确认对话框 -->
    <div v-if="showUndeployDialog" class="modal">
      <div class="modal-content">
        <div class="modal-header">
          <h3><i class="icon-alert"></i> 确认取消部署</h3>
          <button class="close-btn" @click="showUndeployDialog = false">&times;</button>
        </div>
        <div class="modal-body">
          <p>确定要从节点 <strong>{{ undeployNode.name }}</strong> 取消部署模型 <strong>{{ undeployModel.name }} v{{ undeployModel.version }}</strong> 吗？</p>

          <div class="warning-message">
            <i class="icon-alert"></i>
            <p>取消部署将停止该模型的所有运行实例，可能会影响依赖此模型的服务。</p>
          </div>
        </div>
        <div class="modal-actions">
          <button class="cancel-btn" @click="showUndeployDialog = false">取消</button>
          <button class="confirm-btn danger" @click="confirmUndeploy">确认取消部署</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'APMDeployment',
  data() {
    return {
      currentView: 'nodes',
      nodes: [
        {
          id: 1,
          name: "GPU节点-1",
          status: "active",
          ip: "192.168.1.101",
          cpu: { usage: 32, cores: 16, model: "Intel Xeon Gold 6248R" },
          gpu: { hasGPU: true, model: "NVIDIA RTX 3090", usage: 45 },
          memory: { usage: 45, total: "64GB", used: "28.8GB" },
          // 新增的模型部署数据
          models: [
            {
              id: "model-101",
              name: "图像分类模型",
              version: "1.5",
              type: "cv",
              deployedAt: "2023-05-10T08:30:00",
              status: "running",
              input: "RGB图像",
              output: "分类标签",
              throughput: "120 FPS"  // 可选：性能指标
            },
            {
              id: "model-102",
              name: "目标检测模型",
              version: "2.1",
              type: "cv",
              deployedAt: "2023-05-15T14:20:00",
              status: "running"
            }
          ]
        },
        {
          id: 2,
          name: "计算节点-2",
          status: "active",
          ip: "192.168.1.102",
          cpu: { usage: 68, cores: 32, model: "AMD EPYC 7763" },
          gpu: { hasGPU: false },
          memory: { usage: 72, total: "128GB", used: "92.2GB" },
          models: [
            {
              id: "model-201",
              name: "文本情感分析",
              version: "3.0",
              type: "nlp",
              deployedAt: "2023-05-12T10:15:00",
              status: "stopped"  // 示例：已停止的模型
            }
          ]
        },
        {
          id: 3,
          name: "存储节点-3",
          status: "inactive",
          ip: "192.168.1.103",
          cpu: { usage: 0, cores: 8, model: "Intel Xeon E-2288G" },
          memory: { usage: 0, total: "32GB", used: "0GB" },
          models: []  // 无部署模型
        }
      ],
      expandedModels: {}, // 用来记录每个节点的模型列表展开状态
      availableModels: [
        {
          id: 201,
          name: '图像分类模型',
          version: '1.5',
          size: '256MB',
          type: 'cv',
          framework: 'TensorFlow 2.4',
          description: '用于识别和分类图像中的对象，支持1000种常见类别，基于ImageNet数据集训练。',
          gpu: true,
          minMemory: '8GB',
          recommendedMemory: '16GB'
        },
        {
          id: 202,
          name: '文本情感分析',
          version: '2.0',
          size: '128MB',
          type: 'nlp',
          framework: 'PyTorch 1.8',
          description: '分析文本内容的情感倾向，支持中英文，准确率92.5%。',
          gpu: false,
          minMemory: '4GB'
        },
        {
          id: 203,
          name: '时间序列预测',
          version: '1.2',
          size: '180MB',
          type: 'analytics',
          framework: 'Scikit-learn 1.0',
          description: '基于历史数据预测未来趋势，适用于销售、流量等预测场景。',
          gpu: false,
          minMemory: '4GB'
        },
        {
          id: 204,
          name: '语音识别',
          version: '3.1',
          size: '320MB',
          type: 'audio',
          framework: 'TensorFlow 2.5',
          description: '将语音转换为文本，支持中文普通话和英语，实时识别延迟<200ms。',
          gpu: true,
          minMemory: '12GB'
        },
        {
          id: 205,
          name: '目标检测',
          version: '2.5',
          size: '512MB',
          type: 'cv',
          framework: 'PyTorch 1.9',
          description: '实时检测图像中的多个对象并标记位置，支持80种常见物体类别。',
          gpu: true,
          minMemory: '16GB'
        }
      ],
      searchQuery: '',
      statusFilter: 'all',
      expandedNodes: {},
      showDialog: false,
      newNode: {
        name: '',
        ip: '',
        status: 'active',
        cores: 8,
        totalMemory: '32'
      },
      selectedNodeId: null,
      modelSearch: '',
      modelTypeFilter: 'all',
      showDeployDialog: false,
      deployModel: null,
      deployNode: null,
      forceDeploy: false,
      showAutoDeployDialog: false,
      autoDeployModel: null,
      autoDeployNodes: [],
      showModelDetailsDialog: false,
      currentModel: null,
      showUndeployDialog: false,
      undeployModel: null,
      undeployNode: null,
      expandedMetrics: {},
      activeTab: {},
      showDetails: {},
      schedulingLogs: [], // 用于存储调度日志
      bestNodeScore: 0, // 最佳节点评分

    }
  },
  computed: {
    // 计算提示框位置
    tooltipPosition() {
      return {
        left: `${this.activeTooltip.x + 10}px`,
        top: `${this.activeTooltip.y + 10}px`
      };
    },
    filteredNodes() {
      let filtered = this.nodes;

      // 应用搜索过滤
      if (this.searchQuery) {
        const query = this.searchQuery.toLowerCase();
        filtered = filtered.filter(node =>
            node.name.toLowerCase().includes(query) ||
            node.ip.includes(query)
        );
      }

      // 应用状态过滤
      if (this.statusFilter !== 'all') {
        filtered = filtered.filter(node => node.status === this.statusFilter);
      }

      return filtered;
    },
    activeNodeCount() {
      return this.nodes.filter(node => node.status === 'active').length;
    },
    totalDeployedModels() {
      return this.nodes.reduce((total, node) => total + node.models.length, 0);
    },
    activeNodes() {
      return this.nodes.filter(node => node.status === 'active');
    },
    selectedNode() {
      if (!this.selectedNodeId) return null;
      return this.nodes.find(node => node.id === parseInt(this.selectedNodeId));
    },
    filteredModels() {
      let filtered = this.availableModels;

      // 应用搜索过滤
      if (this.modelSearch) {
        const query = this.modelSearch.toLowerCase();
        filtered = filtered.filter(model =>
            model.name.toLowerCase().includes(query) ||
            model.description.toLowerCase().includes(query)
        );
      }

      // 应用类型过滤
      if (this.modelTypeFilter !== 'all') {
        filtered = filtered.filter(model => model.type === this.modelTypeFilter);
      }

      return filtered;
    },
    hasCompatibilityIssues() {
      if (!this.deployModel || !this.deployNode) return false;

      return (
          (this.deployModel.gpu && !this.deployNode.hasGPU) ||
          (parseInt(this.deployModel.minMemory) > parseInt(this.deployNode.totalMemory || 32))
      );
    }
  },
  methods: {
    toggleMetrics(nodeId) {
      this.$set(this.expandedMetrics, nodeId, !this.expandedMetrics[nodeId]);
    },
    toggleNodeExpansion(nodeId) {
      this.$set(this.expandedNodes, nodeId, !this.expandedNodes[nodeId])
    },
    toggleModels(nodeId) {
      this.$set(this.expandedModels, nodeId, !this.expandedModels[nodeId])
    },
    toggleNodeDetails(nodeId) {
      this.$set(this.expandedNodes, nodeId, !this.expandedNodes[nodeId]);
    },
    showAddNodeDialog() {
      this.showDialog = true;
    },
    closeAddNodeDialog() {
      this.showDialog = false;
      this.newNode = {
        name: '',
        ip: '',
        status: 'active',
        cores: 8,
        totalMemory: '32'
      };
    },
    addNode() {
      const newNode = {
        id: Math.max(...this.nodes.map(n => n.id)) + 1,
        name: this.newNode.name,
        ip: this.newNode.ip,
        status: this.newNode.status,
        uptime: '0天0小时',
        cpu: 0,
        memory: 0,
        cores: this.newNode.cores || 8,
        totalMemory: `${this.newNode.totalMemory || 32}GB`,
        storage: '1TB SSD',
        hasGPU: false,
        models: []
      };

      this.nodes.push(newNode);
      this.closeAddNodeDialog();
    },
    switchToDeploymentView() {
      this.currentView = 'deployment';
      this.selectedNodeId = null;
    },
    switchToNodesView() {
      this.currentView = 'nodes';
    },
    deployToNode(node) {
      this.switchToDeploymentView();
      this.selectedNodeId = node.id;
    },
    refreshNodeStats() {
      // 模拟刷新节点状态
      this.nodes.forEach(node => {
        if (node.status === 'active') {
          node.cpu = Math.min(100, Math.max(0, node.cpu + (Math.random() * 20 - 10)));
          node.memory = Math.min(100, Math.max(0, node.memory + (Math.random() * 15 - 7.5)));
        }
      });
    },
    deployModel1(model, node) {
      this.deployModel = model;
      this.deployNode = node;
      this.forceDeploy = false;
      this.showDeployDialog = true;
    },
    autoDeploy(model) {
      this.autoDeployModel = model;

      // 模拟自动选择节点逻辑 - 选择资源使用率最低的兼容节点
      let suitableNodes = this.nodes
          .filter(node => node.status === 'active')
          .filter(node => {
            // 检查GPU需求
            if (model.gpu && !node.hasGPU) return false;
            // 检查内存需求
            if (parseInt(model.minMemory) > parseInt(node.totalMemory || 32)) return false;
            return true;
          })
          .sort((a, b) => (a.cpu + a.memory) - (b.cpu + b.memory));

      // 如果没有完全兼容的节点，选择最接近的
      if (suitableNodes.length === 0) {
        suitableNodes = this.nodes
            .filter(node => node.status === 'active')
            .sort((a, b) => {
              // 优先考虑有GPU的节点
              const aScore = (a.hasGPU ? 0 : 100) + a.cpu + a.memory;
              const bScore = (b.hasGPU ? 0 : 100) + b.cpu + b.memory;
              return aScore - bScore;
            });
      }

      this.autoDeployNodes = suitableNodes.slice(0, 1); // 选择最优的一个节点
      this.showAutoDeployDialog = true;

      // 在实际应用中，这里应该调用API进行自动部署
      console.log(`自动部署模型 ${model.name} 到节点`, this.autoDeployNodes);
    },
    confirmDeploy() {
      // 在实际应用中，这里应该调用API进行部署
      console.log(`部署模型 ${this.deployModel.name} 到节点 ${this.deployNode ? this.deployNode.name : '自动选择'}`);

      // 如果是部署到特定节点
      if (this.deployNode) {
        // 检查是否已经部署了相同模型
        const alreadyDeployed = this.deployNode.models.some(
            m => m.id === this.deployModel.id
        );

        if (!alreadyDeployed) {
          this.deployNode.models.push({
            id: this.deployModel.id,
            name: this.deployModel.name,
            version: this.deployModel.version,
            type: this.deployModel.type
          });
        }
      } else {
        // 自动部署到选中的节点
        this.autoDeployNodes.forEach(node => {
          const alreadyDeployed = node.models.some(
              m => m.id === this.deployModel.id
          );

          if (!alreadyDeployed) {
            node.models.push({
              id: this.deployModel.id,
              name: this.deployModel.name,
              version: this.deployModel.version,
              type: this.deployModel.type
            });
          }
        });
      }

      this.showDeployDialog = false;
      alert(`模型 ${this.deployModel.name} 已成功部署`);
    },
    getModelTypeName(type) {
      const types = {
        cv: '计算机视觉',
        nlp: '自然语言处理',
        audio: '音频处理',
        analytics: '数据分析'
      };
      return types[type] || type;
    },
    showModelDetails(model) {
      this.currentModel = model;
      this.showModelDetailsDialog = true;
    },
    deployFromDetails() {
      this.showModelDetailsDialog = false;
      this.deployModel(this.currentModel, this.selectedNode || null);
    },
    confirmUndeploy1(model, node) {
      this.undeployModel = model;
      this.undeployNode = node;
      this.showUndeployDialog = true;
    },
    confirmUndeploy() {
      // 从节点中移除该模型
      this.undeployNode.models = this.undeployNode.models.filter(
          m => m.id !== this.undeployModel.id
      );

      this.showUndeployDialog = false;
      alert(`已从节点 ${this.undeployNode.name} 取消部署模型 ${this.undeployModel.name}`);
    },
    restartNode(node) {
      // 模拟重启节点
      node.status = 'inactive';
      setTimeout(() => {
        node.status = 'active';
        node.cpu = 10 + Math.random() * 10;
        node.memory = 15 + Math.random() * 10;
        alert(`节点 ${node.name} 已重启`);
      }, 2000);
    },
    stopNode(node) {
      node.status = 'inactive';
      node.cpu = 0;
      node.memory = 0;
      alert(`节点 ${node.name} 已停止`);
    },
    startNode(node) {
      node.status = 'active';
      node.cpu = 10 + Math.random() * 10;
      node.memory = 15 + Math.random() * 10;
      alert(`节点 ${node.name} 已启动`);
    },
    // 计算AEW-KCSS评分
    calculateAEWKCSSScore(node, model) {
      // 算法效率 (Algorithm Efficiency)
      const algorithmEfficiency = 0.8 + Math.random() * 0.2; // 0.8-1.0

      // 资源权重 (Resource Weight)
      const cpuScore = 1 - (node.cpu / 100);
      const memScore = 1 - (node.memory / 100);
      const resourceWeight = (cpuScore * 0.6 + memScore * 0.4) * 0.9 + Math.random() * 0.1;

      // 工作负载 (Workload)
      const workload = 0.7 + (1 - (node.models.length / 10)) * 0.3; // 基于已部署模型数量

      // 知识协同 (Knowledge Collaboration)
      const hasSimilarModels = node.models.some(m => m.type === model.type);
      const knowledgeCollaboration = hasSimilarModels ? 0.9 + Math.random() * 0.1 : 0.6 + Math.random() * 0.3;

      // 成本效益 (Cost Effectiveness)
      const costEffectiveness = 0.8 + Math.random() * 0.2;

      // 安全稳定 (Safety Stability)
      const uptimeScore = node.uptime.includes('天') ?
          Math.min(1, parseInt(node.uptime.split('天')[0]) / 30) : 0.5;
      const safetyStability = 0.7 + uptimeScore * 0.3;

      // 综合评分 (加权计算)
      const totalScore = (
          algorithmEfficiency * 0.25 +
          resourceWeight * 0.2 +
          workload * 0.15 +
          knowledgeCollaboration * 0.15 +
          costEffectiveness * 0.15 +
          safetyStability * 0.1
      );

      return {
        total: totalScore,
        details: {
          algorithmEfficiency,
          resourceWeight,
          workload,
          knowledgeCollaboration,
          costEffectiveness,
          safetyStability
        }
      };
    },



    // 添加调度日志
    addSchedulingLog(message, score = null, scoreDetails = null) {
      this.schedulingLogs.push({
        timestamp: new Date().toLocaleTimeString(),
        message,
        score,
        scoreDetails
      });
    },
  },
  created() {
    // 初始化所有节点的展开状态
    this.nodes.forEach(node => {
      this.$set(this.expandedNodes, node.id, false)
      this.$set(this.expandedMetrics, node.id, false)
      this.$set(this.expandedModels, node.id, false)
    })
  },
  startMonitoring() {
    // 模拟实时数据更新
    this.monitorInterval = setInterval(() => {
      this.nodes.forEach(node => {
        if (node.status === 'active') {
          // 更新CPU使用率 (±5%)
          node.cpu.usage = Math.min(100, Math.max(0,
              node.cpu.usage + (Math.random() * 10 - 5)
          ))

          // 更新CPU温度
          node.cpu.temperature = Math.min(100, Math.max(30,
              node.cpu.temperature + (Math.random() * 4 - 2)
          ))

          // 更新GPU数据
          if (node.gpu.hasGPU) {
            node.gpu.usage = Math.min(100, Math.max(0,
                node.gpu.usage + (Math.random() * 10 - 5)
            ))
            node.gpu.memory.usage = Math.min(100, Math.max(0,
                node.gpu.memory.usage + (Math.random() * 10 - 5)
            ))
            node.gpu.temperature = Math.min(90, Math.max(40,
                node.gpu.temperature + (Math.random() * 6 - 3)
            ))
            node.gpu.memory.used = `${(parseFloat(node.gpu.memory.used) + (Math.random() * 2 - 1)).toFixed(1)}GB`;
          }

          // 更新内存数据
          node.memory.usage = Math.min(100, Math.max(0,
              node.memory.usage + (Math.random() * 8 - 4)
          ))
          node.memory.used = `${(parseFloat(node.memory.used) + (Math.random() * 0.5 - 0.25).toFixed(1))}GB`;

          // 更新磁盘数据
          node.disks.forEach(disk => {
            disk.usage = Math.min(100, Math.max(0,
                disk.usage + (Math.random() * 2 - 1)
            ))
            disk.readSpeed = `${Math.round(50 + Math.random() * 150)}MB/s`;
            disk.writeSpeed = `${Math.round(30 + Math.random() * 100)}MB/s`;
          });

          // 更新网络数据
          node.network.interfaces.forEach(intf => {
            intf.upload = `${Math.round(10 + Math.random() * 80)}Mbps`;
            intf.download = `${Math.round(50 + Math.random() * 150)}Mbps`;
          });
          node.network.totalUpload = node.network.interfaces[0].upload;
          node.network.totalDownload = node.network.interfaces[0].download;
        }
      });
    }, 3000); // 每3秒更新一次
  },

  stopMonitoring() {
    if (this.monitorInterval) {
      clearInterval(this.monitorInterval);
    }
  },
  // 切换模型列表展开状态
  toggleModels(nodeId) {
    this.$set(this.expandedModels, nodeId, !this.expandedModels[nodeId]);
  },

  // 显示模型悬浮提示
  showModelTooltip(node, model, event) {
    this.activeTooltip = {
      node,
      model,
      x: event.clientX,
      y: event.clientY
    };
  },

  // 隐藏提示
  hideTooltip() {
    this.activeTooltip = null;
  },

  // 卸载模型
  unDeploy(model, node) {
    if (confirm(`确定从节点 ${node.name} 卸载 ${model.name} 吗？`)) {
      node.models = node.models.filter(m => m.id !== model.id);
    }
  },
}
</script>

<style>
/* 基础样式 */
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

body {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  line-height: 1.6;
  color: #333;
  background-color: #f5f7fa;
}

#app {
  min-height: 100vh;
}

.app-container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 20px;
  transition: filter 0.3s ease;
}

.app-container.blur {
  filter: blur(2px);
}

/* 图标样式 */
.icon {
  display: inline-block;
  margin-right: 5px;
  font-size: 1.1em;
  vertical-align: middle;
}

/* 按钮样式 */
button {
  cursor: pointer;
  transition: all 0.2s ease;
  border-radius: 4px;
  padding: 8px 15px;
  font-size: 14px;
  border: none;
  display: inline-flex;
  align-items: center;
}

button:hover {
  opacity: 0.9;
}

button i {
  margin-right: 5px;
}

/* 头部样式 */
.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 25px;
  padding-bottom: 15px;
  border-bottom: 1px solid #e1e4e8;
}

.header h1 {
  font-size: 24px;
  color: #333;
  display: flex;
  align-items: center;
}

.header h1 i {
  margin-right: 10px;
  color: #4a6bdf;
}

/* 搜索和过滤样式 */
.search-filter {
  display: flex;
  margin-bottom: 20px;
  gap: 15px;
  align-items: center;
}

.search-input {
  flex: 1;
  padding: 10px 15px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
  transition: border 0.3s;
}

.search-input:focus {
  outline: none;
  border-color: #4a6bdf;
}

.filter-group {
  display: flex;
  align-items: center;
}

.filter-group label {
  margin-right: 8px;
  font-size: 14px;
}

.filter-select {
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

/* 统计栏样式 */
.stats-bar {
  display: flex;
  gap: 15px;
  margin-bottom: 25px;
}

.stat-item {
  flex: 1;
  background: white;
  padding: 15px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
  text-align: center;
}

.stat-value {
  font-size: 24px;
  font-weight: bold;
  color: #4a6bdf;
  margin-bottom: 5px;
}

.stat-label {
  font-size: 14px;
  color: #666;
}

/* 节点卡片样式 */
.nodes-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
  gap: 20px;
}

.node-card {
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  overflow: hidden;
  transition: transform 0.2s, box-shadow 0.2s;
}

.node-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.node-card.active {
  border-left: 4px solid #4CAF50;
}

.node-card.inactive {
  border-left: 4px solid #F44336;
}

.card-header {
  padding: 15px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  cursor: pointer;
  background-color: #f9f9f9;
}

.node-title {
  display: flex;
  align-items: center;
}

.node-title h3 {
  font-size: 16px;
  margin: 0 10px 0 5px;
}

.node-ip {
  font-size: 12px;
  color: #666;
  background: #eee;
  padding: 2px 6px;
  border-radius: 4px;
}

.node-status {
  display: flex;
  align-items: center;
}

.status-badge {
  padding: 3px 10px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: bold;
  margin-right: 8px;
}

.active .status-badge {
  background-color: #E8F5E9;
  color: #4CAF50;
}

.inactive .status-badge {
  background-color: #FFEBEE;
  color: #F44336;
}

.icon-chevron-down {
  transition: transform 0.3s;
}

.icon-chevron-down.rotate {
  transform: rotate(180deg);
}

/* 卡片内容样式 */
.card-body {
  padding: 0 15px 15px;
}

.resource-meters {
  margin: 15px 0;
}

.meter {
  margin-bottom: 10px;
}

.meter-label {
  font-size: 13px;
  margin-bottom: 5px;
  display: flex;
  justify-content: space-between;
}

.meter-bar {
  height: 8px;
  background: #eee;
  border-radius: 4px;
  position: relative;
  overflow: hidden;
}

.meter-fill {
  height: 100%;
  border-radius: 4px;
  background: #4a6bdf;
  transition: width 0.5s ease;
}

.meter-fill.high {
  background: #F44336;
}

.meter-value {
  position: absolute;
  right: 5px;
  top: -18px;
  font-size: 11px;
  color: #666;
}

.info-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 10px;
  margin: 15px 0;
}

.info-item {
  font-size: 13px;
  display: flex;
  align-items: center;
}

.info-item i {
  margin-right: 8px;
  color: #666;
}

/* 已部署模型样式 */
.deployed-models {
  margin-top: 20px;
  padding-top: 15px;
  border-top: 1px dashed #ddd;
}

.deployed-models h4 {
  font-size: 14px;
  margin-bottom: 10px;
  display: flex;
  align-items: center;
}

.deployed-models h4 i {
  margin-right: 8px;
}

.model-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.model-tag {
  background: #e3f2fd;
  color: #1976d2;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  display: flex;
  align-items: center;
}

.model-tag i {
  margin-left: 5px;
  cursor: pointer;
  font-size: 10px;
  opacity: 0.7;
}

.model-tag i:hover {
  opacity: 1;
}

.empty-models {
  color: #888;
  font-style: italic;
  font-size: 13px;
}

/* 节点操作按钮 */
.node-actions {
  display: flex;
  gap: 10px;
  margin-top: 15px;
  flex-wrap: wrap;
}

.action-btn {
  font-size: 13px;
  padding: 6px 10px;
}

.action-btn i {
  font-size: 12px;
}

.action-btn.deploy {
  background: #4a6bdf;
  color: white;
}

.action-btn.restart {
  background: #FFC107;
  color: #333;
}

.action-btn.stop {
  background: #F44336;
  color: white;
}

.action-btn.start {
  background: #4CAF50;
  color: white;
}

/* 部署视图样式 */
.deployment-content {
  display: grid;
  grid-template-columns: 300px 1fr;
  gap: 25px;
}

.node-selection {
  background: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.node-selection h2 {
  font-size: 18px;
  margin-bottom: 15px;
  display: flex;
  align-items: center;
}

.node-selection h2 i {
  margin-right: 8px;
  color: #4a6bdf;
}

.node-selector {
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
}

.node-select {
  flex: 1;
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  width: 200px;
}

.refresh-btn {
  background: #f5f5f5;
  color: #333;
  padding: 8px 12px;
}

.selected-node-info {
  margin-top: 20px;
}

.node-card-mini {
  background: #f9f9f9;
  padding: 15px;
  border-radius: 6px;
  border-left: 3px solid #4a6bdf;
}

.node-card-mini .node-title {
  margin-bottom: 10px;
}

.node-card-mini .node-title h3 {
  font-size: 15px;
}

.node-stats {
  display: flex;
  gap: 10px;
  font-size: 13px;
}

.node-stats .stat {
  display: flex;
  align-items: center;
}

.node-stats i {
  margin-right: 5px;
}

/* 模型选择区域 */
.model-selection {
  background: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.model-selection h2 {
  font-size: 18px;
  margin-bottom: 15px;
  display: flex;
  align-items: center;
}

.model-selection h2 i {
  margin-right: 8px;
  color: #4a6bdf;
}

.model-filters {
  display: flex;
  gap: 15px;
  margin-bottom: 20px;
}

/* 模型卡片样式 */
.model-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 15px;
}

.model-card {
  background: white;
  border: 1px solid #e1e4e8;
  border-radius: 8px;
  padding: 15px;
  transition: transform 0.2s, box-shadow 0.2s;
}

.model-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.model-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.model-header h3 {
  font-size: 16px;
  color: #333;
}

.model-version {
  font-size: 12px;
  background: #f5f5f5;
  padding: 2px 6px;
  border-radius: 4px;
  color: #666;
}

.model-meta {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
  margin-bottom: 10px;
  font-size: 12px;
}

.model-type {
  padding: 2px 6px;
  border-radius: 4px;
  font-weight: bold;
}

.model-type.cv {
  background: #e3f2fd;
  color: #1976d2;
}

.model-type.nlp {
  background: #e8f5e9;
  color: #388e3c;
}

.model-type.audio {
  background: #f3e5f5;
  color: #8e24aa;
}

.model-type.analytics {
  background: #fff3e0;
  color: #e65100;
}

.model-size, .model-framework {
  color: #666;
}

.model-desc {
  font-size: 13px;
  color: #555;
  margin-bottom: 15px;
  line-height: 1.5;
}

.model-requirements {
  display: flex;
  gap: 10px;
  font-size: 12px;
  color: #666;
  margin-bottom: 15px;
  flex-wrap: wrap;
}

.model-requirements i {
  margin-right: 3px;
}

.model-actions {
  display: flex;
  gap: 10px;
}

.model-actions button {
  flex: 1;
  font-size: 13px;
  padding: 8px 10px;
}

.deploy-btn {
  background: #4a6bdf;
  color: white;
}

.details-btn {
  background: #f5f5f5;
  color: #333;
}

/* 模态框样式 */
.modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  padding: 20px;
}

.modal-content {
  background: white;
  border-radius: 8px;
  width: 500px;
  max-width: 100%;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
}

.modal-content.large {
  width: 800px;
}

.modal-header {
  padding: 15px 20px;
  border-bottom: 1px solid #e1e4e8;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.modal-header h3 {
  font-size: 18px;
  display: flex;
  align-items: center;
}

.modal-header h3 i {
  margin-right: 8px;
}

.close-btn {
  background: none;
  border: none;
  font-size: 24px;
  color: #666;
  cursor: pointer;
  padding: 0;
  line-height: 1;
}

.modal-body {
  padding: 20px;
}

.modal-actions {
  padding: 15px 20px;
  border-top: 1px solid #e1e4e8;
  display: flex;
  justify-content: flex-end;
  gap: 10px;
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
  display: flex;
  align-items: center;
}

.form-group label i {
  margin-right: 8px;
}

.form-input {
  width: 100%;
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.form-input:focus {
  outline: none;
  border-color: #4a6bdf;
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  margin-top: 20px;
}

/* 按钮变体 */
.cancel-btn {
  background: #f5f5f5;
  color: #333;
}

.submit-btn, .confirm-btn {
  background: #4a6bdf;
  color: white;
}

.confirm-btn.danger {
  background: #F44336;
}

.danger {
  background: #F44336;
  color: white;
}

.success {
  color: #4CAF50;
}

/* 兼容性检查样式 */
.compatibility-check {
  margin: 15px 0;
  padding: 15px;
  background: #f9f9f9;
  border-radius: 6px;
}

.compatibility-check h4 {
  margin-bottom: 10px;
  font-size: 15px;
}

.compatibility-check ul {
  list-style: none;
}

.compatibility-check li {
  padding: 5px 0;
  display: flex;
  align-items: center;
  font-size: 14px;
}

.compatibility-check i {
  margin-right: 8px;
}

.compatible {
  color: #4CAF50;
}

.incompatible {
  color: #F44336;
}

/* 部署节点样式 */
.deployed-node {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 0;
  border-bottom: 1px solid #eee;
}

.deployed-node:last-child {
  border-bottom: none;
}

.node-info {
  display: flex;
  align-items: center;
}

.node-info i {
  font-size: 20px;
  margin-right: 10px;
  color: #4a6bdf;
}

.node-info h4 {
  font-size: 15px;
  margin-bottom: 3px;
}

.node-info p {
  font-size: 13px;
  color: #666;
}

.deploy-status {
  font-size: 13px;
  color: #4CAF50;
  display: flex;
  align-items: center;
}

.deploy-status i {
  margin-right: 5px;
}

.deployment-summary {
  margin-top: 20px;
  padding-top: 15px;
  border-top: 1px solid #eee;
}

.deployment-summary h4 {
  margin-bottom: 10px;
  font-size: 15px;
}

.deployment-summary ul {
  list-style: none;
  font-size: 14px;
}

.deployment-summary li {
  padding: 3px 0;
}

/* 模型详情样式 */
.model-detail-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
}

.detail-section {
  margin-bottom: 20px;
}

.detail-section.full-width {
  grid-column: 1 / -1;
}

.detail-section h4 {
  font-size: 16px;
  margin-bottom: 10px;
  display: flex;
  align-items: center;
  color: #333;
}

.detail-section h4 i {
  margin-right: 8px;
  color: #4a6bdf;
}

.detail-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 14px;
}

.detail-table td {
  padding: 8px 0;
  vertical-align: top;
}

.detail-table td:first-child {
  color: #666;
  width: 120px;
}

.io-spec {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
}

.input-spec, .output-spec {
  background: #f9f9f9;
  padding: 15px;
  border-radius: 6px;
}

.input-spec h5, .output-spec h5 {
  margin-bottom: 10px;
  font-size: 15px;
}

pre {
  font-family: 'Courier New', Courier, monospace;
  font-size: 13px;
  white-space: pre-wrap;
  background: white;
  padding: 10px;
  border-radius: 4px;
  border: 1px solid #eee;
}

/* 警告消息 */
.warning-message {
  background: #fff3e0;
  padding: 10px 15px;
  border-radius: 6px;
  margin-top: 15px;
  display: flex;
  align-items: flex-start;
}

.warning-message i {
  color: #FF9800;
  margin-right: 10px;
  font-size: 18px;
}

.warning-message p {
  font-size: 14px;
  color: #666;
}

/* 过渡动画 */
.slide-enter-active, .slide-leave-active {
  transition: all 0.3s ease;
  max-height: 500px;
  overflow: hidden;
}

.slide-enter, .slide-leave-to {
  max-height: 0;
  opacity: 0;
  padding-top: 0;
  padding-bottom: 0;
  margin-top: 0;
  margin-bottom: 0;
}

/* 指标部分样式 */
.metric-section {
  margin-bottom: 20px;
  padding-bottom: 15px;
  border-bottom: 1px solid #eee;
}

.metric-section h4 {
  font-size: 15px;
  margin-bottom: 10px;
  display: flex;
  align-items: center;
}

.metric-section h4 i {
  margin-right: 8px;
  color: #4a6bdf;
}

.metric-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 15px;
}

.metric-item {
  display: flex;
  flex-direction: column;
}

.metric-label {
  font-size: 12px;
  color: #666;
  margin-bottom: 5px;
}

.metric-value {
  font-size: 14px;
}

/* 磁盘项目样式 */
.disk-item {
  margin-bottom: 15px;
}

.disk-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 5px;
}

.disk-name {
  font-size: 13px;
  font-weight: bold;
}

.disk-total {
  font-size: 12px;
  color: #666;
}

.disk-speed {
  display: flex;
  justify-content: space-between;
  font-size: 12px;
  color: #666;
  margin-top: 5px;
}

/* 网络接口样式 */
.network-interface {
  margin-top: 10px;
  padding: 8px;
  background: #f9f9f9;
  border-radius: 4px;
}

.interface-name {
  font-size: 13px;
  font-weight: bold;
  margin-bottom: 5px;
}

.interface-stats {
  display: flex;
  justify-content: space-between;
  font-size: 12px;
  color: #666;
}

/* 计量条样式 */
.meter-bar {
  height: 8px;
  background: #eee;
  border-radius: 4px;
  position: relative;
  margin: 5px 0;
}

.meter-fill {
  height: 100%;
  border-radius: 4px;
  background: #4a6bdf;
  transition: width 0.5s ease;
}

.meter-fill.high {
  background: #F44336;
}

.meter-value {
  position: absolute;
  right: 5px;
  top: -18px;
  font-size: 11px;
  color: #666;
}

/* 图标样式 */
.icon-cpu:before { content: "🖥️"; }
.icon-gpu:before { content: "🎮"; }
.icon-memory:before { content: "🧠"; }
.icon-storage:before { content: "💾"; }
.icon-network:before { content: "🌐"; }
.icon-download:before { content: "↓"; }
.icon-upload:before { content: "↑"; }

/* 响应式设计 */
@media (max-width: 1024px) {
  .deployment-content {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 768px) {
  .header {
    flex-direction: column;
    align-items: flex-start;
    gap: 15px;
  }

  .search-filter {
    flex-direction: column;
    align-items: stretch;
  }

  .nodes-list {
    grid-template-columns: 1fr;
  }

  .model-detail-grid {
    grid-template-columns: 1fr;
  }

  .io-spec {
    grid-template-columns: 1fr;
    gap: 15px;
  }
}

/* 图标字体 (使用Unicode或实际项目中引入图标库) */
.icon-server:before { content: "🖥️"; }
.icon-plus:before { content: "+"; }
.icon-upload:before { content: "↑"; }
.icon-arrow-left:before { content: "←"; }
.icon-refresh:before { content: "↻"; }
.icon-power:before { content: "⏻"; }
.icon-box:before { content: "📦"; }
.icon-clock:before { content: "🕒"; }
.icon-cpu:before { content: "🖥️"; }
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
.icon-x:before { content: "×"; }
.icon-chevron-down:before { content: "⌄"; }
/* 方案一：可折叠指标分组样式 */
.collapsible-section {
  border: 1px solid #e1e4e8;
  border-radius: 6px;
  margin-top: 10px;
  overflow: hidden;
}

.section-header {
  padding: 8px 12px;
  background: #f6f8fa;
  display: flex;
  justify-content: space-between;
  align-items: center;
  cursor: pointer;
  font-size: 13px;
  font-weight: 500;
}

.section-header:hover {
  background: #eaeef2;
}

.section-content {
  padding: 10px;
  font-size: 13px;
}

.metric-group {
  margin-bottom: 10px;
}

.metric-group h5 {
  margin: 8px 0;
  font-size: 13px;
  color: #555;
}

.metric-row {
  display: flex;
  justify-content: space-between;
  padding: 4px 0;
}

.disk-row {
  display: flex;
  align-items: center;
  margin: 5px 0;
}

.disk-name {
  width: 80px;
  font-size: 12px;
}

.disk-usage {
  flex: 1;
  display: flex;
  align-items: center;
}

.usage-bar {
  height: 8px;
  background: #4a6bdf;
  border-radius: 4px;
  margin-right: 8px;
}

.usage-text {
  font-size: 11px;
  color: #666;
}
@media (max-width: 768px) {
  .compact-metrics {
    flex-wrap: wrap;
  }
  .gauge-container {
    width: 50%;
    margin-bottom: 15px;
  }
}
/* 根据使用率设置颜色 */
.gauge {
  --fill-color: #4CAF50; /* 绿色: <60% */
}
.gauge.warning {
  --fill-color: #FFC107; /* 黄色: 60-80% */
}
.gauge.danger {
  --fill-color: #F44336; /* 红色: >80% */
}
.deployed-models {
  margin-top: 15px;
  border-top: 1px dashed #eee;
  padding-top: 10px;
}

.models-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 0;
  cursor: pointer;
  font-weight: 500;
  color: #4a6bdf;
}

.models-header:hover {
  background: #f5f7fa;
}

.models-list {
  margin-top: 8px;
  max-height: 200px;
  overflow-y: auto;
}

.model-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px;
  border-radius: 4px;
  background: #f9f9f9;
  margin-bottom: 6px;
}

.model-info {
  flex: 1;
}

.model-name {
  font-weight: 500;
}

.model-version {
  font-size: 12px;
  color: #666;
  margin-left: 8px;
}

.model-actions button {
  margin-left: 8px;
  padding: 4px 8px;
  font-size: 12px;
}

.btn-detail {
  background: #e3f2fd;
  color: #1976d2;
}

.btn-remove {
  background: #ffebee;
  color: #f44336;
}

.empty-models {
  color: #888;
  font-style: italic;
  text-align: center;
  padding: 10px;
}

.fade-enter-active, .fade-leave-active {
  transition: opacity 0.3s;
}
.fade-enter, .fade-leave-to {
  opacity: 0;
}
/* 添加调度日志和评分相关的样式 */
.scheduling-log {
  margin: 15px 0;
  padding: 15px;
  background: #f5f7fa;
  border-radius: 6px;
  max-height: 200px;
  overflow-y: auto;
}

.scheduling-log h4 {
  margin-bottom: 10px;
  font-size: 15px;
  color: #333;
  display: flex;
  align-items: center;
}

.scheduling-log h4 i {
  margin-right: 8px;
}

.log-entry {
  margin-bottom: 10px;
  padding-bottom: 10px;
  border-bottom: 1px dashed #e1e4e8;
  font-size: 13px;
}

.log-entry:last-child {
  border-bottom: none;
  margin-bottom: 0;
  padding-bottom: 0;
}

.log-timestamp {
  color: #666;
  font-size: 12px;
  margin-bottom: 3px;
}

.log-message {
  margin-bottom: 5px;
}

.log-score {
  background: #e3f2fd;
  padding: 5px 8px;
  border-radius: 4px;
  font-size: 12px;
  margin-top: 5px;
}

.score-value {
  font-weight: bold;
  color: #1976d2;
}

.score-breakdown {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-top: 5px;
  font-size: 11px;
}

.score-breakdown span {
  background: #f5f5f5;
  padding: 2px 5px;
  border-radius: 3px;
}

.node-score {
  margin-top: 10px;
  padding: 8px;
  background: #f9f9f9;
  border-radius: 4px;
}

.score-header {
  font-size: 13px;
  font-weight: bold;
  margin-bottom: 5px;
}

.score-details {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 5px;
  font-size: 12px;
}

.score-item {
  display: flex;
  justify-content: space-between;
}

.score-label {
  color: #666;
}

.icon-list:before {
  content: "📋";
}
</style>
