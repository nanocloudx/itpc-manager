import Vue from 'vue'
import Router from 'vue-router'
import Index from './pages/Index.vue'
import Players from './pages/Players.vue'
import Events from './pages/Events.vue'
import Game from './pages/Game.vue'
import Ticket from './pages/Ticket.vue'

Vue.use(Router)

const router = new Router({
  mode: 'history',
  routes: [
    {
      path: '/',
      name: 'Index',
      component: Index
    },
    {
      path: '/players',
      name: 'Players',
      component: Players
    },
    {
      path: '/events',
      name: 'Events',
      component: Events
    },
    {
      path: '/events/:eventId',
      name: 'Game',
      component: Game
    },
    {
      path: '/events/:eventId/entries/:entryId/ticket',
      name: 'Ticket',
      component: Ticket
    }
  ]
})

export default router
