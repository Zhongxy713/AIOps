<template>
  <div class="kubernetes-container">
    <h3>集群列表</h3>
    <!-- Kubernetes Cluster Info Section -->
      <el-row :gutter="20">
        <el-card class="cluster-card" shadow="hover">
        <!-- Left Column: Cluster Info -->
        <el-col :span="6">
          <div class="cluster-info">
<!--            <el-avatar icon="el-icon-flag" class="cluster-icon"></el-avatar>-->
            <img src="../../assets/svg/kubernetes-logo.svg" alt="Kubernetes Logo" class="cluster-icon" style="width: 50px; height: 50px;"/>
            <div>
              <h3>{{ cluster.name }}</h3>
              <p>{{ cluster.status }}</p>
              <p>K8S {{ cluster.version }}</p>
              <p>{{ cluster.command }}</p>
            </div>
          </div>
        </el-col>
        </el-card>
      </el-row>
      <el-row :gutter="20" style="margin-top: 20px">
        <!-- Right Column: Add Cluster -->
        <el-col :span="6">
          <el-button class="add-cluster-button" icon="el-icon-plus" @click="addCluster">
            添加集群
          </el-button>
        </el-col>
      </el-row>

  </div>
</template>

<script>
export default {
  data() {
    return {
      // Cluster Information
      cluster: {
        name: "xxx",
        status: "已连接",
        version: "v1.28.2",
        command: "cat /etc/kubernetes/admin.conf"
      }
    };
  },
  methods: {
    addCluster() {
      // Handle adding a new cluster (can be expanded with functionality)
      console.log("Add new cluster functionality here.");
    }
  }
};
</script>

<style scoped>
.kubernetes-container {
  padding: 20px;
}

.cluster-card {
  padding: 20px;
}

.cluster-info {
  display: flex;
  align-items: center;
}

.cluster-icon {
  margin-right: 15px;
  font-size: 30px;
  color: #409EFF;
}

h3 {
  margin-bottom: 10px;
  font-size: 18px;
  font-weight: bold;
}

p {
  margin: 5px 0;
  font-size: 14px;
  color: #999;
}

.add-cluster-button {
  width: 100%;
  height: 100%;
  background-color: #f5f7fa;
  color: #409EFF;
  border-radius: 10px;
  font-size: 16px;
  text-align: center;
}

.add-cluster-button:hover {
  background-color: #e6f7ff;
}
</style>
