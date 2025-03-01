const { defineConfig } = require('@vue/cli-service')
module.exports = defineConfig({
  runtimeCompiler: true,
  transpileDependencies: true,
  devServer:{
    port:7000
}
})
