<template>
  <div>
    <h2>Events</h2>
    <div>
      <h3>Register</h3>
      <input v-model="id" placeholder="id">
      <input v-model="title" placeholder="title">
      <input v-model="place" placeholder="place">
      <input v-model="date" placeholder="date">
      <button @click="onClickRegister">Register</button>
    </div>
    <div>
      <h3>List</h3>
      <ul>
        <li v-for="event in events">
          <router-link :to="{ name: 'Game', params: { eventId: event.id }}">
            <span class="id">{{ event.id }}</span>
            <span class="title">{{ event.title }}</span>
            <span class="place">{{ event.place }}</span>
            <span class="date">{{ event.date }}</span>
          </router-link>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
export default {
  data () {
    return {
      id: '',
      title: '',
      place: '',
      date: '',
      events: []
    }
  },
  beforeMount () {
    const url = '/api/events'
    fetch(url).then(response => response.json()).then(results => this.events = results)
  },
  methods: {
    onClickRegister() {
      const url = '/api/events'
      const method = 'post'
      const headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      }
      const body = JSON.stringify({
        id: this.id,
        title: this.title,
        place: this.place,
        date: this.date,
      })
      fetch(url, { method, headers, body }).then(response => response.json()).then(result => {
        alert('registration successful!')
      })
    }
  }
}
</script>

<style lang="scss" scoped>

</style>
