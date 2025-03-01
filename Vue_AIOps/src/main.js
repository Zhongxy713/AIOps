import Vue from 'vue'
import App from './App.vue'
import router from './router'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import './assets/global.css'
import Antd from 'ant-design-vue'
import './assets/styles/reset.css'
import './assets/styles/border.css'
import './assets/styles/iconfont.css'
import 'ant-design-vue/dist/antd.css'
import animated from 'animate.css'
import request from "@/utils/request";
import store from './store'
// main.js全局注册


Vue.config.productionTip = false
Vue.use(Antd)
Vue.use(animated)

Vue.use(ElementUI,{size:"mini"});
Vue.prototype.request=request

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')
