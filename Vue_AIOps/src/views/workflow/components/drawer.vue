<template>
  <div class="Ec-x6-icon">
    <el-drawer
      title="组件"
      :visible.sync="visible"
      :direction="direction"
      size="300px"
      :modal="false"
      :modal-append-to-body="false"
      style="position: absolute; width: 300px; box-sizing: border-box; height:calc(100vh - 180px); margin-top: 55px; background-color: #F5F5F5"
      show-close
    >
      <section class="listBar" @click.stop="" v-for="(item, index) in configList"
               :key="index">
        <p @click="showMore = !showMore">
          <img
            :class="{ arrow: showMore }"
            src="@/assets/svg/model.svg"
            alt=""
          />
          {{ item.nodeTitle }}
        </p>
        <div v-if="showMore" class="listBar-cot">
          <div
            v-for="(node, index) in item.children"
            :key="index"
            class="drag-cot"
            draggable="true"
            @drag="drag(node)"
            @dragend="dragend(node)"
          >
            <span>
              <img src="@/assets/svg/model.svg" alt="" />
            </span>
            <p style="margin: 5px 0px 10px 0px">
              {{ node.nodeTitle }}
            </p>
          </div>
        </div>
      </section>
    </el-drawer>
  </div>
</template>

<script>
const mouseXY = { x: null, y: null };
import registerShapes from "@/views/workflow/components/nodeTheme/shapes";
export default {
  name: "DrawerCom",

  data() {
    return {
      visible: true,
      direction: "ltr",
      showMore: false,
      configList: [],
      menus: [],
    };
  },
  mounted() {
    this.initFlowGraph()
    document.getElementById("container").addEventListener(
      "dragover",
      function (e) {
        mouseXY.x = e.clientX;
        mouseXY.y = e.clientY;
      },
      false
    );
  },
  methods: {
    initFlowGraph() {
      this.request.get("/node").then((res) => {
        console.log("res.data", res.data);
        this.menus = res.data
        console.log('menus', this.menus)
        this.configList = this.menus
            }
      )
    },
    drag: function () {
      // const parentRect = document
      //   .getElementById("container")
      //   .getBoundingClientRect();
      // let mouseInGrid = false;
      // if (
      //   mouseXY.x > parentRect.left &&
      //   mouseXY.x < parentRect.right &&
      //   mouseXY.y > parentRect.top &&
      //   mouseXY.y < parentRect.bottom
      // ) {
      //   mouseInGrid = true;
      // }
    },
    dragend: function (item) {
      const parentRect = document
        .getElementById("container")
        .getBoundingClientRect();
      let mouseInGrid = false;
      if (
        mouseXY.x > parentRect.left &&
        mouseXY.x < parentRect.right &&
        mouseXY.y > parentRect.top &&
        mouseXY.y < parentRect.bottom
      ) {
        mouseInGrid = true;
      }
      if (mouseInGrid === true) {
        // this.$emit("addNode", this.nodeConfig(item, mouseXY.x, mouseXY.y));
        console.log("item", item)
        this.$emit("addNode",registerShapes(item, mouseXY.x, mouseXY.y));
      }
    },
  },
};
</script>
<style scoped>
.Ec-x6-icon /deep/ .el-drawer__body {
  overflow-y: scroll;
}

.Ec-x6-icon /deep/ .el-drawer__header {
  padding: 0 12px;
  margin-bottom: 0;
  width: 300px;
}

.listBar {
  display: flex;
  justify-content: flex-start;
  flex-wrap: wrap;
  font-size: 14px;
  margin: 10px 0px 20px 0px
}

.listBar img {
  width: 12px;
}

.arrow {
  transform: rotate(90deg);
  transition-duration: 0.3s;
}

.listBar-cot {
  display: inline-block;
  padding-left: 12px;
  box-sizing: border-box;
  width: 100%;
  text-align: left;
}

.listBar-cot .drag-cot {
  display: inline-flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: center;
  width: 62px;
  height: 62px;
}

.listBar-cot .drag-cot span {
  display: inline-block;
  width: 50px;
  height: 50px;
}

.listBar-cot .drag-cot span img {
  width: 100%;
  height: 100%;
}

.listBar-cot .drag-cot p {
  margin: -2px 0 0;
  text-align: center;
  font-size: 12px;
  color: #939393;
}
</style>
