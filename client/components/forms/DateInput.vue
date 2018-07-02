<template>
  <input
    :value="value"
    type="date"
    class="date-input"
    @input="$emit('input', $event.target.value)"
  >
</template>

<script>
export default {
  props: {
    value: {
      type: String,
      default: ''
    }
  }
}
</script>

<style lang="scss" scoped>
  .date-input {
    display: block;
    border: none;
    outline: 0;
    width: 100%;
    height: 50px;
    font-size: 1rem;
    padding: 1rem;
    color: #ffffff;
    background-color: rgb(30, 30, 30);
    margin-bottom: 1rem;
  }
  .date-input:focus {
    background-color: rgb(50, 50, 50);
  }
</style>
