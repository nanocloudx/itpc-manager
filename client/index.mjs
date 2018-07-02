import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'

export default new Vue({
  store,
  router,
  el: '#app',
  components: { App },
  template: '<App/>'
})
