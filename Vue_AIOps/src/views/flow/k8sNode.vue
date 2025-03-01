<template>
  <div class="dashboard-container">
    <el-header>
      <el-row>
        <el-button type="primary" size="medium">部署新算法管道模型</el-button>
        <el-button type="success" size="medium">新增部署节点</el-button>
        <el-button type="info" size="medium" @click="drawer = true">查看调度信息</el-button>
      </el-row>
    </el-header>
    <!-- Main Content -->
    <el-main>
      <!-- Resource Cards -->
      <div class="nodes-container">
        <h3>Nodes</h3>
        <div class="scrollable-window">
          <!-- Horizontal Scroll Container -->
          <div class="scroll-container">
            <el-row :gutter="20">
              <!-- Iterate through nodes -->
              <el-col :span="8" v-for="node in resources" :key="node.name">
                <el-card class="node-card" shadow="hover">
                  <el-row :gutter="10">
                    <!-- Icon and Title Section -->
                    <el-col :span="10">
                      <img src="../../assets/svg/node.svg"  style="width: 40px; height: 40px;"/>
                    </el-col>
                    <el-col :span="10">
                      <div>
                        <el-button type="text" @click="dialogFormVisible = true">{{ node.name }}</el-button>
                      </div>
                    </el-col>
                  </el-row>
                  <el-row :gutter="10">
                    <!-- Status Section -->
                    <el-col :span="10">
                      <div style="margin-top: 3px">
                        <el-tag type="success">{{ node.status }}</el-tag>
                      </div>
                    </el-col>
                    <el-col :span="10">
                      <div style="margin-left: 10px">
                        <span>{{ node.timeAgo }}</span>
                      </div>
                    </el-col>
                  </el-row>
                </el-card>
              </el-col>
            </el-row>
          </div>
        </div>
      </div>

      <el-dialog title="部署信息" :visible.sync="dialogFormVisible">
        <!-- Compute Resources Section -->
            <h3>已部署算法管道模型</h3>
            <el-row :gutter="20">
              <el-col :span="8" v-for="(node, index) in computeResources" :key="index">
                <el-card class="small-card" shadow="hover">
                  <el-aside>
                    <img src="../../assets/svg/pod.svg"  style="width: 40px; height: 40px;"/>
                  </el-aside>
                  <el-main>
                  <h4>{{ node.name }}</h4>
                  <p>IP: {{ node.ip }}</p>
                  <p>Status: {{ node.status }}</p>
                  <span>{{ node.lastUpdated }}</span>
                  </el-main>
                </el-card>
              </el-col>
            </el-row>
        <div slot="footer" class="dialog-footer">
          <el-button @click="dialogFormVisible = false">取 消</el-button>
          <el-button type="primary" @click="dialogFormVisible = false">确 定</el-button>
        </div>
      </el-dialog>

      <el-dialog
          title="调度日志"
          :visible.sync="drawer"
          >
        <div class="schedule-container">
          <h2>Filter</h2>
          <!-- Filter Table -->
          <el-table :data="filterData" border style="width: 100%" :current-page="currentPage" :page-size="pageSize">
            <el-table-column prop="node" label="Node" width="180"></el-table-column>
            <el-table-column prop="nodeName" label="NodeName" width="180"></el-table-column>
            <el-table-column prop="nodeResourcesFit" label="NodeResourcesFit" width="180"></el-table-column>
            <el-table-column prop="nodeUnschedulable" label="NodeUnschedulable" width="180"></el-table-column>
            <el-table-column prop="taintToleration" label="TaintToleration" width="180"></el-table-column>
            <el-pagination
                :page-size="pageSize"
                :current-page="currentPage"
                :total="filterData.length"
                layout="total, sizes, prev, pager, next"
                @current-change="handlePageChange"
                @size-change="handleSizeChange"
            ></el-pagination>
          </el-table>

          <h2>Score</h2>
          <!-- Score Table -->
          <el-table :data="scoreData" border style="width: 100%" :current-page="currentPage" :page-size="pageSize">
            <el-table-column prop="node" label="Node" width="180"></el-table-column>
            <el-table-column prop="imageLocality" label="ImageLocality" width="180"></el-table-column>
            <el-table-column prop="nodeResourcesBalancedAllocation" label="NodeResourcesBalancedAllocation" width="220"></el-table-column>
            <el-table-column prop="nodeResourcesFit" label="NodeResourcesFit" width="180"></el-table-column>
            <el-table-column prop="taintToleration" label="TaintToleration" width="180"></el-table-column>
            <el-pagination
                :page-size="pageSize"
                :current-page="currentPage"
                :total="scoreData.length"
                layout="total, sizes, prev, pager, next"
                @current-change="handlePageChange"
                @size-change="handleSizeChange"
            ></el-pagination>
          </el-table>

          <h2>Final Score (Normalized + Applied plugin weight)</h2>
          <!-- Final Score Table -->
          <el-table :data="finalScoreData" border style="width: 100%" :current-page="currentPage" :page-size="pageSize">
            <el-table-column prop="node" label="Node" width="180"></el-table-column>
            <el-table-column prop="imageLocality" label="ImageLocality" width="180"></el-table-column>
            <el-table-column prop="nodeResourcesBalancedAllocation" label="NodeResourcesBalancedAllocation" width="220"></el-table-column>
            <el-table-column prop="nodeResourcesFit" label="NodeResourcesFit" width="180"></el-table-column>
            <el-table-column prop="taintToleration" label="TaintToleration" width="180"></el-table-column>
            <el-pagination
                :page-size="pageSize"
                :current-page="currentPage"
                :total="finalScoreData.length"
                layout="total, sizes, prev, pager, next"
                @current-change="handlePageChange"
                @size-change="handleSizeChange"
            ></el-pagination>
          </el-table>
        </div>

      </el-dialog>

      <!-- Storage Resources Section -->
      <div class="storage-resources">
        <el-card class="section-card" shadow="hover">
          <h3>存储资源</h3>
          <el-row :gutter="20">
            <el-col :span="8" v-for="(storage, index) in storageResources" :key="index">
              <el-card class="small-card" shadow="hover">
                <h4>{{ storage.storageClass }}</h4>
                <p>PV Count: {{ storage.pvCount }}</p>
                <p>Status: {{ storage.status }}</p>
              </el-card>
            </el-col>
          </el-row>
        </el-card>
      </div>
    </el-main>

  </div>
</template>

<script>
export default {
  data() {
    return {
      activeTab: "default",
      // The icon for the card
      icon: 'el-icon-star',
      // Resource data
      resources: [
        { name: "node-abc", status: "Active", timeAgo: "大约 20 小时", icon: "el-icon-s-management" },
        { name: "node-def", status: "Active", timeAgo: "大约 20 小时", icon: "el-icon-s-grid" },
        { name: "node-ghi", status: "Active", timeAgo: "大约 20 小时", icon: "el-icon-s-tools" },
        { name: "node-jkl", status: "Active", timeAgo: "大约 20 小时", icon: "el-icon-s-platform" },
        { name: "node-mno", status: "Active", timeAgo: "大约 20 小时", icon: "el-icon-s-home" },
        { name: "node-pqr", status: "Active", timeAgo: "大约 20 小时", icon: "el-icon-s-management" },
        { name: "node-stu", status: "Active", timeAgo: "大约 20 小时", icon: "el-icon-s-grid" },
        { name: "node-vwx", status: "Active", timeAgo: "大约 20 小时", icon: "el-icon-s-tools" },
        { name: "node-yz", status: "Active", timeAgo: "大约 20 小时", icon: "el-icon-s-platform"},
      ],
      computeResources: [
        { name: "testAPM01", ip: "10.8.42.15", status: "Ready", lastUpdated: "20 minutes ago" },
        { name: "testAPM02", ip: "10.8.42.16", status: "Ready", lastUpdated: "20 minutes ago" },
        { name: "testAPM03", ip: "10.8.42.17", status: "Ready", lastUpdated: "20 minutes ago" }
      ],
      storageResources: [
        { storageClass: "Standard", pvCount: 0, status: "No PVs" },
        { storageClass: "SSD", pvCount: 2, status: "Available" }
      ],
      dialogTableVisible: false,
      dialogFormVisible: false,
      drawer: false,
      direction: 'rtl',

      currentPage: 1,
      pageSize: 3,
      filterData: [
        { node: 'node-b99pj', nodeName: 'passed', nodeResourcesFit: 'passed', nodeUnschedulable: 'passed', taintToleration: 'passed' },
        { node: 'node-l47qj', nodeName: 'passed', nodeResourcesFit: 'passed', nodeUnschedulable: 'passed', taintToleration: 'passed' },
        { node: 'node-mp5q6', nodeName: 'passed', nodeResourcesFit: 'passed', nodeUnschedulable: 'passed', taintToleration: 'passed' },
      ],
      scoreData: [
        { node: 'node-b99pj', imageLocality: 0, nodeResourcesBalancedAllocation: 76, nodeResourcesFit: 73, taintToleration: 0 },
        { node: 'node-l47qj', imageLocality: 0, nodeResourcesBalancedAllocation: 76, nodeResourcesFit: 73, taintToleration: 0 },
        { node: 'node-mp5q6', imageLocality: 0, nodeResourcesBalancedAllocation: 76, nodeResourcesFit: 73, taintToleration: 0 },
      ],
      finalScoreData: [
        { node: 'node-b99pj', imageLocality: 0, nodeResourcesBalancedAllocation: 76, nodeResourcesFit: 73, taintToleration: 300 },
        { node: 'node-l47qj', imageLocality: 0, nodeResourcesBalancedAllocation: 76, nodeResourcesFit: 73, taintToleration: 300 },
        { node: 'node-mp5q6', imageLocality: 0, nodeResourcesBalancedAllocation: 76, nodeResourcesFit: 73, taintToleration: 300 },
      ],
    };
  },
  methods: {
    handlePageChange(page) {
      this.currentPage = page;
    },
    handleSizeChange(size) {
      this.pageSize = size;
    }
  }
};
</script>

<style scoped>
.dashboard-container {
  padding: 20px;
}
.scrollable-window {
  padding: 20px;
}

.scroll-container {
  overflow-x: auto;
  white-space: nowrap;
  padding-bottom: 10px;
}
.resource-cards {
  margin-top: 20px;
}

.resource-card {
  padding: 20px;
  border-radius: 10px;
  text-align: center;
}

.section-card {
  padding: 20px;
  border-radius: 10px;
  margin-top: 30px;
}

.small-card {
  padding: 15px;
  border-radius: 10px;
  text-align: center;
}
p {
  margin: 5px 0;
}
.nodes-container {
   padding: 20px;
 }

h3 {
  font-size: 20px;
  font-weight: bold;
  margin-bottom: 20px;
}

.node-card {
  padding: 20px;
  border-radius: 10px;
}

.node-name {
  font-size: 18px;
  margin-bottom: 10px;
}
.el-table {
  margin-bottom: 20px;
}

.el-pagination {
  margin-top: 10px;
}
</style>
