<template>
  <div id="coverCot" style=" height: calc(100vh - 125px); overflow: hidden">
    <section class="section-cot" style="width: 100%; height: 100%">
      <div id="container" @click.stop="hideFn">
        <MenuBar
            v-if="showContextMenu"
            ref="menuBar"
            @callBack="contextMenuFn"
        />
        <header>
          <el-tooltip
              class="item"
              effect="dark"
              content="项目"
              placement="bottom"
          >
            <i class="el-icon-menu" @click="showDrawerFn()" />
          </el-tooltip>
          <el-tooltip
              class="item"
              effect="dark"
              content="长按shift多选"
              placement="bottom"
          >
            <i class="el-icon-crop" />
          </el-tooltip>
          <el-tooltip
              class="item"
              effect="dark"
              content="放大"
              placement="bottom"
          >
            <i class="el-icon-zoom-in" @click="zoomFn(0.2)" />
          </el-tooltip>
          <el-tooltip
              class="item"
              effect="dark"
              content="缩小"
              placement="bottom"
          >
            <i class="el-icon-zoom-out" @click="zoomFn(-0.2)" />
          </el-tooltip>
          <el-tooltip
              class="item"
              effect="dark"
              content="适应屏幕"
              placement="bottom"
          >
            <i class="el-icon-full-screen" @click="centerFn" />
          </el-tooltip>
          <el-tooltip
              class="item"
              effect="dark"
              content="撤销"
              placement="bottom"
          >
            <i class="el-icon-refresh-left" @click="toolbarClick('undo')" />
          </el-tooltip>
          <el-tooltip
              class="item"
              effect="dark"
              content="还原"
              placement="bottom"
          >
            <i class="el-icon-refresh-right" @click="toolbarClick('redo')" />
          </el-tooltip>
          <el-tooltip
              class="item"
              effect="dark"
              content="保存"
              placement="bottom"
          >
            <i class="el-icon-upload" @click="saveFn()" />
          </el-tooltip>
          <el-tooltip
              class="item"
              effect="dark"
              content="加载保存页面"
              placement="bottom"
          >
            <i class="el-icon-link" @click="loadFn()" />
          </el-tooltip>
        </header>
        <div id="draw-cot" />
        <Drawer ref="drawer" @addNode="addNode" />
      </div>
    </section>
    <DialogCondition ref="dialogCondition"></DialogCondition>
    <DialogMysql ref="dialogMysql"></DialogMysql>
    <DialogAlConfig ref="dialogAlConfig"></DialogAlConfig>
    <DialogRuleConfig ref="DialogRuleConfig"></DialogRuleConfig>
  </div>
</template>

<script>
import { Graph, Path } from "@antv/x6";
import "@antv/x6-vue-shape";
// import database from "./components/nodeTheme/database.vue";
import condition from "./components/nodeTheme/condition.vue";
// import DataJson from "./components/data";
import MenuBar from "./components/menuBar";
import Drawer from "./components/drawer";
import DialogCondition from "./components/dialog/condition.vue";
import DialogMysql from "./components/dialog/mysql.vue";
import DialogAlConfig from "./components/dialog/alConfig.vue";
import DialogRuleConfig from "./components/dialog/edge-rule.vue";
import CustomNode from "@/views/workflow/components/nodeTheme/CustomNode.vue";
import onlyOut from "./components/nodeTheme/onlyOut.vue";
import onlyIn from "./components/nodeTheme/onlyIn.vue";



export default {
  name: "App",
  components: {MenuBar, Drawer, DialogCondition, DialogMysql, DialogAlConfig, DialogRuleConfig},
  emits: [
    'getGraph',
    'nodeClick',
    'refresh',
    'redo',
    'undo',
    'clear'
  ],
  data() {
    return {
      graph: "",
      timer: "",
      isLock: false,
      showContextMenu: false,
      optTypes: {
        redo: () => {
          this.graph.redo()
          this.$emit('redo')
        },
        undo: () => {
          this.graph.undo()
          this.$emit('undo')
        },
      }
    };
  },
  mounted() {
    // 初始化 graph
    this.initGraph();

  },
  methods: {
    getNodeById(id) {
      return this.graph.getCellById(id);
    },
    hideFn() {
      this.showContextMenu = false;
    },
    toolbarClick(type) {
      if (this.optTypes[type]) {
        this.optTypes[type]()
      }
    },
    initGraph() {
      // 例子流程需要的东西↓↓↓↓↓↓↓↓↓↓↓↓↓
// 注册节点
      Graph.registerNode(
          "dag-condition",
          {
            inherit: "vue-shape",
            width: 180,
            height: 50,
            component: {
              template: `<condition />`,
              components: {
                condition,
              },
            },
            ports: {
              groups: {
                top: {
                  position: "top",
                  attrs: {
                    circle: {
                      r: 4,
                      magnet: true,
                      stroke: "#C2C8D5",
                      strokeWidth: 1,
                      fill: "#fff",
                    },
                  },
                },
                bottom: {
                  position: "bottom",
                  attrs: {
                    circle: {
                      r: 4,
                      magnet: true,
                      stroke: "#C2C8D5",
                      strokeWidth: 1,
                      fill: "#fff",
                    },
                  },
                },
              },
            },
          },
          true
      );

      Graph.registerNode(
          "dag-onlyOut",
          {
            inherit: "vue-shape",
            width: 180,
            height: 50,
            component: {
              template: `<onlyOut />`,
              components: {
                onlyOut,
              },
            },
            ports: {
              groups: {
                top: {
                  position: "top",
                  attrs: {
                    circle: {
                      r: 4,
                      magnet: true,
                      stroke: "#C2C8D5",
                      strokeWidth: 1,
                      fill: "#fff",
                    },
                  },
                },
                bottom: {
                  position: "bottom",
                  attrs: {
                    circle: {
                      r: 4,
                      magnet: true,
                      stroke: "#C2C8D5",
                      strokeWidth: 1,
                      fill: "#fff",
                    },
                  },
                },
              },
            },
          },
          true
      );

      Graph.registerNode(
          "dag-onlyIn",
          {
            inherit: "vue-shape",
            width: 180,
            height: 50,
            component: {
              template: `<onlyIn />`,
              components: {
                onlyIn,
              },
            },
            ports: {
              groups: {
                top: {
                  position: "top",
                  attrs: {
                    circle: {
                      r: 4,
                      magnet: true,
                      stroke: "#C2C8D5",
                      strokeWidth: 1,
                      fill: "#fff",
                    },
                  },
                },
                bottom: {
                  position: "bottom",
                  attrs: {
                    circle: {
                      r: 4,
                      magnet: true,
                      stroke: "#C2C8D5",
                      strokeWidth: 1,
                      fill: "#fff",
                    },
                  },
                },
              },
            },
          },
          true
      );

      Graph.registerNode(
          "dag-node",
          {
            inherit: "vue-shape",
            width: 180,
            height: 60,
            component: {
              template: `<CustomNode />`,
              components: {
                CustomNode,
              },
            },
            ports: {
              groups: {
                top: {
                  position: "top",
                  attrs: {
                    circle: {
                      r: 4,
                      magnet: true,
                      stroke: "#C2C8D5",
                      strokeWidth: 1,
                      fill: "#fff",
                    },
                  },
                },
                bottom: {
                  position: "bottom",
                  attrs: {
                    circle: {
                      r: 4,
                      magnet: true,
                      stroke: "#C2C8D5",
                      strokeWidth: 1,
                      fill: "#fff",
                    },
                  },
                },
              },
            },
          },
          true
      );

      Graph.registerEdge(
          "dag-edge",
          {
            inherit: "edge",
            attrs: {
              line: {
                stroke: "#C2C8D5",
                strokeWidth: 2,
                targetMarker: {
                  name: "block",
                  width: 12,
                  height: 8,
                },
              },
            },
          },
          true
      );
      Graph.registerConnector(
          "algo-connector",
          (s, e) => {
            const offset = 4;
            const deltaY = Math.abs(e.y - s.y);
            const control = Math.floor((deltaY / 3) * 2);

            const v1 = { x: s.x, y: s.y + offset + control };
            const v2 = { x: e.x, y: e.y - offset - control };

            return Path.normalize(
                `M ${s.x} ${s.y}
           L ${s.x} ${s.y + offset}
           C ${v1.x} ${v1.y} ${v2.x} ${v2.y} ${e.x} ${e.y - offset}
           L ${e.x} ${e.y}
          `
            );
          },
          true
      );
      // 例子流程需要的东西↑↑↑↑↑↑↑↑↑↑↑↑↑↑
      const graph = new Graph({
        grid: {
          size: 10,
          visible: true,
          type: "dot", // 'dot' | 'fixedDot' | 'mesh'
          args: {
            color: "#fdfdfd", // 网格线/点颜色
            thickness: 1, // 网格线宽度/网格点大小
          },
        },
        background: {
          color: "#d7e3b3", // 设置画布背景颜色
        },
        container: document.getElementById("draw-cot"),
        panning: {
          enabled: true,
          eventTypes: ["leftMouseDown", "mouseWheel"],
        },
        mousewheel: {
          enabled: true,
          modifiers: "ctrl",
          factor: 1.1,
          maxScale: 1.5,
          minScale: 0.5,
        },
        highlighting: {
          magnetAdsorbed: {
            name: "stroke",
            args: {
              attrs: {
                fill: "#fff",
                stroke: "#31d0c6",
                strokeWidth: 4,
              },
            },
          },
        },
        connecting: {
          snap: true,
          allowBlank: false,
          allowLoop: false,
          highlight: true,
          connector: "algo-connector",
          connectionPoint: "anchor",
          anchor: "center",
          validateMagnet() {
            // return magnet.getAttribute('port-group') !== 'top'

            // 限制连线配置
            return true;
          },
          createEdge() {
            return graph.createEdge({
              shape: "dag-edge",
              attrs: {
                line: {
                  strokeDasharray: "5 5",
                  targetMarker: {
                    name: "block",
                    width: 12,
                    height: 8,
                  },
                },
              },
              zIndex: -1,
            });
          },
        },
        selecting: {
          enabled: true,
          multiple: true,
          rubberEdge: true,
          rubberNode: true,
          modifiers: "shift",
          rubberband: true,
        },
        keyboard: true,
        clipboard: true,
        history: true,
      });
      this.graph = graph;

      graph.on("edge:contextmenu", ({ e, x, y, edge, view }) => {
        console.log(x, y, view);
        this.showContextMenu = true;
        this.$nextTick(() => {
          this.$refs.menuBar.initFn(e.offsetX+200, e.offsetY+120, {
            type: "edge",
            item: edge,
          });
        });
      });

      graph.on("node:contextmenu", ({ e, x, y, node, view }) => {
        console.log(e, x, y, view);
        this.showContextMenu = true;

        this.$nextTick(() => {
          // this.$refs.menuBar.setItem({ type: 'node', item: node })
          const p = graph.localToPage(x, y);
          this.$refs.menuBar.initFn(p.x-200, p.y-120, { type: "node", item: node });
        });
      });

      graph.on("edge:connected", ({ edge }) => {
        const source = graph.getCellById(edge.source.cell);
        const target = graph.getCellById(edge.target.cell);
        console.log("source", source);
        console.log("target", target);
        // // 只允许输入
        // if (target.data.type == "output") {
        //   return graph.removeEdge(edge.id);
        // }
        //
        // // 只允许输出
        // if (source.data.type == "onlyIn") {
        //   return graph.removeEdge(edge.id);
        // }
        //
        // // 如果线源头的一端链接桩只允许输入
        // if (/in/.test(edge.source.port)) {
        //   return graph.removeEdge(edge.id);
        // }
        //
        // // 目标一端链接桩只允许输出
        // if (/out/.test(edge.target.port)) {
        //   return graph.removeEdge(edge.id);
        // }

        if (source.data.type == "condition") {
          console.log("source = ",source);
          console.log("target = ",target);
          console.log("edge = ",edge);
          if (target.data.t === edge.id || target.data.f === edge.id) {
            return graph.removeEdge(edge.id);
          }
          this.$refs.dialogCondition.visible = true;
          this.$refs.dialogCondition.init(source, edge);
        }

        edge.attr({
          line: {
            strokeDasharray: "",
          },
        });
      });
    },
    // async showNodeStatus(statusList) {
    //   const status = statusList.shift();
    //   status?.forEach((item) => {
    //     const { id, status } = item;
    //     const node = this.graph.getCellById(id);
    //     const data = node.getData();
    //     node.setData({
    //       ...data,
    //       status: status,
    //     });
    //   });
    //   this.timer = setTimeout(() => {
    //     this.showNodeStatus(statusList);
    //   }, 300);
    // },
    // 初始化节点/边
    init(data = []) {
      const cells = [];
      data.forEach((item) => {
        if (item.shape === "dag-edge") {
          cells.push(this.graph.createEdge(item));
        } else {
          delete item.component;
          cells.push(this.graph.createNode(item));
        }
      });
      this.graph.resetCells(cells);
    },
    zoomFn(num) {
      this.graph.zoom(num);
    },
    centerFn() {
      const num = 1 - this.graph.zoom();
      num > 1 ? this.graph.zoom(num * -1) : this.graph.zoom(num);
      this.graph.centerContent();
    },
    // startFn(item) {
    //   this.timer && clearTimeout(this.timer);
    //   this.init(item);
    //   this.showNodeStatus(Object.assign([], nodeStatusList));
    //   this.graph.centerContent();
    // },
    saveFn() {
      localStorage.setItem(
          "x6Json",
          JSON.stringify(this.graph.toJSON({ diff: true }))
      );
    },
    loadFn() {
      this.timer && clearTimeout(this.timer);
      const x6Json = JSON.parse(localStorage.getItem("x6Json"));

      this.startFn(x6Json.cells);
    },
    contextMenuFn(type, node) {
      switch (type) {
        case "remove":
          if (node.type == "edge") {
            this.graph.removeEdge(node.item.id);
          } else if (node.type == "node") {
            this.graph.removeNode(node.item.id);
          }
          break;
        case "source":
          this.$refs.dialogMysql.visible = true;
          this.$refs.dialogMysql.init(node);
          break;
        case "config":
          this.$refs.dialogAlConfig.drawer = true;
          this.$refs.dialogAlConfig.nodeClick(node);
          break;
        case "ruleConfig":
          this.$refs.DialogRuleConfig.drawer = true;
          this.$refs.DialogRuleConfig.edgeClick(node);
          break;
      }

      this.showContextMenu = false;
    },

    showDrawerFn() {
      this.$refs.drawer.visible = !this.$refs.drawer.visible;
    },
    addNode(option) {
      console.log("option=",option);
      const p = this.graph.pageToLocal(option.x, option.y);
      this.graph.addNode(Object.assign({}, option, p));
    },
  },
};
</script>

<style  scoped>
header {
  display: flex;
  //justify-content: flex-end;
  width: 100%;
  height: 50px;
  box-sizing: border-box;
  justify-content: center; /* 水平居中 */
  align-items: center;
}

header i {
  margin: 8px;
  font-size: 30px;
}

.x6-node-selected .node {
  border-color: #1890ff;
  border-radius: 2px;
  box-shadow: 0 0 0 4px #d4e8fe;
}

.x6-node-selected .node.success {
  border-color: #52c41a;
  border-radius: 2px;
  box-shadow: 0 0 0 4px #ccecc0;
}

.x6-node-selected .node.failed {
  border-color: #ff4d4f;
  border-radius: 2px;
  box-shadow: 0 0 0 4px #fedcdc;
}

.x6-edge:hover path:nth-child(2) {
  stroke: #1890ff;
  stroke-width: 1px;
}

.x6-edge-selected path:nth-child(2) {
  stroke: #1890ff;
  stroke-width: 1.5px !important;
}

.section-cot {
  display: flex;
}

.section-cot #container {
  position: relative;
  flex: 1;
}

.section-cot #container #draw-cot {
  width: 100%;
  height: 100%;
}

::-webkit-scrollbar {
  width: 0;
}
</style>
