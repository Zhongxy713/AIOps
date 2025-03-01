<template>
  <div class="upload-model">
    <!-- 步骤条 -->
    <el-steps :active="activeStep" align-center>
      <el-step title="创建模型" />
      <el-step title="上传版本" />
    </el-steps>

    <!-- 表单 -->
    <el-form :model="form" label-width="120px" style="margin-top: 30px">
      <el-form-item label="模型名称" prop="modelName" :rules="[{ required: true, message: '请输入模型名称', trigger: 'blur' }]">
        <el-input v-model="form.modelName" maxlength="32" placeholder="请输入模型名称" />
      </el-form-item>

      <el-form-item label="框架" prop="framework" :rules="[{ required: true, message: '请选择框架', trigger: 'change' }]">
        <el-select v-model="form.framework" placeholder="请选择框架">
          <el-option label="TensorFlow" value="tensorflow" />
          <el-option label="PyTorch" value="pytorch" />
          <el-option label="Keras" value="keras" />
        </el-select>
      </el-form-item>

      <el-form-item label="模型格式" prop="modelFormat" :rules="[{ required: true, message: '请选择模型格式', trigger: 'change' }]">
        <el-select v-model="form.modelFormat" placeholder="请选择模型格式">
          <el-option label="SavedModel" value="savedmodel" />
          <el-option label="H5" value="h5" />
          <el-option label="ONNX" value="onnx" />
        </el-select>
      </el-form-item>

      <el-form-item label="模型类别" prop="modelCategory" :rules="[{ required: true, message: '请选择模型类别', trigger: 'change' }]">
        <el-select v-model="form.modelCategory" placeholder="请选择模型类别">
          <el-option label="图像分类" value="image-classification" />
          <el-option label="文本分类" value="text-classification" />
          <el-option label="目标检测" value="object-detection" />
        </el-select>
      </el-form-item>

      <el-form-item label="模型描述" prop="description">
        <el-input type="textarea" v-model="form.description" maxlength="255" placeholder="请输入模型描述" />
      </el-form-item>

      <!-- 操作按钮 -->
      <div class="form-actions">
        <el-button @click="cancelForm" class="cancel-btn">取消</el-button>
        <el-button type="primary" @click="nextStep" :loading="loading">下一步</el-button>
      </div>
    </el-form>
  </div>
</template>

<script>
export default {
  data() {
    return {
      activeStep: 0, // 当前步骤
      form: {
        modelName: '',
        framework: '',
        modelFormat: '',
        modelCategory: '',
        description: ''
      },
      loading: false, // 按钮加载状态
    };
  },
  methods: {
    cancelForm() {
      // 重置表单或关闭对话框
      this.$message.info("取消操作");
    },
    nextStep() {
      this.loading = true;
      // 处理表单提交逻辑
      setTimeout(() => {
        this.activeStep++;
        this.loading = false;
      }, 1000);
    },
  }
};
</script>

<style scoped>
.upload-model {
  width: 600px;
  margin: 50px auto;
  padding: 20px;
  background-color: #fff;
  border-radius: 8px;
}

.el-steps {
  margin-bottom: 30px;
}

.el-form-item {
  margin-bottom: 20px;
}

.form-actions {
  display: flex;
  justify-content: space-between;
  margin-top: 20px;
}

.cancel-btn {
  background-color: #f0f0f0;
}
</style>
