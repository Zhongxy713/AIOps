<template>
    <div v-show="visible" width="380px">
      pageTwo页面
    </div>
</template>

<script>
export default {
  data() {
    return {
      visible: false,
      bool: true,
      node: {},
      label: "",
    };
  },
  mounted() {},
  methods: {
    init(item) {
      this.node = item;
      this.label = item.item.data.label;
    },
    submit() {
      var node = this.$parent.getNodeById(this.node.item.id);
      node.setData(
          Object.assign({}, this.node.item.data, { label: this.label })
      );
      // this.node.setData({})
      // this.node.item.data.label = this.label;
      this.visible = false;
    },
  },
}
</script>

<style>

</style>
