<template>
  <div>
    <el-row>
      <el-col :span="24">
        <!-- Algorithm Model List Section -->
        <el-card  shadow="hover">
          <h3>算法管道模型</h3>
          <el-row :gutter="10">
            <el-col :span="8" v-for="algorithm in algorithmModels" :key="algorithm.id">
              <el-card class="algorithm-card" shadow="hover">
                <el-container>
                  <el-aside width="60px">
                      <img src="../../assets/svg/魔方-copy-copy.svg"  style="width: 50px; height: 50px; margin-top: 20px"/>
                  </el-aside>
                  <el-main>
                    <p>{{ algorithm.name }}</p>
                  </el-main>
                </el-container>
              </el-card>
            </el-col>
          </el-row>
          <!-- 分页组件 -->
          <el-pagination
              @size-change="handleSizeChange"
              @current-change="handleCurrentChange"
              style="margin-top: 20px;"
              background
              :current-page="pageNum"
              :page-sizes="[3, 5, 10, 20]"
              :page-size="pageSize"
              layout="total, sizes, prev, pager, next, jumper"
              :total="total">
          </el-pagination>
        </el-card>
      </el-col>
    </el-row>
      <el-row>
      <el-col :span="24">
    <!-- Buttons in between -->
    <div class="buttons-container">
      <el-button class="deploy-button" type="primary" @click="deployToNode">
        部署到选中节点
      </el-button>
      <el-button class="schedule-button" type="success" @click="autoSchedule">
        自动调度部署
      </el-button>
    </div>
      </el-col>
      </el-row>
      <el-row>
      <el-col :span="24">
    <!-- Deployment Node Information Section -->
    <el-card  shadow="hover">
      <h3>可部署节点</h3>
      <el-row :gutter="20">
        <!-- Iterate through deployment nodes -->
        <el-col :span="6" v-for="(node, index) in deploymentNodes" :key="index">
          <el-card class="node-card" shadow="hover">
            <div class="node-details">
<!--              <el-avatar icon="el-icon-server" size="large" />-->
              <img src="../../assets/svg/node.svg" alt="Node" class="cluster-icon" style="width: 50px; height: 50px;"/>
              <h4>{{ node.name }}</h4>
              <p>{{ node.status }}</p>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import {getAPMData} from "@/axios/node";

export default {
  data() {
    return {
      // Algorithm models data
      algorithmModels: [
        { name: 'TestAPM01', description: 'Recommendation algorithm based on user similarity.' },
        { name: 'TestAPM02', description: 'Recommendation algorithm using matrix decomposition.' },
        { name: 'TestAPM03', description: 'Unsupervised learning algorithm for clustering.' },
      ],
      // Deployment nodes data
      deploymentNodes: [
        { name: 'node-b99pj', status: 'Active' },
        { name: 'node-l47qj', status: 'Active' },
        { name: 'node-mp5q6', status: 'Active' },
        { name: 'node-9q7q6', status: 'Active' },
          // Add more nodes here
        { name: 'node-9q7q6', status: 'Active' },
        { name: 'node-9q7q6', status: 'Active' },
        { name: 'node-9q7q6', status: 'Active' },
        { name: 'node-9q7q6', status: 'Active' },
        { name: 'node-9q7q6', status: 'Active' },
        { name: 'node-9q7q6', status: 'Active' },
        { name: 'node-9q7q6', status: 'Active' },
        { name: 'node-9q7q6', status: 'Active' },
        { name: 'node-9q7q6', status: 'Active' },
        { name: 'node-9q7q6', status: 'Active' },
      ],
      pageNum: 1,
      APMName: "",
      currentPage: 1, // 当前页码
      pageSize: 3, // 每页显示的算法数量
      tableData: [],
      total: 0,
    };
  },
  computed: {
  },
  created() {
    this.getAllAPMData()
  },
  methods: {
    // Handle deploy to specified node
    deployToNode() {
      console.log("Deploying algorithm model to the specified node...");
    },
    // Handle auto schedule
    autoSchedule() {
      console.log("Automatically scheduling algorithm models to nodes...");
    },
    // 处理搜索
    handleSearch() {
      this.currentPage = 1; // 搜索时重置到第一页
    },
    handleSizeChange(pageSize) {
      console.log(pageSize)
      this.pageSize = pageSize
      this.getAllAPMData()
    },
    handleCurrentChange(pageNum) {
      console.log(pageNum)
      this.pageNum = pageNum
      this.getAllAPMData()
    },
    getAllAPMData() {
      let param = {
        pageNum: this.pageNum,
        pageSize: this.pageSize,
        apmName: this.APMName
      }
      getAPMData(param).then(res => {

        this.tableData = res.data.records
        this.total = res.data.total
        console.log(this.tableData)
        console.log(this.total)
      })
    }
  },
};
</script>

<style scoped>
.main-container {
  display: flex;
  justify-content: space-between;
  padding: 20px;
}

.algorithm-models,
.deployment-nodes {
  width: 45%;
}

h3 {
  font-size: 20px;
  font-weight: bold;
  margin-bottom: 20px;
}

.model-card,
.node-card {
  padding: 20px;
  border-radius: 10px;
}

.model-details,
.node-details {
  text-align: center;
}

.model-details h4,
.node-details h4 {
  font-size: 18px;
  margin-bottom: 10px;
}

.model-details p,
.node-details p {
  font-size: 14px;
  color: #409EFF;
}

.buttons-container {
  display: flex;
  justify-content: center;
  margin: 20px 0;
}

.deploy-button,
.schedule-button {
  margin: 0 10px;
  height: 50px;
  width: 160px;
  font-size: large;
}

.el-avatar {
  margin-bottom: 10px;
}
.el-row {
  margin-bottom: 20px;
  &:last-child {
    margin-bottom: 0;
  }
}
.el-col {
  border-radius: 4px;
}
.algorithm-card {
  margin-bottom: 20px;
  padding: 20px;
  border-radius: 10px;
}
</style>
