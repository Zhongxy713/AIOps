<template>
  <div :class="visible?'full-screen':''" >
    <graph-config-container :graph="this.graph" @full="handleFull" @load="load"></graph-config-container>
    <div id="container">
      <div id="stencil"></div>
      <div id="graph-container" ref="graph"></div>
      <div v-show="configVisibe" id="config-container">
        <node-config-container v-show="isNode" :node="curNode" @updateData="handleNode"></node-config-container>
        <edge-config-container v-show="!isNode" :edge="curEdge" @updateData="handleEdge"></edge-config-container>
        <span class="iconfont collpase-icon" @click="handleCollpaseConfig">&#xe68a;</span>
      </div>
      <span v-show="!configVisibe" class="iconfont open-icon" @click="handleOpenConfig">&#xe689;</span>
    </div>
  </div>
</template>

<script>
import { Graph, Addon } from '@antv/x6'
import { Sketch } from 'vue-color'
import '@antv/x6-vue-shape'
import FlowGraph from './JS/initStencil'
import EdgeConfigContainer from './components/EdgeConfigContainer'
import NodeConfigContainer from './components/NodeConfigContainer'
import GraphConfigContainer from './components/GraphConfigContainer'
import {getAPMJson, getNodeData, getNodeParam} from '@/axios/node'
export default {
  name: 'CreateFlow',
  components: {
    GraphConfigContainer,
    EdgeConfigContainer,
    NodeConfigContainer,
    // eslint-disable-next-line vue/no-unused-components
    'sketch-picker': Sketch
  },
  data () {
    return {
      visible: false,
      // graph: {},
      canRedo: false,
      canUndo: false,
      history: null,
      graph: Graph,
      menus: [],
      tableColumns:[],
      NodeName: '',
      NodeData: [],
      selectedNode: {},
      stencil: Addon.Stencil,
      ports: {},
      curNode: {},
      curEdge: {},
      paramInfo:{},
      configVisibe: true,
      isNode: false,
      apmJson:{},
    }
  },
  methods: {
    // 是否全屏
    handleFull (value) {
      this.visible = value

      const container = document.getElementById('container')
      if (value) {
        // 进入全屏模式，容器覆盖整个屏幕，包括导航栏
        container.style.left = '0';  // 左移覆盖导航栏
        container.style.width = '100%';
        this.handleCollpaseConfig()
        // nav.style.display = 'none';  // 隐藏导航栏
      } else {
        // 退出全屏，恢复导航栏和容器布局
        container.style.left = '200px';  // 导航栏宽度恢复
        container.style.width = 'calc(100% - 250px)';
        // nav.style.display = 'block';  // 显示导航栏
      }

    },
    // 画布绑定监听事件
    graphOnEvent () {
      // 监听画布添加节点动作
      // eslint-disable-next-line no-unused-vars
      this.graph.on('node:added', ({ node, index, options }) => {
        // console.log("0000000000000000000")
        // console.log('node:added',node)
        this.curNode = node
        this.isNode = true
        // todo 监听到画布添加了node之后，调后端接口创建一个接口
        // console.log('node:added',this.curNode)
        // node.setLabel('xwtest') // 修改label的值
        // console.log('监听到拖入一个控件id：' + node.store.data.id)
        // console.log(this.graph.getNodes())
      })
      // // 监听画布移除节点动作
      // // eslint-disable-next-line no-unused-vars
      // this.graph.on('node:removed', ({ node, index, options }) => {
      //   this.curNode = node
      //   // console.log('node:removed')
      //   // console.log(node)
      // })
      // 监听节点之间连接动作
      // eslint-disable-next-line no-unused-vars
      this.graph.on('edge:added', ({ edge, index, options }) => {
        const source = edge.getSource(); // 获取源节点和端口信息
        // const target = edge.getTarget(); // 获取目标节点

        // 检查连接点是否是右侧连接点
        if (source.port && source.port.startsWith('right-')) {
          console.log("右节点")
          edge.setAttrs({
            line: {
              strokeDasharray: 5.5
            }}
          )
          console.log("变成虚线")
          console.log('edge:connected', edge)
          this.isNode = false
          this.curEdge = edge
        }
        else{
          this.isNode = false
          this.curEdge = edge
        }

        // todo 监听到连接线动作之后，调后端接口绑定关系
        // console.log('edge:added')
        // console.log(edge)
      })
      // 监听点击节点之间连接动作
      // eslint-disable-next-line no-unused-vars
      this.graph.on('edge:click', ({ e, x, y, edge, view }) => {
        console.log("你点击了这条边：", edge)
        this.isNode = false
        this.curEdge = edge
        // console.log('edge:click')
      })
      // 监听节点之间移除连接动作
      // eslint-disable-next-line no-unused-vars
      this.graph.on('edge:removed', ({ edge, index, options }) => {
        // todo 监听到连接线动作之后，调后端接口绑定关系
        // console.log('edge:removed')
        // console.log(edge)
      })
      this.graph.on('blank:click', () => {
        // 点击空白处时移除所有连接线的工具
        this.graph.getEdges().forEach(edge => {
          edge.removeTools();
        });
      })
    },
    // 更新node的数据
    initFlowGraph() {
      this.request.get("/node").then((res) => {
            // console.log("res.data", res.data);
            this.menus = res.data
            // console.log('menus', this.menus)

            this.graph = FlowGraph.create(document.getElementById('graph-container'))
            this.stencil = FlowGraph.initStencil(
                document.getElementById('stencil'),
                this.menus
            )

            this.graphOnEvent ()
            this.initNodeClickEvent()
            // this.initHistoryStore()
          }
      )
    },
    initNodeClickEvent() {
      this.graph.on('node:click', (node) => {
          // this.curNode = node
          // this.isNode = true
          this.nodeClick(node)
      })
    },

    // initHistoryStore() {
    //   this.history = this.graph.history
    //   this.history.on('change', () => {
    //     this.canRedo = this.history.canRedo()
    //     this.canUndo = this.history.canUndo()
    //   })
    // },

    nodeClick(node) {
      // this.drawer = true
      // console.log('node', node)
      this.selectedNode = `你点击了${node?.cell?.store?.data?.data?.nodeName}`
      // console.log('selectedNode', this.selectedNode)
      // this.NodeData = node?.cell?.store?.data?.data?.nodeData
      this.NodeName = node?.cell?.store?.data?.data?.nodeName
      // console.log('NodeName', this.NodeName)
      this.NodeData = []
      this.tableColumns = []



      getNodeData(this.NodeName).then(res => {
        // console.log('res', res.data)
        // this.NodeData = JSON.stringify(res.data.nodeData).split(',')
        this.NodeData = res.data
        for (const key in res.data) {
          if (Object.prototype.hasOwnProperty.call(res.data,key)) {
          // if (res.data.nodeData.hasOwnProperty(key)) {
            this.tableColumns.push(key)
          }
        }
        // console.log('tableColumns', this.tableColumns)
        // console.log('NodeData', this.NodeData)
        // console.log('nodeName = ', this.NodeData.nodeName)
      })
      // console.log('node', node?.cell?.store?.data?.data)
      // console.log('selectedNode', this.selectedNode)

      // 缓存中是否存在该节点信息
      if (sessionStorage.getItem(this.NodeName)) {
        console.log('Node 信息存在');
      } else {
        console.log("Node 信息不存在")
        this.getNodeParamData(this.NodeName)

      }
      this.curNode = node.cell
      this.isNode = true
    },
    getNodeParamData(name) {
      getNodeParam(name).then(res => {
        console.log('res', res.data)
        this.paramInfo = res.data.records[0]
        console.log('paramInfo', this.paramInfo)
        sessionStorage.setItem(this.NodeName, JSON.stringify(this.paramInfo));
      })
    },
    handleNode (data) {
      console.log('返回组件data', data)
      this.curNode = data
      console.log('返回组件curNode的data', data)
    },
    load(){
      if(this.$route.query.ID === undefined){
        return
      }else {
      let apmId = this.$route.query.ID
      getAPMJson(apmId).then(res => {
        this.apmJson = JSON.parse(res.data.apmJson)
        console.log("获得算法管道模型的JSON：", this.apmJson)
        this.graph.fromJSON(this.apmJson)  // 触发事件，传递解析后的数据
      })}
    },
    // 更新edge的数据
    handleEdge (data) {
      this.curEdge = data
    },
    // 收缩配置面板
    handleCollpaseConfig () {
      this.configVisibe = false
      this.$refs.graph.style.width = 'calc(100% - 250px)'
    },
    // 展开配置面板
    handleOpenConfig () {
      this.configVisibe = true
      this.$refs.graph.style.width = 'calc(100% - 500px)'
    }
  },
  async mounted () {
    // 监听键盘按键事件
    let self = this
    this.$nextTick(function () {
      document.addEventListener('keyup', function (e) {
        // 此处填写你的业务逻辑即可
        if (e.keyCode === 27) {
          self.visible = false
        }
      })
    })

    // 折叠配置框
    this.handleCollpaseConfig()
    try {
      // 等待 this.initFlowGraph 完成
      await this.initFlowGraph();

      // 然后再执行 this.load
      await this.load();

      console.log('Both initFlowGraph and load have been executed in order.');
    } catch (error) {
      console.error('Error during mounted process:', error);
    }
    // this.initFlowGraph()
    // this.load()
    // 初始化画布
    // this.initGraph()
    // 绑定画布快捷键
    // this.graphBindKey()

    // 初始化流程控件面板
    // this.initStencil()


    // 画布绑定监听事件
    // this.graphOnEvent()
    // 初始化连接桩
    // this.initPorts()
    // 渲染所有左侧控件图形
    // this.loadStencil()
  }
}
</script>

<style scoped>
.full-screen {
  position: fixed;
  overflow: auto;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  background-color: #fff;
  border: 0;
  border-radius: 0px;
  padding:0;
  margin:0;
  height: 100%;
}
#container {
  position: fixed;
  display: flex;
  left: 210px;
  right: 0;
  border-radius: 0px;
  padding:0;
  margin:0;
  border: 1px solid #dfe3e8;
  height: 100%;
}
#stencil {
  width: 250px;
  height: 100%;
  position: relative;
  border-right: 1px solid #dfe3e8;
}
#graph-container {
  width: calc(100% - 500px);
  /*width: 100%;*/
  height: 100%;
  /*background-color: #fffbe6*/
}
#config-container {
  position: relative;
  width: 250px;
  height: 100%;
  border-left: 1px solid #dfe3e8;
}
.collpase-icon {
  position: absolute;
  top: 25px;
  left: -8px;
  color: #aaa;
  background-color: #fff;
  cursor: pointer;
}
.open-icon{
  position: relative;
  top: 10px;
  right: 10px;
  color: #aaa;
  background-color: #fff;
  cursor: pointer;
}
.x6-widget-transform > div {
  border: 1px solid #239edd;
}
.x6-widget-transform > div:hover {
  background-color: #3dafe4;
}
</style>
