<template>
  <a-tabs type="card" defaultActiveKey="1" size="small">
    <a-tab-pane key="1" tab="参数">
      <el-form :model="paramForm" ref="dynamicValidateForm"  style="margin: 0 15px 0 15px">
        <el-form-item
            label="组件名称">
          <el-input v-model="this.curLabel" :disabled="true"></el-input>
        </el-form-item>
        <el-form-item v-for="index in paramForm.paramCount" :key="index" :label="paramForm.paramNamesZh[index - 1]">
          <el-input  v-model="paramForm.paramValues[index - 1]" :placeholder="'请输入参数' + index"></el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="submitForm('paramForm')">保存</el-button>
        </el-form-item>
      </el-form>
    </a-tab-pane>
  </a-tabs>
</template>

<script>
import {Node} from '@antv/x6'
export default {
  name: 'NodeConfigContainer',
  props: {
    node: Node
  },
  data () {
    return {
      dynamicValidateForm: {
        domains: [{
          value: ''
        }],
        email: ''
      },
      paramForm:{},
      curNode: Node,
      form: this.$form.createForm(this, {name: 'configPanel'}),
      curLabel: '',
      curNodeName:'',
      // 算法参数数据
      alForm:{
        algorithmName: '', // 算法名称
        param1: '',        // 参数1
        param2: 0,         // 参数2
        algorithmType: '', // 算法类型
        enableAlgorithm: false, // 是否启用
      },
    }
  },
  mounted() {
    // getNodeParam()
  },
  methods: {
    submitForm() {
        // 将信息序列化为 JSON 并存储到 sessionStorage 中
        sessionStorage.setItem(this.curNodeName, JSON.stringify(this.paramForm));
        // 显示提交成功的提示
        this.$message({
          message: '信息已提交并存储！',
          type: 'success'
        });
    },
  },
  watch: {
    node (newValue) {
      console.log("得到node： ", newValue)
      this.curNode = newValue
      this.curLabel = this.curNode.data.nodeTitle
      this.curNodeName = this.curNode.data.nodeName
      console.log("curLabel: ", this.curLabel)
      this.curFontSize = this.curNode.attrs ? this.curNode.attrs.text.fontSize : ''
      console.log("curFontSize: ", this.curFontSize)
      this.paramForm = sessionStorage.getItem(this.curNodeName) ? JSON.parse(sessionStorage.getItem(this.curNodeName)) : {}
    },
    curNode (newValue) {
      console.log("updateData")
      this.$emit('updateData', newValue)
      console.log("updateData END")
    }
  }
}
</script>

<style scoped>
.color-container {
  margin-top: 8px;
  width: 24px;
  height: 24px;
  padding: 4px;
  border: 1px solid #dfe3e8;
  border-radius: 2px;
}
.edit-color {
  cursor: pointer;
  height: 100%;
}
</style>
