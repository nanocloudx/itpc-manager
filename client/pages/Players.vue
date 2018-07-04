<template>
  <div>
    <h2>Players</h2>
    <div>
      <h3>Register</h3>
      <input v-model="organization" placeholder="organization">
      <input v-model="name" placeholder="name">
      <button @click="onClickRegister">Register</button>
    </div>
    <div>
      <h3>List</h3>
      <ul>
        <li v-for="player in players">
          <span class="organization">{{ player.organization }}</span>
          <span class="name">{{ player.name }}</span>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
export default {
  data () {
    return {
      organization: '',
      name: '',
      players: []
    }
  },
  beforeMount () {
    const url = '/api/players'
    fetch(url).then(response => response.json()).then(results => this.players = results)
  },
  methods: {
    onClickRegister() {
      const url = '/api/players'
      const method = 'post'
      const headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      }
      const body = JSON.stringify({
        organization: this.organization,
        name: this.name
      })
      fetch(url, { method, headers, body }).then(response => response.json()).then(result => {
        console.log(result)
        alert('registration successful!')
      })
    }
  }
}
</script>

<style lang="scss" scoped>

</style>
