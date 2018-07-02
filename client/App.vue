<template>
  <div id="app">
    <header>
      <div class="wrapper">
        <h1 class="header-title">ITPC Manager</h1>
      </div>
    </header>
    <div class="main">
      <div class="wrapper">
        <router-view/>
      </div>
    </div>
  </div>
</template>

<script>
export default {
}
</script>

<style lang="scss">
  * {
    box-sizing: border-box;
  }
  html, body {
    color: rgb(142, 146, 147);
    background-color: rgb(40, 40, 40);
    min-width: 1200px;
    font-family: -apple-system, BlinkMacSystemFont, "Helvetica Neue", YuGothic, "ヒラギノ角ゴ ProN W3", Hiragino Kaku Gothic ProN, Arial, "メイリオ", Meiryo, sans-serif;
  }
  li {
    list-style: none;
  }
  header {
    background-color: rgb(25, 25, 25);
    color: #ffffff;
    font-size: 1rem;
  }
  .wrapper {
    max-width: 1200px;
    margin: 0 auto;
    padding: 1rem;
  }
</style>
