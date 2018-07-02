<template>
  <input
    :value="value"
    :placeholder="placeholder"
    type="text"
    class="text-input"
    @input="$emit('input', $event.target.value)"
  >
</template>

<script>
export default {
  props: {
    value: {
      type: String,
      default: ''
    },
    placeholder: {
      type: String,
      default: ''
    }
  }
}
</script>

<style lang="scss" scoped>
  .text-input {
    display: block;
    border: none;
    outline: 0;
    width: 100%;
    font-size: 1rem;
    padding: 1rem;
    color: #ffffff;
    background-color: rgb(30, 30, 30);
    margin-bottom: 1rem;
  }
  .text-input:focus {
    background-color: rgb(50, 50, 50);
  }
</style>
