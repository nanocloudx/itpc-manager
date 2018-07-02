<template>
  <div>
    <p>It works!</p>
  </div>
</template>

<script>
import { mapState, mapGetters, mapActions } from 'vuex'

export default {
  components: {
    //
  },
  computed: {
    ...mapState([]),
    ...mapGetters([])
  },
  beforeMount () {
    //
  },
  methods: {
    ...mapActions([])
  }
}
</script>

<style lang="scss" scoped>

</style>
