<template>
  <div>
    <h2>{{ event.title }}</h2>
    <div>
      <h3>Finish <span class="length">[{{ finishers.length }}]</span></h3>
      <ul>
        <li v-for="entry in finishers" :class="{ prize: entry.rank <= 3, final: entry.rank <= 10 }">
          <p class="rank">{{ entry.rank }}</p>
          <p class="organization">{{ entry.organization }}</p>
          <p class="name">{{ entry.name }}</p>
        </li>
      </ul>
    </div>
    <hr>
    <div>
      <h3>Playing <span class="length">[{{ playings.length }}]</span></h3>
      <ul>
        <li v-for="entry in playings">
          <p class="organization">{{ entry.organization }}</p>
          <p class="name">{{ entry.name }}</p>
        </li>
      </ul>
    </div>
    <hr>
    <div>
      <h3>Registration <span class="length">[{{ registrations.length }}]</span></h3>
      <ul>
        <li v-for="entry in registrations">
          <p class="organization">{{ entry.organization }}</p>
          <p class="name">{{ entry.name }}</p>
          <p class="ticket"><router-link :to="{ name: 'Ticket', params: { eventId: event.id, entryId: entry.id }}">Ticket</router-link></p>
        </li>
      </ul>
    </div>
    <hr>
    <div>
      <h3>Register</h3>
      <select v-model="selectedPlayerId">
        <option v-for="player in players" :value="player.id">
          {{ player.organization }} {{ player.name }}
        </option>
      </select>
      <button @click="onClickRegister">Register</button>
    </div>
  </div>
</template>

<script>
export default {
  data () {
    return {
      selectedPlayerId: null,
      event: {},
      players: [],
      entries: []
    }
  },
  computed: {
    finishers () {
      const players = this.entries.filter(entry => entry.status !== 'none')
      let finishers = this.entries.filter(entry => entry.status === 'finish')
      finishers = finishers.sort((a, b) => a.finishTime - b.finishTime)
      return finishers.map((entry, index) => Object.assign(entry, { rank: players.length - index })).reverse()
    },
    playings () {
      return this.entries.filter(entry => entry.status === 'playing').sort((a, b) => {
        const nameA = a.organization.toUpperCase()
        const nameB = b.organization.toUpperCase()
        if (nameA < nameB) {
          return -1
        }
        if (nameA > nameB) {
          return 1
        }
        return 0
      })
    },
    registrations () {
      return this.entries.filter(entry => entry.status === 'none').sort((a, b) => {
        const nameA = a.organization.toUpperCase()
        const nameB = b.organization.toUpperCase()
        if (nameA < nameB) {
          return -1
        }
        if (nameA > nameB) {
          return 1
        }
        return 0
      })
    }
  },
  beforeMount () {
    this.fetchEvent()
    this.fetchPlayers()
    this.fetchEntries()
  },
  methods: {
    fetchEvent() {
      fetch(`/api/events/${this.$route.params.eventId}`).then(response => response.json()).then(results => this.event = results)
    },
    fetchPlayers() {
      fetch(`/api/players`).then(response => response.json()).then(results => this.players = results)
    },
    fetchEntries() {
      fetch(`/api/events/${this.$route.params.eventId}/entries`)
        .then(response => response.json())
        .then(results => this.entries = results)
    },
    onClickRegister() {
      const url = `/api/events/${this.$route.params.eventId}/entries/`
      const method = 'post'
      const headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      }
      const body = JSON.stringify({
        playerId: this.selectedPlayerId
      })
      fetch(url, { method, headers, body }).then(response => response.json()).then(result => {
        this.fetchEntries()
        alert('registration successful!')
      })
    }
  }
}
</script>

<style lang="scss" scoped>
  h2 {
    font-size: 3rem;
    margin-bottom: 1rem;
  }
  h3 {
    font-size: 2rem;
    margin-bottom: 1rem;
    .length {
      font-size: 1.5rem;
    }
  }
  li {
    font-size: 1.5rem;
    color: #ffffff;
    display: flex;
    &.final {
      font-size: 1.8rem;
      color: #00c3ff;
    }
    &.prize {
      font-size: 2.2rem !important;
      color: #ffba00 !important;;
    }
    .ticket {
      margin-left: 1rem;
      font-size: 1rem;
      line-height: 1.5rem;
    }
  }
  .rank {
    width: 50px;
  }
  .organization {
    width: 200px;
  }
</style>
