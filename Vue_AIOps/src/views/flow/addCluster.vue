<template>
  <div class="kubernetes-cluster-form">

    <el-form :model="form" label-width="120px">
      <el-form-item label="集群名称">
        <el-input  />
      </el-form-item>

      <el-form-item label="描述">
        <el-input  placeholder="请输入 " />
      </el-form-item>
    </el-form>
    <!-- Tabs -->
    <el-tabs v-model="activeTab">
      <el-tab-pane label="Token" name="token">
        <!-- Token Section -->
        <div class="token-section">
          <el-row :gutter="20">
            <el-col :span="24">
              <!-- Code block to display the script -->
              <el-card class="code-card" shadow="hover">
                <pre class="code-block">{{ scriptText }}</pre>
                <el-button class="copy-button" icon="el-icon-copy-document" @click="copyScript">复制</el-button>
              </el-card>
            </el-col>
          </el-row>
          <el-form :model="form" label-width="120px">
            <el-form-item label="ApiServer 地址">
              <el-input v-model="form.apiServer" placeholder="请输入 API 地址" />
            </el-form-item>

            <el-form-item label="Token">
              <el-input v-model="form.token" placeholder="请输入 Token" />
            </el-form-item>
          </el-form>
        </div>
      </el-tab-pane>

      <el-tab-pane label="KubeConfig" name="kubeconfig">
        <div>这里是 KubeConfig 配置内容</div>
      </el-tab-pane>

      <el-tab-pane label="Kubernetes Agent" name="k8s-agent">
        <div>这里是 Kubernetes Agent 配置内容</div>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
export default {
  data() {
    return {
      activeTab: 'token', // Default tab
      form: {
        apiServer: '',
        token: '',
      },
      // Example script text
      scriptText: `cat << EOF > kuboard-create-token.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: kuboard
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: kuboard-admin
  namespace: kuboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  ......`,
    };
  },
  methods: {
    // Method to handle copy action
    copyScript() {
      const el = document.createElement('textarea');
      el.value = this.scriptText;
      document.body.appendChild(el);
      el.select();
      document.execCommand('copy');
      document.body.removeChild(el);
      this.$message.success('脚本已复制');
    }
  }
};
</script>

<style scoped>
.kubernetes-cluster-form {
  padding: 20px;
}

.token-section h3 {
  font-size: 18px;
  font-weight: bold;
  margin-top: 20px;
}

.code-card {
  position: relative;
}

.code-block {
  background-color: #f4f4f4;
  padding: 20px;
  font-size: 14px;
  white-space: pre-wrap;
  word-wrap: break-word;
  color: #333;
}

.copy-button {
  position: absolute;
  top: 10px;
  right: 10px;
}

.el-input {
  width: 100%;
}

.el-button {
  margin-top: 20px;
}

.el-tabs__nav {
  margin-bottom: 20px;
}
</style>
