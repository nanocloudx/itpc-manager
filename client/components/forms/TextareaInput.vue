<template>
  <textarea
    :value="value"
    :placeholder="placeholder"
    class="textarea-input"
    @input="$emit('input', $event.target.value)"
  ></textarea>
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
  .textarea-input {
    display: block;
    border: none;
    outline: 0;
    width: 100%;
    height: calc(100% - 1rem);
    font-size: 1rem;
    padding: 1rem;
    color: #ffffff;
    background-color: rgb(30, 30, 30);
    resize: none;
  }
  .textarea-input:focus {
    background-color: rgb(50, 50, 50);
  }
</style>
