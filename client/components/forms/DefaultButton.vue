<template>
  <button
    class="button"
    @click="onClick"
  >
    {{ text }}
  </button>
</template>

<script>
export default {
  props: {
    text: {
      type: String,
      default: 'button'
    }
  },
  methods: {
    onClick () {
      this.$emit('click')
    }
  }
}
</script>

<style lang="scss" scoped>
  .button {
    cursor: pointer;
    display: inline-block;
    font-size: 1rem;
    line-height: 1rem;
    padding: 0.5rem 1rem;
    margin-bottom: 1rem;
    text-decoration: none;
    background: rgb(130, 30, 230);
    color: #ffffff;
    border: none;
    border-radius: 3px;
    outline: none;
  }
  .button:active {
    background: rgb(120, 30, 200);
  }
</style>
