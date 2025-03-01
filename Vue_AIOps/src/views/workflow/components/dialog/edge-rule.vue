<template>
  <el-drawer
      :modal="false"
      :with-header="false"
      :visible.sync="drawer"
      :direction="direction">
    <div>
      <el-select v-model="selectedPage" placeholder="Select a page" @change="navigateToPage">
        <el-option label="Page 1" value="page1"></el-option>
        <el-option label="Page 2" value="page2"></el-option>
      </el-select>
    </div>
    <DialogPageOne ref="pageOne"></DialogPageOne>
    <DialogPageTwo ref="pageTwo"></DialogPageTwo>

  </el-drawer>
</template>
<script>
import DialogPageOne from '@/views/workflow/components/pageOne.vue'
import DialogPageTwo from '@/views/workflow/components/pageTwo.vue'

export default {
  components: {DialogPageOne, DialogPageTwo},
  data() {
    return {
      drawer: false,
      direction: 'rtl',
      selectedPage: 'page1',
      node: {},
      label: "",
    }
  },
  mounted() {

  },
  methods: {
    navigateToPage(value) {
      // this.$router.push(value);
      if(value === 'page1') {
        this.$refs.pageTwo.visible = false;
        this.$refs.pageOne.visible = true;
      } else if(value === 'page2') {
        this.$refs.pageOne.visible = false;
        this.$refs.pageTwo.visible = true;
      }
    },

    edgeClick(item) {
      this.node = item
      this.tableColumns = []
      this.drawer = true
      console.log("item=", item)
      console.log("name=", item.data.nodeName)
      let nodeName = item.data.nodeName
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
#rule {
  border: 2px solid #333;
  height: 80vh;
  min-height: 80vh;
}
</style>
