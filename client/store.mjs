import Vue from 'vue'
import Vuex from 'vuex'
import fetchApi from './utils/fetch-api'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    // articles: [],
    // selectedArticleId: null
  },
  getters: {
    // selectedArticle (state) {
    //   return state.articles.find(article => article.id === state.selectedArticleId)
    // }
  },
  mutations: {
    // updateSelectedArticleId (state, id) {
    //   state.selectedArticleId = id
    // },
    // updateArticles (state, articles) {
    //   state.articles = articles
    // }
  },
  actions: {
    // updateSelectedArticleId (context, id) {
    //   context.commit('updateSelectedArticleId', id)
    // },
    // async fetchArticles (context) {
    //   const articles = await fetchApi('/admin/api/articles', 'get')
    //   context.commit('updateArticles', articles)
    // },
    // async createArticle (context) {
    //   const article = await fetchApi('/admin/api/articles', 'post')
    //   context.dispatch('updateSelectedArticleId', article.id)
    //   context.dispatch('fetchArticles')
    // }
  }
})
