<template>
  <div id="header">
    <a-tooltip title="放大">
      <span class="iconfont header-iconfont" @click="()=>{this.graph.zoom(0.2)}">&#xe898;</span>
    </a-tooltip>
    <a-tooltip title="缩小">
      <span class="iconfont header-iconfont" @click="()=>{this.graph.zoom(-0.2)}">&#xe897;</span>
    </a-tooltip>
    <a-tooltip title="撤销">
      <span class="iconfont header-iconfont" @click="()=>{this.graph.history.undo()}">&#xe739;</span>
    </a-tooltip>
    <a-tooltip title="取消撤销">
      <span class="iconfont header-iconfont" @click="()=>{this.graph.history.redo()}">&#xe652;</span>
    </a-tooltip>
    <a-tooltip title="全屏">
      <span class="iconfont header-iconfont" @click="()=>{this.$emit('full',true)}">&#xec13;</span>
    </a-tooltip>
    <a-tooltip title="退出全屏">
      <span class="iconfont header-iconfont" @click="()=>{this.$emit('full',false)}">&#xe7d6;</span>
    </a-tooltip>
    <a-tooltip title="导出">
      <span class="iconfont header-iconfont" @click="handleAdd">&#xe64a;</span>
    </a-tooltip>
    <el-dialog  title="算法管道模型信息" :visible.sync="dialogFormVisible" width="30%" >
      <el-form label-width="80px" size="small">
        <el-form-item label="算法管道模型名称">
          <el-input v-model="APMData.apmName" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="创建者">
          <el-input v-model="APMData.createAuthor" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="描述">
          <el-input v-model="APMData.description" autocomplete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取 消</el-button>
        <el-button type="primary" @click="save">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { Graph } from '@antv/x6'
import {saveAPMData, saveParamData} from "@/axios/node";
import '@antv/x6-vue-shape'
// import FlowGraph from './JS/initStencil'

export default {
  name: 'GraphConfigContainer',
  props: {
    graph: Graph
  },
  data () {
    return {
      nodeNames:[],
      APMData:{},
      dialogFormVisible: false,
    }
  },
  created() {
    // this.getAPMJson()
  },
  mounted() {
    this.getAPMJson()
  },
  methods: {


    // 导入
    // async load() {
    //   await this.getAPMJson()
    //   // console.log("导入算法管道模型：", JSON.parse(this.apmJson))
    //   // 检查 this.APMData.apmJson 是否存在并且不是空字符串
    //   if (this.apmJson) {
    //     try {
    //       // const apmJsonParsed = JSON.parse(this.apmJson);  // 尝试解析 JSON
    //       // console.log(apmJsonParsed);
    //       // this.graph.fromJSON(apmJsonParsed); // 如果需要用，可以解开注释
    //
    //     } catch (error) {
    //       console.error('Error parsing JSON:', error);
    //     }
    //   } else {
    //     console.warn('No valid APM JSON data found.');
    //   }
    //
    //
    //   // this.$emit('load', JSON.parse(this.apmJson))
    // },

    handleAdd() {
      this.dialogFormVisible = true
      this.APMData = {}
    },
    // 导出
    save () {
      // console.log(this.graph.toJSON())
      this.exportToJson()

      // 保存参数数据


      // let paramList = sessionStorage.getItem('imgInput') ? JSON.parse(sessionStorage.getItem('imgInput')) : {}
      // saveParamData(paramList).then(res => {
      //   console.log(res)
      // })

      // this.saveNodeDataFromSessionStorage(this.nodeNames)
       this.saveAPMData()

      this.dialogFormVisible = false
    },
    // 处理 nodeNames 数组中的节点，获取 sessionStorage 数据并保存
    async saveNodeDataFromSessionStorage(nodeNames) {
      for (const nodeName of nodeNames) {
        const nodeData = sessionStorage.getItem(nodeName);
        if (nodeData) {
          const parsedData = JSON.parse(nodeData);  // 解析 sessionStorage 的 JSON 数据
          await this.saveParam(parsedData)
        } else {
          console.warn(`未找到 ${nodeName} 对应的数据`);
        }
      }
    },
    async saveParam(nodeData){
      console.log('保存节点数据：', nodeData)
      try {
        // 发送请求保存数据
        await saveParamData(nodeData).then(res => {
          console.log(res)
        });  // 等待保存完成再继续
      } catch (error) {
        console.error('请求失败，节点数据保存失败', error);
      }
    },

    saveAPMData(){
      // 保存算法管道模型数据

      console.log("保存算法管道模型：", this.APMData)
      saveAPMData(this.APMData).then(res => {
        console.log("保存算法管道模型成功")
        console.log(res)
      })
    },

    exportToJson() {
      // 获取所有节点和边
      const cells = this.graph.getCells();

      // 用于存储节点和边的自定义格式
      const nodes = [];
      const edges = [];

      // 遍历所有的 cells，分别处理节点和边
      cells.forEach(cell => {
        if (cell.isNode()) {
          // 自定义节点的导出格式
          const nodeData = {
            id: cell.id,
            data: cell.getData(),   // 假设你给节点定义了自定义的数据
          };
          nodes.push(nodeData);
        } else if (cell.isEdge()) {

          // 获取边的标签
          const label = cell.getLabels();

          // 提取 labelText 中的 text 值
          let labelTextValue = null;
          if (label && Array.isArray(label) && label.length > 0) {
            labelTextValue = label[0]?.attrs?.labelText?.text || null;
          }

          // 自定义边的导出格式
          const edgeData = {
            id: cell.id,
            source: cell.getSource(), // 源节点
            target: cell.getTarget(), // 目标节点
            label: labelTextValue,   // 边的标签（如果有的话）
          };
          edges.push(edgeData);
        }
      });

      // 将节点和边的信息打包成自定义 JSON
      const jsonData = {
        nodes: nodes,
        edges: edges,
      };

      this.analyzeJson(jsonData)
      // 将对象转换为 JSON 字符串
      // const jsonString = JSON.stringify(customJson, null, 2);



      // // 下载 JSON 文件
      // const blob = new Blob([jsonString], { type: 'application/json' });
      // const url = URL.createObjectURL(blob);
      //
      // const a = document.createElement('a');
      // a.href = url;
      // a.download = 'graph-data.json'; // 文件名
      // a.click();
      // URL.revokeObjectURL(url);
    },

    // 解析Json
    analyzeJson(jsonData){

      // 提取nodes中的数据为一个对象，以便通过id快速访问
      const nodeMap = jsonData.nodes.reduce((map, node) => {
        map[node.id] = node.data.id;
        return map;
      }, {});

      // 提取nodes中的数据为一个对象，以便通过id快速访问nodeName
      const nodeNameMap = jsonData.nodes.reduce((map, node) => {
        map[node.id] = node.data.nodeName;
        return map;
      }, {});


      // 初始化结果集合
      const edgeWithoutLabel = [];
      const edgeWithLabel = [];
      const nodeIds = [];


      // 处理edges，根据label是否为null，分类并生成集合
      jsonData.edges.forEach(edge => {
        const sourceId = nodeMap[edge.source.cell];
        const targetId = nodeMap[edge.target.cell];

        // 判断label是否为null
        if (edge.label === null) {
          edgeWithoutLabel.push([sourceId, targetId]);

          // 按照无 label 的边顺序添加节点到 nodeIds，确保不重复
          if (!nodeIds.includes(sourceId)) {
            nodeIds.push(sourceId);
            this.nodeNames.push(nodeNameMap[edge.source.cell])
          }
          if (!nodeIds.includes(targetId)) {
            nodeIds.push(targetId);
            this.nodeNames.push(nodeNameMap[edge.target.cell])
          }
        } else {
          edgeWithLabel.push([sourceId, targetId, edge.label]);
        }
      });

      // 输出结果
      console.log('无label的边:', edgeWithoutLabel);
      console.log('有label的边:', edgeWithLabel);
      console.log('节点集合:', nodeIds);
      console.log('节点名称集合:', this.nodeNames);


      this.APMData.id = this.$route.query.ID
      this.APMData.nodeList = nodeIds
      this.APMData.edgeList = edgeWithoutLabel
      this.APMData.ruleList = edgeWithLabel
      this.APMData.nodeNameList = this.nodeNames
      this.APMData.apmJson = JSON.stringify(this.graph.toJSON())
      // this.APMData = {
      //   id: this.$route.query.ID,
      //   nodeList: nodeIds,
      //   edgeList: edgeWithoutLabel,
      //   ruleList: edgeWithLabel,
      //   nodeNameList: this.nodeNames,
      //   apmJson: JSON.stringify(this.graph.toJSON())
      // };


      // // 将节点和边的信息打包成自定义 JSON
      // const algorithmic_pipeline_model = {
      //   nodes: nodeIds,
      //   edges: edgeWithoutLabel,
      //   rules: edgeWithLabel
      // };
      // // 将对象转换为 JSON 字符串
      // const jsonString = JSON.stringify(algorithmic_pipeline_model, null, 2);
      // // 下载 JSON 文件
      // const blob = new Blob([jsonString], { type: 'application/json' });
      // const url = URL.createObjectURL(blob);
      //
      // const a = document.createElement('a');
      // a.href = url;
      // a.download = 'algorithmic_pipeline_model.json'; // 文件名
      // a.click();
      // URL.revokeObjectURL(url);
    }
  }
}
</script>

<style scoped>
#header {
  display: flex;
  border-top: 1px solid #dfe3e8;
  padding-top: 5px;
  margin:0;
  height: 35px;
  width: 100%;
}
.header-iconfont{
  margin-left: 20px;
  cursor: pointer;
  color: #595959;
}
</style>
