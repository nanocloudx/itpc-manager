<template>
  <div>
    <h2>Game</h2>
    <div>
      <h3>Register</h3>
      <select v-model="selectedPlayerId">
        <option v-for="player in players" :value="player.id">
          {{ player.organization }} {{ player.name }}
        </option>
      </select>
      <button @click="onClickRegister">Register</button>
    </div>
    <div>
      <h3>Entries</h3>
      <ul>
        <li v-for="entry in entries">
          <span class="rank">{{ entry.rank }}</span>
          <span class="organization">{{ entry.organization }}</span>
          <span class="name">{{ entry.name }}</span>
          <span class="status">{{ entry.status }}</span>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
export default {
  data () {
    return {
      selectedPlayerId: null,
      players: [],
      entries: []
    }
  },
  beforeMount () {
    this.fetchPlayers()
    this.fetchEntries()
    // setInterval(() => {
    //   this.fetchEntries()
    // }, 5 * 1000)
  },
  methods: {
    fetchPlayers() {
      fetch(`/api/players`).then(response => response.json()).then(results => this.players = results)
    },
    fetchEntries() {
      fetch(`/api/events/${this.$route.params.eventId}/players`).then(response => response.json()).then(results => this.entries = results)
    },
    onClickRegister() {
      const url = `/api/events/${this.$route.params.eventId}/players/${this.selectedPlayerId}/`
      const method = 'post'
      const headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      }
      fetch(url, { method, headers }).then(response => response.json()).then(result => {
        this.fetchEntries()
        alert('registration successful!')
      })
    }
  }
}
</script>

<style lang="scss" scoped>

</style>
