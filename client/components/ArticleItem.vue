<template>
  <li class="article">
    <p
      v-show="!published"
      class="unpublished">Unpublished</p>
    <h4 class="article-title">{{ title || '- title -' }}</h4>
    <p class="article-alternateid">{{ alternateId || '- alternateId -' }}</p>
    <p class="article-id">{{ id }}</p>
  </li>
</template>

<script>
export default {
  props: {
    title: {
      type: String,
      default: ''
    },
    alternateId: {
      type: String,
      default: ''
    },
    id: {
      type: String,
      default: ''
    },
    published: {
      type: Boolean,
      default: false
    }
  }
}
</script>

<style lang="scss" scoped>
  .article {
    padding: 1rem 0.5rem;
    border-bottom: 1px solid rgb(50, 50, 50);
    cursor: pointer;
    .article-title {
      color: #ffffff;
      font-size: 1rem;
      line-height: 1.2rem;
    }
    .article-alternateid {
      font-size: 0.9rem;
      line-height: 1.1rem;
    }
    .article-id {
      font-size: 0.7rem;
      line-height: 0.9rem;
    }
    &:first-child {
      border-top: 1px solid rgb(50, 50, 50);
    }
    &:hover {
      background-color: rgb(50, 50, 50);
    }
    .unpublished {
      color: rgb(130, 30, 230);
      font-size: 0.7rem;
      line-height: 0.9rem;
    }
  }
</style>
