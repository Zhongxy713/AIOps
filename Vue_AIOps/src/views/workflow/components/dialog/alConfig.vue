<template>
  <el-drawer
      :modal="false"
      :with-header="false"
      :visible.sync="drawer"
      :direction="direction">
    <el-card class="code-card">
      <div slot="header" class="clearfix">
        <span>组件信息</span>
      </div>
      <div v-for="o in tableColumns" :key="o" class="text item" >
        {{ o[0] + ': ' + o[1] }}
      </div>
    </el-card>

    <el-table
        :data="InputArgument"
        stripe
        border
    >
      <el-table-column label="输入参数配置" header-align="center">
        <template slot-scope="scope">
          <div class="educationExperienceDiv">
            <el-input
                v-model="scope.row.input"
                placeholder=""
            />
          </div>
        </template>
      </el-table-column>
      <el-table-column
          label="操作"
          header-align="center"
      >
        <template slot-scope="scope">
          <el-button
              v-if="scope.row.show === 'true'"
              type="success"
              size="mini"
              icon="el-icon-circle-plus-outline"
              plain
              @click="pushNewInputArgument(scope.$index)"
          />
          <el-button
              type="danger"
              size="mini"
              icon="el-icon-delete"
              plain
              @click="deleteInputArgument(scope.$index)"
          />
        </template>
      </el-table-column>
    </el-table>

    <el-table
        :data="OutputArgument"
        stripe
        border
    >
      <el-table-column label="输出参数配置" header-align="center">
        <template slot-scope="scope">
          <div class="educationExperienceDiv">
            <el-input
                v-model="scope.row.output"
                placeholder=""
            />
          </div>
        </template>
      </el-table-column>
      <el-table-column
          label="操作"
          header-align="center"
      >
        <template slot-scope="scope">
          <el-button
              v-if="scope.row.show === 'true'"
              type="success"
              size="mini"
              icon="el-icon-circle-plus-outline"
              plain
              @click="pushNewOutputArgument(scope.$index)"
          />
          <el-button
              type="danger"
              size="mini"
              icon="el-icon-delete"
              plain
              @click="deleteOutputArgument(scope.$index)"
          />
        </template>
      </el-table-column>
    </el-table>
  </el-drawer>
</template>
<script>
export default {
  data() {
    return {
      drawer: false,
      direction: 'rtl',
      InputArgument: [{
        // 输入参数
        input: '',
        // 是否显示新增按钮
        show: 'true'
      }],
      OutputArgument: [{
        // 输出参数
        output: '',
        // 是否显示新增按钮
        show: 'true'
      }],
      inputParams: '',
      outputParams: '',
      selectedNode: '',
      tableData: [],
      tableColumns: [],
      NodeData: {
        // nodeName: '11111',
        // nodeDescription: '111111',
        // nodeVersion: '11111',
        // nodeDependence: '111111'
      },
      graph: null,
      node: {},
      label: "",
    }
  },
  mounted() {

  },
  methods: {
    // 添加新的输入参数
    pushNewInputArgument(index) {
      const list = this.InputArgument
      list[index].show = 'false'
      list.push({
        // 参数
        input: '',
        // 是否显示新增按钮
        show: 'true'
      })
      this.InputArgument = list
    },
    // 删除输入参数
    deleteInputArgument(index) {
      let list = this.InputArgument
      if (index === 0 && list.length === 1) {
        list.splice(index, 1)
        list.push({
          // 参数
          input: '',
          // 是否显示新增按钮
          show: 'true'
        })
      } else {
        list.splice(index, 1)
      }
      if (index === list.length) {
        list[index - 1].show = 'true'
      }
      list = this.InputArgument
    },
    // 添加新的输出参数
    pushNewOutputArgument(index) {
      const list = this.OutputArgument
      list[index].show = 'false'
      list.push({
        // 参数
        output: '',
        // 是否显示新增按钮
        show: 'true'
      })
      this.OutputArgument = list
    },
    // 删除输出参数
    deleteOutputArgument(index) {
      let list = this.OutputArgument
      if (index === 0 && list.length === 1) {
        list.splice(index, 1)
        list.push({
          // 参数
          output: '',
          // 是否显示新增按钮
          show: 'true'
        })
      } else {
        list.splice(index, 1)
      }
      if (index === list.length) {
        list[index - 1].show = 'true'
      }
      list = this.OutputArgument
    },
    nodeClick(item) {
      this.node = item
      this.tableColumns = []
      this.drawer = true
      console.log("name=", item.item.data.nodeName)
      let nodeName = item.item.data.nodeName
      console.log('nodeName11111', nodeName)
      this.request.post("/node",{
        nodeName: nodeName
      }).then(res => {
        console.log('res', res.data)
        // this.NodeData = JSON.stringify(res.data.nodeData).split(',')
        this.NodeData = res.data.data
        // for (const key in res.data.data) {
        //   if (res.data.data.hasOwnProperty.call(key)) {
        //     this.tableColumns.push(key)
        //   }
        // }
        // this.tableColumns =  Object.keys( this.NodeData).map(key => [key,  this.NodeData[key]]);
        this.tableColumns = Object.entries(this.NodeData)
        console.log('tableColumns', this.tableColumns)
        console.log('NodeData', this.NodeData)
        console.log('nodeName = ', this.NodeData.nodeName)
        console.log('nodeDependence = ', this.NodeData.node_dependence)
        console.log('nodeDescription = ', this.NodeData.node_description)
        console.log('nodeVersion = ', this.NodeData.node_version)

      })
    },
  }
}
</script>

<style>
.code-card {
  //border: #6d94f8 4px solid;
  margin:  0 0 0 5px;
  //height: calc(100vh - 50px);
}
.educationExperienceDiv {
  width: 100%;
  overflow: hidden;
  border: 1px solid rgb(231, 227, 227);
  border-radius: 10px;
  .el-input__inner {
    border: none;
  }
}
.text {
  font-size: 14px;
}

.item {
  margin-bottom: 18px;
}
img {
  max-width: 100%;
  height: auto;
}
</style>
